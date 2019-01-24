//
//  InfoModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/14.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InfoModel : NSObject
@property (nonatomic,copy)NSString *city_id;
@property (nonatomic,copy)NSString *face;
@property (nonatomic,copy)NSString *id_name;
@property (nonatomic,copy)NSString *id_number;
@property (nonatomic,copy)NSString *id_photo;
@property (nonatomic,copy)NSString *is_account;
@property (nonatomic,copy)NSString *mobile;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,copy)NSString *verify_name;
@property (nonatomic,copy)NSString *tech_number;
@property (nonatomic,strong)NSDictionary *verify;
@property (nonatomic,strong)NSDictionary *account_info;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *from;
@property (nonatomic,copy)NSString *intro;
@end
