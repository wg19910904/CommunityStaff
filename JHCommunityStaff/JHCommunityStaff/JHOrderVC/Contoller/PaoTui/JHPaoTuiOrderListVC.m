//
//  JHPaoTuiOrderListVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/11.
//  Copyright © 2016年 jianghu2. All rights reserved.
//跑腿类订单列表

#import "JHPaoTuiOrderListVC.h"
#import "HttpTool.h"
#import "JHWaiMaiListCell.h"
#import "JHSongListCell.h"
#import "JHBuyListCell.h"
#import "JHBuyOrderDetailVC.h"
#import "JHSongOrderDetailVC.h"
#import "JHWaiMaiOrderDetailVC.h"
#import "JHPaoTuiOrderDetailVC.h"
#import "MJRefresh.h"
#import "JHPaotuiListModel.h"
#import "JHOtherListCell.h"
#import "JHWaiMaiMapVC.h"
#import "JHSongMapVC.h"
#import "JHBuyMapVC.h"
#import "JHPaotuiOtherMapVC.h"
#import "JHOrderReplyVC.h"
#import "PaoTuiSetMoneyMenBan.h"
#import "GaoDe_Convert_BaiDu.h"
@interface JHPaoTuiOrderListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_numLabel;//待处理订单数量
    UIView *_bottomLine;//按钮下面的蓝线
    UIButton *_lastBnt;
    MJRefreshAutoNormalFooter *_footer;
    MJRefreshNormalHeader *_header;
    NSString *_status;//订单状态
    NSInteger _page;
    UIImageView *_backImg;//无网络状态下背景
    NSMutableArray *_dataArray;//数据源
    NSMutableDictionary *conditionDic;//搜索条件字典
}


@end

@implementation JHPaoTuiOrderListVC
- (instancetype)initWithFrame:(CGRect)frame
                   withVerify:(NSString *)verifyName
                     withBool:(BOOL)isSearch
                withCondition:(NSMutableDictionary *)dic{
    if(self = [super init]){
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
    _dataArray = [[NSMutableArray alloc] init];
    if (!_isSearchResult) {
        [self addNotifiCation];
        [self createButtons];
    }
    [self createTableView];
    [self loadNewData];
}
#pragma mark====添加通知====
- (void)addNotifiCation{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"buyMapStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"cancelOrder" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"paotuiSetMoney" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"waimaiMapOrderStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"paotuiOtherMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"waimaiOrderStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"songDetailStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"paotuiOtherdetailStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"songMapStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"buyDetailStatusButton" object:nil];
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
    _bottomLine = [[UIView alloc] initWithFrame:FRAME((WIDTH / 3 - 50) / 2, 38, 50, 2)];
    _bottomLine.backgroundColor = THEME_COLOR;
    [backView addSubview:_bottomLine];
    NSArray *titles = @[NSLocalizedString(@"待抢单", nil),NSLocalizedString(@"待取送", nil),NSLocalizedString(@"已完成", nil)];
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
            _status = @"1";
        }
    }
}
#pragma mark=====待接单,待处理,已完成按钮点击事件======
- (void)clickButton:(UIButton *)sender{
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeCondition" object:nil];
     [conditionDic removeAllObjects];
    sender.selected = YES;
    _lastBnt = sender;
    _bottomLine.center = CGPointMake(sender.center.x, 38);
    _status = [NSString stringWithFormat:@"%ld",sender.tag];
    [self loadNewData];
}

#pragma mark======创建表视图=========
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0,_isSearchResult?0:40,WIDTH,HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMorePaoTuiData)];
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        _tableView.mj_footer = _footer;
        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 80, 200, 200 / 1.36)];
        [self.view addSubview:_tableView];
        [_tableView registerClass:[JHWaiMaiListCell class] forCellReuseIdentifier:@"waimai"];
        [_tableView registerClass:[JHBuyListCell class] forCellReuseIdentifier:@"buy"];
        [_tableView registerClass: [JHSongListCell class] forCellReuseIdentifier:@"song"];
        [_tableView registerClass:[JHOtherListCell class] forCellReuseIdentifier:@"other"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (!_isSearchResult) {
            if([self.verifyName isEqualToString:@"1"]){
                _tableView.frame = FRAME(0, 40, WIDTH,HEIGHT - 64);
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
        [conditionDic addEntriesFromDictionary:@{@"status":_status}];
    }
    [HttpTool postWithAPI:@"staff/paotui/order" withParams:conditionDic success:^(id json) {
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
                JHPaotuiListModel *model = [[JHPaotuiListModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            _backImg.image = IMAGE(@"no_data");
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
            }else{
                [_backImg removeFromSuperview];
            }
            _tableView.mj_footer.userInteractionEnabled = YES;
            [self createTableView];
            if(self.paoTuiBlock){
                self.paoTuiBlock(nil);
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
- (void)loadMorePaoTuiData{
    _page ++;
    NSDictionary *dic = @{@"page":@(_page)};
    [conditionDic addEntriesFromDictionary:dic];
    if (!_isSearchResult) {
        [conditionDic addEntriesFromDictionary:@{@"status":_status}];
    }
    [HttpTool postWithAPI:@"staff/paotui/order" withParams:conditionDic success:^(id json) {
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
                JHPaotuiListModel *model = [[JHPaotuiListModel alloc] init];
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
    JHPaotuiListModel *model = _dataArray[indexPath.section];
    if([model.type isEqualToString:@"waimai"]){
        return 274;
    }else if([model.type isEqualToString:@"song"] || [model.type isEqualToString:@"buy"]){
        return 224;
    }else{
        return 194;
    }
    return  0;
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
    JHPaotuiListModel *model = [[JHPaotuiListModel alloc] init];
    if(_dataArray.count == 0){
        
    }else{
        model = _dataArray[indexPath.section];
    }
    if([model.type isEqualToString:@"waimai"]){
        JHWaiMaiListCell *waimai = [_tableView dequeueReusableCellWithIdentifier:@"waimai" forIndexPath:indexPath];
        waimai.mobileButton.tag = indexPath.section + 1;
        [waimai.mobileButton addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
        waimai.look.tag = indexPath.section + 1;
        [waimai.look addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
        waimai.statusButton.tag = indexPath.section + 1;
        [waimai.statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        [waimai setPaotuiListModel:_dataArray[indexPath.section]];
        return waimai;
    }else if([model.type isEqualToString:@"buy"]){
        JHBuyListCell *buy = [_tableView dequeueReusableCellWithIdentifier:@"buy" forIndexPath:indexPath];
        buy.mobileButton.tag = indexPath.section + 1;
        [buy.mobileButton addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
        buy.look.tag = indexPath.section + 1;
        [buy.look addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
        buy.statusButton.tag = indexPath.section + 1;
        [buy.statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        [buy setPaotuiListModel:_dataArray[indexPath.section]];
        return buy;
    }else if([model.type isEqualToString:@"song"]){
        JHSongListCell *song = [_tableView dequeueReusableCellWithIdentifier:@"song" forIndexPath:indexPath];
        song.mobileButton.tag = indexPath.section + 1;
        [song.mobileButton addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
        song.look.tag = indexPath.section + 1;
        [song.look addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
        song.statusButton.tag = indexPath.section + 1;
        [song.statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        [song setPaotuiListModel:_dataArray[indexPath.section]];
        return song;
    }else {
        JHOtherListCell *other = [_tableView dequeueReusableCellWithIdentifier:@"other" forIndexPath:indexPath];
        other.mobileButton.tag = indexPath.section + 1;
        [other.mobileButton addTarget:self action:@selector(clickMobileButton:) forControlEvents:UIControlEventTouchUpInside];
        other.look.tag = indexPath.section + 1;
        [other.look addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
        other.statusButton.tag = indexPath.section + 1;
        [other.statusButton addTarget:self action:@selector(clickStatusButton:) forControlEvents:UIControlEventTouchUpInside];
        [other setPaotuiListModel:_dataArray[indexPath.section]];
        return other;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHPaotuiListModel *model = _dataArray[indexPath.section];
    if([model.type isEqualToString:@"waimai"]){
        JHWaiMaiOrderDetailVC *waimai = [[JHWaiMaiOrderDetailVC alloc] init];
        waimai.order_id = model.order_id;
        if(self.paoTuiBlock){
            self.paoTuiBlock(waimai);
        }
    }else if([model.type isEqualToString:@"buy"]){
        JHBuyOrderDetailVC *buy = [[JHBuyOrderDetailVC alloc] init];
        buy.order_id = model.order_id;
        if(self.paoTuiBlock){
            self.paoTuiBlock(buy);
        }
    }else if([model.type isEqualToString:@"song"]){
        JHSongOrderDetailVC *song = [[JHSongOrderDetailVC alloc] init];
        song.order_id = model.order_id;
        if(self.paoTuiBlock){
            self.paoTuiBlock(song);
        }
    }else{
        JHPaoTuiOrderDetailVC *paotui = [[JHPaoTuiOrderDetailVC alloc] init];
        paotui.order_id = model.order_id;
        paotui.type = model.type;
        if(self.paoTuiBlock){
            self.paoTuiBlock(paotui);
        }
    }
    
}
#pragma mark=======订单状态按钮点击事件========
- (void)clickStatusButton:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    JHPaotuiListModel *model = _dataArray[sender.tag - 1];
    NSString *api = nil;
    NSString *alert = nil;
    NSDictionary *dic = @{@"order_id":model.order_id};
    if([model.type isEqualToString:@"waimai"]){
        if([model.staff_id isEqualToString:@"0"]){
            api = @"staff/waimai/order/qiang";
            alert = NSLocalizedString(@"接单", nil);
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if (([model.order_status isEqualToString:@"1"] || [model.order_status isEqualToString:@"2"]) && ![model.staff_id isEqualToString:@"0"]){
            api = @"staff/waimai/order/pei";
            alert = NSLocalizedString(@"开始配送", nil);
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if ([model.order_status isEqualToString:@"3"]){
            api = @"staff/waimai/order/finshed";
            alert = NSLocalizedString(@"订单送达", nil);
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if([model.order_status isEqualToString:@"8"] && ![model.comment_info[@"comment_id"] isEqualToString:@"0"]){
           
            if([model.comment_info[@"reply_time"] isEqualToString:@"0"]){
                JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
                reply.comment_id = model.comment_info[@"comment_id"];
                reply.isMap = NO;
                if(self.paoTuiBlock){
                    self.paoTuiBlock(reply);
                }
                
            }
        }
    }else{
        if([model.order_status isEqualToString:@"0"] && [model.staff_id isEqualToString:@"0"]){
            api = @"staff/paotui/order/qiang";
            alert = NSLocalizedString(@"接单", nil);
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if([model.order_status isEqualToString:@"1"] || [model.order_status isEqualToString:@"2"]){
            if([model.type isEqualToString:@"buy"]){
                alert = NSLocalizedString(@"已购买", nil);
            }else if([model.type isEqualToString:@"song"]){
                alert = NSLocalizedString(@"已取件", nil);
            }else if ([model.type isEqualToString:@"seat"]){
                alert = NSLocalizedString(@"开始占座", nil);
            }else if([model.type isEqualToString:@"paidui"]){
                alert = NSLocalizedString(@"开始排队", nil);
            }else if([model.type isEqualToString:@"chongwu"]){
                alert = NSLocalizedString(@"开始照顾", nil);
            }else{
                alert = NSLocalizedString(@"开始服务", nil);
            }
            api = @"staff/paotui/order/startwork";
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if ([model.order_status isEqualToString:@"3"]){
            if([model.type isEqualToString:@"buy"]){
                alert = NSLocalizedString(@"已送达", nil);
            }else if([model.type isEqualToString:@"song"]){
                alert = NSLocalizedString(@"已送达", nil);
            }else if ([model.type isEqualToString:@"seat"]){
                alert = NSLocalizedString(@"占座结束", nil);
            }else if([model.type isEqualToString:@"paidui"]){
                alert = NSLocalizedString(@"排队结束", nil);
            }else if([model.type isEqualToString:@"chongwu"]){
                alert = NSLocalizedString(@"照顾结束", nil);
            }else{
                alert = NSLocalizedString(@"完成服务", nil);
            }
            api = @"staff/paotui/order/finshed";
            [self requestWitApi:api dic:dic alert:alert withModel:model];
        }else if ([model.order_status isEqualToString:@"4"]){
            //帮我买设置金额
//            if([model.type isEqualToString:@"buy"]){
//                [PaoTuiSetMoneyMenBan creatSetMoneyMenBanWithOrderId:model.order_id viewController:self success:^{
//                    NSLog(@"帮我买设置金额成功");
//                } cancel:^{
//                    NSLog(@"取消了");
//                }];
//            }
        }else if([model.order_status isEqualToString:@"8"] && ![model.comment_info[@"comment_id"] isEqualToString:@"0"]){
            if([model.comment_info[@"reply_time"] isEqualToString:@"0"]){
                JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
                reply.comment_id = model.comment_info[@"comment_id"];
                reply.isMap = NO;
                if(self.paoTuiBlock){
                    self.paoTuiBlock(reply);
                }
            }
        }
    }
}
#pragma mark=====订单状态按钮网络请求=====
- (void)requestWitApi:(NSString *)api dic:(NSDictionary *)dic alert:(NSString *)alert withModel:(JHPaotuiListModel*)model{
    SHOW_HUD
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            if([model.type isEqualToString:@"buy"] && [model.order_status isEqualToString:@"3"]){
//                [PaoTuiSetMoneyMenBan creatSetMoneyMenBanWithOrderId:model.order_id viewController:self success:^{
//                    NSLog(@"帮我买设置金额成功");
//                } cancel:^{
//                    NSLog(@"取消了");
//                }];
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
    JHPaotuiListModel *model = _dataArray[sender.tag - 1];
    if([model.type isEqualToString:@"waimai"]){
        JHWaiMaiMapVC *map = [[JHWaiMaiMapVC alloc] init];
        double o_lat = 0.00;
        double o_lng = 0.00;
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.o_lat doubleValue] WithBD_lon:[model.o_lng doubleValue] WithGD_lat:&o_lat WithGD_lon:&o_lng];
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.lat doubleValue] WithBD_lon:[model.lng doubleValue] WithGD_lat:&lat WithGD_lon:&lng];
        map.o_lat = [NSString stringWithFormat:@"%f",o_lat];
        map.o_lng = [NSString stringWithFormat:@"%f",o_lng];
        map.lat = [NSString stringWithFormat:@"%f",lat];
        map.lng = [NSString stringWithFormat:@"%f",lng];
        map.pei_type = model.pei_type;
        map.order_status = model.order_status;
        map.order_status_label = model.order_status_label;
        map.staff_id = model.staff_id;
        map.online_pay = model.online_pay;
        map.pay_status = model.pay_status;
        map.paoTuiAmount = model.paotui_amount;
        map.comment_info = model.comment_info;
        map.order_id = model.order_id;
        if(self.paoTuiBlock){
            self.paoTuiBlock(map);
        }
    }else if ([model.type isEqualToString:@"buy"]){
        JHBuyMapVC *map = [[JHBuyMapVC alloc] init];
        double o_lat = 0.00;
        double o_lng = 0.00;
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.o_lat doubleValue] WithBD_lon:[model.o_lng doubleValue] WithGD_lat:&o_lat WithGD_lon:&o_lng];
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.lat doubleValue] WithBD_lon:[model.lng doubleValue] WithGD_lat:&lat WithGD_lon:&lng];
        map.o_lat = [NSString stringWithFormat:@"%f",o_lat];
        map.o_lng = [NSString stringWithFormat:@"%f",o_lng];
        map.lat = [NSString stringWithFormat:@"%f",lat];
        map.lng = [NSString stringWithFormat:@"%f",lng];
        map.order_status = model.order_status;
        map.staff_id = model.staff_id;
        map.comment_info = model.comment_info;
        map.order_id = model.order_id;
        map.o_addr = model.o_addr;
        map.paoTuiAmount = model.paotui_amount;
        if(self.paoTuiBlock){
            self.paoTuiBlock(map);
        }
    }else if ([model.type isEqualToString:@"song"]){
        JHSongMapVC *map = [[JHSongMapVC alloc] init];
        double o_lat = 0.00;
        double o_lng = 0.00;
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.o_lat doubleValue] WithBD_lon:[model.o_lng doubleValue] WithGD_lat:&o_lat WithGD_lon:&o_lng];
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.lat doubleValue] WithBD_lon:[model.lng doubleValue] WithGD_lat:&lat WithGD_lon:&lng];
        map.o_lat = [NSString stringWithFormat:@"%f",o_lat];
        map.o_lng = [NSString stringWithFormat:@"%f",o_lng];
        map.lat = [NSString stringWithFormat:@"%f",lat];
        map.lng = [NSString stringWithFormat:@"%f",lng];
        map.order_status = model.order_status;
        map.staff_id = model.staff_id;
        map.comment_info = model.comment_info;
        map.order_id = model.order_id;
        map.paoTuiAmount = model.paotui_amount;
        map.order_status_label = model.order_status_label;
        if(self.paoTuiBlock){
            self.paoTuiBlock(map);
        }
    }else{
        JHPaotuiOtherMapVC *map = [[JHPaotuiOtherMapVC alloc] init];
        double lat = 0.00;
        double lng = 0.00;
        [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[model.lat doubleValue] WithBD_lon:[model.lng doubleValue] WithGD_lat:&lat WithGD_lon:&lng];
        map.lat = [NSString stringWithFormat:@"%f",lat];
        map.lng = [NSString stringWithFormat:@"%f",lng];
        map.order_status = model.order_status;
        map.staff_id = model.staff_id;
        map.comment_info = model.comment_info;
        map.order_id = model.order_id;
        map.paoTuiAmount = model.paotui_amount;
        map.type = model.type;
        map.order_status_label = model.order_status_label;
        if(self.paoTuiBlock){
            self.paoTuiBlock(map);
        }
    }
}
#pragma mark=======电话按钮点击事件=======
- (void)clickMobileButton:(UIButton *)sender{
    NSLog(@"打电话了");
    JHPaotuiListModel *model = _dataArray[sender.tag - 1];
    NSString *title = model.mobile;
    [self showMobile:title];
}
#pragma mark=====提示框方法========
- (void)showMobile:(NSString *)title{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [alertViewController addAction:certainAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"buyMapStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paotuiSetMoney" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"waimaiMapOrderStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paotuiOtherMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"waimaiOrderStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"songDetailStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"paotuiOtherdetailStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"buyDetailStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"songMapStatusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NEWORDER" object:nil];
}
@end
