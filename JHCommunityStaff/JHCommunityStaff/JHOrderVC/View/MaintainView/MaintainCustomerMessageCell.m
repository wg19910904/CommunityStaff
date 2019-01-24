//
//  MaintainCustomerMessageCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "MaintainCustomerMessageCell.h"

@implementation MaintainCustomerMessageCell
{
    UIView *_bottomLine;
    UIView *_middleLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}
#pragma mark====初始化子控件=====
- (void)initSubView{
    _basic = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15 - 90, 15)];
    _basic.font = FONT(12);
    _basic.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_basic];
    _destination = [[UILabel alloc] init];
    _destination.font = FONT(12);
    _destination.numberOfLines = 0;
    _destination.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_destination];
    _distant = [[UILabel alloc] init];
    _distant.font = FONT(12);
    _distant.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_distant];
    _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
    _middleLine = [[UIView alloc] init];
    _middleLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_middleLine];
}
- (void)setMaintainDetailFrameModel:(MaintainOrderDetailFrameModel *)maintainDetailFrameModel{
    _maintainDetailFrameModel = maintainDetailFrameModel;
    _basic.text = [NSString stringWithFormat:@"%@ %@",maintainDetailFrameModel.maintainDetailModel.contact,maintainDetailFrameModel.maintainDetailModel.mobile];
    _destination.text = [NSString stringWithFormat:NSLocalizedString(@"目的地:%@%@", nil),maintainDetailFrameModel.maintainDetailModel.addr,maintainDetailFrameModel.maintainDetailModel.house];
    _destination.frame = maintainDetailFrameModel.destinationRect;
    _distant.text = [NSString stringWithFormat:NSLocalizedString(@"距离我:%@", nil),maintainDetailFrameModel.maintainDetailModel.juli_label];
    _distant.frame = maintainDetailFrameModel.distantRect;
    NSRange distantRange = [_distant.text rangeOfString:NSLocalizedString(@"距离我:", nil)];
    NSMutableAttributedString *distantAttributed = [[NSMutableAttributedString alloc] initWithString:_distant.text];
    [distantAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:distantRange];
    _distant.attributedText = distantAttributed;
    _mobileButton.frame = maintainDetailFrameModel.mobileButtonRect;
    _bottomLine.frame = FRAME(0, maintainDetailFrameModel.customerMessageHeight - 0.5, WIDTH, 0.5f);
    _middleLine.frame = FRAME(WIDTH - 80, 15, 0.5, maintainDetailFrameModel.customerMessageHeight - 30);

}


@end
