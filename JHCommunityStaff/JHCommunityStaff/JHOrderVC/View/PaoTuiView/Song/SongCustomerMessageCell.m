//
//  SongCustomerMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "SongCustomerMessageCell.h"
#import "NSObject+CGSize.h"
@interface SongCustomerMessageCell ()
{
    UILabel *_pickAddr;//取货地址
    UILabel *_deliverAddr;//收货地址
    UILabel *_pickDistant;//买距离
    UILabel *_deliverDistant;//收货距离
    UILabel *_picker;//取货人信息
    UILabel *_deliver;//收货人信息
    UIImageView *_pickImg;//取货图片
    UIImageView *_deliverImg;//收货图片
    UIView *_bottomLine;
    UIView *_middleLine;
    UIView *_pickMobileLine;
    UIView *_deliverMobileLine;
    
}
@end
@implementation SongCustomerMessageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
#pragma mark===初始化子控件=======
- (void)initSubViews{
    _picker = [[UILabel alloc] init];
    _picker.textColor = HEX(@"666666", 1.0f);
    _picker.font = FONT(12);
    _picker.numberOfLines = 0;
    [self.contentView addSubview:_picker];
    _pickImg = [[UIImageView alloc] init];
    _pickImg.image = IMAGE(@"order_label_-pickup");
    [self.contentView addSubview:_pickImg];
    _pickAddr = [[UILabel alloc] init];
    _pickAddr.textColor = HEX(@"666666", 1.0f);
    _pickAddr.font = FONT(12);
    _pickAddr.numberOfLines = 0;
    [self.contentView addSubview:_pickAddr];
    _pickDistant = [[UILabel alloc] init];
    _pickDistant.font = FONT(12);
    _pickDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_pickDistant];
    _deliver = [[UILabel alloc] init];
    _deliver.textColor = HEX(@"666666", 1.0f);
    _deliver.font = FONT(12);
    _deliver.numberOfLines = 0;
    [self.contentView addSubview:_deliver];
    _deliverImg = [[UIImageView alloc] init];
    _deliverImg.image = IMAGE(@"order_label_goodsreceipt");
    [self.contentView addSubview:_deliverImg];
    _deliverAddr = [[UILabel alloc] init];
    _deliverAddr.textColor = HEX(@"666666", 1.0f);
    _deliverAddr.font = FONT(12);
    _deliverAddr.numberOfLines = 0;
    [self.contentView addSubview:_deliverAddr];
    _deliverDistant = [[UILabel alloc] init];
    _deliverDistant.font = FONT(12);
    _deliverDistant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_deliverDistant];
    _pickMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pickMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_pickMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_pickMobile setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_pickMobile];
    _deliverMobile = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deliverMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateNormal];
    [_deliverMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateSelected];
    [_deliverMobile setBackgroundImage:IMAGE(@"order_call02") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_deliverMobile];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    _middleLine = [[UIView alloc] init];
    _middleLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_middleLine];
    _pickMobileLine = [[UIView alloc] init];
    _pickMobileLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_pickMobileLine];
    _deliverMobileLine = [[UIView alloc] init];
    _deliverMobileLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_deliverMobileLine];
    
}
- (void)setPaotuiFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiFrameModel{
    _paotuiFrameModel = paotuiFrameModel;
    _picker.text = [NSString stringWithFormat:NSLocalizedString(@"取货人:%@ %@", nil),_paotuiFrameModel.paoTuiDetailModel.o_contact,_paotuiFrameModel.paoTuiDetailModel.o_mobile];
    CGSize pickSize = [self currentSizeWithString:_picker.text font:FONT(12) withWidth:0];
    _picker.frame = FRAME(15, 15, pickSize.width, 15);
    _pickImg.frame = FRAME(20 + pickSize.width, 15, 30, 15);
    _pickAddr.text = [NSString stringWithFormat:NSLocalizedString(@"取货地址:%@%@", nil),_paotuiFrameModel.paoTuiDetailModel.o_addr,_paotuiFrameModel.paoTuiDetailModel.o_house];
    _pickAddr.frame = _paotuiFrameModel.songPickerRect;
    _pickDistant.frame =  FRAME(15, 50 + _pickAddr.frame.size.height, WIDTH - 105, 15);
    _pickDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiFrameModel.paoTuiDetailModel.juli_qidian];
    NSRange pickDistantRange = [_pickDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *pickDistantAttributed = [[NSMutableAttributedString alloc] initWithString:_pickDistant.text];
    [pickDistantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:pickDistantRange];
    _pickDistant.attributedText = pickDistantAttributed;
    _deliver.text = [NSString stringWithFormat:NSLocalizedString(@"收货人:%@ %@", nil),_paotuiFrameModel.paoTuiDetailModel.contact,_paotuiFrameModel.paoTuiDetailModel.mobile];
    CGSize deliverSize = [self currentSizeWithString:_deliver.text font:FONT(12) withWidth:0];
    _deliver.frame = FRAME(15, 95 + _pickAddr.frame.size.height, deliverSize.width, 15);
    _deliverImg.frame = FRAME(20 + deliverSize.width , 95 + _pickAddr.frame.size.height, 30, 15);
    _deliverAddr.text = [NSString stringWithFormat:NSLocalizedString(@"收货地址:%@%@", nil),_paotuiFrameModel.paoTuiDetailModel.addr,_paotuiFrameModel.paoTuiDetailModel.house];
    _deliverAddr.frame = _paotuiFrameModel.songDeliverRect;
    _deliverDistant.frame = FRAME(15, _paotuiFrameModel.songCustomerMessageHeight - 30,WIDTH - 105, 15);
    _deliverDistant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),_paotuiFrameModel.paoTuiDetailModel.juli_zhongdian];
    NSRange deliverDistantRange = [_deliverDistant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *deliverDistantAttributed = [[NSMutableAttributedString alloc] initWithString:_deliverDistant.text];
    [deliverDistantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:deliverDistantRange];
    _deliverDistant.attributedText = deliverDistantAttributed;
    _pickMobile.frame = FRAME(WIDTH - 55, 25 + _pickAddr.frame.size.height / 2  , 30, 30);
    _deliverMobile.frame = FRAME(WIDTH - 55, 80 + _pickAddr.frame.size.height + 25 + _deliverAddr.frame.size.height / 2, 30, 30);
    _bottomLine.frame = FRAME(0, _paotuiFrameModel.songCustomerMessageHeight - 0.5, WIDTH, 0.5);
    _middleLine.frame = FRAME(15, 79.5 + _pickAddr.frame.size.height, WIDTH - 30, 0.5);
    _pickMobileLine.frame = FRAME(WIDTH - 80, 15, 0.5, 50 + _pickAddr.frame.size.height);
    _deliverMobileLine.frame = FRAME(WIDTH - 80, 80 + _pickAddr.frame.size.height + 15, 0.5, 50 + _deliverAddr.frame.size.height);
}
@end
