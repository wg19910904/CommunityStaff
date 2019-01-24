//
//  WaiMaiOrderDetailCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/1.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "WaiMaiOrderDetailCell.h"
#import "TransformTime.h"
#import "NSObject+CGSize.h"
@interface WaiMaiOrderDetailCell ()
{
    
    UILabel *_orderID;//订单ID
    UILabel *_time;//服务时间
    UILabel *_onTime;//准时
    UILabel *_note;//备注
    UIView *_bottomLine;//底部线条
}
@end

@implementation WaiMaiOrderDetailCell

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
    _orderID = [[UILabel alloc] initWithFrame:FRAME(15, 15 , WIDTH - 30, 15)];
    _orderID.textColor = HEX(@"666666", 1.0f);
    _orderID.font = FONT(12);
    [self.contentView addSubview:_orderID];
    _time = [[UILabel alloc] initWithFrame:FRAME(15, 40 , WIDTH  - 30, 15)];
    _time.textColor = HEX(@"666666", 1.0f);
    _time.font = FONT(12);
    [self.contentView addSubview:_time];
    _onTime = [[UILabel alloc] initWithFrame:FRAME(65, 65, WIDTH - 80, 15)];
    _onTime.textColor = THEME_COLOR;
    _onTime.font = FONT(12);
    [self.contentView addSubview:_onTime];
    _note = [[UILabel alloc] init];
    _note.textColor = HEX(@"666666", 1.0f);
    _note.font = FONT(12);
    _note.numberOfLines = 0;
    [self.contentView addSubview:_note];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
}
- (void)setPaotuiOrderDetailFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiOrderDetailFrameModel{
    _paotuiOrderDetailFrameModel = paotuiOrderDetailFrameModel;
    _orderID.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.order_id];
    _time.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:_paotuiOrderDetailFrameModel.paoTuiDetailModel.dateline]];
    _onTime.text = GLOBAL(paotuiOrderDetailFrameModel.paoTuiDetailModel.pei_time_label);
//    if([_paotuiOrderDetailFrameModel.paoTuiDetailModel.pei_time isEqualToString:@"0"]){
//        _onTime.text = NSLocalizedString(@"送达时间(尽快送达)", nil);
//    }else{
//        _onTime.text = [NSString stringWithFormat:NSLocalizedString(@"准时送达(%@送达)", nil),[self transfromWithStr:_paotuiOrderDetailFrameModel.paoTuiDetailModel.pei_time]];
//    }
    if(_paotuiOrderDetailFrameModel.paoTuiDetailModel.intro.length == 0){
        _note.text = NSLocalizedString(@"备注: (无)", nil);
    }else{
        _note.text = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),_paotuiOrderDetailFrameModel.paoTuiDetailModel.intro];
    }
    _note.frame = _paotuiOrderDetailFrameModel.waimaiNoteRect;
    _bottomLine.frame = FRAME(0,_paotuiOrderDetailFrameModel.waimaiOrderDetailHeight - 0.5, WIDTH, 0.5);
}
//时间戳转换时间
- (NSString *)transfromWithStr:(NSString *)string
{
    NSTimeInterval time = [string doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end
