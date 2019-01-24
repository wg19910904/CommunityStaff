//
//  JHOrderCommentCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "OrderCommentFrameModel.h"

typedef  void (^OrderCommentBlock)();

@interface JHOrderCommentCell : UITableViewCell
@property (nonatomic,strong)UIImageView *icon;//评价人员头像
@property (nonatomic,strong)StarView *starView;//星星等级
@property (nonatomic,strong)UILabel *nameLabel;//姓名和时间
@property (nonatomic,strong)UILabel *content;//评价内容
@property (nonatomic,strong)UILabel *replyContent;//回复内容
@property (nonatomic,strong)UIImageView *replyImg;//灰色背景
@property (nonatomic,strong)UILabel *replyTime;//回复时间
@property (nonatomic,strong)OrderCommentFrameModel *frameModel;
@property (nonatomic,copy)OrderCommentBlock orderCommentBlock;
@end
