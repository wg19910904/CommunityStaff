//
//  JHMoneyFrameModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/16.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMoneyFrameModel.h"
#import "NSObject+CGSize.h"
#import "TransformTime.h"
@implementation JHMoneyFrameModel
- (void)setMoneyModel:(JHMoneyModel *)moneyModel{
    _moneyModel = moneyModel;
    NSString *intro = nil;
    if([moneyModel.status isEqualToString:@"0"]){
        intro = [NSString stringWithFormat:NSLocalizedString(@"提现待审中(%@)", nil),[TransformTime transfromWithString:moneyModel.dateline]];
    }else if([moneyModel.status isEqualToString:@"1"]){
        intro = [NSString stringWithFormat:NSLocalizedString(@"提现成功(%@)", nil),[TransformTime transfromWithString:moneyModel.dateline]];
    }else if([moneyModel.status isEqualToString:@"2"]){
        intro = [NSString stringWithFormat:NSLocalizedString(@"提现被拒绝,原因:%@(%@)", nil),moneyModel.reason,[TransformTime transfromWithString:moneyModel.dateline]];
    }else{
        intro = moneyModel.intro;
    }
    CGSize contentSize = [self currentSizeWithString:intro font:FONT(15) withWidth:30];
    _contentRect = FRAME(15, 15, contentSize.width, contentSize.height);
    _rowHeight =  60 + contentSize.height;
    
}
@end
