//
//  BuyCustomerMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "BuyCustomerMessageCell.h"

@interface BuyCustomerMessageCell ()
{
    UILabel *_buyAddr;//购货地址
    UILabel *_deliverAddr;//收货地址
    UIImageView *_assignImg;//是否指定地址
    UILabel *_buyDistant;//买距离
    UILabel *_deliverDistant;//收货距离
    UILabel *_deliver;//收货人信息
    UIView *_middleLine;
    UIView *_bottomLine;
    UIView *_mobileLine;
    
}
@end

@implementation BuyCustomerMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#pragma mark====初始化子控件====
- (void)initSubView{
    
    UILabel *buyLabel = [[UILabel alloc] initWithFrame:FRAME(15, 15, 55, 15)];
    buyLabel.textColor = HEX(@"666666", 1.0f);
    buyLabel.font = FONT(12);
    buyLabel.text = NSLocalizedString(@"购买地址:", nil);
    [self.contentView addSubview:buyLabel];
    _buyAddr = [[UILabel alloc] initWithFrame:FRAME(130, 15, WIDTH - 130 - 30, 15)];
    _buyAddr.textColor = HEX(@"666666", 1.0f);
    _buyAddr.font = FONT(12);
    _buyAddr.numberOfLines = 0;
    [self.contentView addSubview:_buyAddr];
    _assignImg = [[UIImageView alloc] initWithFrame:FRAME(70, 15, 30, 15)];
    [self.contentView addSubview:_assignImg];
    _buyDistant = [[UILabel alloc] init];
    _buyDistant.font = FONT(12);
    _buyDistant.textColor = HEX(@"ff6600", 1.0f);
    _deliver = [[UILabel alloc] init];
    _deliver.font = FONT(12);
    _deliver.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_deliver];
    _deliverAddr = [[UILabel alloc] init];
    _deliverAddr.textColor = HEX(@"666666", 1.0f);
    _deliverAddr.font = FONT(12);
    _deliverAddr.numberOfLines = 0;
    [self.contentView addSubview:_deliverAddr];
    _deliverDistant = [[UILabel alloc] init];
    _deliverDistant.font = FONT(12);
    _deliverDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_deliverDistant];
    _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    _middleLine = [[UIView alloc] init];
    _middleLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_middleLine];
    _mobileLine = [[UIView alloc] init];
    _mobileLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_mobileLine];
    
}
- (void)setPaotuiDetailFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiDetailFrameModel{
    _paotuiDetailFrameModel = paotuiDetailFrameModel;
    _buyAddr.frame =_paotuiDetailFrameModel.buyAddrRect;
    _buyAddr.text = [NSString stringWithFormat:@"%@%@",_paotuiDetailFrameModel.paoTuiDetailModel.o_addr,_paotuiDetailFrameModel.paoTuiDetailModel.o_house];
    _buyDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.juli_qidian];
    NSRange distantRange = [_buyDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *distantAttributed = [[NSMutableAttributedString alloc] initWithString:_buyDistant.text];
    [distantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:distantRange];
    _buyDistant.attributedText = distantAttributed;
    _buyDistant.frame = FRAME(15, _paotuiDetailFrameModel.buyAddrRect.size.height + _paotuiDetailFrameModel.buyAddrRect.origin.y + 10,WIDTH - 105, 15);
    _deliver.text = [NSString stringWithFormat:NSLocalizedString(@"收货人:%@ %@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.contact,_paotuiDetailFrameModel.paoTuiDetailModel.mobile];
    _deliverAddr.text = [NSString stringWithFormat:NSLocalizedString(@"收货地址:%@%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.addr,_paotuiDetailFrameModel.paoTuiDetailModel.house];
    _deliverAddr.frame = _paotuiDetailFrameModel.buyGetAddrRect;
    _bottomLine.frame = FRAME(0, _paotuiDetailFrameModel.buyCustomerMessageHeight - 0.5, WIDTH, 0.5);
    
    if(_paotuiDetailFrameModel.paoTuiDetailModel.o_addr.length == 0){
        _assignImg.image = IMAGE(@"order_label_appointno");
        [_buyDistant removeFromSuperview];
        _deliver.frame = FRAME(15, 45 + _buyAddr.frame.size.height, WIDTH - 15 - 90, 15);
        _middleLine.frame = FRAME(15, 29.5 + _buyAddr.frame.size.height, WIDTH - 30, 0.5);
        _mobileLine.frame = FRAME(WIDTH - 80, 29.5 + _paotuiDetailFrameModel.buyAddrRect.size.height + 15, 0.5, 50 + _paotuiDetailFrameModel.buyGetAddrRect.size.height);
        _deliverDistant.frame =  FRAME(15, 70 + _paotuiDetailFrameModel.buyAddrRect.size.height + _paotuiDetailFrameModel.buyGetAddrRect.size.height + 10, WIDTH - 105, 15);
         _deliverDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.juli_quancheng];
        _mobileButton.frame = FRAME(WIDTH - 55, 30 + _paotuiDetailFrameModel.buyAddrRect.size.height + 25 + _paotuiDetailFrameModel.buyGetAddrRect.size.height / 2 , 30, 30);
    }else{
        _assignImg.image = IMAGE(@"order_label_appoint");
        [self.contentView addSubview:_buyDistant];
        _deliver.frame = FRAME(15, 70 + _buyAddr.frame.size.height, WIDTH - 15 - 90, 15);
        _middleLine.frame = FRAME(15, 54.5 + _buyAddr.frame.size.height, WIDTH - 30, 0.5);
        _mobileLine.frame = FRAME(WIDTH - 80, 55 + _paotuiDetailFrameModel.buyAddrRect.size.height + 15, 0.5, 50 + _paotuiDetailFrameModel.buyGetAddrRect.size.height);
        _deliverDistant.frame =  FRAME(15, 95 + _paotuiDetailFrameModel.buyAddrRect.size.height + _paotuiDetailFrameModel.buyGetAddrRect.size.height + 10, WIDTH - 105, 15);
          _deliverDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiDetailFrameModel.paoTuiDetailModel.juli_zhongdian];
        _mobileButton.frame = FRAME(WIDTH - 55, 55 + _paotuiDetailFrameModel.buyAddrRect.size.height + 25 + _paotuiDetailFrameModel.buyGetAddrRect.size.height / 2 , 30, 30);
    }
    NSRange deliverRange = [_deliverDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *deliverAttributed = [[NSMutableAttributedString alloc] initWithString:_deliverDistant.text];
    [deliverAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:deliverRange];
    _deliverDistant.attributedText = deliverAttributed;
   
};
@end
