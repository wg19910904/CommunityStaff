//
//  JHCountCellTwo.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCountCellTwo.h"
#import "UUChart.h"

@interface JHCountCellTwo ()<UUChartDataSource>
@property(nonatomic,strong)UUChart *chartView;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)NSArray *titleArray;
@end


@implementation JHCountCellTwo

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        topLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:topLine];
        UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(0, 259.5, WIDTH, 0.5)];
        bottomLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:bottomLine];
        [self initSubViews];
    }
    return self;
}
#pragma mark====初始化子控件====
- (void)initSubViews{
    _title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15, 15)];
    _title.font = FONT(14);
    _title.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_title];
}
- (void)configUIWthType:(NSString *)type data:(NSArray *)dataArray title:(NSArray *)titleArray{
    if([type isEqualToString:@"income"]){
        self.title.text = NSLocalizedString(@"近7天收入曲线", nil);
    }else{
        self.title.text = NSLocalizedString(@"近7天订单量曲线", nil);
    }
    if(self.chartView){
        [self.chartView removeFromSuperview];
        self.chartView = nil;
    }
    _dataArray = dataArray;
    _titleArray = titleArray;
    self.chartView = [[UUChart alloc] initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, 205) dataSource:self style:UUChartStyleLine];
    [self.chartView showInView:self.contentView];
}
- (NSArray *)getXtitles:(int)num{
    NSMutableArray *xTitles =[NSMutableArray array];
    for(int i = 0; i < _titleArray.count ; i ++){
        NSString *str = [_titleArray[i] substringWithRange:NSMakeRange(5, 5)];
        [xTitles addObject:str];
    }
    return  xTitles;
}
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart{
    return  [self getXtitles:7];
}
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart{
    return @[_dataArray];
   
}
- (NSArray *)chartConfigColors:(UUChart *)chart{
    return @[[UUColor theme]];
}
- (CGRange)chartRange:(UUChart *)chart{
    int total = 0;
    NSInteger length = 0;
    for (int i = 0; i < _dataArray.count; i++) {
        if (i == 0) {
            total = [_dataArray[0] intValue];
        }else{
            total = total > [_dataArray[i] intValue]?total:[_dataArray[i] intValue];
        }
    }
    if (total == 0) {
        total = 1000;
    }else{
        length = [NSString stringWithFormat:@"%d",total].length;
        total = total/pow( 10,length - 1);
        total = total+1;
        total = total*pow( 10,length - 1);
        NSLog(@"=======%d%ld%f======",total,length,pow( 10,length - 1));
    }
    return CGRangeMake(total, 0);
}
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index{
    return YES;
}
@end
