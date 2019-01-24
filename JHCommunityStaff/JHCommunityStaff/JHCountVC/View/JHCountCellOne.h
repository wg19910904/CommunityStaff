//
//  JHCountCellOne.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCountCellOne : UITableViewCell
@property (nonatomic,strong)UILabel *today_num;//今日
@property (nonatomic,strong)UILabel *week_num;//本周
@property (nonatomic,strong)UILabel *month_num;//本月
@property (nonatomic,strong)UILabel *total_num;//累计
@property (nonatomic,strong)UILabel *today;//今日订单量or今日收入额
@property (nonatomic,strong)UILabel *week;//本周订单量or本周收入额
@property (nonatomic,strong)UILabel *month;//本月订单量or本月收入额
@property (nonatomic,strong)UILabel *total;//累计订单量or累计收入额
@property (nonatomic,strong)NSArray *dataArray;//数据源
- (void)setDataArray:(NSArray *)dataArray withType:(NSString *)type;
@end
