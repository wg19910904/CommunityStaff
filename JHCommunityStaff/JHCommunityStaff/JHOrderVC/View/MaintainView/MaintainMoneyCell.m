//
//  MaintainMoneyCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "MaintainMoneyCell.h"
#import "NSObject+CGSize.h"
@implementation MaintainMoneyCell
{
    UIView *_topLine;
    UIView *_bottomLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubView];
        _topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        _topLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_topLine];
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_bottomLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark====初始化子控件=====
- (void)initSubView{
//    _danbaoAmount = [[UILabel alloc] initWithFrame:FRAME(15, 40, WIDTH - 30, 15)];
//    _danbaoAmount.font = FONT(12);
//    _danbaoAmount.textColor = HEX(@"ff6600", 1.0f);
//    [self.contentView addSubview:_danbaoAmount];
    _money = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 15)];
    _money.font = FONT(12);
    _money.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_money];
    _jiesuan = [[UILabel alloc] init];
    _jiesuan.font = FONT(12);
    _jiesuan.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_jiesuan];
}
- (void)setMaintainDetailFramelModel:(MaintainOrderDetailFrameModel *)maintainDetailFramelModel{
    _maintainDetailFramelModel = maintainDetailFramelModel;
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"定金:￥%@", nil),maintainDetailFramelModel.maintainDetailModel.danbao_amount];
    NSRange moneyRange = [_money.text rangeOfString:NSLocalizedString(@"定金:", nil)];
    NSMutableAttributedString *moneyAttributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [moneyAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:moneyRange];
    _money.attributedText = moneyAttributed;
//    _danbaoAmount.text = [NSString stringWithFormat:NSLocalizedString(@"担保金额:￥%@(已托管)", nil),maintainDetailFramelModel.maintainDetailModel.danbao_amount];
//    NSRange danbaoRange = [_danbaoAmount.text rangeOfString:NSLocalizedString(@"担保金额:", nil)];
//    NSMutableAttributedString *danbaoAttributed = [[NSMutableAttributedString alloc] initWithString:_danbaoAmount.text];
//    [danbaoAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:danbaoRange];
//    _danbaoAmount.attributedText = danbaoAttributed;
     _jiesuan.frame = FRAME(15,40,WIDTH - 30, 15);
    if([_maintainDetailFramelModel.maintainDetailModel.order_status isEqualToString:@"8"]){
        _jiesuan.text = [NSString stringWithFormat:NSLocalizedString(@"结算金额:￥%@(已付款)", nil),_maintainDetailFramelModel.maintainDetailModel.jiesuan_price];
    }else{
        _jiesuan.text = [NSString stringWithFormat:NSLocalizedString(@"结算金额:￥%@(待付款)", nil),_maintainDetailFramelModel.maintainDetailModel.jiesuan_price];
    }
    NSRange jiesuanRange = [_jiesuan.text rangeOfString:NSLocalizedString(@"结算金额:", nil)];
    NSMutableAttributedString *jiesuanAttributed = [[NSMutableAttributedString alloc] initWithString:_jiesuan.text];
    [jiesuanAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:jiesuanRange];
    _jiesuan.attributedText = jiesuanAttributed;
    if([_maintainDetailFramelModel.maintainDetailModel.jiesuan_price floatValue] > 0){
        [self.contentView addSubview:_jiesuan];
    }else{
        [_jiesuan removeFromSuperview];
    }
    _bottomLine.frame = FRAME(0, maintainDetailFramelModel.moneyHeight - 0.5, WIDTH, 0.5);
}
@end
