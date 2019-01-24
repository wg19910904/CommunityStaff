//
//  HouseCustomerMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHouseOrderDetailFrameModel.h"
@interface HouseCustomerMessageCell : UITableViewCell
@property (nonatomic,strong)UILabel *basic;//姓名+电话
@property (nonatomic,strong)UILabel *destination;//目的地
@property (nonatomic,strong)UILabel *distant;//距离
@property (nonatomic,strong)UIButton *mobileButton;//打电话按钮
@property (nonatomic,strong)JHHouseOrderDetailFrameModel *houseOrderDetailFrame;
@end
