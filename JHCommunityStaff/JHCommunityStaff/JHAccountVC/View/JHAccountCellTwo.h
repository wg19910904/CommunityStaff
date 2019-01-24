//
//  JHAccountCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/8/26.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoModel.h"
@interface JHAccountCellTwo : UITableViewCell
@property (nonatomic,strong)UILabel *leftTitle;//左边
@property (nonatomic,strong)UILabel *rightTitle;//右边
@property (nonatomic,strong)UIImageView *dirImg;//箭头图片
@property (nonatomic,assign)NSIndexPath *indexPath;
@property (nonatomic,strong)InfoModel *infoModel;
- (void)setInfoModel:(InfoModel *)infoModel indexPath:(NSIndexPath *)indexPath;
@end
