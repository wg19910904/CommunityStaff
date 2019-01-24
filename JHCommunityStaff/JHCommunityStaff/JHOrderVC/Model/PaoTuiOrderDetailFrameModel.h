//
//  PaoTuiOrderDetailFrameModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaotuiDetailModel.h"
@interface PaoTuiOrderDetailFrameModel : NSObject

@property (nonatomic,strong)PaotuiDetailModel *paoTuiDetailModel;
//外卖
@property (nonatomic,assign)CGFloat waimaiOrderDetailHeight;//外卖详情单元格高度
@property (nonatomic,assign)CGRect waimaiNoteRect;//外卖备注
@property (nonatomic,assign)CGFloat waimaiCustomerMessageHeight;//外卖订单客户商家信息豪高度
@property (nonatomic,assign)CGRect waimaiCustomerAddrRect;
@property (nonatomic,assign)CGRect waimaiShopAddrRect;
//帮我送
@property (nonatomic,assign)CGFloat songOrderDetailHeight;
@property (nonatomic,assign)CGRect songNoteRect;
@property (nonatomic,assign)CGFloat songCustomerMessageHeight;
@property (nonatomic,assign)CGRect songPickerRect;
@property (nonatomic,assign)CGRect songDeliverRect;
//帮我买
@property (nonatomic,assign)CGFloat buyOrderDetailHeight;
@property (nonatomic,assign)CGFloat buyCustomerMessageHeight;
@property (nonatomic,assign)CGRect buyNoteRect;
@property (nonatomic,assign)CGRect buyAddrRect;
@property (nonatomic,assign)CGRect buyGetAddrRect;
@property (nonatomic,assign)CGFloat buyMoneyHeight;

//跑腿其他订单
@property (nonatomic,assign)CGFloat otherOrderDeatailHeight;
@property (nonatomic,assign)CGFloat otherCustomerHeight;
@property (nonatomic,assign)CGRect otherNoteRect;
@property (nonatomic,assign)CGRect otherCustomerRect;
@end
