//
//  ReconderSearchChoseTimeCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YFTypeBtn.h"
@interface ReconderSearchChoseTimeCell : UITableViewCell
@property(nonatomic,strong)UILabel *leftL;
@property(nonatomic,strong)YFTypeBtn *rightBtn;
@property(nonatomic,copy)NSString *choseTimeArrow;//选择时间的图片
@end
