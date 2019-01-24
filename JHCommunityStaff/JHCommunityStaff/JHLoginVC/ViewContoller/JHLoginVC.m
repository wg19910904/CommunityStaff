//
//  JHLoginViewController.m
//  JHCommunityStaff
//
//  Created by jianghu on 2018/2/10.
//  Copyright © 2018年 jianghu2. All rights reserved.
//

#import "JHLoginVC.h"
#import "JHMainVC.h"
#import "JHApplyVC.h"
#import "AppDelegate.h"
#import "JHForgetPasswordVC.h"
#import "HttpTool.h"
#import "MBProgressHUD.h"
#import "JPUSHService.h"
#import "AppDelegate.h"
#import "JHShowAlert.h"
#import "JHShareModel.h"
#import "XHCodeTF.h"
@interface JHLoginVC (){
    XHCodeTF *phoneF;
    UITextField *keyF;
    UILabel *titleL;
    UIButton *loginBtn;
    UIButton *forgetKeyBtn;
    UIButton *applyBtn;
    UIControl *_backView;
}

@end

@implementation JHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"登录",nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.hidden = YES;
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (token.length > 0) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        JHMainVC *main = [[JHMainVC alloc] init];
        [self.navigationController pushViewController:main animated:NO];
        [app.locationModel initMap];
    }
    [self getDefaultCode];
    [self setupUI];


    
    
}
- (void)getDefaultCode{
    SHOW_HUD
    [HttpTool postWithAPI:@"magic/get_default_code"
               withParams:@{}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"magic/get_default_code------------%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          NSString *def_code = json[@"data"][@"code_code"];
                          [JHShareModel shareModel].def_code = def_code;
                          [phoneF setShowCode:SHOW_COUNTRY_CODE];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addNotification];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI{
    self.backBtn.hidden = YES;
    
    UIImageView * backImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backImg.image = [UIImage imageNamed:@"bg_login"];
    [self.view addSubview:backImg];
    
    
    titleL = [[UILabel alloc]initWithFrame:FRAME((WIDTH- 120)/2, 120, 120, 36)];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    titleL.text = NSLocalizedString(@"服务端",nil);
    titleL.textColor = HEX(@"FFFFFF", 1);
    [self.view addSubview:titleL];
    
    UIView *phoneV = [[UIView alloc] init];
    phoneV.layer.borderWidth = 1.0;
    phoneV.layer.borderColor = HEX(@"FFFFFF", 1).CGColor;
    phoneV.layer.cornerRadius = 4;
    phoneV.clipsToBounds = YES;
    [self.view addSubview:phoneV];
    [phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(titleL.mas_bottom).offset = 80;
        make.height.offset = 50;
    }];
    phoneF = [[XHCodeTF alloc]init];
    [phoneV addSubview:phoneF];
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.top.bottom.offset = 0;
    }];
    phoneF.placeholder =NSLocalizedString(@"请输入手机号",nil);
    phoneF.backgroundColor = [UIColor clearColor];
    phoneF.textColor  = HEX(@"FFFFFF", 1);
    phoneF.keyboardType = UIKeyboardTypeNumberPad;
    phoneF.clipsToBounds = YES;
    phoneF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneF.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    phoneF.fatherVC = weakself;
    
    UIButton *phoneLeftImg = [[UIButton alloc]initWithFrame:FRAME(0, 13, 50, 24)];
    [phoneLeftImg setImage:[UIImage imageNamed:@"icon_user"] forState:0];
    phoneLeftImg.userInteractionEnabled = NO;
    [phoneV addSubview:phoneLeftImg];
    
    
    UIButton *phoneRightImg = [[UIButton alloc]initWithFrame:FRAME(phoneF.bounds.size.width - 50, 13, 50, 24)];
    [phoneRightImg setImage:[UIImage imageNamed:@"btn_reset"] forState:0];
    [phoneRightImg addTarget:self action:@selector(phoneRightImgClick) forControlEvents:UIControlEventTouchUpInside];
    phoneF.rightView = phoneRightImg;
    phoneF.rightViewMode = UITextFieldViewModeWhileEditing;
    
    
    
    keyF = [[UITextField alloc]init];
    [self.view addSubview:keyF];
    [keyF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(phoneF.mas_bottom).offset = 20;
        make.height.offset = 50;
    }];
    keyF.placeholder =NSLocalizedString(@"请输入登录密码",nil);
    keyF.backgroundColor = [UIColor clearColor];
    keyF.textColor = HEX(@"FFFFFF", 1);
    keyF.secureTextEntry = YES;
    keyF.layer.cornerRadius = 4;
    keyF.clipsToBounds = YES;
    keyF.layer.borderWidth = 1.0;
    keyF.layer.borderColor = HEX(@"FFFFFF", 1).CGColor;
    UIButton *keyLeftImg = [[UIButton alloc]initWithFrame:FRAME(16, 13, 50, 24)];
    [keyLeftImg setImage:[UIImage imageNamed:@"icon_password"] forState:0];
    keyLeftImg.userInteractionEnabled = NO;
    keyF.leftView = keyLeftImg;
    keyF.leftViewMode = UITextFieldViewModeAlways;
    keyF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton *keyRightImg = [[UIButton alloc]initWithFrame:FRAME(keyF.bounds.size.width - 50, 13, 50, 24)];
    [keyRightImg setImage:[UIImage imageNamed:@"icon_nosee"] forState:UIControlStateSelected];
    [keyRightImg setImage:[UIImage imageNamed:@"icon_see"] forState:0];
    [keyRightImg addTarget:self action:@selector(keyRightImgClick:) forControlEvents:UIControlEventTouchUpInside];
    keyF.rightView = keyRightImg;
    keyF.rightViewMode = UITextFieldViewModeWhileEditing;
    
    loginBtn = [[UIButton alloc]init];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(keyF.mas_bottom).offset = 30;
        make.height.offset = 50;
    }];
    [loginBtn setTitle:NSLocalizedString(@"登录",nil) forState:0];
    loginBtn.layer.cornerRadius = 4;
    //    loginBtn.clipsToBounds = YES;
    loginBtn.titleLabel.font = FONT(20);
    loginBtn.backgroundColor = HEX(@"FFFFFF", 1);
    //    [loginBtn setTintColor:HEX(@"00B1F7", 1)];
    [loginBtn setTitleColor:HEX(@"00B1F7", 1) forState:0];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    forgetKeyBtn = [[UIButton alloc]init];
    [self.view addSubview:forgetKeyBtn];
    [forgetKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -(WIDTH -100)/2;
        make.left.offset = (WIDTH -100)/2;
        make.top.equalTo(loginBtn.mas_bottom).offset = 30;
        make.height.offset = 20;
    }];
    [forgetKeyBtn setTitle:NSLocalizedString(@"忘记密码?",nil) forState:0];
    forgetKeyBtn.backgroundColor = [UIColor clearColor];
    [forgetKeyBtn setTitleColor:HEX(@"FFFFFF", 1) forState:0];
    forgetKeyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    forgetKeyBtn.titleLabel.font = FONT(16);
    [forgetKeyBtn addTarget:self action:@selector(forgetKeyClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    applyBtn = [[UIButton alloc]init];
    [self.view addSubview:applyBtn];
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -(WIDTH -100)/2;
        make.left.offset = (WIDTH -100)/2;
        make.bottom.offset = -48;
        make.height.offset = 20;
    }];
    [applyBtn setTitle:NSLocalizedString(@"申请入驻>>",nil) forState:0];
    applyBtn.backgroundColor = [UIColor clearColor];
    [applyBtn setTitleColor:HEX(@"FFFFFF", 1) forState:0];
    applyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    applyBtn.titleLabel.font = FONT(18);
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark======添加通知==========
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePassword) name:@"changePassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMobile) name:@"changeMobile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePassword) name:@"FindPassword" object:nil];
}

#pragma mark========UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField == phoneF){
        keyF.text = @"";
    }
    return  YES;
}
#pragma mark===修改手机号======
- (void)changeMobile{
    phoneF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
}
#pragma mark =======修改密码和找回密码========
- (void)changePassword{
    keyF.text = @"";
}

#pragma mark -点击登录
-(void)loginBtnClick{
    
    [self.view endEditing:YES];
    if(phoneF.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入手机号", nil)];
    }else if (keyF.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入密码", nil)];
    }else if (keyF.text.length < 6){
        [self showAlertViewWithTitle:NSLocalizedString(@"密码不少于6位", nil)];
    }else{
        SHOW_HUD
        NSString *open_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"openUDID"];
        NSString *register_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
        NSDictionary *dic = @{@"mobile":phoneF.text,@"passwd":keyF.text,@"open_id":(open_id ? open_id : @""),@"register_id":(register_id ? register_id : @"")};
        [HttpTool postWithAPI:@"staff/entry/login" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                JHMainVC *main = [[JHMainVC alloc] init];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:main animated:YES];
                });
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"token"] forKey:@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:[[phoneF.text componentsSeparatedByString:@"-"] lastObject] forKey:@"user"];
                [[NSUserDefaults standardUserDefaults] setObject:keyF.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"from"] forKey:@"from"];
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"staff_id"] forKey:@"staff_id"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [app.locationModel initMap];
                
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"登录失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
    }
    
}
#pragma mark -忘记密码
-(void)forgetKeyClick{
    JHForgetPasswordVC *forget = [[JHForgetPasswordVC alloc] init];
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark -申请入驻
-(void)applyBtnClick{
    JHApplyVC *apply = [[JHApplyVC alloc] init];
    [self.navigationController pushViewController:apply animated:YES];
}
#pragma mark -清除按钮
-(void)phoneRightImgClick{
    phoneF.text = @"";
}
-(void)keyRightImgClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        keyF.secureTextEntry = NO;
    }else{
        keyF.secureTextEntry = YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FindPassword" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changePassword" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeMobile" object:nil];
}
@end

