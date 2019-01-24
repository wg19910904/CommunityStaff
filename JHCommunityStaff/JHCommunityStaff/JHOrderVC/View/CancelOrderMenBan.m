//
//  CancelOrderMenBan.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "CancelOrderMenBan.h"
#import "AppDelegate.h"
#import "HttpTool.h"
@interface CancelOrderMenBan ()<UITextViewDelegate>
{
    UITextView *_cancelText;//取消理由
    UIButton *_lastBnt;//记录理由按钮的上一次选择
    UILabel *_describleLabel;//请输入你想回复的内容标签
    UILabel *_numLabel;//字数标签
    UIView  *_cancelBackView;//取消订单蒙版白色视图
    NSString *_reason;//取消订单理由
}

@end


@implementation CancelOrderMenBan

+ (void)createCanCelOrderMenBanWithOrderId:(NSString *)order_id from:(NSString *)from viewControllwer:(JHBaseVC *)vc success:(void (^)(void))success{
    CancelOrderMenBan *cancel = [[CancelOrderMenBan alloc] init];
    cancel.order_id = order_id;
    cancel.from = from;
    cancel.vc = vc;
    dispatch_async(dispatch_get_main_queue(), ^{
       [cancel createCanCelOrderMenBan:cancel];
    });
    cancel.successCancelOrder = ^{
        success();
    };
}
- (void)createCanCelOrderMenBan:(CancelOrderMenBan  * )mengban{
    mengban.frame = FRAME(0, 0, WIDTH, HEIGHT);
    _cancelOrderMenBan = mengban;
    [mengban addTarget:self action:@selector(touchView) forControlEvents:UIControlEventTouchUpInside];
    mengban.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app.window addSubview:mengban];
    _cancelBackView = [[UIView alloc] initWithFrame:FRAME(27.5, (HEIGHT  - 255) / 2, WIDTH - 55, 255)];
    _cancelBackView.backgroundColor = [UIColor whiteColor];
    _cancelBackView.layer.cornerRadius = 4.0f;
    _cancelBackView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ddddd)];
    _cancelBackView.userInteractionEnabled = YES;
    [_cancelBackView addGestureRecognizer:tap];
    [mengban addSubview:_cancelBackView];
    UILabel *title = [[UILabel alloc] initWithFrame:FRAME(0, 0, _cancelBackView.bounds.size.width, 40)];
    title.font = FONT(14);
    title.textColor = HEX(@"333333", 1.0f);
    title.text = NSLocalizedString(@"取消理由", nil);
    title.textAlignment = NSTextAlignmentCenter;
    [_cancelBackView addSubview:title];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, _cancelBackView.bounds.size.width, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_cancelBackView addSubview:thread];
    CGFloat space = (_cancelBackView.bounds.size.width - 240)/4;
    for(int i = 0 ; i < 3; i ++){
        UIButton *bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        bnt.frame = FRAME(space + (80 + space) * i, 55, 80, 30);
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateHighlighted];
        [bnt setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [bnt setTitleColor:HEX(@"666666", 1.0f) forState:UIControlStateNormal];
        bnt.layer.cornerRadius = 15.0f;
        bnt.layer.borderColor = LINE_COLOR.CGColor;
        bnt.layer.borderWidth = 0.5f;
        bnt.clipsToBounds = YES;
        bnt.tag = i + 1;
        bnt.titleLabel.font = FONT(12);
        if(i == 0){
            bnt.selected = YES;
            _lastBnt = bnt;
            [bnt setTitle:NSLocalizedString(@"临时有事", nil) forState:UIControlStateNormal];
            _reason = bnt.currentTitle;
        }else if (i == 1){
            [bnt setTitle:NSLocalizedString(@"时间来不及", nil) forState:UIControlStateNormal];
        }else{
            [bnt setTitle:NSLocalizedString(@"身体不舒服", nil) forState:UIControlStateNormal];
        }
        [bnt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBackView addSubview:bnt];
    }
    UIView *textBackView = [[UIView alloc] initWithFrame:FRAME(15, 95, _cancelBackView.bounds.size.width - 30, 90)];
    textBackView.backgroundColor = HEX(@"fafafa", 1.0f);
    [_cancelBackView addSubview:textBackView];
    _cancelText = [[UITextView alloc] initWithFrame:FRAME(10, 0, textBackView.bounds.size.width - 20, 80 - 15)];
    _cancelText.delegate = self;
    _cancelText.font = FONT(12);
    _cancelText.backgroundColor = HEX(@"fafafa", 1.0f);
    [textBackView addSubview:_cancelText];
    _describleLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, _cancelText.bounds.size.width - 20, 15)];
    _describleLabel.font = FONT(12);
    _describleLabel.textColor = HEX(@"cccccc", 1.0f);
    _describleLabel.text = NSLocalizedString(@"补充说明", nil);
    [_cancelText addSubview:_describleLabel];
    _numLabel = [[UILabel alloc] initWithFrame:FRAME(textBackView.bounds.size.width - 140,textBackView.bounds.size.height - 15, 130, 15)];
    _numLabel.text = NSLocalizedString(@"120字", nil);
    _numLabel.font = FONT(12);
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = HEX(@"cccccc", 1.0f);
    [textBackView addSubview:_numLabel];
    CGFloat bntSpace = (_cancelBackView.bounds.size.width - 160) / 3;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = FRAME(bntSpace, 200, 80, 40);
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(16);
    [cancelBtn setBackgroundColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 4.0f;
    cancelBtn.clipsToBounds = YES;
    [_cancelBackView addSubview:cancelBtn];
    UIButton *certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certainBtn.frame = FRAME(2 * bntSpace + 80, 200, 80, 40);
    [certainBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [certainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    certainBtn.titleLabel.font = FONT(16);
    [certainBtn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(certainButton) forControlEvents:UIControlEventTouchUpInside];
    certainBtn.layer.cornerRadius = 4.0f;
    certainBtn.clipsToBounds = YES;
    [_cancelBackView addSubview:certainBtn];
}
#pragma mark--=======蒙版上取消按钮点击事件=====
- (void)cancelButton{
    [_cancelOrderMenBan removeFromSuperview];
    _cancelOrderMenBan = nil;
}
#pragma mark=======蒙版上确定按钮点击事件==========
- (void)certainButton{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_cancelBackView animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.color = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString *reason = nil;
    if(_cancelText.text.length == 0){
        reason = _reason;
    }else{
        reason = [NSString stringWithFormat:NSLocalizedString(@"%@,补充:%@", nil),_reason,_cancelText.text];
    }
    NSDictionary *dic = @{@"order_id":self.order_id,@"reason":reason};
    NSString *api = nil;
    if([self.from isEqualToString:@"house"]){
        api = @"staff/house/order/cancel";
    }else if([self.from isEqualToString:@"weixiu"]){
        api = @"staff/weixiu/order/cancel";
    }else if([self.from isEqualToString:@"waimai"]){
        api = @"staff/waimai/order/cancel";
    }else {
        api = @"staff/paotui/order/cancel";
    }
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
        if([json[@"error"] isEqualToString:@"0"]){
            [_cancelOrderMenBan removeFromSuperview];
            _cancelOrderMenBan = nil;
            if(self.successCancelOrder){
                self.successCancelOrder();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelOrder" object:nil];
        }else{
            [_cancelOrderMenBan removeFromSuperview];
            _cancelOrderMenBan = nil;
            [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
            [self showAlert:[NSString stringWithFormat:NSLocalizedString(@"取消订单失败 ,原因%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        [_cancelOrderMenBan removeFromSuperview];
        _cancelOrderMenBan = nil;
        [MBProgressHUD hideHUDForView:_cancelBackView animated:YES];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlert:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        
    }];
}
#pragma mark========取消订单理由上面蒙版白色视图的轻点手势事件============
- (void)ddddd{
    [_cancelText resignFirstResponder];
}
#pragma mark========取消理由蒙版理由按钮点击事件========
- (void)clickButton:(UIButton *)sender{
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
        _lastBnt.layer.borderColor = LINE_COLOR.CGColor;
    }
    sender.selected = YES;
    sender.layer.borderColor  = THEME_COLOR.CGColor;
    _lastBnt = sender;
    _reason = sender.currentTitle;
}
#pragma mark=====取消理由蒙版点击事件=======
- (void)touchView{
    [_cancelOrderMenBan removeFromSuperview];
    _cancelOrderMenBan = nil;
}
#pragma mark=======UITextViewDelegate=======
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _describleLabel.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _cancelBackView.frame;
        rect.origin.y = 40;
        _cancelBackView.frame = rect;
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if(_cancelText.text.length == 0){
        _describleLabel.hidden = NO;
        _numLabel.text = NSLocalizedString(@"120字", nil);
    }else if (_cancelText.text.length < 120 && _cancelText.text.length > 0){
        NSInteger num = 120 - (_cancelText.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }else{
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _cancelBackView.frame;
        rect.origin.y = (HEIGHT  - 255) / 2;
        _cancelBackView.frame = rect;
    }];
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_cancelText.text.length >= 120){
        [self textViewShouldEndEditing:_cancelText];
        [_cancelText resignFirstResponder];
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }else{
        NSInteger num = 120 - (_cancelText.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }
}
#pragma mark-======显示警告框=====
- (void)showAlert:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self.vc presentViewController:alertController animated:YES completion:nil];
}
@end
