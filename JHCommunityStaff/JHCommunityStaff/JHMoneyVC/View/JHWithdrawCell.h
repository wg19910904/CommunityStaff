//
//  JHWithdrawCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMoneyFrameModel.h"

@interface JHWithdrawCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;//标题内容
@property (nonatomic,strong)UILabel *money;//金额
@property (nonatomic,strong)UILabel *account;//账户信息
@property (nonatomic,strong)JHMoneyFrameModel *moneyFrameModel;
@end
