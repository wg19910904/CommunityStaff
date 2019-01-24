//
//  JHVerifyVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHVerifyVC : JHBaseVC
@property (nonatomic,copy)NSString *userName;//姓名
@property (nonatomic,copy)NSString *userId;//身份证号
@property (nonatomic,copy)NSString *img;//认证照片
@property (nonatomic,copy)NSString *verifyStatus;//认证状态
@property (nonatomic,copy)NSString *reason; // 拒绝原因
@end
