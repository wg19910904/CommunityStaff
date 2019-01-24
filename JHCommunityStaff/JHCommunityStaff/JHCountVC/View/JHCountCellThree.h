//
//  JHCountCellThree.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHCountCellThree : UITableViewCell
@property (nonatomic,strong)UILabel *title;//近一月收入曲线or近一月订单量曲线
-(void)creatNSMutableArray:(NSMutableArray *)infoArray withNSMutableArray:(NSMutableArray *)dateArray withType:(NSString *)type;

@end
