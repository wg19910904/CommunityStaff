//
//  JHShowAlert.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShowAlert.h"

@implementation JHShowAlert
+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)msg withBtn_cancel:(NSString *)cancel withBtn_true:(NSString *)ensure withVC:(UIViewController *)vc{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];

    }
    if (ensure) {
        [alertControl addAction:[UIAlertAction actionWithTitle:ensure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [vc presentViewController:alertControl animated:YES completion:nil];
}
+(void)showAlertWithTitle:(NSString *)title
              withMessage:(NSString *)msg
           withBtn_cancel:(NSString *)cancel
             withBtn_sure:(NSString *)sure
          withCancelBlock:(void(^)(void))cancelBlock
            withSureBlock:(void(^)(void))sureBlock {
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
    }
    if (sure) {
        [alertControl addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }
            
        }]];
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
}
+(void)showAlertWithMsg:(NSString *)msg
{
    
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil]];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
}
@end
