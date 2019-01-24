//
//  JHIndiviualCell.m
//  JHCommunityStaff
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHIndiviualCell.h"

@implementation JHIndiviualCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setInfo:(NSString *)info{
    _info = info;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_textView == nil) {
        _textView = [[UITextView alloc]init];
        _textView.frame = FRAME(15, 10, WIDTH - 30, 180);
        _textView.layer.cornerRadius = 3;
        _textView.text = info;
        _textView.clipsToBounds = YES;
        _textView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.font = FONT(16);
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.textColor = HEX(@"999999", 1.0f);
        [self addSubview:_textView];
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(10, 215, WIDTH - 20, 40);
        self.btn.layer.cornerRadius = 3;
        self.btn.layer.masksToBounds = YES;
        [self.btn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
        [self addSubview:self.btn];
    }
}
@end
