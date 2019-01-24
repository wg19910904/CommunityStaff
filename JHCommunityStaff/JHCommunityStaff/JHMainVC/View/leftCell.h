//
//  leftCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftCell : UITableViewCell
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)UILabel *title;
- (void)configSubViewWithImg:(UIImage *)img title:(NSString *)title frame:(NSInteger)frame;
@end
