//
//  JHChangeMobileVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//更换手机号码

#import "JHChangeMobileVC.h"
#import <IQKeyboardManager.h>
#import "HttpTool.h"
#import "SecurityCode.h"
#import "XHCodeTF.h"
@interface JHChangeMobileVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UIImageView *_mobileImg;//手机图片
    UILabel *_mobileLabel;//当前手机号码
    UILabel *_alertLabel;//提示标签
    XHCodeTF *_newMobile;//新手机
    UIView *_newMobileBack;//新手机背景
    UIButton *_codeBnt;//验证码按钮
    UITextField *_code;//验证码
    UIView *_codeBack;//验证码背景
    UIButton *_changeBnt;//更新手机按钮
    NSTimer *_timer;//定时器
    int _num;//秒数
    SecurityCode *_control;
}
@end

@implementation JHChangeMobileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"更换手机号", nil)];
    [self initSubViews];
    [self createTableView];
    _control = [[SecurityCode alloc] init];
}
#pragma mark=====初始化子控件=======
- (void)initSubViews{
    
    _mobileImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 60) / 2, 20, 60, 60)];
    _mobileImg.layer.cornerRadius = _mobileImg.frame.size.width / 2;
    _mobileImg.clipsToBounds = YES;
    _mobileImg.image = IMAGE(@"zl_mobile");
    _mobileLabel = [[UILabel alloc] initWithFrame:FRAME(0, 90, WIDTH, 15)];
    _mobileLabel.textAlignment = NSTextAlignmentCenter;
    _mobileLabel.textColor = HEX(@"333333", 1.0f);
    _mobileLabel.text = [NSString stringWithFormat:NSLocalizedString(@"您的当前手机号为%@", nil),_mobile];
    _mobileLabel.font = FONT(14);
    _alertLabel = [[UILabel alloc] initWithFrame:FRAME(0, 115, WIDTH, 15)];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.textColor = HEX(@"999999", 1.0f);
    _alertLabel.text = NSLocalizedString(@"更换后个人信息不变,下次可以使用新手机号登录", nil);
    _alertLabel.font = FONT(12);
    _newMobileBack = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 125, 44)];
    _newMobileBack.layer.cornerRadius = 4.0f;
    _newMobileBack.clipsToBounds = YES;
    _newMobileBack.backgroundColor = [UIColor whiteColor];
    _newMobileBack.layer.borderColor = THEME_COLOR.CGColor;
    _newMobileBack.layer.borderWidth = 0.5f;
    _newMobile = [[XHCodeTF alloc] initWithFrame:FRAME(0, 0, _newMobileBack.frame.size.width, 44)];
    _newMobile.delegate = self;
    _newMobile.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _newMobile.leftView.backgroundColor = [UIColor whiteColor];
    _newMobile.leftViewMode = UITextFieldViewModeAlways;
    _newMobile.backgroundColor = [UIColor whiteColor];
    _newMobile.font = FONT(14);
    _newMobile.keyboardType = UIKeyboardTypeNumberPad;
    _newMobile.placeholder = NSLocalizedString(@"请输入新手机号", nil);
    _newMobile.textColor = HEX(@"333333", 1.0f);
    _newMobile.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    _newMobile.fatherVC = weakself;
    
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
    _code = [[UITextField alloc] initWithFrame:FRAME(0, 0, _codeBack.frame.size.width, 44)];
    _code.delegate = self;
    _code.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _code.leftView.backgroundColor = [UIColor whiteColor];
    _code.leftViewMode = UITextFieldViewModeAlways;
    _code.backgroundColor = [UIColor whiteColor];
    _code.backgroundColor = [UIColor whiteColor];
    _code.font = FONT(14);
    _code.keyboardType = UIKeyboardTypeNumberPad;
    _code.placeholder = NSLocalizedString(@"请输入验证码", nil);
    _code.textColor = HEX(@"333333", 1.0f);
    [_newMobileBack addSubview:_newMobile];
    [_codeBack addSubview:_code];
    _changeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _changeBnt.layer.cornerRadius = 4.0f;
    _changeBnt.clipsToBounds = YES;
   
    [_changeBnt setTitle:NSLocalizedString(@"验证后更换新手机", nil) forState:UIControlStateNormal];
    [_changeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_changeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _changeBnt.titleLabel.font = FONT(16);
    [_changeBnt addTarget:self action:@selector(clickChangeMobile) forControlEvents:UIControlEventTouchUpInside];
}
#pragma  mark=====更换新手机按钮点击事件=======
- (void)clickChangeMobile{
    NSLog(@"换手机");
    if(_newMobile.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入新手机号", nil)];
    }else if (_code.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入验证码", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"mobile":_newMobile.text,@"sms_code":_code.text};
        [HttpTool postWithAPI:@"staff/account/update_mobile" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                [self.navigationController popViewControllerAnimated:YES];
                [[NSUserDefaults standardUserDefaults] setObject:_newMobile.text forKey:@"user"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeMobile" object:nil userInfo:@{@"mobile":_newMobile.text}];
                if (self.myBlock) {
                    self.myBlock(_newMobile.text);
                }
                
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"更换失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
    }
}
#pragma mark ========创建定时器===========
- (void)createTimer
{
    _num = 60;
    if(_timer == nil)
    {
        _codeBnt.enabled = NO;
        _newMobile.userInteractionEnabled = NO;
        [_code becomeFirstResponder];
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
    _newMobile.userInteractionEnabled = YES;
    [_timer invalidate];
    _timer = nil;
}

#pragma mark======验证码按钮点击事件==========
- (void)clickCodeBnt{
    NSLog(@"获取验证码");
    NSLog(@"获取验证码");
    if(_newMobile.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"手机号不能为空,请重新输入", nil)];
    } else{
        _codeBnt.userInteractionEnabled = NO;
        [[NSUserDefaults standardUserDefaults] setObject:_newMobile.text forKey:@"SECURITY_MOBILE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if([_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)] || [_codeBnt.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]){
            NSDictionary *dic = @{@"mobile":_newMobile.text};
            [HttpTool postWithAPI:@"magic/sendsms" withParams:dic success:^(id json) {
                NSLog(@"json%@",json);
                _codeBnt.userInteractionEnabled = YES;
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
                _codeBnt.userInteractionEnabled = YES;
                NSLog(@"error:%@",error.localizedDescription);
            }];
        }
    }
}

#pragma mark=====创建表视图========
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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 1)
        return 20;
    else if (section == 0)
        return 10;
    
    else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 145;
    }else
        return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_newMobileBack];
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
            [cell.contentView addSubview:_changeBnt];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 145)];
        view.backgroundColor = BACK_COLOR;
        [view addSubview:_mobileImg];
        [view addSubview:_mobileLabel];
        [view addSubview:_alertLabel];
        return view;
    }
     return nil;
}
#pragma mark=====UITextFieldDelegate====
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
@end
