//
//  JHMoneyCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//收入明细或者提现明细

#import "JHIncomeMoneyCell.h"
#import "TransformTime.h"
#import "NSObject+CGSize.h"
@implementation JHIncomeMoneyCell
{
    UIView *_topLine;
    UIView *_bottomLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
#pragma mark=====初始化子控件======
- (void)initSubViews{
    _title = [[UILabel alloc] init];
    _title.font = FONT(14);
    _title.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_title];
    _time = [[UILabel alloc] init];
    _time.textColor = HEX(@"999999", 1.0f);
    _time.font = FONT(12);
    [self.contentView addSubview:_time];
    _money = [[UILabel alloc] init];
    _money.font = FONT(18);
    _money.textColor = HEX(@"36be49", 1.0f);
    [self.contentView addSubview:_money];
    _topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
    _topLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_topLine];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
}
- (void)setMoneyFrameModel:(JHMoneyFrameModel *)moneyFrameModel{
    _moneyFrameModel = moneyFrameModel;
    _title.text = moneyFrameModel.moneyModel.intro;
    _title.frame = _moneyFrameModel.contentRect;
    _money.text = [NSString stringWithFormat:@"+%@",moneyFrameModel.moneyModel.money];
     CGSize size = [self currentSizeWithString:_money.text font:FONT(18) withWidth:0];
    _money.frame = FRAME(WIDTH - 15 - size.width, (_moneyFrameModel.rowHeight - 20) / 2, size.width, 20);
    _time.text = [TransformTime transfromWithString:moneyFrameModel.moneyModel.dateline];
    _time.frame = FRAME(15 ,30 + _moneyFrameModel.contentRect.size.height, WIDTH, 15);
    _bottomLine.frame = FRAME(0, _moneyFrameModel.rowHeight - 0.5, WIDTH, 0.5);
}
@end
