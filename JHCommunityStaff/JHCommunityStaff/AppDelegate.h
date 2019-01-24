//
//  AppDelegate.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/3.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLocationModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) JHLocationModel *locationModel;
@end

