//
//  JHChangeNameVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//修改昵称

#import "JHChangeNameVC.h"
#import "HttpTool.h"
@interface JHChangeNameVC ()<UITextFieldDelegate>
{
    UITextField *_nameTextField;
    UIButton *_rightBtn;//导航栏右侧完成按钮
    UILabel *_alertLabel;//特别提醒
}
@end

@implementation JHChangeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"姓名", nil)];
    [self createRightBarItem];
    [self createUI];
}
#pragma mark======创建右侧完成按钮=====
- (void)createRightBarItem{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    _rightBtn.titleLabel.font = FONT(16);
    [_rightBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(clickRightBnt)
       forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}
#pragma mark======搭建UI======
- (void)createUI{
    _nameTextField = [[UITextField alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 44)];
    _nameTextField.layer.cornerRadius = 4.0f;
    _nameTextField.layer.borderColor = THEME_COLOR.CGColor;
    _nameTextField.layer.borderWidth = 0.5f;
    _nameTextField.clipsToBounds = YES;
    _nameTextField.delegate = self;
    _nameTextField.placeholder = NSLocalizedString(@"请输入姓名", nil);
    _nameTextField.backgroundColor = [UIColor whiteColor];
    _nameTextField.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _nameTextField.leftView.backgroundColor = [UIColor whiteColor];
    _nameTextField.leftViewMode = UITextFieldViewModeAlways;
    _nameTextField.font = FONT(14);
    _alertLabel = [[UILabel alloc] initWithFrame:FRAME(0, 69, WIDTH, 15)];
    _alertLabel.text = NSLocalizedString(@"特别提示:身份认证成功后无法修改真实姓名", nil);
    _alertLabel.font = FONT(12);
    _alertLabel.textColor = HEX(@"999999", 1.0f);
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_nameTextField];
    [self.view addSubview:_alertLabel];
}

#pragma mark=====导航栏右侧完成按钮点击事件======
- (void)clickRightBnt{
    
    if(_nameTextField.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入姓名", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"name":_nameTextField.text};
        [HttpTool postWithAPI:@"staff/account/update_name" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeName" object:nil userInfo:dic];
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"修改失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
            NSLog(@"error%@",error.localizedDescription);
            
        }];
       

    }
    
}
#pragma mark======点击视图键盘消失=====
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}
#pragma mark======UITextFieldDelegate============
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
@end
