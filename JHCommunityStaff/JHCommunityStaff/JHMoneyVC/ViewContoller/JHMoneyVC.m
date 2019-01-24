//
//  JHMoneyVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMoneyVC.h"
#import "JHIncomeDetailVC.h"
#import "JHWithdrawalVC.h"
#import "JHApplyCashVC.h"
#import "HttpTool.h"
#import "MJRefresh.h"
@interface JHMoneyVC ()<UIWebViewDelegate>
//{
//    UITableView *_tableView;//主表视图
//    UILabel *_money;//我的余额
//    UILabel *_cash;//提现
//    UIButton *_cashBnt;//申请提现按钮
//    UIImageView *_backImg;//背景图
//    MJRefreshNormalHeader *_header;
//    UIView *_noNetBackView;//无网络请求数据失败背景
//    UILabel * _waitTiXian;//提现待审核
//    NSString *_totalWaitMoney;
//}
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)UIButton *closeBtn;
@end

@implementation JHMoneyVC

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self addTitle:NSLocalizedString(@"资金管理", nil)];
//    [self initSubViews];
//    [self createTableView];
//    [self requestData];
//}
//#pragma mark=====初始化子控件===========
//- (void)initSubViews{
//    _money = [[UILabel alloc] initWithFrame:FRAME(0, 40, WIDTH / 2, 20)];
//    _money.font = FONT(18);
//    _money.textColor = HEX(@"ff6600", 1.0f);
//    _money.textAlignment = NSTextAlignmentCenter;
//    _cash = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2, 40, WIDTH / 2, 20)];
//    _cash.font = FONT(18);
//    _cash.textColor = HEX(@"ff6600", 1.0f);
//    _cash.textAlignment = NSTextAlignmentCenter;
//    _cashBnt = [UIButton buttonWithType:UIButtonTypeCustom];
//    _cashBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
//    _cashBnt.layer.cornerRadius = 4.0f;
//    _cashBnt.clipsToBounds = YES;
//    [_cashBnt setTitle:NSLocalizedString(@"申请提现", nil) forState:UIControlStateNormal];
//    [_cashBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_cashBnt setBackgroundColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
//    _cashBnt.titleLabel.font = FONT(16);
//    [_cashBnt addTarget:self action:@selector(clickCashBnt) forControlEvents:UIControlEventTouchUpInside];
//    _backImg = [[UIImageView  alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200 / 1.36)];
//    _backImg.image = IMAGE(@"no_net");
//    _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
//    _noNetBackView.backgroundColor = BACK_COLOR;
//    [_noNetBackView addSubview:_backImg];
//    _waitTiXian = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 35)];
//    _waitTiXian.textAlignment = NSTextAlignmentCenter;
//    _waitTiXian.font = FONT(12);
//    _waitTiXian.textColor = THEME_COLOR;
//    _totalWaitMoney = nil;
//}
//#pragma mark=======请求网络数据====
//- (void)requestData{
//    SHOW_HUD
//    [HttpTool postWithAPI:@"staff/money/capital" withParams:@{} success:^(id json) {
//        NSLog(@"json%@",json);
//        if([json[@"error"] isEqualToString:@"0"]){
//            HIDE_HUD
//            [_noNetBackView removeFromSuperview];
//            _money.text = [NSString stringWithFormat:NSLocalizedString(@"￥%.2f", nil),[json[@"data"][@"money"] floatValue]];
//            _cash.text = [NSString stringWithFormat:NSLocalizedString(@"￥%.2f", nil),[json[@"data"][@"tixian"] floatValue]];
//            _waitTiXian.text = [NSString stringWithFormat:NSLocalizedString(@"提现待审     ￥%.2f", nil),[json[@"data"][@"total_wait_money"] floatValue]];
//            _totalWaitMoney = json[@"data"][@"total_wait_money"];
//            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_waitTiXian.text];
//            NSRange range = [_waitTiXian.text rangeOfString:NSLocalizedString(@"提现待审", nil)];
//            [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
//            _waitTiXian.attributedText = attribute;
//            [_tableView reloadData];
//        }else{
//            HIDE_HUD
//            [_tableView addSubview:_noNetBackView];
//            [_tableView reloadData];
//        }
//        [_tableView.mj_header endRefreshing];
//    } failure:^(NSError *error) {
//        HIDE_HUD
//        [_tableView.mj_header endRefreshing];
//         [_tableView reloadData];
//        NSLog(@"error%@",error.localizedDescription);
//        [_tableView addSubview:_noNetBackView];
//    }];
//}
//#pragma mark=====申请提现按钮点击事件======
//- (void)clickCashBnt{
//    JHApplyCashVC *applyCash = [[JHApplyCashVC alloc] init];
//    applyCash.applyCashBlock = ^{
//        [self requestData];
//    };
//    [self.navigationController pushViewController:applyCash animated:YES];
//}
//#pragma mark=====创建表视图=======
//- (void)createTableView{
//    if(_tableView == nil){
//        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.showsVerticalScrollIndicator = NO;
//        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
//        view.backgroundColor = BACK_COLOR;
//        _tableView.backgroundView = view;
//        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
//        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
//        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
//        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
//        _tableView.mj_header = _header;
//        [self.view addSubview:_tableView];
//        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200 / 1.36)];
//        _backImg.image = IMAGE(@"no_net");
//    }else{
//        [_tableView reloadData];
//    }
//}
//#pragma mark=====UITableViewDelegate==========
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if(section == 1)
//        return 2;
//    else
//        return 1;
//}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0)
//        return 75;
//    else
//        return 44;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section == 0)
//        if([_totalWaitMoney floatValue] > 0){
//            return 35;
//        }else
//            return 10;
//    else if(section == 1)
//            return 20;
//    else
//        return CGFLOAT_MIN;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return CGFLOAT_MIN;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    if([_totalWaitMoney floatValue] > 0){
//        if(section == 0){
//            UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 35)];
//            view.backgroundColor = BACK_COLOR;
//            [view addSubview:_waitTiXian];
//            return view;
//        }else
//            return nil;
//    }else
//        return nil;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0){
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        [cell.contentView addSubview:_money];
//        [cell.contentView addSubview:_cash];
//        for(int i = 0; i < 2;i ++){
//            UILabel *title = [[UILabel alloc] initWithFrame:FRAME((WIDTH / 2) * i, 15, WIDTH / 2, 15)];
//            title.textColor = HEX(@"333333", 1.0f);
//            title.font = FONT(14);
//            title.textAlignment = NSTextAlignmentCenter;
//            if(i == 0)
//                title.text = NSLocalizedString(@"我的余额", nil);
//            else
//                title.text = NSLocalizedString(@"我的提现", nil);
//            [cell.contentView addSubview:title];
//        }
//        UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(WIDTH / 2 - 0.5, 10, 0.5, 55)];
//        thread.backgroundColor = LINE_COLOR;
//        [cell.contentView addSubview:thread];
//        UILabel *bottomLine = [[UILabel alloc] initWithFrame:FRAME(0, 74.5, WIDTH, 0.5)];
//        bottomLine.backgroundColor = LINE_COLOR;
//        [cell.contentView addSubview:bottomLine];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else if(indexPath.section == 1){
//        switch (indexPath.row) {
//            case 0:
//            {
//                UITableViewCell *cell = [[UITableViewCell alloc] init];
//                UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH / 2, 15)];
//                title.textColor = HEX(@"333333", 1.0f);
//                title.font = FONT(14);
//                title.text = NSLocalizedString(@"收入明细", nil);
//                [cell.contentView addSubview:title];
//                UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 14.5, 7, 12)];
//                dirImg.image = IMAGE(@"arrow_right");
//                [cell.contentView addSubview:dirImg];
//                cell.contentView.backgroundColor = [UIColor whiteColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                for(int i = 0; i < 2; i ++){
//                    UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(0,43.5 * i, WIDTH, 0.5)];
//                    thread.backgroundColor = LINE_COLOR;
//                    [cell.contentView addSubview:thread];
//                }
//                return cell;
//            }
//                break;
//            case 1:
//            {
//                UITableViewCell *cell = [[UITableViewCell alloc] init];
//                UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH / 2, 15)];
//                title.textColor = HEX(@"333333", 1.0f);
//                title.font = FONT(14);
//                title.text = NSLocalizedString(@"提现明细", nil);
//                [cell.contentView addSubview:title];
//                UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 14.5, 7, 12)];
//                dirImg.image = IMAGE(@"arrow_right");
//                [cell.contentView addSubview:dirImg];
//                cell.contentView.backgroundColor = [UIColor whiteColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                UILabel *thread = [[UILabel alloc] initWithFrame:FRAME(0,43.5, WIDTH, 0.5)];
//                thread.backgroundColor = LINE_COLOR;
//                [cell.contentView addSubview:thread];
//                return cell;
//
//            }
//                break;
//            default:
//                break;
//        }
//    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        [cell.contentView addSubview:_cashBnt];
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//
//    }
//    return nil;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 1){
//        switch (indexPath.row) {
//            case 0:
//            {
//                JHIncomeDetailVC *income = [[JHIncomeDetailVC alloc] init];
//                [self.navigationController pushViewController:income animated:YES];
//            }
//                break;
//            case 1:
//            {
//                JHWithdrawalVC *withdraw = [[JHWithdrawalVC alloc] init];
//                [self.navigationController pushViewController:withdraw animated:YES];
//            }
//                break;
//            default:
//
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.web];
    [self add_closeBtn];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    SHOW_HUD
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    HIDE_HUD
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *title =[_web stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self addTitle:title];
    self.closeBtn.hidden = ! [self.web canGoBack];
    
    HIDE_HUD
}

- (UIWebView *)web{
    if (_web == nil) {
        _web = [[UIWebView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT-64)];
        [_web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/staff",KReplace_Url]]]];
        _web.delegate = self;
    }
    return _web;
}

- (void)close{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickBackBtn{
    if ([self.web canGoBack]) {
        [self.web goBack];
    }else{
        [self close];
    }
}
- (void)add_closeBtn{
    _closeBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 20)];
    [_closeBtn setImage:IMAGE(@"closeNew") forState:(UIControlStateNormal)];
    [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:_closeBtn];
    _closeBtn.hidden = YES;
    UIBarButtonItem *leftItem = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItems = @[leftItem,closeItem];
    
}
@end
