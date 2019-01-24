//
//  MaintainOrderDetailFrameModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MaintainDetailModel.h"
@interface MaintainOrderDetailFrameModel : NSObject
@property (nonatomic,strong)MaintainDetailModel *maintainDetailModel;
@property (nonatomic,assign)CGFloat orderDetailHeight;
@property (nonatomic,assign)CGFloat customerMessageHeight;
@property (nonatomic,assign)CGFloat imgHeight;
@property (nonatomic,assign)CGFloat moneyHeight;
@property (nonatomic,assign)CGRect  contentRect;//评论内容
@property (nonatomic,assign)CGRect recordRect;//录音
@property (nonatomic,assign)CGRect recordSecondRect;//秒数
@property (nonatomic,assign)CGRect  destinationRect;//目的地
@property (nonatomic,assign)CGRect distantRect;//距离我
@property (nonatomic,assign)CGRect mobileButtonRect;//电话按钮
@end
