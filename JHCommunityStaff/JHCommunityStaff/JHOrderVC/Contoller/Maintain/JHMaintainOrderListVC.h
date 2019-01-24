//
//  JHMaintainOrderListVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/11.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^MaintainBlock)(JHBaseVC *vc);
@interface JHMaintainOrderListVC : JHBaseVC
@property (nonatomic,copy)MaintainBlock maintainBlock;
@property (nonatomic,copy)NSString *verifyName;
@property(nonatomic,strong)NSDictionary *conditionDic;
@property(nonatomic,assign)BOOL isSearchResult;//是否是搜索界面跳转过来
- (instancetype)initWithFrame:(CGRect)frame
                   withVerify:(NSString *)verifyName
                     withBool:(BOOL)isSearch
                withCondition:(NSMutableDictionary *)dic;
@end
