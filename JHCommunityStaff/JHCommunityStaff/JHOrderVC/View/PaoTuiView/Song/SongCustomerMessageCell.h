//
//  SongCustomerMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaoTuiOrderDetailFrameModel.h"
@interface SongCustomerMessageCell : UITableViewCell
@property (nonatomic,strong) UIButton *pickMobile;//取货人电话按钮
@property (nonatomic,strong) UIButton *deliverMobile;//收货人电话按钮
@property (nonatomic,strong)PaoTuiOrderDetailFrameModel *paotuiFrameModel;
@end
