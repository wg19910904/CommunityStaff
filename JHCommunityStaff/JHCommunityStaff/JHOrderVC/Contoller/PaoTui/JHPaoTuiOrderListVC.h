//
//  JHPaoTuiOrderListVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/11.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

typedef void(^PaoTuiBlock)(JHBaseVC *vc);

@interface JHPaoTuiOrderListVC : JHBaseVC
@property (nonatomic,copy)PaoTuiBlock paoTuiBlock;
@property (nonatomic,copy)NSString *verifyName;
@property(nonatomic,assign)BOOL isSearchResult;//是否是搜索界面跳转过来
- (instancetype)initWithFrame:(CGRect)frame
                   withVerify:(NSString *)verifyName
                     withBool:(BOOL)isSearch
                withCondition:(NSMutableDictionary *)dic;
- (void)loadNewData;
@end
