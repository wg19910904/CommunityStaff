//
//  WaiMaiCustomerMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/1.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "WaiMaiCustomerMessageCell.h"
#import "NSObject+CGSize.h"
@interface WaiMaiCustomerMessageCell ()
{
    UIImageView *_customerImg;//客户图片
    UIImageView *_shopImg;//店家图片
    UILabel *_customerAddr;//客户地址
    UILabel *_shopAddr;//店家地址
    UILabel *_customerDistant;//客户距离
    UILabel *_shopDistant;//店家距离
    UILabel *_customer;//客户信息
    UILabel *_shop;//店家信息
    UIView *_middleLine;
    UIView *_bottomLine;
    UIView *_customerMobileLine;
    UIView *_shopMobileLine;
}
@end
@implementation WaiMaiCustomerMessageCell

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
    _customer  = [[UILabel alloc] init];
    _customer.textColor = HEX(@"666666", 1.0f);
    _customer.font = FONT(12);
    _customer.numberOfLines = 0;
    [self.contentView addSubview:_customer];
    _customerImg = [[UIImageView alloc] init];
    _customerImg.image = IMAGE(@"order_label_customer");
    [self.contentView addSubview:_customerImg];
    _customerAddr = [[UILabel alloc] init];
    _customerAddr.textColor = HEX(@"666666", 1.0f);
    _customerAddr.font = FONT(12);
    _customerAddr.numberOfLines = 0;
    [self.contentView addSubview:_customerAddr];
    _customerDistant = [[UILabel alloc] init];
    _customerDistant.font = FONT(12);
    _customerDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_customerDistant];
    _shop = [[UILabel alloc] init];
    _shop.textColor = HEX(@"666666", 1.0f);
    _shop.font = FONT(12);
    _shop.numberOfLines = 0;
    [self.contentView addSubview:_shop];
    _shopImg = [[UIImageView alloc] init];
    _shopImg.image = IMAGE(@"order_label_shop");
    [self.contentView addSubview:_shopImg];
    _shopAddr = [[UILabel alloc] init];
    _shopAddr.textColor = HEX(@"666666", 1.0f);
    _shopAddr.font = FONT(12);
    _shopAddr.numberOfLines = 0;
    [self.contentView addSubview:_shopAddr];
    _shopDistant = [[UILabel alloc] init];
    _shopDistant.font = FONT(12);
    _shopDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_shopDistant];
    _customerMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_customerMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_customerMobile];
    _shopMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateNormal];
    [_shopMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateSelected];
    [_shopMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_shopMobile];
    _middleLine = [[UIView alloc] init];
    _middleLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_middleLine];
    
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    _customerMobileLine = [[UIView alloc] init];
    _customerMobileLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_customerMobileLine];
    _shopMobileLine = [[UIView alloc] init];
    _shopMobileLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_shopMobileLine];
}
- (void)setPaotuiOrderDetailFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiOrderDetailFrameModel{
    _paotuiOrderDetailFrameModel = paotuiOrderDetailFrameModel;
    _customer.text = [NSString stringWithFormat:@"%@ %@",_paotuiOrderDetailFrameModel.paoTuiDetailModel.contact,_paotuiOrderDetailFrameModel.paoTuiDetailModel.mobile];
    CGSize  customerSize = [self currentSizeWithString:_customer.text font:FONT(12) withWidth:0];
    _customer.frame = FRAME(15, 15, customerSize.width, 15);
    _customerImg.frame = FRAME(20 + customerSize.width, 15, 30, 15);
    _customerAddr.text = [NSString stringWithFormat:NSLocalizedString(@"客户地址:%@%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.addr,_paotuiOrderDetailFrameModel.paoTuiDetailModel.house];
    _customerAddr.frame = _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect;
    _customerDistant.frame = FRAME(15, _customerAddr.frame.origin. y + _customerAddr.frame.size.height + 10, WIDTH - 105, 15);
    _customerDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距商家:%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.juli_zhongdian];
    NSRange customerDistantRange = [_customerDistant.text rangeOfString:NSLocalizedString(@"距商家:", nil)];
    NSMutableAttributedString *customerDistantAttributed = [[NSMutableAttributedString alloc] initWithString:_customerDistant.text];
    [customerDistantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:customerDistantRange];
    _customerDistant.attributedText = customerDistantAttributed;
    _shop.text = [NSString stringWithFormat:NSLocalizedString(@"商家店铺:%@ %@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.shop[@"title"],_paotuiOrderDetailFrameModel.paoTuiDetailModel.shop[@"phone"]];
    CGSize shopSize = [self currentSizeWithString:_shop.text font:FONT(12) withWidth:0];
    _shop.frame = FRAME(15, 95 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height, shopSize.width, 15);
    _shopImg.frame = FRAME(20 + shopSize.width ,95 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height, 30, 15);
    _shopAddr.text = [NSString stringWithFormat:NSLocalizedString(@"商家地址:%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.shop[@"addr"]];
    _shopAddr.frame = _paotuiOrderDetailFrameModel.waimaiShopAddrRect;
    _shopDistant.frame =FRAME(15,  95 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height + 25 + 10 +_paotuiOrderDetailFrameModel.waimaiShopAddrRect.size.height , WIDTH - 105, 15);
    _shopDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.juli_qidian];
    NSRange shopDistantRange = [_shopDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *shopDistantAttributed = [[NSMutableAttributedString alloc] initWithString:_shopDistant.text];
    [shopDistantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:shopDistantRange];
    _shopDistant.attributedText = shopDistantAttributed;
    
    _customerMobile.frame = FRAME(WIDTH - 55, 25 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height / 2  , 30, 30);
    _shopMobile.frame = FRAME(WIDTH - 55, 80 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height + 25 + _paotuiOrderDetailFrameModel.waimaiShopAddrRect.size.height / 2, 30, 30);
    _middleLine.frame =  FRAME(15, 79.5 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height, WIDTH - 30, 0.5);
    _bottomLine.frame = FRAME(0, _paotuiOrderDetailFrameModel.waimaiCustomerMessageHeight - 0.5, WIDTH, 0.5);
    _customerMobileLine.frame = FRAME(WIDTH - 80, 15, 0.5, 50 + _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height);
    _shopMobileLine.frame = FRAME(WIDTH - 80, 80 +  _paotuiOrderDetailFrameModel.waimaiCustomerAddrRect.size.height + 15, 0.5, 50 + paotuiOrderDetailFrameModel.waimaiShopAddrRect.size.height);
}
@end
