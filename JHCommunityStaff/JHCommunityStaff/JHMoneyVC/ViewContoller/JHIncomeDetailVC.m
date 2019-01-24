//
//  JHIncomeDetailVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//收入明细

#import "JHIncomeDetailVC.h"
#import "JHIncomeMoneyCell.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "JHMoneyModel.h"
#import "JHMoneyFrameModel.h"
@interface JHIncomeDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSInteger _page;
    NSMutableArray *_dataArray;//数据源
    UIImageView *_backImg;//无网络背景
}
@end

@implementation JHIncomeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"收入明细", nil)];
    _dataArray = [@[] mutableCopy];
    [self createTableView];
    [self loadNewData];
}
#pragma mark======创建表视图=======
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200 / 1.36)];
        [self.view addSubview:_tableView];
        
    }else{
        [_tableView reloadData];
    }
}
#pragma mark==请求第一页数据=======
- (void)loadNewData{
    _page = 1;
    SHOW_HUD
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/money/log" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [_dataArray removeAllObjects];
            NSArray *dataArray = json[@"data"][@"items"];
            for(NSDictionary *dic in dataArray){
                JHMoneyFrameModel *moneyFrameModel = [[JHMoneyFrameModel alloc] init];
                JHMoneyModel *model = [[JHMoneyModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                moneyFrameModel.moneyModel = model;
                [_dataArray addObject:moneyFrameModel];
            }
            [_tableView reloadData];
            _backImg.image = IMAGE(@"no_data");
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
            }else{
                [_backImg removeFromSuperview];
            }
            _tableView.mj_footer.userInteractionEnabled = YES;
        }else{
            HIDE_HUD
            [_dataArray removeAllObjects];
            [self createTableView];
            _backImg.image = IMAGE(@"no_net");
            [_tableView addSubview:_backImg];
            _tableView.mj_footer.userInteractionEnabled = NO;
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
         [_tableView.mj_footer endRefreshing];
        NSLog(@"eror%@",error.localizedDescription);
        [_dataArray removeAllObjects];
        [self createTableView];
        _backImg.image = IMAGE(@"no_net");
        [_tableView addSubview:_backImg];
        _tableView.mj_footer.userInteractionEnabled = NO;
    }];
}
#pragma mark=====加载更多数据=======
- (void)loadMoreData{
    SHOW_HUD
    _page ++;
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/money/log" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSArray *dataArray = json[@"data"][@"items"];
            if(dataArray.count == 0){
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in dataArray){
                JHMoneyFrameModel *moneyFrameModel = [[JHMoneyFrameModel alloc] init];
                JHMoneyModel *model = [[JHMoneyModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                moneyFrameModel.moneyModel = model;
                [_dataArray addObject:moneyFrameModel];
            }
              [_tableView reloadData];
            HIDE_HUD
         
        }else{
            HIDE_HUD
            [self showAlertViewWithTitle:NSLocalizedString(@"数据请求失败", nil)];
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"eror%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark======UITableViewDelegate=========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataArray[indexPath.section] rowHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 40;
    else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == _dataArray.count - 1)
        return CGFLOAT_MIN;
    else
        return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
        view.backgroundColor = BACK_COLOR;
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 15, WIDTH, 15)];
        label.font = FONT(12);
        label.textColor = HEX(@"999999", 1.0f);
        label.text = NSLocalizedString(@"最近30天资金收入明细", nil);
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"income";
    JHIncomeMoneyCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[JHIncomeMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setMoneyFrameModel:_dataArray[indexPath.section]];
    return cell;
}
@end
