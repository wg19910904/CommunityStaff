//
//  OrderCommentFrameModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/17.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
@interface OrderCommentFrameModel : NSObject
@property (nonatomic,assign)CGRect contentRect;//评价内容尺寸
@property (nonatomic,assign)CGFloat imgHeight;//图片尺寸
@property (nonatomic,assign)CGRect replyRect;//回复内容尺寸
@property (nonatomic,assign)CGRect replyImgRect;//回复灰色底图尺寸
@property (nonatomic,assign)CGFloat rowHeight;//单元格尺寸
@property (nonatomic,strong)CommentModel *commentModel;
@end
