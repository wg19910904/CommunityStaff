//
//  JHReachabiltyModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/13.
//  Copyright © 2016年 jianghu2. All rights reserved.
//断网通知

#import <Foundation/Foundation.h>
#import "Reachability.h"
@interface JHShareModel : NSObject
@property (nonatomic,strong)Reachability *hostReach;
@property (nonatomic,strong)NSString *cityCode;//城市编号
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *mobile;
/**
 保存当前版本
 */
@property(nonatomic,copy)NSString *version;
@property(nonatomic,assign)BOOL isNotUpdate;//是否强制升级
//存储默认的区号
@property(nonatomic,copy)NSString *def_code;

+(JHShareModel *)shareModel;
//添加断网通知
-(void)addReachability;
@end
