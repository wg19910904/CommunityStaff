//
//  JHHouseingCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHouseingListModel.h"
@interface JHHouseingCell : UITableViewCell
@property (nonatomic,strong)UIButton *mobileButton;//打电话按钮
@property (nonatomic,strong)UIButton *look;//查看路线
@property (nonatomic,strong)UIButton *statusButton;//状态按钮
@property (nonatomic,strong)JHHouseingListModel *houseingModel;
@end
