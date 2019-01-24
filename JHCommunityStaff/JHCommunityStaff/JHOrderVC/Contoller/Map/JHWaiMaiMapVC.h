//
//  JHWaiMaiMapVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHWaiMaiMapVC : JHBaseVC
@property (nonatomic,copy)NSString *o_lat;
@property (nonatomic,copy)NSString *o_lng;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *pei_type;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *online_pay;
@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,strong)NSDictionary *comment_info;
@property (nonatomic,copy)NSString *order_status_label;
@property (nonatomic,copy)NSString *paoTuiAmount;
@property (nonatomic,copy)NSString *order_id;
@end
