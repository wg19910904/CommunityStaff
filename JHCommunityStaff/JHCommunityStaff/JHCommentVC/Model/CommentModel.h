//
//  CommentModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic,copy)NSString *comment_id;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *have_photo;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,strong)NSArray *photos;
@property (nonatomic,copy)NSString *reply;
@property (nonatomic,copy)NSString *reply_time;
@property (nonatomic,copy)NSString *score;
@property (nonatomic,copy)NSString *uid;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *member_face;
@property (nonatomic,copy)NSString *member_name;

@end
