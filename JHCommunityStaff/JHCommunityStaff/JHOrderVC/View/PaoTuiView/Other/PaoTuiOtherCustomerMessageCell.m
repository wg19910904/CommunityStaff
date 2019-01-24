//
//  PaoTuiCustomerMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "PaoTuiOtherCustomerMessageCell.h"

@interface PaoTuiOtherCustomerMessageCell ()
{
    UILabel *_customer;//客户信息
    UILabel *_customerAddr;//客户地址
    UILabel *_customerDistant;//客户距离
    UIView *_bottomLine;
    UIView *_middleLine;
}
@end
@implementation PaoTuiOtherCustomerMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark====初始化子控件=====
- (void)initSubViews{
    _customer = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15 - 90, 15)];
    _customer.font = FONT(12);
    _customer.textColor = HEX(@"666666", 1.0f);
     [self.contentView addSubview:_customer];
    _customerAddr = [[UILabel alloc] init];
    _customerAddr.font = FONT(12);
    _customerAddr.numberOfLines = 0;
    _customerAddr.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_customerAddr];
    _customerDistant = [[UILabel alloc] init];
    _customerDistant.font = FONT(12);
    _customerDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_customerDistant];
    _customerMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_customerMobile];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    _middleLine = [[UIView alloc] init];
    _middleLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_middleLine];
}
- (void)setPaotuiFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiFrameModel{
    _paotuiFrameModel = paotuiFrameModel;
    _customer.text = [NSString stringWithFormat:NSLocalizedString(@"联系人:%@ %@", nil),_paotuiFrameModel.paoTuiDetailModel.contact,_paotuiFrameModel.paoTuiDetailModel.mobile];
    _customerAddr.text = [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@%@", nil),_paotuiFrameModel.paoTuiDetailModel.addr,_paotuiFrameModel.paoTuiDetailModel.house];
    _customerAddr.frame = _paotuiFrameModel.otherCustomerRect;
  _customerDistant.frame = FRAME(15, _customerAddr.frame.size.height + 50, WIDTH - 95, 15);
    _customerDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiFrameModel.paoTuiDetailModel.juli_quancheng];
    NSRange customerRange = [_customerDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *customerAttributed = [[NSMutableAttributedString alloc] initWithString:_customerDistant.text];
    [customerAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:customerRange];
    _customerDistant.attributedText = customerAttributed;
    _customerMobile.frame = FRAME(WIDTH - 55, (50 + _customerAddr.frame.size.height) / 2, 30, 30);
    _bottomLine.frame = FRAME(0,_paotuiFrameModel.otherCustomerHeight - 0.5,WIDTH,0.5);
    _middleLine.frame = FRAME(WIDTH - 80, 15, 0.5, 50 + _customerAddr.frame.size.height);
}
@end
