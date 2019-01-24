//
//  BuyMoneyCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaoTuiOrderDetailFrameModel.h"
@interface BuyMoneyCell : UITableViewCell
@property (nonatomic,strong)UILabel *money;//定金
@property (nonatomic,strong)UILabel *danBaoAmount;//担保金额
@property (nonatomic,strong)UILabel *jiesuan;//结算金额
//@property (nonatomic,strong)UILabel *totalMoney;//服务总额
//@property (nonatomic,strong)UILabel *hongBaoTitle;//红包抵扣
@property (nonatomic,strong)PaoTuiOrderDetailFrameModel *paotuiDetailFrameModel;
@end
