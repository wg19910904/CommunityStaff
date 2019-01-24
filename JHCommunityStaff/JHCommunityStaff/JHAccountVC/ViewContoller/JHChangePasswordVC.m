//
//  JHChangePasswordVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//修改密码

#import "JHChangePasswordVC.h"
#import "HttpTool.h"
#import <IQKeyboardManager.h>
#import "MBProgressHUD.h"
#import "SecurityCode.h"
#import "XHCodeTF.h"
@interface JHChangePasswordVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    XHCodeTF *_mobile;//电话
    UIView *_mobileBack;//电话背景图;
    UITextField *_code;//验证码
    UIView *_codeBack;//验证码背景图;
    UITextField *_password;//密码
    UIView *_passwordBack;//密码背景图;
    UITextField *_passwordAgain;//确认密码
    UIView *_passwordAgainBack;//确认密码背景图;
    UIButton *_codeBnt;//验证按钮
    NSTimer *_timer;//定时器
    int _num;
    UIButton *_certainBnt;//确认按钮
    UILabel *_alertLabel;//特别提醒
    SecurityCode *_control;
}

@end

@implementation JHChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"修改密码", nil)];
    [self initSubViews];
    [self createTableView];
    _control = [[SecurityCode alloc] init];
    
}
#pragma mark=====初始化子控件=========
- (void)initSubViews{
    _mobileBack = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 125, 44)];
    _mobileBack.layer.cornerRadius = 4.0f;
    _mobileBack.clipsToBounds = YES;
    _mobileBack.backgroundColor = [UIColor whiteColor];
    _mobileBack.layer.borderColor = LINE_COLOR.CGColor;
    _mobileBack.layer.borderWidth = 0.5f;
    _mobile = [[XHCodeTF alloc] initWithFrame:FRAME(50, 0, _mobileBack.frame.size.width - 50, 44)];
    _mobile.delegate = self;
    _mobile.backgroundColor = [UIColor whiteColor];
    _mobile.font = FONT(14);
    _mobile.text = _phone;
    _mobile.userInteractionEnabled = NO;
    _mobile.keyboardType = UIKeyboardTypeNumberPad;
    _mobile.placeholder = NSLocalizedString(@"请输入手机号", nil);
    _mobile.textColor = HEX(@"333333", 1.0f);
    _mobile.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _mobile.fatherVC = weakself;
    
    _codeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _codeBnt.frame = FRAME(WIDTH - 105, 0,90, 44);
    _codeBnt.titleLabel.font = FONT(16);
    _codeBnt.layer.cornerRadius = 4.0f;
    _codeBnt.clipsToBounds = YES;
    _codeBnt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_codeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_codeBnt setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [_codeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBnt addTarget:self action:@selector(clickCodeBnt) forControlEvents:UIControlEventTouchUpInside];
    _codeBack = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _codeBack.layer.cornerRadius = 4.0f;
    _codeBack.clipsToBounds = YES;
    _codeBack.backgroundColor = [UIColor whiteColor];
    _codeBack.layer.borderColor = LINE_COLOR.CGColor;
    _codeBack.layer.borderWidth = 0.5f;
    _code = [[UITextField alloc] initWithFrame:FRAME(50, 0, _codeBack.frame.size.width - 50, 44)];
    _code.delegate = self;
    _code.backgroundColor = [UIColor whiteColor];
    _code.font = FONT(14);
    _code.keyboardType = UIKeyboardTypeNumberPad;
    _code.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _code.textColor = HEX(@"333333", 1.0f);
    _passwordBack = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _passwordBack.layer.cornerRadius = 4.0f;
    _passwordBack.clipsToBounds = YES;
    _passwordBack.backgroundColor = [UIColor whiteColor];
    _passwordBack.layer.borderColor = LINE_COLOR.CGColor;
    _passwordBack.layer.borderWidth = 0.5f;
    _password = [[UITextField alloc] initWithFrame:FRAME(50, 0, _codeBack.frame.size.width - 50, 44)];
    _password.delegate = self;
    _password.secureTextEntry = YES;
    _password.backgroundColor = [UIColor whiteColor];
    _password.font = FONT(14);
    _password.placeholder = NSLocalizedString(@"请输入新密码(不少于6位)", nil);
    _password.textColor = HEX(@"333333", 1.0f);
    _passwordAgainBack = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _passwordAgainBack.layer.cornerRadius = 4.0f;
    _passwordAgainBack.clipsToBounds = YES;
    _passwordAgainBack.backgroundColor = [UIColor whiteColor];
    _passwordAgainBack.layer.borderColor = LINE_COLOR.CGColor;
    _passwordAgainBack.layer.borderWidth = 0.5f;
    _passwordAgain = [[UITextField alloc] initWithFrame:FRAME(50, 0, _codeBack.frame.size.width - 50, 44)];
    _passwordAgain.delegate = self;
    _passwordAgain.backgroundColor = [UIColor whiteColor];
    _passwordAgain.font = FONT(14);
    _passwordAgain.secureTextEntry = YES;
    _passwordAgain.placeholder = NSLocalizedString(@"请再次输入新密码", nil);
    _passwordAgain.textColor = HEX(@"333333", 1.0f);
    [_mobileBack addSubview:_mobile];
    [_codeBack addSubview:_code];
    [_passwordBack addSubview:_password];
    [_passwordAgainBack addSubview:_passwordAgain];
    [self addImg];
    _certainBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _certainBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _certainBnt.layer.cornerRadius = 4.0f;
    _certainBnt.clipsToBounds = YES;
    
    [_certainBnt setTitle:NSLocalizedString(@"确认", nil) forState:UIControlStateNormal];
    [_certainBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certainBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _certainBnt.titleLabel.font = FONT(16);
    [_certainBnt addTarget:self action:@selector(clickCertainBnt) forControlEvents:UIControlEventTouchUpInside];
    _alertLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 15)];
    _alertLabel.font = FONT(12);
    _alertLabel.text = NSLocalizedString(@"特别提示:登录密码即支付密码", nil);
    _alertLabel.textColor = HEX(@"999999", 1.0f);
    _alertLabel.textAlignment = NSTextAlignmentCenter;
}
#pragma mark======添加图标=======
- (void)addImg{
    NSArray *imgs = @[IMAGE(@"sq_mobile"),IMAGE(@"sq_code"),IMAGE(@"login_password"),IMAGE(@"login_password")];
    for(int i = 0 ; i < imgs.count ; i ++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15, 11, 20, 20)];
        img.image = imgs[i];
        switch (i) {
                
            case 0:
                [_mobileBack addSubview:img];
                break;
            case 1:
                [_codeBack addSubview:img];
                break;
            case 2:
                [_passwordBack addSubview:img];
                break;
            case 3:
                [_passwordAgainBack addSubview:img];
                break;
                
            default:
                break;
        }
    }
    
}
#pragma mark ========创建定时器===========
- (void)createTimer
{
    _num = 60;
    if(_timer == nil)
    {
        _codeBnt.enabled = NO;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    [_timer fire];
}
#pragma mark ========开启定时器===========
- (void)onTimer
{
    _num--;
    [_codeBnt setTitle:[NSString stringWithFormat:@"%ds",_num] forState:UIControlStateNormal];
    [_codeBnt setBackgroundColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
    if(_num == 0)
    {
        [self closeTimer];
    }
}
#pragma mark ========关闭定时器===========
- (void)closeTimer
{
    [_codeBnt setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
    [_codeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _codeBnt.enabled = YES;
    [_timer invalidate];
    _timer = nil;
}
#pragma mark======验证码按钮点击事件==========
- (void)clickCodeBnt{
    NSLog(@"获取验证码");
    
    if(_mobile.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"手机号不能为空,请重新输入", nil)];
    } else{
        [[NSUserDefaults standardUserDefaults] setObject:_mobile.text forKey:@"SECURITY_MOBILE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)] || [_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]){
            NSDictionary *dic = @{@"mobile":_mobile.text};
            [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
                NSLog(@"json%@",json);
                
                if ([json[@"error"] isEqualToString:@"0"]) {
                    
                    if ([json[@"data"][@"sms_code"] isEqualToString:@"1"]) {
    
                            //获取图形验证码
                            [HttpTool postWithAPI:@"magic/verify" withParams:dic success:^(id json) {
                                
                                if(json){
                                    [_control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                                        [_control removeFromSuperview];
                                        if ([result isEqualToString:NSLocalizedString(@"正确", nil)]) {
                                            [self createTimer];
                                        }
                                    }];
                                    [_control refesh:json];
                                }else{
                                    [self showAlertViewWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                                }
                            } failure:^(NSError *error) {
                                [self showAlertViewWithTitle:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                                NSLog(@"%@",error.localizedDescription);
                            }];

                
                    }else{
                        [self createTimer];
                    }
                    //获取图形验证码
                }else{
                    [self  showAlertViewWithTitle:json[@"message"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"error:%@",error.localizedDescription);
            }];
        }
    }
}
#pragma mark=======创建表视图========
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        [self.view addSubview:_tableView];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark=====UITableViewDelegate===========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 5)
        return 15;
    else
        return  44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 3)
        return 20;
    else if(section == 5)
        return 0.1;
    else
        return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return  10;
    }else
        return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_mobileBack];
            [cell.contentView addSubview:_codeBnt];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_codeBack];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_passwordBack];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_passwordAgainBack];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_certainBnt];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        case 5:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_alertLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = BACK_COLOR;
            return cell;
            
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark=====立即申请按钮点击事件========
- (void)clickCertainBnt{
    NSLog(@"确认");
    if(_code.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入验证码", nil)];
    }else if (_password.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入新密码", nil)];
    }else if(_passwordAgain.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请再次输入新密码", nil)];
    }else if (_password.text.length < 6 || _passwordAgain.text.length < 6){
        [self showAlertViewWithTitle:NSLocalizedString(@"密码不少于6位", nil)];
    }else if([_passwordAgain.text isEqualToString:_password.text] == NO){
        [self showAlertViewWithTitle:NSLocalizedString(@"两次输入的新密码不一致,请再次输入", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"newpswd":_passwordAgain.text,@"sms_code":_code.text};
        [HttpTool postWithAPI:@"staff/account/editpswd" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changePassword" object:nil];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
                [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"修改密码失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            NSLog(@"erro%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
        
    }
    
}
#pragma mark=======UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark======scrollViewDelegate==========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if(manager.enable){
        
    }else{
        [self.view endEditing: YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
