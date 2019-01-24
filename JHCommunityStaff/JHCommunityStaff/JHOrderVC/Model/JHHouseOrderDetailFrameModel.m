//
//  JHHouseOrderDetailFrameModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/24.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHHouseOrderDetailFrameModel.h"
#import "NSObject+CGSize.h"
@implementation JHHouseOrderDetailFrameModel
- (void)setHouseDetailModel:(JHHouseOrderDetailModel *)houseDetailModel{
    _houseDetailModel = houseDetailModel;
    //订单
    NSString *note = nil;
    if(houseDetailModel.intro.length == 0){
        note = NSLocalizedString(@"备注: (无)", nil);
    }else{
        note = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),houseDetailModel.intro];
    }
    CGSize noteSize = [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _contentRect  = FRAME(15, 115, noteSize.width, noteSize.height);
    if([houseDetailModel.voice_info[@"voice"] isEqualToString:@""]){
        _orderDetailHeight = 115 + noteSize.height + 15;
    }else{
        _recordRect = FRAME(15, 115 + noteSize.height + 10, 100, 25);
        _recordSecondRect = FRAME(120, 130 + noteSize.height, 100, 15);
         _orderDetailHeight = 115 + noteSize.height + 15 + 35;
    }
    
    //客户
    CGSize destinationSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"目的地:%@%@", nil),houseDetailModel.addr,houseDetailModel.house] font:FONT(12) withWidth:105];
    _destinationRect = FRAME(15, 40, destinationSize.width, destinationSize.height);
    _distantRect = FRAME(15, destinationSize.height + 50, WIDTH - 95, 15);
    _mobileButtonRect = FRAME(WIDTH - 55, (50 + destinationSize.height) / 2, 30, 30);
    _customerMessageHeight = _destinationRect.size.height + 80;
    //图片
    _imgHeight = (WIDTH - 60) / 4 + 20;
    //定金之类的
    _moneyHeight = 45;
    if([houseDetailModel.jiesuan_price floatValue] > 0){
        _moneyHeight += 25;
    }
}
@end
