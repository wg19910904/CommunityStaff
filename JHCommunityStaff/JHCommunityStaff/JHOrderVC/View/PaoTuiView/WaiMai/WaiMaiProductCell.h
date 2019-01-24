//
//  WaiMaiCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WaiMaiProductCell : UITableViewCell
@property (nonatomic,strong)UILabel *title;//菜品和价格
@property (nonatomic,strong)UILabel *num;//数量
@property (nonatomic,strong)NSDictionary *dataDic;
@end
