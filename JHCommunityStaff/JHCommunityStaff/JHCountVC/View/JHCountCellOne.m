//
//  JHCountCellOne.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCountCellOne.h"

@implementation JHCountCellOne
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(WIDTH / 2 - 0.5, 15, 0.5, 115)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
        UIView *topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        topLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:topLine];
        UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 144.5, WIDTH, 0.5)];
        bottomLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:bottomLine];
    }
    return self;
}
#pragma mark===初始化子控件======
- (void)initSubViews{
    _today = [[UILabel alloc] initWithFrame:FRAME(0, 15, WIDTH / 2, 15)];
    _today.textColor = HEX(@"333333", 1.0f);
    _today.font = FONT(14);
    _today.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_today];
    _week = [[UILabel alloc] initWithFrame:FRAME( WIDTH / 2, 15, WIDTH / 2, 15)];
    _week.textColor = HEX(@"333333", 1.0f);
    _week.font = FONT(14);
    _week.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_week];
    _month = [[UILabel alloc] initWithFrame:FRAME(0 , 80, WIDTH / 2, 15)];
    _month.textColor = HEX(@"333333", 1.0f);
    _month.font = FONT(14);
    _month.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_month];
    _total = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2, 80, WIDTH / 2, 15)];
    _total.textColor = HEX(@"333333", 1.0f);
    _total.font = FONT(14);
    _total.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_total];
    _today_num = [[UILabel alloc] initWithFrame:FRAME(0, 40, WIDTH / 2, 25)];
    _today_num.textColor = THEME_COLOR;
    _today_num.font = FONT(22);
    _today_num.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_today_num];
    _week_num = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2, 40, WIDTH / 2, 25)];
    _week_num.textColor = THEME_COLOR;
    _week_num.font = FONT(22);
    _week_num.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_week_num];
    _month_num = [[UILabel alloc] initWithFrame:FRAME(0, 105, WIDTH / 2, 25)];
    _month_num.textColor = THEME_COLOR;
    _month_num.font = FONT(22);
    _month_num.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_month_num];
    _total_num = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2, 105, WIDTH / 2, 25)];
    _total_num.textColor = THEME_COLOR;
    _total_num.font = FONT(22);
    _total_num.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_total_num];

}
- (void)setDataArray:(NSArray *)dataArray withType:(NSString *)type{
    _dataArray = dataArray;
    if([type isEqualToString:@"income"]){
        _today.text = NSLocalizedString(@"今日收入额", nil);
        _week.text = NSLocalizedString(@"近7天收入额", nil);
        _month.text = NSLocalizedString(@"近30天收入额", nil);
        _total.text = NSLocalizedString(@"累计收入额", nil);
    }else{
        _today.text = NSLocalizedString(@"今日订单量", nil);
        _week.text = NSLocalizedString(@"近7天订单量", nil);
        _month.text = NSLocalizedString(@"近30天订单量", nil);
        _total.text = NSLocalizedString(@"累计订单量", nil);
    }
    _today_num.text = [NSString stringWithFormat:@"%@",_dataArray[0]];
    _week_num.text = [NSString stringWithFormat:@"%@",_dataArray[1]];
    _month_num.text = [NSString stringWithFormat:@"%@",_dataArray[2]];
    _total_num.text = [NSString stringWithFormat:@"%@",_dataArray[3]];
}
@end
