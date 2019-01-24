//
//  JHCommentCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "CommentFrameModel.h"
#import "YFStartView.h"
@interface JHCommentCell : UITableViewCell
@property (nonatomic,strong)UIImageView *icon;//评价人员头像
@property (nonatomic,strong)YFStartView *starView;//星星等级
@property (nonatomic,strong)UILabel *nameLabel;//姓名和时间
@property (nonatomic,strong)UILabel *content;//评价内容
@property (nonatomic,strong)UIButton *replyBnt;//回复按钮
@property (nonatomic,strong)UILabel *replyContent;//回复内容
@property (nonatomic,strong)UIImageView *replyImg;//灰色背景
@property (nonatomic,strong)UILabel *replyTime;//回复时间
@property (nonatomic,strong)CommentFrameModel *frameModel;
@end
