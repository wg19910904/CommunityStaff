//
//  SetMoneyMenBan.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "HouseSetMoneyMenBan.h"
#import "MaintainSetMoneyMenBan.h"
#import "AppDelegate.h"
#import "HttpTool.h"
@interface HouseSetMoneyMenBan ()<UITextFieldDelegate>
{
    UITextField *_amountFiled;//金额
    UIView *_backView;//蒙版上的白色视图
}

@end

@implementation HouseSetMoneyMenBan
+ (void)creatSetMoneyMenBanWithOrderId:(NSString *)order_id viewController:(JHBaseVC *)vc success:(void (^)(void))success cancel:(void (^)(void))cancel{
    HouseSetMoneyMenBan *setMoney = [[HouseSetMoneyMenBan alloc] init];
    setMoney.order_id = order_id;
    setMoney.vc = vc;
    setMoney.success = ^{
        success();
    };
    setMoney.cancel = ^{
        cancel();
    };
    [setMoney creatSetMoneyMenBan:setMoney];
}
- (void)creatSetMoneyMenBan:(HouseSetMoneyMenBan *)menBan{
    menBan.frame = FRAME(0, 0, WIDTH, HEIGHT);
    _setMoneyMenBan = menBan;
    [menBan addTarget: self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
    _setMoneyMenBan.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:menBan];
    _backView = [[UIView alloc] initWithFrame:FRAME(27.5,  (HEIGHT  - 200) / 2, WIDTH - 55, 200)];
    _backView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackView)];
    [_backView addGestureRecognizer:tap];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 4.0f;
    _backView.clipsToBounds = YES;
    [menBan addSubview:_backView];
    UILabel *title = [[UILabel alloc] initWithFrame:FRAME(0, 0, _backView.bounds.size.width, 40)];
    title.font = FONT(14);
    title.textColor = HEX(@"333333", 1.0f);
    title.text = NSLocalizedString(@"设定结算金额", nil);
    title.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:title];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, _backView.bounds.size.width, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_backView addSubview:thread];
    _amountFiled = [[UITextField alloc] initWithFrame:FRAME(15, 55, _backView.bounds.size.width - 30, 40)];
    _amountFiled.delegate = self;
    _amountFiled.keyboardType = UIKeyboardTypeDecimalPad;
    _amountFiled.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _amountFiled.leftViewMode =  UITextFieldViewModeAlways;
    UILabel *yuan = [[UILabel alloc] initWithFrame:FRAME(0, 0, 25, 40)];
    yuan.textColor = HEX(@"ff6600", 1.0f);
    yuan.text = NSLocalizedString(@"元", nil);
    yuan.font = FONT(14);
    _amountFiled.rightView = yuan;
    _amountFiled.rightViewMode = UITextFieldViewModeAlways;
    _amountFiled.placeholder = NSLocalizedString(@"请输入订单总金额", nil);
    _amountFiled.textColor = HEX(@"ff6600", 1.0f);
    _amountFiled.backgroundColor = BACK_COLOR;
    _amountFiled.layer.cornerRadius = 4.0f;
    _amountFiled.layer.borderColor = LINE_COLOR.CGColor;
    _amountFiled.layer.borderWidth = 0.5f;
    _amountFiled.clipsToBounds = YES;
    [_backView addSubview:_amountFiled];
    UILabel *describel = [[UILabel alloc] initWithFrame:FRAME(15, 100, _backView.bounds.size.width - 30, 15)];
    describel.font = FONT(12);
    describel.textColor = HEX(@"999999", 1.0f);
    describel.text = NSLocalizedString(@"金额为您和客户商量后的金额,方便结算", nil);
    [_backView addSubview:describel];
    CGFloat space = (_backView.bounds.size.width - 160) / 3;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = FRAME(space, 130, 80, 40);
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(16);
    [cancelBtn setBackgroundColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMoneyButton) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 4.0f;
    cancelBtn.clipsToBounds = YES;
    [_backView addSubview:cancelBtn];
    UIButton *certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certainBtn.frame = FRAME(2 *space + 80, 130, 80, 40);
    [certainBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = FONT(16);
    [certainBtn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certainMoneyButton) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.layer.cornerRadius = 4.0f;
    certainBtn.clipsToBounds = YES;
    [_backView addSubview:certainBtn];
    
}
#pragma mark======蒙版上白色视图的轻点手势按钮点击事件==========
- (void)tapBackView{
    [_amountFiled resignFirstResponder];
}
#pragma mark--=======蒙版上取消按钮点击事件=====
- (void)cancelMoneyButton{
    if(self.cancel){
        self.cancel();
    }
    [_setMoneyMenBan removeFromSuperview];
    _setMoneyMenBan = nil;
}
- (void)touchView{
    [_setMoneyMenBan removeFromSuperview];
    _setMoneyMenBan = nil;
}
#pragma mark=======蒙版上确定按钮点击事件==========
- (void)certainMoneyButton{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_backView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSDictionary *dic = @{@"order_id":self.order_id,@"jiesuan_price":_amountFiled.text};
    [HttpTool postWithAPI:@"staff/house/order/setprice" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [MBProgressHUD hideHUDForView:_backView animated:YES];
            [_setMoneyMenBan removeFromSuperview];
            _setMoneyMenBan = nil;
            if(self.success){
                self.success();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"houseSetMoney" object:nil];
        }else{
            [MBProgressHUD hideHUDForView:_backView animated:YES];
            [_setMoneyMenBan removeFromSuperview];
            _setMoneyMenBan = nil;
            [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"设置总额失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_backView animated:YES];
        [_setMoneyMenBan removeFromSuperview];
        _setMoneyMenBan = nil;
        NSLog(@"error%@",error.localizedDescription);
        [self showAlert:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark-======显示警告框=====
- (void)showAlert:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.vc presentViewController:alertController animated:YES completion:nil];
}

@end
