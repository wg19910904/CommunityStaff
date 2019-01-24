//
//  JHCountCellTwo.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCountCellTwo : UITableViewCell
@property (nonatomic,strong)UILabel *title;//近一周收入曲线or近一周订单量曲线
- (void)configUIWthType:(NSString *)type data:(NSArray *)dataArray title:(NSArray *)titleArray;
@end
