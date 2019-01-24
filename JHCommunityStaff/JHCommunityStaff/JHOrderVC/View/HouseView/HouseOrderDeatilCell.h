//
//  HouseOrderDeatilCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHouseOrderDetailFrameModel.h"
@interface HouseOrderDeatilCell : UITableViewCell

@property (nonatomic,strong)UILabel *orderID;//订单ID
@property (nonatomic,strong)UILabel *project;//预约项目
@property (nonatomic,strong)UILabel *time;//服务时间
@property (nonatomic,strong)UILabel *note;//备注
@property (nonatomic,strong)UIImageView *recordBck;//录音灰色背景
@property (nonatomic,strong)UIImageView *recordImg;//录音图标
@property (nonatomic,strong)UILabel *recordSecond;//录音秒数
@property (nonatomic,strong)UILabel *fuwutimeLabel;//服务时间
@property (nonatomic,strong)JHHouseOrderDetailFrameModel *houseOrderDetailFrameModel;
@end
