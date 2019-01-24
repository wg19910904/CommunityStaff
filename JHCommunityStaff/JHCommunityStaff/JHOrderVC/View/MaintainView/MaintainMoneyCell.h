//
//  MaintainMoneyCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MaintainOrderDetailFrameModel.h"
@interface MaintainMoneyCell : UITableViewCell
@property (nonatomic,strong)UILabel *money;//定金
//@property (nonatomic,strong)UILabel *danbaoAmount;//担保金额
@property (nonatomic,strong)UILabel *jiesuan;//结算金额
//@property (nonatomic,strong)UILabel *totalMoney;//服务总额
//@property (nonatomic,strong)UILabel *hongBaoTitle;//红包抵扣
@property (nonatomic,strong)MaintainOrderDetailFrameModel *maintainDetailFramelModel;
@end
