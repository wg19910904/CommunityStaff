//
//  ReconderSearchChoseTimeCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderSearchChoseTimeCell.h"
@interface ReconderSearchChoseTimeCell()
{
    UIImageView *arrowImgV;
}
@end
@implementation ReconderSearchChoseTimeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatLine];
        [self leftL];
        [self rightBtn];
    }
    return self;
}
-(void)creatLine{
    UIView *line = [UIView new];
    line.backgroundColor = HEX(@"e6e6e6", 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}
-(UILabel *)leftL{
    if (!_leftL) {
        _leftL = [UILabel new];
        _leftL.textColor = HEX(@"666666", 1);
        _leftL.font = FONT(14);
        [self addSubview:_leftL];
        [_leftL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 25;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.offset = 20;
            make.bottom.offset = -10;
        }];
    }
    return _leftL;
}
-(YFTypeBtn *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[YFTypeBtn alloc]init];
        [_rightBtn setTitle:NSLocalizedString(@"请选择", nil) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = FONT(14);
        _rightBtn.titleAlignment = NSTextAlignmentRight;
        [_rightBtn setTitleColor:HEX(@"999999", 1) forState:UIControlStateNormal];
        [self addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -12;
            make.height.offset = 30;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.offset = 130;
        }];
        UIImageView *imgV = [UIImageView new];
       
        arrowImgV = imgV;
        [_rightBtn addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -3;
            make.centerY.mas_equalTo(_rightBtn.mas_centerY);
            make.width.offset = 10;
            make.height.offset = 15;
        }];
    }
    return _rightBtn;
}
-(void)setChoseTimeArrow:(NSString *)choseTimeArrow{
    _choseTimeArrow = choseTimeArrow;
     arrowImgV.image = IMAGE(choseTimeArrow);
}
@end
