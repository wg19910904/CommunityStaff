//
//  JHMainTainSkillCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/7/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHMaintainSkillCell : UITableViewCell
@property (nonatomic,copy)void(^maintainSkillBlock)(NSArray *skillArray);
@property (nonatomic,strong)NSArray *dataArray;

@end
