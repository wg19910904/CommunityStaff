//
//  JHMainVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"
#import "CDRTranslucentSideBar.h"
@interface JHMainVC : JHBaseVC
@property (nonatomic,strong) CDRTranslucentSideBar *sideBar;
@property(nonatomic,assign)BOOL isSearchResult;//是否是搜索界面跳转过来
@property(nonatomic,strong)NSMutableDictionary *conditionDic;
@end
