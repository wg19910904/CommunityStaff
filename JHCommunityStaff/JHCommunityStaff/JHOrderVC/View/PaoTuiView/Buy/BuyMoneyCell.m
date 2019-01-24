//
//  BuyMoneyCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "BuyMoneyCell.h"
#import "NSObject+CGSize.h"
@implementation BuyMoneyCell
{
    UIView *_topLine;
    UIView *_bottomLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        _topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        _topLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_topLine];
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_bottomLine];
        
    }
    return self;
}
#pragma mark======初始化子控件====
- (void)initSubViews{
    _money = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 15)];
    _money.font = FONT(12);
    _money.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_money];
    _danBaoAmount = [[UILabel alloc] initWithFrame:FRAME(15, 40, WIDTH - 30, 15)];
    _danBaoAmount.font = FONT(12);
    _danBaoAmount.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_danBaoAmount];
    _jiesuan = [[UILabel alloc] init];
    _jiesuan.font = FONT(12);
    _jiesuan.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_jiesuan];
}
- (void)setPaotuiDetailFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiDetailFrameModel{
    _paotuiDetailFrameModel = paotuiDetailFrameModel;
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"跑腿费:￥%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.paotui_amount];
    NSRange moneyRange = [_money.text rangeOfString:NSLocalizedString(@"跑腿费:", nil)];
    NSMutableAttributedString *moneyAttributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [moneyAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:moneyRange];
    _money.attributedText = moneyAttributed;
    
    _danBaoAmount.text = [NSString stringWithFormat:NSLocalizedString(@"预估费用:%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.expected_price.floatValue > 0?[@"¥" stringByAppendingString:_paotuiDetailFrameModel.paoTuiDetailModel.expected_price]:NSLocalizedString(@"无", nil)];
    NSRange danbaoRange = [_danBaoAmount.text rangeOfString:NSLocalizedString(@"预估费用:", nil)];
    NSMutableAttributedString *danbaoAttributed = [[NSMutableAttributedString alloc] initWithString:_danBaoAmount.text];
    [danbaoAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:danbaoRange];
    _danBaoAmount.attributedText = danbaoAttributed;
    _jiesuan.frame = FRAME(15, 65, WIDTH - 30, 15);
    if([_paotuiDetailFrameModel.paoTuiDetailModel.order_status isEqualToString:@"8"]){
        _jiesuan.text = [NSString stringWithFormat:NSLocalizedString(@"结算金额:￥%@(已付款)", nil),_paotuiDetailFrameModel.paoTuiDetailModel.jiesuan_amount];
    }else{
        _jiesuan.text = [NSString stringWithFormat:NSLocalizedString(@"结算金额:￥%@(待付款)", nil),_paotuiDetailFrameModel.paoTuiDetailModel.jiesuan_amount];
    }
    NSRange jiesuanRange = [_jiesuan.text rangeOfString:NSLocalizedString(@"结算金额:", nil)];
    NSMutableAttributedString *jiesuanAttributed = [[NSMutableAttributedString alloc] initWithString:_jiesuan.text];
    [jiesuanAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:jiesuanRange];
    _jiesuan.attributedText = jiesuanAttributed;
    if([_paotuiDetailFrameModel.paoTuiDetailModel.jiesuan_amount floatValue] > 0){
        [self.contentView addSubview:_jiesuan];
    }else{
        [_jiesuan removeFromSuperview];
    }
    _bottomLine.frame = FRAME(0, _paotuiDetailFrameModel.buyMoneyHeight - 0.5, WIDTH, 0.5);
}
@end
