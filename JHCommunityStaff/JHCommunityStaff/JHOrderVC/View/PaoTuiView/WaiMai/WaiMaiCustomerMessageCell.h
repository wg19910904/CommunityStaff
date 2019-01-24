//
//  WaiMaiCustomerMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/1.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaoTuiOrderDetailFrameModel.h"
@interface WaiMaiCustomerMessageCell : UITableViewCell
@property (nonatomic,strong)UIButton *customerMobile;//客户电话按钮
@property (nonatomic,strong)UIButton *shopMobile;//店家电话按钮

@property (nonatomic,strong)PaoTuiOrderDetailFrameModel *paotuiOrderDetailFrameModel;
@end
