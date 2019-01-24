//
//  JHCountIncomeVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/17.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCountIncomeVC.h"
#import "JHCountCellOne.h"
#import "JHCountCellTwo.h"
#import "JHCountCellThree.h"
#import "HttpTool.h"
#import "MJRefresh.h"
@interface JHCountIncomeVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_incomeArray;//收入
    NSDictionary *_monthDic;
    NSDictionary *_weekDic;
    MJRefreshNormalHeader *_header;
    UIView *_noNetBackView;//无网络状态下背景
    BOOL _isYes;
}
@end

@implementation JHCountIncomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _monthDic = [@{} mutableCopy];
    _weekDic = [@{} mutableCopy];
    _incomeArray = [[NSMutableArray alloc] init];
    [self createTableView];
     [self requestData];
}
#pragma mark======创建表视图=========
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0,WIDTH , HEIGHT - 44 - 15 - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        [self.view addSubview:_tableView];
        _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        _noNetBackView.backgroundColor = BACK_COLOR;
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 60, 200, 200 / 1.36)];
        img.image = IMAGE(@"no_net");
        [_noNetBackView addSubview:img];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark-========请求数据=========
- (void)requestData{
    SHOW_HUD
    [HttpTool postWithAPI:@"staff/tongji/amount" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            _isYes = YES;
            [_noNetBackView removeFromSuperview];
            _monthDic = json[@"data"][@"month_detail"];
            _weekDic = json[@"data"][@"week_detail"];
            [_incomeArray addObject:json[@"data"][@"today_save"]];
            [_incomeArray addObject:json[@"data"][@"week_save"]];
            [_incomeArray addObject:json[@"data"][@"month_save"]];
            [_incomeArray addObject:json[@"data"][@"total_save"]];
            [self createTableView];
        }else{
            HIDE_HUD
            [_tableView addSubview:_noNetBackView];
            _isYes = NO;
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
         [_tableView.mj_header endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [_tableView addSubview:_noNetBackView];
        _isYes = NO;
    }];
}

#pragma mark====UITableViewDelegate========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isYes)
        return 1;
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 145;
    else
        return 260;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 10;
    else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2)
        return CGFLOAT_MIN;
    else
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            JHCountCellOne *cell = [[JHCountCellOne alloc] init];
            [cell setDataArray:_incomeArray withType:@"income"];
            return cell;
        }
            break;
        case 1:
        {
            JHCountCellTwo *cell = [[JHCountCellTwo alloc] init];
           [cell configUIWthType:@"income" data:_weekDic[@"value"] title:_weekDic[@"key"]];
            return cell;
        }
            break;
        case 2:
        {
            JHCountCellThree *cell = [[JHCountCellThree alloc] init];
            NSMutableArray *dateArray = [@[] mutableCopy];
            for(NSString *str in _monthDic[@"key"]){
                NSString *string = [str substringWithRange:NSMakeRange(5, 5)];
                [dateArray addObject:string];
            }
            [cell creatNSMutableArray:_monthDic[@"value"] withNSMutableArray:dateArray withType:@"income"];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
@end
