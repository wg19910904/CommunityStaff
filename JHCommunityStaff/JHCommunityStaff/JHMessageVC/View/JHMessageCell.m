//
//  JHMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMessageCell.h"
#import "NSObject+CGSize.h"
#import "TransformTime.h"
@implementation JHMessageCell
{
    UIView *_thread1;
    UIView *_thread2;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
#pragma mark====初始化控件=====
- (void)initSubViews{
    _readImg = [[UIImageView alloc] initWithFrame:FRAME(5,20, 5, 5)];
    _readImg.image = IMAGE(@"msg_dot");
//    [self.contentView addSubview:_readImg];
    _title = [[UILabel alloc] init];
    _title.font = FONT(14);
    _title.numberOfLines = 0;
    [self.contentView addSubview:_title];
    _time = [[UILabel alloc] init];
    _time.font = FONT(12);
    _time.textColor = HEX(@"999999", 1.0f);
    [self.contentView addSubview:_time];
    _thread1 = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    _thread1.backgroundColor = LINE_COLOR;
    _thread2 = [[UIView alloc] init];
    _thread2.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_thread1];
    [self.contentView addSubview:_thread2];
}
- (void)setMessageModel:(MessageModel *)messageModel{
    _messageModel = messageModel;
    
    _title.text = [NSString stringWithFormat:@"%@:%@",messageModel.title,messageModel.content];
    CGSize size = [self currentSizeWithString:_title.text font:FONT(14) withWidth:30];
    _title.frame = FRAME(15, 15, WIDTH - 30, size.height);
    if([messageModel.is_read isEqualToString:@"0"]){
        [self.contentView addSubview:_readImg];
        _title.textColor = HEX(@"333333", 1.0f);
        NSRange range = [_title.text rangeOfString:[NSString stringWithFormat:@"%@:",messageModel.title]];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_title.text];;
        [attributed addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range];
        _title.attributedText = attributed;
        
    }else{
        [_readImg removeFromSuperview];
        _title.textColor = HEX(@"999999", 1.0f);
    }
    _time.frame = FRAME(15, 30 + size.height, WIDTH - 15, 15);
     _time.text = [TransformTime transfromWithString:messageModel.dateline];
    _thread2.frame = FRAME(0, 59.5 + size.height, WIDTH, 0.5);
}
@end
