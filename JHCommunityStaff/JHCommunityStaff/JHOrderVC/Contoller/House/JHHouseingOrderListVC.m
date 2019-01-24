//
//  JHOrderListVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//家政订单列表

#import "JHHouseingOrderListVC.h"
#import "HttpTool.h"
#import "JHHouseingCell.h"
#import "JHHouseMapVC.h"
#import "JHHouseingOrderDetailVC.h"
#import "MJRefresh.h"
#import "JHHouseingListModel.h"
#import "AppDelegate.h"
#import "JHOrderReplyVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "HouseSetMoneyMenBan.h"
@interface JHHouseingOrderListVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *_numLabel;//待处理订单数量
    UILabel *_bottomLine;//按钮下面的蓝线
    UIButton *_lastBnt;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSString *_type;//类型
    NSMutableArray *_dataArray;//数据源
    NSInteger _page;
    NSString *_orderID;//记录订单号
    UIImageView *_backImg;//无网络状态下背景
    NSMutableDictionary *conditionDic;//搜索条件字典
}
@end

@implementation JHHouseingOrderListVC

- (instancetype)initWithFrame:(CGRect)frame
                   withVerify:(NSString *)verifyName
                     withBool:(BOOL)isSearch
                withCondition:(NSMutableDictionary *)dic
{
    self = [super init];
    if (self) {
        if (isSearch) {
            _isSearchResult = YES;
            conditionDic = dic;
        }else{
            conditionDic = @{}.mutableCopy;
        }
        self.verifyName = verifyName;
        self.view.frame = frame;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    if (!_isSearchResult) {
         [self addNotificartion];
         [self createButtons];
    }
    _type = @"1";
    _dataArray = @[].mutableCopy;
    [self createTableView];
    [self loadNewData];
   
}
#pragma mark=====添加通知====
- (void)addNotificartion{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"houseMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"cancelOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"houseSetMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"houseDetailStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"NEWORDER" object:nil];
}
#pragma mark====创建待接单,待处理,已完成按钮======
- (void)createButtons{
    UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    _numLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 6  + 25,8, 15, 15)];
    _numLabel.layer.cornerRadius = _numLabel.frame.size.width / 2;
    _numLabel.clipsToBounds = YES;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.backgroundColor =  HEX(@"FE2600", 1.0f);
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.font = FONT(10);
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [backView addSubview:thread];
    _bottomLine = [[UILabel alloc] initWithFrame:FRAME((WIDTH / 3 - 50) / 2, 38, 50, 2)];
    _bottomLine.backgroundColor = THEME_COLOR;
    [backView addSubview:_bottomLine];
    NSArray *titles = @[NSLocalizedString(@"待接单", nil),NSLocalizedString(@"待处理", nil),NSLocalizedString(@"已完成", nil)];
    for(int i = 0; i < 3; i++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = FRAME(i * (WIDTH / 3), 0, WIDTH / 3, 40);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:HEX(@"333333", 1.0f) forState:UIControlStateNormal];
        [button setTitleColor:THEME_COLOR forState:UIControlStateHighlighted];
        [button setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        button.titleLabel.font = FONT(14);
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1;
        [backView addSubview:button];
        if(i == 0){
            button.selected = YES;
            _lastBnt = button;
            _bottomLine.center = CGPointMake(button.center.x, 38);
        }
    }
}
#pragma mark=====待接单,待处理,已完成按钮点击事件======
- (void)clickButton:(UIButton *)sender{
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
    }
    [conditionDic removeAllObjects];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeCondition" object:nil];
    sender.selected = YES;
    _lastBnt = sender;
    _bottomLine.center = CGPointMake(sender.center.x, 38);
    _type = [NSString stringWithFormat:@"%ld",sender.tag];
    [self loadNewData];
}
#pragma mark======创建表视图=========
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, _isSearchResult?0:40, WIDTH,HEIGHT- 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 80, 200, 200 / 1.36)];
        [self.view addSubview:_tableView];
        if (!_isSearchResult) {
            if([self.verifyName isEqualToString:@"1"]){
                _tableView.frame = FRAME(0, 40, WIDTH,HEIGHT- 64);
            }else{
                _tableView.frame = FRAME(0, 40, WIDTH,HEIGHT- 64 - 40);
            }
        }
    }else{
        [_tableView reloadData];
    }
}
#pragma mark====加载第一页数据========
- (void)loadNewData{
    HIDE_HUD
    SHOW_HUD
    _page = 1;
    NSDictionary *dic = @{@"page":@(_page)};
    [conditionDic addEntriesFromDictionary:dic];
    if (!_isSearchResult) {
        [conditionDic addEntriesFromDictionary:@{@"status":_type}];
    }
    [HttpTool postWithAPI:@"staff/house/order" withParams:conditionDic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            UIButton *btn = (UIButton *)[self.view viewWithTag:2];
            [_dataArray removeAllObjects];
            NSArray *data = json[@"data"][@"items"];
            if([json[@"data"][@"wait_count"] isEqualToString:@"0"]){
                [_numLabel removeFromSuperview];
            }else if([json[@"data"][@"wait_count"] integerValue] > 99){
                _numLabel.text = @"99";
                [btn addSubview:_numLabel];
            }else{
                _numLabel.text = json[@"data"][@"wait_count"];
                [btn addSubview:_numLabel];
            }
            for(NSDictionary *dic in data){
                JHHouseingListModel *model = [[JHHouseingListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self createTableView];
            _backImg.image = IMAGE(@"no_data");
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
            }else{
                [_backImg removeFromSuperview];
            }
            _tableView.mj_footer.userInteractionEnabled = YES;
            if(self.houseBlock){
                self.houseBlock(nil);
            }
            HIDE_HUD
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
        NSLog(@"error%@",error.localizedDescription);
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
    [conditionDic addEntriesFromDictionary:dic];
    if (!_isSearchResult) {
        [conditionDic addEntriesFromDictionary:@{@"status":_type}];
    }
    [HttpTool postWithAPI:@"staff/house/order" withParams:conditionDic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            UIButton *btn = (UIButton *)[self.view viewWithTag:2];
            NSArray *data = json[@"data"][@"items"];
            if([json[@"data"][@"wait_count"] isEqualToString:@"0"]){
                [_numLabel removeFromSuperview];
            }else if([json[@"data"][@"wait_count"] integerValue] > 99){
                _numLabel.text = @"99";
                [btn addSubview:_numLabel];
            }else{
                _numLabel.text = json[@"data"][@"wait_count"];
                [btn addSubview:_numLabel];
            }
            if(data.count == 0){
                HIDE_HUD
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                return ;
            }
            for(NSDictionary *dic in data){
                JHHouseingListModel *model = [[JHHouseingListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self createTableView];
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
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark=======UITableViewDelegate=======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 219;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 10;
    else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"houseing";
    JHHouseingCell *houseing = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if(houseing == nil){
        houseing = [[JHHouseingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    houseing.mobileButton.tag = indexPath.section + 1;
    [houseing.mobileButton addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
    houseing.look.tag = indexPath.section + 1;
    [houseing.look addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
    houseing.statusButton.tag = indexPath.section + 1;
    [houseing.statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
    [houseing setHouseingModel:_dataArray[indexPath.section]];
    return houseing;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHHouseingOrderDetailVC *houseingDetail = [[JHHouseingOrderDetailVC alloc] init];
    houseingDetail.order_id = [_dataArray[indexPath.section] order_id];
    if(self.houseBlock){
        self.houseBlock(houseingDetail);
    }
}
#pragma mark=======订单状态按钮点击事件========
- (void)clickStatusButton:(UIButton *)sender{
    NSLog(@"订单状态");
    JHHouseingListModel *model = _dataArray[sender.tag - 1];
    NSDictionary *dic = @{@"order_id":model.order_id};
    NSString *api = nil;
    NSString *alertStr = nil;
    if([model.order_status isEqualToString:@"0"] ){
        api = @"staff/house/order/qiang";
        alertStr = NSLocalizedString(@"接单", nil);
        [self requestWitApi:api dic:dic alert:alertStr model:model];
    }else if([model.order_status isEqualToString:@"1"]  ||  [model.order_status isEqualToString:@"2"]){
        api = @"staff/house/order/startwork";
        alertStr = NSLocalizedString(@"开始服务", nil);
        [self requestWitApi:api dic:dic alert:alertStr model:model];
    }else if([model.order_status isEqualToString:@"3"]){
        api = @"staff/house/order/finshed";
        alertStr = NSLocalizedString(@"完成服务", nil);
        [self requestWitApi:api dic:dic alert:alertStr model:model];
    }else if ([model.order_status isEqualToString:@"4"]){
        
        [HouseSetMoneyMenBan creatSetMoneyMenBanWithOrderId:model.order_id viewController:self success:^{
            NSLog(@"家政设定总额成功");
        } cancel:^{
            NSLog(@"取消了");
        }];
    }else if ([model.order_status isEqualToString:@"5"]){
    }else if([model.order_status isEqualToString:@"8"] && ![model.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([model.comment_info[@"reply_time"] isEqualToString:@"0"]){
            JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
            reply.comment_id = model.comment_info[@"comment_id"];
            reply.isMap = NO;
            if(self.houseBlock){
                self.houseBlock(reply);
            }
        }
    }
}
#pragma mark=====订单状态按钮网络请求=====
- (void)requestWitApi:(NSString *)api dic:(NSDictionary *)dic alert:(NSString *)alert model:(JHHouseingListModel *)model{
    SHOW_HUD
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            if([model.order_status isEqualToString:@"3"]){
                [HouseSetMoneyMenBan creatSetMoneyMenBanWithOrderId:model.order_id viewController:self success:^{
                    NSLog(@"家政设定总额成功");
                } cancel:^{
                    NSLog(@"取消了");
                }];
            }else{
               [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@成功", nil),alert]];
            }
            [self loadNewData];
        }else{
            HIDE_HUD
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@失败,原因:%@", nil),alert,json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark=====查看路线按钮点击事件======
- (void)clickLookButton:(UIButton *)sender{
    NSLog(@"查看路线");
    JHHouseingListModel *model = _dataArray[sender.tag - 1];
    JHHouseMapVC *map = [[JHHouseMapVC alloc] init];
    map.order_id = model.order_id;
    map.order_status = model.order_status;
    map.comment_info = model.comment_info;
    map.status_label = model.order_status_label;
    map.pay_status = model.pay_status;
    map.danBao = model.danbao_amount;
    double lat = 0.0;
    double lng = 0.0;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.lat doubleValue]
                                                 WithBD_lon:[model.lng doubleValue]
                                                 WithGD_lat:&lat
                                                 WithGD_lon:&lng];
    map.lat = [NSString stringWithFormat:@"%f",lat];
    map.lng = [NSString stringWithFormat:@"%f",lng];
    if(self.houseBlock){
        self.houseBlock(map);
    }
}
#pragma mark=======电话按钮点击事件=======
- (void)clickMobileButton:(UIButton *)sender{
    NSLog(@"打电话了");
    NSString *title = [_dataArray[sender.tag - 1] mobile];
    [self showMobile:title];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"houseMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"houseSetMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"houseDetailStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEWORDER" object:nil];
}
@end
