//
//  PaoTuiOrderDetailFrameModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "PaoTuiOrderDetailFrameModel.h"
#import "NSObject+CGSize.h"
@implementation PaoTuiOrderDetailFrameModel
- (void)setPaoTuiDetailModel:(PaotuiDetailModel *)paoTuiDetailModel{
    _paoTuiDetailModel = paoTuiDetailModel;
    NSString *note = nil;
    if(paoTuiDetailModel.intro.length == 0){
        note = NSLocalizedString(@"备注: (无)", nil);
    }else{
        note = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),paoTuiDetailModel.intro];
    }
    //外卖
    CGSize waimaiNoteSize =  [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _waimaiNoteRect = FRAME(15, 90, waimaiNoteSize.width, waimaiNoteSize.height);
    _waimaiOrderDetailHeight = 90 + waimaiNoteSize.height + 15;
    
   CGSize waimaiCustomerAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"客户地址:%@%@", nil),paoTuiDetailModel.addr,paoTuiDetailModel.house] font:FONT(12) withWidth:95];
    _waimaiCustomerAddrRect = FRAME(15, 40, waimaiCustomerAddrSize.width, waimaiCustomerAddrSize.height);
    CGSize waimaiShopAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"店铺地址:%@", nil),_paoTuiDetailModel.shop[@"addr"]] font:FONT(12) withWidth:95];
    _waimaiShopAddrRect = FRAME(15, 95 + _waimaiCustomerAddrRect.size.height + 25, waimaiShopAddrSize.width, waimaiShopAddrSize.height);
    _waimaiCustomerMessageHeight = _waimaiShopAddrRect.origin.y + _waimaiShopAddrRect.size.height + 40;
    //帮我送
    CGSize songNoteSize = [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _songNoteRect = FRAME(15, 90, songNoteSize.width, songNoteSize.height);
    _songOrderDetailHeight = 90 + songNoteSize.height + 15;
    if(![_paoTuiDetailModel.voice_info[@"voice"]  isEqualToString:@""]){
        _songOrderDetailHeight += 35;
    }
    if(_paoTuiDetailModel.photos.count != 0){
        _songOrderDetailHeight += ((WIDTH - 60) / 4 + 10);
    }
   CGSize songPickAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"取货地址:%@%@", nil),_paoTuiDetailModel.o_addr,_paoTuiDetailModel.o_house] font:FONT(12) withWidth:105];
    _songPickerRect = FRAME(15, 40, songPickAddrSize.width, songPickAddrSize.height);
   CGSize songDeliverAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"收货地址:%@%@", nil),_paoTuiDetailModel.addr,_paoTuiDetailModel.house] font:FONT(12) withWidth:105];
    _songDeliverRect =  FRAME(15, 95 + songPickAddrSize.height + 25, songDeliverAddrSize.width,songDeliverAddrSize.height);
    _songCustomerMessageHeight = 95 + songPickAddrSize.height + 25 + songDeliverAddrSize.height + 40;
    //帮我买
    CGSize buyNoteSize = [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _buyNoteRect = FRAME(15, 65, buyNoteSize.width, buyNoteSize.height);
    _buyOrderDetailHeight = 80 + buyNoteSize.height + 15;
    if(![_paoTuiDetailModel.voice_info[@"voice"]  isEqualToString:@""]){
        _buyOrderDetailHeight += 35;
    }
    if(_paoTuiDetailModel.photos.count != 0){
        _buyOrderDetailHeight += ((WIDTH - 60) / 4 + 10);
    }
    CGSize buyAddrSize = [self currentSizeWithString:[NSString stringWithFormat:@"%@%@",_paoTuiDetailModel.o_addr,_paoTuiDetailModel.o_house] font:FONT(12) withWidth:110];
    CGSize buyGetAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"收货地址:%@%@", nil),_paoTuiDetailModel.addr,_paoTuiDetailModel.house] font:FONT(12) withWidth:110];
    if(_paoTuiDetailModel.o_addr.length == 0){
       _buyAddrRect = FRAME(105, 15, 0, 15);
       _buyGetAddrRect =   FRAME(15, 70 + buyAddrSize.height, buyGetAddrSize.width, buyGetAddrSize.height);
    }else{
       _buyAddrRect =  FRAME(105, 15, buyAddrSize.width, buyAddrSize.height);
       _buyGetAddrRect =   FRAME(15, 95 + buyAddrSize.height, buyGetAddrSize.width, buyGetAddrSize.height);
    }
    _buyCustomerMessageHeight =  _buyGetAddrRect.origin.y + _buyGetAddrRect.size.height + 40;
    
    _buyMoneyHeight = 70;
    if([_paoTuiDetailModel.jiesuan_amount floatValue] > 0){
        _buyMoneyHeight += 25;
    }
    //跑腿其他订单
    CGSize otherNoteSize =  [self currentSizeWithString:note font:FONT(12) withWidth:30];
    _otherNoteRect = FRAME(15, 65, otherNoteSize.width, otherNoteSize.height);
    _otherOrderDeatailHeight = 65 + otherNoteSize.height + 15;
    if(![_paoTuiDetailModel.voice_info[@"voice"]  isEqualToString:@""]){
        _otherOrderDeatailHeight += 35;
    }
    if(_paoTuiDetailModel.photos.count != 0){
        _otherOrderDeatailHeight += ((WIDTH - 60) / 4 + 10);
    }
   CGSize otherCusomerAddrSize = [self currentSizeWithString:[NSString stringWithFormat:NSLocalizedString(@"服务地址:%@%@", nil),_paoTuiDetailModel.addr,_paoTuiDetailModel.house] font:FONT(12) withWidth:105];
    _otherCustomerRect = FRAME(15, 40, otherCusomerAddrSize.width, otherCusomerAddrSize.height);
    _otherCustomerHeight  = 40 + otherCusomerAddrSize.height + 40;
}
@end
