//
//  SkillModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/14.
//  Copyright © 2016年 jianghu2. All rights reserved.
//技能模型

#import <Foundation/Foundation.h>

@interface SkillModel : NSObject
@property (nonatomic,copy)NSString *cate_id;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *icon;
@property (nonatomic,copy)NSString *info;
@property (nonatomic,copy)NSString *orderby;
@property (nonatomic,copy)NSString *orders;
@property (nonatomic,copy)NSString *parent_id;
@property (nonatomic,copy)NSString *photo;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *start;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *unit;
@property (nonatomic,copy)NSString *is_selected;
@end
