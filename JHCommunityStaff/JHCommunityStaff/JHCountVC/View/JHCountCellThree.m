//
//  JHCountCellThree.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCountCellThree.h"
#import "BEMSimpleLineGraphView.h"

@interface JHCountCellThree ()<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>
{
    BEMSimpleLineGraphView *_myGraph;
}
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (strong, nonatomic) NSMutableArray *myInfoArray;
@property (nonatomic,strong) UILabel *labelDates;
@end

@implementation JHCountCellThree

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
#pragma mark====初始化子控件======
- (void)initSubViews{
    _title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15, 15)];
    _title.font = FONT(14);
    _title.textColor = HEX(@"666666", 1.0f);
    [self.contentView addSubview:_title];
}
-(void)creatNSMutableArray:(NSMutableArray *)infoArray withNSMutableArray:(NSMutableArray *)dateArray withType:(NSString *)type{
    if([type isEqualToString:@"income"]){
        self.title.text = NSLocalizedString(@"近30天收入曲线", nil);
    }else{
        self.title.text = NSLocalizedString(@"近30天订单量曲线", nil);
    }
    _myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:FRAME(10, 40, WIDTH - 20, 200)];
    [self.contentView addSubview:_myGraph];
   // _myGraph.colorXaxisLabel = [UIColor whiteColor];//[UIColor colorWithRed:71 / 255.0 green:71 / 255.0 blue:71 / 255.0 alpha:1.0f];
    _myGraph.colorYaxisLabel = [UIColor colorWithRed:71 / 255.0 green:71 / 255.0 blue:71 / 255.0 alpha:1.0f];
    _myGraph.colorTop = [UIColor whiteColor];
   // _myGraph.colorLine = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0f];
    _myGraph.colorLine = THEME_COLOR;
  _myGraph.colorBottom  = [UIColor whiteColor];
    _myGraph.colorPoint = THEME_COLOR;
    _myGraph.delegate = self;
    _myGraph.dataSource = self;
//    _myGraph.enableTouchReport = YES;
//    _myGraph.enablePopUpReport = YES;
//    _myGraph.enableYAxisLabel = YES;
//    _myGraph.autoScaleYAxis = YES;
//    _myGraph.alwaysDisplayDots = NO;
//    _myGraph.enableReferenceXAxisLines = YES;
//    _myGraph.enableReferenceYAxisLines = YES;
//    _myGraph.enableReferenceAxisFrame = YES;
//    _myGraph.enableBezierCurve = YES;
    
    
    
    _myGraph.enableTouchReport = YES;
    _myGraph.enablePopUpReport = YES;
    _myGraph.enableYAxisLabel = YES;
    _myGraph.autoScaleYAxis = YES;
    _myGraph.alwaysDisplayDots = NO;
    _myGraph.enableReferenceXAxisLines = YES;
    _myGraph.enableReferenceYAxisLines = YES;
    _myGraph.enableReferenceAxisFrame = YES;
    _myGraph.enableXAxisLabel = YES;
    _myGraph.enableBezierCurve = YES;
    
    _myInfoArray = infoArray;
    self.arrayOfDates = dateArray;
    _labelDates = [[UILabel alloc] initWithFrame:FRAME(0, 230, WIDTH, 15)];
    _labelDates.text = [NSString stringWithFormat:NSLocalizedString(@"%@ 到 %@", nil),dateArray[0],[dateArray lastObject]];
    _labelDates.font = FONT(14);
    _labelDates.backgroundColor = [UIColor whiteColor];
    _labelDates.textColor = [UIColor colorWithRed:71 / 255.0 green:71 / 255.0 blue:71 / 255.0 alpha:1.0f];
    _labelDates.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_labelDates];
    [self hydrateDatasets];
    [_myGraph reloadGraph];
}

- (void)hydrateDatasets {
    if (!self.arrayOfValues) {
        self.arrayOfValues = [NSMutableArray array];
    }
    [self.arrayOfValues removeAllObjects];
    BOOL showNullValue = true;
    for (int i = 0; i < _myInfoArray.count; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloatWithNum:i])];
        if (i == 0) {
        } else if (showNullValue && i == 4) {
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            
        }
    }
    NSLog(@"......%@.....",self.arrayOfDates);
}
- (NSString *)labelForDateAtIndex:(NSInteger)index {
    return self.arrayOfDates[index];
//    NSString * time = [self.arrayOfDates[index] substringWithRange:NSMakeRange(5, 5)];
//    return time;
}
- (float)getRandomFloatWithNum:(int)num {
    float i1 = [_myInfoArray[num] floatValue];
    NSLog(@"%f====%@",i1,_myInfoArray[num] );
    return i1;
}
#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelDates.text = [NSString stringWithFormat:@"%@", [self labelForDateAtIndex:index]];
}
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelDates.text = [NSString stringWithFormat:NSLocalizedString(@" %@ 到 %@", nil), [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}

@end
