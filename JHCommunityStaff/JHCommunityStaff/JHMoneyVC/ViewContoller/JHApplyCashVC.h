//
//  JHApplyCashVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^ApplyCashBlock)();

@interface JHApplyCashVC : JHBaseVC
@property (nonatomic,copy)ApplyCashBlock applyCashBlock;
@end
