//
//  PaoTuiCustomerMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaoTuiOrderDetailFrameModel.h"
@interface PaoTuiOtherCustomerMessageCell : UITableViewCell
@property (nonatomic,strong) UIButton *customerMobile;//客户电话按钮
@property (nonatomic,strong)PaoTuiOrderDetailFrameModel *paotuiFrameModel;
@end
