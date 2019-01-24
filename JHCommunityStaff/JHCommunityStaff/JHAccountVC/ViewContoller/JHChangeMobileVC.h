//
//  JHChangeMobileVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHChangeMobileVC : JHBaseVC
@property (nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)void(^(myBlock))(NSString * newMobile);
@end
