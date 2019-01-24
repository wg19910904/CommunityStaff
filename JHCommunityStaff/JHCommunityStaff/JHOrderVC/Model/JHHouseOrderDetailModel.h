//
//  JHHouseOrderDetailModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/21.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHHouseOrderDetailModel : NSObject
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *shop_id;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *fuwu_time;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *online_pay;
@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,copy)NSString *total_price;
@property (nonatomic,copy)NSString *hongbao_id;
@property (nonatomic,copy)NSString *hongbao;
@property (nonatomic,copy)NSString *order_youhui;
@property (nonatomic,copy)NSString *first_youhui;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *o_lng;
@property (nonatomic,copy)NSString *o_lat;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *house;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,copy)NSString *order_from;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *cui_time;
@property (nonatomic,copy)NSString *comment_status;
@property (nonatomic,copy)NSString *jd_time;
@property (nonatomic,copy)NSString *pay_code;
@property (nonatomic,copy)NSString *pay_time;
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *cate_title;
@property (nonatomic,copy)NSString *jiesuan_price;
@property (nonatomic,copy)NSString *danbao_amount;
@property (nonatomic,copy)NSString *order_status_label;
@property (nonatomic,copy)NSString *order_status_warning;
@property (nonatomic,copy)NSString *juli_label;
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,strong)NSDictionary *comment_info;
@property (nonatomic,strong)NSDictionary *voice_info;
@end
