//
//  JHWithdrawCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHWithdrawCell.h"
#import "TransformTime.h"
#import "NSObject+CGSize.h"
@implementation JHWithdrawCell
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
    [self.contentView addSubview:_title];
    _account = [[UILabel alloc] init];
    _account.textColor = HEX(@"999999", 1.0f);
    _account.font = FONT(12);
    [self.contentView addSubview:_account];
    _money = [[UILabel alloc] init];
    _money.font = FONT(18);
    _money.textColor = HEX(@"333333", 1.0f);
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
    if([moneyFrameModel.moneyModel.status isEqualToString:@"0"]){
        //待处理
        _title.textColor = HEX(@"333333", 1.0f);
         _title.text = [NSString stringWithFormat:NSLocalizedString(@"提现待审中(%@)", nil),[TransformTime transfromWithString:moneyFrameModel.moneyModel.dateline]];
    }else if([moneyFrameModel.moneyModel.status isEqualToString:@"1"]){
        //通过
        _title.textColor = HEX(@"04ae10", 1.0f);
         _title.text = [NSString stringWithFormat:NSLocalizedString(@"提现成功(%@)", nil),[TransformTime transfromWithString:moneyFrameModel.moneyModel.dateline]];
    }else if([moneyFrameModel.moneyModel.status isEqualToString:@"2"]){
        //拒绝
        _title.textColor = HEX(@"999999", 1.0f);
        _title.text = [NSString stringWithFormat:NSLocalizedString(@"提现被拒绝,原因:%@(%@)", nil),moneyFrameModel.moneyModel.reason,[TransformTime transfromWithString:moneyFrameModel.moneyModel.dateline]];
    }
    _title.frame = _moneyFrameModel.contentRect;
    _money.text = [NSString stringWithFormat:@"-%@",moneyFrameModel.moneyModel.money];
    CGSize size = [self currentSizeWithString:_money.text font:FONT(18) withWidth:0];
    _money.frame = FRAME(WIDTH - 15 - size.width, (_moneyFrameModel.rowHeight - 20) / 2, size.width, 20);
    _account.text = [NSString stringWithFormat:NSLocalizedString(@"账户:%@", nil),moneyFrameModel.moneyModel.intro];
    _account.frame = FRAME(15 ,30 + _moneyFrameModel.contentRect.size.height, WIDTH, 15);
    _bottomLine.frame = FRAME(0, _moneyFrameModel.rowHeight - 0.5, WIDTH, 0.5);
}
@end
