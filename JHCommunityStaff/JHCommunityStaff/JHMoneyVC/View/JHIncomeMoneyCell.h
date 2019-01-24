//
//  JHMoneyCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMoneyFrameModel.h"
@interface JHIncomeMoneyCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;//标题内容
@property (nonatomic,strong)UILabel *time;//时间
@property (nonatomic,strong)UILabel *money;//金额
@property (nonatomic,strong)JHMoneyFrameModel *moneyFrameModel;
@end
