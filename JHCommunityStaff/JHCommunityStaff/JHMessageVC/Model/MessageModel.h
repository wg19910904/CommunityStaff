//
//  MessageModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *dateline;
@property (nonatomic,copy)NSString *is_read;
@property (nonatomic,copy)NSString *msg_id;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *title;
@end
