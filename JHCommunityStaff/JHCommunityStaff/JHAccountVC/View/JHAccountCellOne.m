//
//  JHAccountCellOne.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/8/26.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHAccountCellOne.h"
#import "UIImageView+WebCache.h"
@implementation JHAccountCellOne
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
#pragma mark--==初始化子控件
- (void)initSubViews{
    _iconImg = [[UIImageView alloc] initWithFrame:FRAME(15, 15, 40, 40)];
    _iconImg.layer.cornerRadius = _iconImg.frame.size.width / 2;
    _iconImg.contentMode = UIViewContentModeScaleAspectFill;
    _iconImg.clipsToBounds = YES;
    _nameLabel = [[UILabel alloc] initWithFrame:FRAME(65, 15, 120, 20)];
    _nameLabel.textColor = HEX(@"333333", 1.0f);
    _nameLabel.font = FONT(16);
    _mobileLabel = [[UILabel alloc] initWithFrame:FRAME(65, 40, 150, 20)];
    _mobileLabel.textColor = HEX(@"999999", 1.0f);
    _mobileLabel.font = FONT(14);
    self.dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 29, 7, 12)];
    self.dirImg.image = IMAGE(@"arrow_right");
    [self.contentView addSubview:self.dirImg];
    UIView *topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    topLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 69.5, WIDTH, 0.5)];
    bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:bottomLine];
    [self.contentView addSubview:_iconImg];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_mobileLabel];
}
- (void)setInfoModel:(InfoModel *)infoModel{
    _infoModel = infoModel;
    [_iconImg sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:infoModel.face]] placeholderImage:IMAGE(@"sy_head")];
    _nameLabel.text = infoModel.name;
    _mobileLabel.text = infoModel.mobile;
}
@end
