//
//  JHSetCellThree.m
//  JHCommunityStaff
//
//  Created by ijianghu on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHSetCellThree.h"

@implementation JHSetCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
     _indexPath = indexPath;
    self.backgroundColor = BACK_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_myBtn == nil) {
        _myBtn = [[UIButton alloc]init];
        _myBtn.frame = FRAME(20, 30, WIDTH - 40, 50);
        [_myBtn setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_myBtn setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0  alpha:0.2] forState:UIControlStateHighlighted];
        _myBtn.layer.cornerRadius = 4;
        _myBtn.layer.masksToBounds = YES;
        [_myBtn setTitle:NSLocalizedString(@"退出登录", nil) forState:UIControlStateNormal];
        [self addSubview:_myBtn];
    }
}
@end
