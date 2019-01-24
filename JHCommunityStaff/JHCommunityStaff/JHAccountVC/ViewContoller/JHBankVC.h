//
//  JHBankVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHBankVC : JHBaseVC
@property (nonatomic,copy)NSString *accountNumber;
@property (nonatomic,copy)NSString *accountName;
@property (nonatomic,copy)NSString *accountTitle;
@property (nonatomic,copy)NSString *accountValue;

@property (nonatomic,assign)BOOL status; //是否已设置
@end
