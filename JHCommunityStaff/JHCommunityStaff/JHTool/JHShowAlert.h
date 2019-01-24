//
//  JHShowAlert.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHShowAlert : NSObject
+(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)msg withBtn_cancel:(NSString *)cancel withBtn_true:(NSString *)ensure withVC:(UIViewController *)vc;
/**
 *  JHShowAlert
 *
 *  @param title       提示标题
 *  @param msg         提示信息
 *  @param cancel      左边按钮名称
 *  @param sure        右边按钮名称
 *  @param cancelBlock 左边按钮点击方法回调
 *  @param sureBlock   右边的按钮点击方法回调
 */
+(void)showAlertWithTitle:(NSString *)title
              withMessage:(NSString *)msg
           withBtn_cancel:(NSString *)cancel
             withBtn_sure:(NSString *)sure
          withCancelBlock:(void(^)(void))cancelBlock
            withSureBlock:(void(^)(void))sureBlock;
/**
 *  显示简单信息
 *
 *  @param msg 要显示的信息
 */
+(void)showAlertWithMsg:(NSString *)msg;
@end
