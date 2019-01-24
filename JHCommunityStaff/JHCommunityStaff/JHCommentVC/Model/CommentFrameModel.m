//
//  CommentFrameModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "CommentFrameModel.h"
#import "NSObject+CGSize.h"
@implementation CommentFrameModel
- (void)setCommentModel:(CommentModel *)commentModel{
    _commentModel = commentModel;
    CGFloat space = (WIDTH - 50 - 30) / 4;
    if(commentModel.content.length != 0){
        //CGSize contentSize = [self currentSizeWithString:commentModel.content font:FONT(14) withWidth:105];
         //_contentRect = FRAME(55, 22.5 + 15 + 20, WIDTH - 55 - 50, contentSize.height);
        CGSize contentSize = [self currentSizeWithString:commentModel.content font:FONT(14) withWidth:50];
        CGFloat height =  (contentSize.height / 14 - 1) * 6;
        _contentRect = FRAME(25, 22.5 + 15 + 20, WIDTH - 50,contentSize.height +  height);
        if(commentModel.photos.count == 0){
            if(commentModel.reply.length == 0){
                _rowHeight = 22.5 + 15 + 20 + 15 + 40 + _contentRect.size.height;
            }else{
                CGSize replySize = [self currentSizeWithString:commentModel.reply font:FONT(14) withWidth:50];
                CGFloat height =  (replySize.height / 14 - 1) * 6;
                _replyRect = FRAME(10, 15, replySize.width, replySize.height + height);
                _replyImgRect = FRAME(15, 22.5 + 15 + 20  + _contentRect.size.height  , WIDTH - 30, 45 + _replyRect.size.height);
                _rowHeight = 22.5 + 15 + 20  + _contentRect.size.height + 45 + _replyRect.size.height + 15 ;
            }
        }else{
             _imgHeight = 22.5 + 15 + 30 + _contentRect.size.height;
            if(commentModel.reply.length == 0){
                _rowHeight = 22.5 + 15 + 20 + 15 + 40 + _contentRect.size.height + 10 + space;
            }else{
                CGSize replySize = [self currentSizeWithString:commentModel.reply font:FONT(14) withWidth:50];
                CGFloat height =  (replySize.height / 14 - 1) * 6;
                _replyRect = FRAME(10, 15,replySize.width, replySize.height + height);
                _replyImgRect = FRAME(15, 22.5 + 15 + 20 + _contentRect.size.height + space + 15, WIDTH - 30, 45 + _replyRect.size.height);
                _rowHeight = 22.5 + 15 + 20  + _contentRect.size.height + 45 + _replyRect.size.height + 15  + space + 15;
            }
        }
    }else{
        if(commentModel.photos == 0){
        }else{
            _imgHeight =  22.5 + 15 + 20;
            if(commentModel.reply.length == 0){
            }else{
                CGSize replySize = [self currentSizeWithString:commentModel.reply font:FONT(14) withWidth:50];
                CGFloat height =  (replySize.height / 14 - 1) * 6;
                _replyRect = FRAME(10, 15, replySize.width, replySize.height + height);
                _replyImgRect = FRAME(15, 22.5 + 15 + 20 + 10 + space , WIDTH - 30, 45 + _replyRect.size.height);
                _rowHeight = 22.5 + 15 + 20  + space + 45 + _replyRect.size.height + 15 + 40;
            }
        }
    }
}
@end
