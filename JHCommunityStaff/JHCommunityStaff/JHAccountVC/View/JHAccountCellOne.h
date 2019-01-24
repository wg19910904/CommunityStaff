//
//  JHAccountCellOne.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/8/26.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface JHAccountCellOne : UITableViewCell
@property (nonatomic,strong)UIImageView *iconImg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *mobileLabel;
@property (nonatomic,strong)InfoModel *infoModel;
@property (nonatomic,strong)UIImageView *dirImg;
@end
