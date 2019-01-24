//
//  JHPaotuiListModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPaotuiListModel : NSObject
@property (nonatomic,copy)NSString *addr;
@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *comment_status;
@property (nonatomic,copy)NSString *contact;
@property (nonatomic,copy)NSString *cui_time;
@property (nonatomic,copy)NSString *danbao_amount;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *day;
@property (nonatomic,copy)NSString *first_youhui;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *hongbao;
@property (nonatomic,copy)NSString *hongbao_id;
@property (nonatomic,copy)NSString *house;
@property (nonatomic,copy)NSString *intro;
@property (nonatomic,copy)NSString *jd_time;
@property (nonatomic,copy)NSString *jiesuan_price;
@property (nonatomic,copy)NSString *juli_qidian;
@property (nonatomic,copy)NSString *juli_quancheng;
@property (nonatomic,copy)NSString *juli_zhongdian;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *money;
@property (nonatomic,copy)NSString *o_addr;
@property (nonatomic,copy)NSString *o_house;
@property (nonatomic,copy)NSString *o_lat;
@property (nonatomic,copy)NSString *o_lng;
@property (nonatomic,copy)NSString *online_pay;
@property (nonatomic,copy)NSString *order_from;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *order_status_label;
@property (nonatomic,copy)NSString *order_status_warning;
@property (nonatomic,copy)NSString *order_youhui;
@property (nonatomic,copy)NSString *paotui_amount;
@property (nonatomic,copy)NSString *pay_code;
@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,copy)NSString *pay_time;
@property (nonatomic,copy)NSString *shop_id;
@property (nonatomic,copy)NSString *shop_name;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *total_price;
@property (nonatomic,copy)NSString *trade_no;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *type_name;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *pei_time;
@property (nonatomic,copy)NSString *pei_type;
@property (nonatomic,copy)NSString *pei_amount;
@property (nonatomic,strong)NSDictionary *comment_info;
@property (nonatomic,strong)NSString *pei_time_label;

@property (nonatomic,assign)BOOL shopInfoAllHidden;//商家的全部信息是否隐藏
@property (nonatomic,assign)BOOL shopHidden;//商家姓名及电话是否隐藏
@property (nonatomic,assign)BOOL clientHidden;//客户姓名及电话是否隐藏
@property (nonatomic,assign)CGFloat shopAddrH;//商家的地址高度
@property (nonatomic,assign)CGFloat clientAddrH;//客户的地址高度
@property (nonatomic,assign)CGFloat cellHeight;//模型对应cell的高度
@end
