//
//  JHCommentCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCommentCell.h"
#import "TransformTime.h"//时间戳转换
#import "UIImageView+WebCache.h"
#import "MyTapGesture.h"
#import "DisplayImageInView.h"
@implementation JHCommentCell
{
    UIImageView *_img1;
    UIImageView *_img2;
    UIImageView *_img3;
    UIImageView *_img4;
    NSMutableArray *_imgArray;
    UIView *_thread1;//
    UIView *_thread2;//
    UIView *_backView;//
    DisplayImageInView *_displayView;
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
#pragma mark===去除图片======
- (void)removeImg{
    [_img1 removeFromSuperview];
    [_img2 removeFromSuperview];
    [_img3 removeFromSuperview];
    [_img4 removeFromSuperview];
}
#pragma mark====初始化控件======
- (void)initSubViews{
    _icon = [[UIImageView alloc] initWithFrame:FRAME(15, 15, 30, 30)];
    _icon.layer.cornerRadius = _icon.frame.size.width / 2;
    _icon.clipsToBounds = YES;
    [self.contentView addSubview:_icon];
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _nameLabel = [[UILabel alloc] initWithFrame:FRAME(55, 22.5, WIDTH - 55 - 85, 15)];
    _nameLabel.textColor = HEX(@"999999", 1.0f);
    _nameLabel.font = FONT(12);
    [self.contentView addSubview:_nameLabel];
    _starView = [[YFStartView alloc]init];
    _starView.frame = FRAME(WIDTH - 100, 14, 80,10);
    _starView.imgSize = CGSizeMake(13, 13);
    _starView.interSpace = 5;
    _starView.userInteractionEnabled = NO;
    _starView.starType = YFStarViewFloat;
    [self.contentView addSubview:_starView];
    _content = [[UILabel alloc] init];
    _content.font = FONT(14);
    _content.numberOfLines = 0;
    _content.textColor = HEX(@"333333", 1.0f);
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
    _replyBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [_replyBnt setTitle:NSLocalizedString(@"回复", nil) forState:UIControlStateNormal];
    [_replyBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _replyBnt.titleLabel.font = FONT(14);
    _replyBnt.layer.cornerRadius = 4.0f;
    _replyBnt.clipsToBounds = YES;
    [_replyBnt setBackgroundColor:HEX(@"ff7d14", 1.0f) forState:UIControlStateNormal];
    [_replyBnt setBackgroundColor:HEX(@"ff7d14", 1.0f) forState:UIControlStateSelected];
    [_replyBnt setBackgroundColor:HEX(@"ff7d14", 0.6f) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_replyBnt];
    _thread1 = [[UIView alloc] init];
    _thread1.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_thread1];
    _thread2 = [[UIView alloc] init];
    _thread2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_thread2];
    
}
- (void)setFrameModel:(CommentFrameModel *)frameModel{
    _frameModel = frameModel;
    CGFloat space = (WIDTH - 50 - 30) / 4;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:frameModel.commentModel.member_face]] placeholderImage:IMAGE(@"zl_head80")];
    _nameLabel.text = [NSString stringWithFormat:@"%@(%@)",frameModel.commentModel.member_name,[TransformTime transfromWithString:frameModel.commentModel.dateline]];
    _starView.currentStarScore = [frameModel.commentModel.score floatValue];
    if(frameModel.commentModel.content.length == 0){
        [_content removeFromSuperview];
    }else{
        _content.text = frameModel.commentModel.content;
        _content.frame = frameModel.contentRect;
        [self.contentView addSubview:_content];
    }
    if(frameModel.commentModel.photos.count == 0){
        [self removeImg];
        [_backView removeFromSuperview];
    }else{
        NSLog(@"%ld==%@",_frameModel.commentModel.photos.count,_frameModel.commentModel.order_id);
        _backView.frame = FRAME(25, frameModel.imgHeight, WIDTH - 50, space);
        [self.contentView addSubview:_backView];
        [self removeImg];
        for(int i = 0; i < frameModel.commentModel.photos.count; i ++){
            UIImageView *img = _imgArray[i];
            img.frame = FRAME((space + 10) * i, 0, space, space);
            [img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:frameModel.commentModel.photos[i]]] placeholderImage:IMAGE(@"pj_pic")];
            MyTapGesture *tap = [[MyTapGesture alloc] initWithTarget:self action:@selector(showImg:)];
            tap.tag = i + 1;
            [img addGestureRecognizer:tap];
            img.userInteractionEnabled = YES;
            [_backView addSubview:img];
        }
    }
    if(frameModel.commentModel.reply.length ==  0){
        [_replyImg removeFromSuperview];
        _replyBnt.frame = FRAME(WIDTH - 80 - 15, frameModel.rowHeight - 35, 80, 30);
        [self.contentView addSubview:_replyBnt];
        [self.contentView addSubview:_thread1];
        _thread1.frame = FRAME(0, frameModel.rowHeight - 40, WIDTH , 0.5);
    }else{
        [_replyBnt removeFromSuperview];
        [_thread1 removeFromSuperview];
        _replyContent.text = frameModel.commentModel.reply;
        _replyContent.frame = frameModel.replyRect;
        _replyImg.frame = frameModel.replyImgRect;
        _replyTime.frame = FRAME(_replyImg.frame.size.width - 140, _replyImg.frame.size.height - 25, 125, 15);
        _replyTime.text = [TransformTime transfromWithString:frameModel.commentModel.reply_time];
        [self.contentView addSubview:_replyImg];
    }
    _thread2.frame = FRAME(0, frameModel.rowHeight - 0.5, WIDTH , 0.5);
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
    if(_displayView == nil)
    {
        _displayView = [[DisplayImageInView alloc] init];
        [_displayView showInViewWithImageUrlArray:self.frameModel.commentModel.photos withIndex:tap.tag withBlock:^{
            [_displayView removeFromSuperview];
            _displayView = nil;
        }];
    }
}
@end
