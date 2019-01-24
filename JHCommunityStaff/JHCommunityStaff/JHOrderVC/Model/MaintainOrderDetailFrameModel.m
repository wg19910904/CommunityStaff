//
//  MaintainOrderDetailFrameModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "MaintainOrderDetailFrameModel.h"
#import "NSObject+CGSize.h"
@implementation MaintainOrderDetailFrameModel
-(void)setMaintainDetailModel:(MaintainDetailModel *)maintainDetailModel{
    _maintainDetailModel = maintainDetailModel;
    //订单
    NSString *note = nil;
    if(maintainDetailModel.intro.length == 0){
        note = NSLocalizedString(@"备注: (无)", nil);
    }else{
        note = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),maintainDetailModel.intro];
    }
    CGSize noteSize = [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _contentRect  = FRAME(15, 115, noteSize.width,noteSize.height);
    if([maintainDetailModel.voice_info[@"voice"]  isEqualToString:@""]){
        _orderDetailHeight = 115 + noteSize.height + 15;
    }else{
        _recordRect = FRAME(15, 115 + noteSize.height + 10, 100, 25);
        _recordSecondRect = FRAME(120, 130 + noteSize.height , 100, 15);
        _orderDetailHeight = 115 + noteSize.height + 15 + 35;
    }
    //客户
    CGSize destinationSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"目的地:%@%@", nil),maintainDetailModel.addr,maintainDetailModel.house] font:FONT(12) withWidth:105];
    _destinationRect = FRAME(15, 40, destinationSize.width, destinationSize.height);
    _distantRect = FRAME(15, destinationSize.height + 50, WIDTH - 95, 15);
    _mobileButtonRect = FRAME(WIDTH - 55, (50 + destinationSize.height) / 2, 30, 30);
    _customerMessageHeight = _destinationRect.size.height + 80;
    //图片
    _imgHeight = (WIDTH - 60) / 4 + 20;
    //定金之类的
    _moneyHeight = 45;
    if([maintainDetailModel.jiesuan_price floatValue] > 0){
        _moneyHeight += 25;
    }
}

@end
