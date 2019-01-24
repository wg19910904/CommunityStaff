//
//  JHOrderCommentCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHOrderCommentCell.h"
#import "TransformTime.h"//时间戳转换
#import "UIImageView+WebCache.h"
#import "MyTapGesture.h"
#import "DisplayImageInView.h"
@implementation JHOrderCommentCell
{
    UIImageView *_img1;
    UIImageView *_img2;
    UIImageView *_img3;
    UIImageView *_img4;
    NSMutableArray *_imgArray;
    UIView *_thread1;//
    UIView *_thread2;//
    UIView *_backView;//
    DisplayImageInView *_displayView;//展示图片
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH , 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
        [self initSubViews];
        [self initImg];
    }
    return self;
}
#pragma mark====初始化相关图片子控件=====
- (void)initImg{
    _img1 = [UIImageView new];
    _img2 = [UIImageView new];
    _img3 = [UIImageView new];
    _img4 = [UIImageView new];
    _imgArray = [@[] mutableCopy];
    [_imgArray addObject:_img1];
    [_imgArray addObject:_img2];
    [_imgArray addObject:_img3];
    [_imgArray addObject:_img4];
}

#pragma mark====初始化控件======
- (void)initSubViews{
    _backView = [[UIView alloc] init];
    _icon = [[UIImageView alloc] initWithFrame:FRAME(15, 15, 30, 30)];
    _icon.layer.cornerRadius = _icon.frame.size.width / 2;
    _icon.clipsToBounds = YES;
    [self.contentView addSubview:_icon];
    _nameLabel = [[UILabel alloc] initWithFrame:FRAME(55, 22.5, WIDTH - 55 - 85, 15)];
    _nameLabel.textColor = HEX(@"999999", 1.0f);
    _nameLabel.font = FONT(12);
    [self.contentView addSubview:_nameLabel];
    _starView = [[StarView alloc] initWithFrame:FRAME(WIDTH - 85, 25, 70, 10)];
    [self.contentView addSubview:_starView];
    _content = [[UILabel alloc] initWithFrame:FRAME(55, 22.5 + 15 + 20, WIDTH - 55 - 50, 15)];
    _content.font = FONT(14);
    _content.numberOfLines = 0;
    _content.textColor = HEX(@"333333", 1.0f);
    _thread1 = [[UIView alloc] init];
    _thread1.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_thread1];
    _replyImg = [[UIImageView alloc] init];
    _replyImg.image = IMAGE(@"reply_box");
    [self.contentView addSubview:_replyImg];
    _replyContent = [[UILabel alloc] init];
    _replyContent.font = FONT(14);
    _replyContent.numberOfLines = 0;
    _replyContent.textColor = HEX(@"666666", 1.0f);
    [_replyImg addSubview:_replyContent];
    _replyTime = [[UILabel alloc] init];
    _replyTime.font = FONT(12);
    _replyTime.textColor = HEX(@"999999", 1.0f);
    _replyTime.textAlignment = NSTextAlignmentRight;
    [_replyImg addSubview:_replyTime];
}
- (void)setFrameModel:(OrderCommentFrameModel *)frameModel{
    _frameModel = frameModel;
    CGFloat space = (WIDTH - 50 - 30) / 4;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:frameModel.commentModel.member_face]] placeholderImage:IMAGE(@"zl_head80")];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)",frameModel.commentModel.member_name,[TransformTime transfromWithString:frameModel.commentModel.dateline]];
    [_starView setStarWithValue:[frameModel.commentModel.score integerValue]];
    if(frameModel.commentModel.content.length == 0){
        [_content removeFromSuperview];
    }else{
        _content.text = frameModel.commentModel.content;
        _content.frame = frameModel.contentRect;
        [self.contentView addSubview:_content];
    }
    if(frameModel.commentModel.photos.count == 0){
        [_backView removeFromSuperview];
    }else{
        _backView.frame = FRAME(25, frameModel.imgHeight, WIDTH - 50, space);
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        for(int i = 0; i < frameModel.commentModel.photos.count; i ++){
            UIImageView *img = _imgArray[i];
            img.frame = FRAME((space + 10) * i ,0, space, space);
            [img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:frameModel.commentModel.photos[i]]] placeholderImage:IMAGE(@"pj_pic")];
            img.userInteractionEnabled = YES;
            [_backView addSubview:img];
            MyTapGesture *tap = [[MyTapGesture alloc] initWithTarget:self action:@selector(showImg:)];
            tap.tag = i + 1;
            [img addGestureRecognizer:tap];
            img.userInteractionEnabled = YES;
        }
    }
    if(frameModel.commentModel.reply.length ==  0){
        [_replyImg removeFromSuperview];
    }else{
        _replyContent.text = frameModel.commentModel.reply;
        _replyContent.frame = frameModel.replyRect;
        _replyImg.frame = frameModel.replyImgRect;
        _replyTime.frame = FRAME(_replyImg.frame.size.width - 140, _replyImg.frame.size.height - 25, 125, 15);
        _replyTime.text = [TransformTime transfromWithString:frameModel.commentModel.reply_time];
        [self.contentView addSubview:_replyImg];
    }
    _thread1.frame = FRAME(0, frameModel.rowHeight - 0.5, WIDTH , 0.5);
    if(frameModel.commentModel.content.length != 0){
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_content.text];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        [paragraph setLineSpacing:6];
        [attributed addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, _content.text.length)];
        _content.attributedText = attributed;
    }
    if(frameModel.commentModel.reply.length != 0){
        NSMutableAttributedString *replyAttributed = [[NSMutableAttributedString alloc] initWithString:_replyContent.text];
        NSMutableParagraphStyle *replyParagraph = [[NSMutableParagraphStyle alloc] init];
        [replyParagraph setLineSpacing:6];
        [replyAttributed addAttribute:NSParagraphStyleAttributeName value:replyParagraph range:NSMakeRange(0, _replyContent.text.length)];
        _replyContent.attributedText = replyAttributed;
    }
}
#pragma mark====展示图片========
- (void)showImg:(MyTapGesture *)tap{

    if(self.orderCommentBlock){
        self.orderCommentBlock();
    }
    if(_displayView == nil){
        _displayView = [[DisplayImageInView alloc] init];
        [_displayView showInViewWithImageUrlArray:self.frameModel.commentModel.photos withIndex:tap.tag withBlock:^{
            [_displayView removeFromSuperview];
            _displayView = nil;
        }];
    }
}
@end
