//
//  JHBaseVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/3.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBaseVC : UIViewController

/**
 *  返回时箭头
 */
@property (nonatomic, strong)UIButton *backBtn;
/**
 *  外部函数
 */
- (void)clickBackBtn;
//添加导航栏标题
- (void)addTitle:(NSString *)title;
//提示框
- (void)showAlertViewWithTitle:(NSString *)title;
/**
 *没有更多数据
 */
- (void)showHaveNoMoreData;
/**
 *打电话提示框
 */
- (void)showMobile:(NSString *)title;
/**
 *  显示一个按钮,并且按钮有回调Block
 *
 *  @param msg      显示的信息
 *  @param title    按钮的文字
 *  @param btnBlock 按钮的回调
 */
- (void)showAlertWithMsg:(NSString *)msg
            withBtnTitle:(NSString *)title
            withBtnBlock:(void(^)())btnBlock;

@end
