//
//  MaintainSetMoneyMenBan.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/26.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
typedef void(^SuccessSetMoney)(void);
typedef void(^CancelSetMoney)(void);
@interface MaintainSetMoneyMenBan : UIControl
@property (nonatomic,strong)MaintainSetMoneyMenBan *setMoneyMenBan;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,weak)JHBaseVC *vc;
@property (nonatomic,copy)SuccessSetMoney success;
@property (nonatomic,copy)CancelSetMoney cancel;
+ (void)creatSetMoneyMenBanWithOrderId:(NSString *)order_id viewController:(JHBaseVC *)vc  success:(void(^)(void))success cancel:(void(^)(void))cancel;
@end

