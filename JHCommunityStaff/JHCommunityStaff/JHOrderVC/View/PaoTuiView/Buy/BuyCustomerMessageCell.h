//
//  BuyCustomerMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaoTuiOrderDetailFrameModel.h"
@interface BuyCustomerMessageCell : UITableViewCell
@property (nonatomic,strong)UIButton *mobileButton;//打电话按钮
@property (nonatomic,strong)PaoTuiOrderDetailFrameModel *paotuiDetailFrameModel;
@end
