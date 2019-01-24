//
//  CancelOrderMenBan.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
typedef void(^SuccessCancelOrder)(void);



@interface CancelOrderMenBan : UIControl
@property (nonatomic,copy)NSString *from;
@property (nonatomic,weak)JHBaseVC *vc;
@property (nonatomic,strong)CancelOrderMenBan *cancelOrderMenBan;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)SuccessCancelOrder successCancelOrder;
+ (void)createCanCelOrderMenBanWithOrderId:(NSString *)order_id from:(NSString *)from viewControllwer:(JHBaseVC *)vc success:(void(^)(void))success;

@end
