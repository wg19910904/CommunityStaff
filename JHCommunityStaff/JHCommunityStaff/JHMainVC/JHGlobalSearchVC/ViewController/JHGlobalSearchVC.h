//
//  JHGlobalSearchVC.h
//  JHCommunityStaff
//
//  Created by ijianghu on 2017/12/15.
//  Copyright © 2017年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHGlobalSearchVC : JHBaseVC
@property(nonatomic,copy)NSString *searchImgStr;//搜索的图片
@property(nonatomic,copy)NSString *choseTimeArrow;//选择时间的图片
@property(nonatomic,strong)UIColor *tintColor;//主题色
@property(nonatomic,copy)void(^clickBlock)(NSMutableDictionary *dic);
@property(nonatomic,copy)NSDictionary *cacheDic; //用于存储上次的筛选条件,当再次进入时,展示出来
@end
