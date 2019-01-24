//
//  JHMoneyFrameModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMoneyModel.h"
@interface JHMoneyFrameModel : NSObject
@property (nonatomic,assign)CGRect contentRect;
@property (nonatomic,assign)CGFloat rowHeight;
@property (nonatomic,strong)JHMoneyModel *moneyModel;
@end
