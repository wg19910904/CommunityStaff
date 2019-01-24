//
//  JHWaiMaiOrderDetailVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//外卖订单详情

#import "JHWaiMaiOrderDetailVC.h"
#import "HttpTool.h"
#import "TransformTime.h"
#import "NSObject+CGSize.h"
#import "WaiMaiProductCell.h"
#import "JHOrderCommentCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "WaiMaiProductCell.h"
#import "JHOrderCommentCell.h"
#import "JHOrderReplyVC.h"
#import "WaiMaiOrderDetailCell.h"
#import "WaiMaiCustomerMessageCell.h"
#import "WaiMaiProductCell.h"
#import "PaoTuiOrderDetailFrameModel.h"
#import "PaotuiDetailModel.h"
#import "MJRefresh.h"
#import "CancelOrderMenBan.h"
#import "JHWaiMaiMapVC.h"
#import "OrderCommentFrameModel.h"
#import "GaoDe_Convert_BaiDu.h"
@interface JHWaiMaiOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
{
    UITableView *_tableView;//
    UIButton *_lookBnt;//查看路线
    UIButton *_statusButton;//订单状态按钮
    UILabel *_money;//配送费
    UILabel *_status;
    UIView *_bottomView;//底部白色视图
    UIButton *_barBnt;//不接单或者取消订单
    UILabel *_typeLabel;
    PaoTuiOrderDetailFrameModel *_waimaiFrameModel;
    PaotuiDetailModel *_waimaiDetailModel;
    OrderCommentFrameModel *_commentFrameModel;
    MJRefreshNormalHeader *_header;
    UIView *_noNetBackView;//无网络状态下背景
    BOOL _isYes;
}

@end

@implementation JHWaiMaiOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"订单详情", nil)];
    _waimaiDetailModel = [[PaotuiDetailModel alloc] init];
    _waimaiFrameModel = [[PaoTuiOrderDetailFrameModel alloc] init];
    [self requestData];
    [self addNotification];
    [self initSubViews];
    [self createBarButton];
    [self createBottomView];
    [self createTableView];
}
#pragma mark-===添加通知======
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"waimaiMapOrderStatusButton" object:nil];
}
#pragma mark======创建不接单或者取消订单=====
- (void)createBarButton{
    NSString *staff_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"staff_id"];
    if([_waimaiDetailModel.staff_id isEqualToString:staff_id] && ([_waimaiDetailModel.order_status isEqualToString:@"1"] || [_waimaiDetailModel.order_status isEqualToString:@"2"] || [_waimaiDetailModel.order_status isEqualToString:@"3"])){
        if(_barBnt == nil){
            _barBnt = [UIButton buttonWithType:UIButtonTypeCustom];
            _barBnt.frame = FRAME(0, 0, 70, 25);
            _barBnt.layer.cornerRadius = 4.0f;
            _barBnt.layer.borderColor = [UIColor whiteColor].CGColor;
            _barBnt.layer.borderWidth = 0.5;
            _barBnt.titleLabel.font = FONT(16);
            [_barBnt setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            [_barBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
            _barBnt.clipsToBounds = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_barBnt];
            [_barBnt addTarget:self action:@selector(clickBarButton) forControlEvents:UIControlEventTouchUpInside];
            [_barBnt setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
        }
    }else{
        [_barBnt removeFromSuperview];
        _barBnt = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark======取消订单按钮点击事件========
- (void)clickBarButton{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CancelOrderMenBan createCanCelOrderMenBanWithOrderId:self.order_id from:@"waimai" viewControllwer:self success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    });
}
#pragma mark======初始化子控件========
- (void)initSubViews{
    _typeLabel = [[UILabel alloc] initWithFrame:FRAME(90, 10, 60, 20)];
    _typeLabel.backgroundColor = THEME_COLOR;
    _typeLabel.layer.cornerRadius = 10.0f;
    _typeLabel.clipsToBounds = YES;
    _typeLabel.font = FONT(12);
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.text = NSLocalizedString(@"外卖单", nil);
    _money = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, WIDTH - 30, 15)];
    _money.font = FONT(12);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _status = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 115, 12.5, 100, 15)];
    _status.font = FONT(14);
    _status.textAlignment = NSTextAlignmentRight;
    _status.textColor = HEX(@"ff6600", 1.0f);
}
#pragma mark=====创建底部查看线路按钮,状态按钮的白色视图=====
- (void)createBottomView{
    _bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - 44 - 64, WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    _lookBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _lookBnt.frame = FRAME(0, 0, WIDTH / 3, 44);
    _lookBnt.titleLabel.font = FONT(14);
    [_lookBnt setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateNormal];
    [_lookBnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_lookBnt setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateSelected];
    [_lookBnt setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateHighlighted];
    [_lookBnt addTarget:self action:@selector(clickLookButton) forControlEvents:UIControlEventTouchUpInside];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_statusButton addTarget:self action:@selector(clickStatusButton) forControlEvents:UIControlEventTouchUpInside];
    _statusButton.frame = FRAME(WIDTH / 3 , 0, WIDTH / 3 * 2, 44);
    _statusButton.titleLabel.font = FONT(14);
    [_bottomView addSubview:_statusButton];
    [_bottomView addSubview:_lookBnt];
    for(int i = 0; i < 2; i ++){
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5 * i, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_bottomView addSubview:thread];
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(WIDTH / 3, 0, 0.5, 44)];
    bottomLine.backgroundColor = LINE_COLOR;
    [_bottomView addSubview:bottomLine];
}
#pragma mark=====订单状态按钮点击事件====
- (void)clickStatusButton{
    NSString *api = nil;
    NSString *alert = nil;
    NSDictionary * dic = @{@"order_id":self.order_id};
    if([_waimaiDetailModel.staff_id isEqualToString:@"0"]){
        api = @"staff/waimai/order/qiang";
        alert = NSLocalizedString(@"接单", nil);
        [self requestWitApi:api dic:dic alert:alert];
        
    }else if (([_waimaiDetailModel.order_status isEqualToString:@"1"] || [_waimaiDetailModel.order_status isEqualToString:@"2"]) && ![_waimaiDetailModel.staff_id isEqualToString:@"0"]){
        api = @"staff/waimai/order/pei";
        alert = NSLocalizedString(@"开始配送", nil);
        [self requestWitApi:api dic:dic alert:alert];
        
    }else if ([_waimaiDetailModel.order_status isEqualToString:@"3"]){
        api = @"staff/waimai/order/finshed";
        alert = NSLocalizedString(@"订单送达", nil);
        [self requestWitApi:api dic:dic alert:alert];
        
    }else if([_waimaiDetailModel.order_status isEqualToString:@"8"] && ![_waimaiDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_waimaiDetailModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
            JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
            reply.comment_id = _waimaiDetailModel.comment_info[@"comment_id"];
            reply.isMap = NO;
            [self.navigationController pushViewController:reply animated:YES];
        }
    }
}
#pragma mark=====订单状态按钮网络请求=====
- (void)requestWitApi:(NSString *)api dic:(NSDictionary *)dic alert:(NSString *)alert{
    SHOW_HUD
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"%@成功", nil),alert]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"waimaiOrderStatusButton" object:nil];
            [self requestData];
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
#pragma mark====处理订单状态按钮=====
- (void)handleOrderStatusButton{
    if([_waimaiDetailModel.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if (([_waimaiDetailModel.order_status isEqualToString:@"1"] || [_waimaiDetailModel.order_status isEqualToString:@"2"]) && ![_waimaiDetailModel.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateHighlighted];
    }else if ([_waimaiDetailModel.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateHighlighted];
    }else if([_waimaiDetailModel.order_status isEqualToString:@"8"] && ![_waimaiDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_waimaiDetailModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
            _statusButton.userInteractionEnabled = YES;
            [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateSelected];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateHighlighted];
        }else{
            _statusButton.userInteractionEnabled = NO;
            [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateSelected];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateHighlighted];
        }
    }else{
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitle:_waimaiDetailModel.order_status_label forState:UIControlStateNormal];
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:_waimaiDetailModel.order_status_label forState:UIControlStateNormal];
        [_statusButton setTitle:_waimaiDetailModel.order_status_label forState:UIControlStateSelected];
        [_statusButton setTitle:_waimaiDetailModel.order_status_label forState:UIControlStateHighlighted];
        
    }
}

#pragma mark======请求网络数据========
- (void)requestData{
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"staff/waimai/order/detail" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            _isYes = YES;
            _bottomView.hidden = NO;
            [_noNetBackView removeFromSuperview];
            CommentModel *model = [[CommentModel alloc] init];
            [ model setValuesForKeysWithDictionary:json[@"data"][@"comment_info"]];
            _commentFrameModel = [[OrderCommentFrameModel alloc] init];
            _commentFrameModel.commentModel = model;
            _waimaiFrameModel = [[PaoTuiOrderDetailFrameModel alloc] init];
            _waimaiDetailModel = [[PaotuiDetailModel alloc] init];
            [_waimaiDetailModel setValuesForKeysWithDictionary:json[@"data"]];
            _waimaiFrameModel.paoTuiDetailModel = _waimaiDetailModel;
            _status.text = _waimaiDetailModel.order_status_label;
            _money.text = [NSString stringWithFormat:NSLocalizedString(@"配送费:￥%@", nil),_waimaiDetailModel.pei_amount];
            NSRange moneyRange = [_money.text rangeOfString:NSLocalizedString(@"配送费:", nil)];
            NSMutableAttributedString *moneyAttributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
            [moneyAttributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"666666", 1.0f)} range:moneyRange];
            _money.attributedText = moneyAttributed;
            [self createBarButton];
            [self handleOrderStatusButton];
            [self createTableView];
            
        }else{
            HIDE_HUD
            _isYes = NO;
            _bottomView.hidden = YES;
            [_barBnt removeFromSuperview];
            _barBnt = nil;
            self.navigationItem.rightBarButtonItem = nil;
            [_tableView addSubview:_noNetBackView];
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        _isYes = NO;
        _bottomView.hidden = YES;
        [_barBnt removeFromSuperview];
        _barBnt = nil;
        self.navigationItem.rightBarButtonItem = nil;
        [_tableView addSubview:_noNetBackView];
        [_tableView.mj_header endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
    }];
}
#pragma mark=====创建表视图=======
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 - 44) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        [self.view addSubview:_tableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        [self.view addSubview:_tableView];
        _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
        _noNetBackView.backgroundColor = BACK_COLOR;
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100,200, 200 / 1.36)];
        img.image = IMAGE(@"no_net");
        [_noNetBackView addSubview:img];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark=======UITableViewDelegate===========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isYes){
        if(section ==0 || section == 1)
            return 2;
        else if(section == 2)
            return _waimaiDetailModel.products.count + 1;
        else
            return 1;
    }else
        return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([_waimaiDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"])
        return 4;
    else
        return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0)
            return 40;
        else
            return _waimaiFrameModel.waimaiOrderDetailHeight;
    }else if (indexPath.section == 1){
        if(indexPath.row == 0)
            return 40;
        else
            return _waimaiFrameModel.waimaiCustomerMessageHeight;
    }else if (indexPath.section == 2)
        return 40;
    else if(indexPath.section == 3)
        return 44;
    else if(indexPath.section == 4)
        return _commentFrameModel.rowHeight;
    else
        return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 12.5, 100, 15)];
            title.font = FONT(14);
            title.textColor = HEX(@"333333", 1.0f);
            title.text = NSLocalizedString(@"订单详情", nil);
            [cell.contentView addSubview:title];
            [cell.contentView addSubview:_status];
            [cell.contentView addSubview:_typeLabel];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for(int i = 0; i < 2; i ++){
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5 * i, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
            }
            return cell;
        }else{
            WaiMaiOrderDetailCell *cell  = [[WaiMaiOrderDetailCell alloc]  init];
            [cell setPaotuiOrderDetailFrameModel:_waimaiFrameModel];
            return cell;
        }
    }else if (indexPath.section == 1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 12.5, 100, 15)];
            title.font = FONT(14);
            title.textColor = HEX(@"333333", 1.0f);
            title.text = NSLocalizedString(@"商家&客户信息", nil);
            [cell.contentView addSubview:title];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for(int i = 0; i < 2; i ++){
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5 * i, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
            }
            return cell;
        }else{
            WaiMaiCustomerMessageCell *cell = [[WaiMaiCustomerMessageCell alloc] init];
            [cell setPaotuiOrderDetailFrameModel:_waimaiFrameModel];
            [cell.shopMobile addTarget:self action:@selector(clickShopMobileButton) forControlEvents:UIControlEventTouchUpInside];
            [cell.customerMobile addTarget:self action:@selector(clickCustomerMobileButton) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }else if ( indexPath.section == 2){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 12.5, 100, 15)];
            title.font = FONT(14);
            title.textColor = HEX(@"333333", 1.0f);
            title.text = NSLocalizedString(@"配送信息", nil);
            [cell.contentView addSubview:title];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for(int i = 0; i < 2; i ++){
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5 * i, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
            }
            return cell;
            
        }else{
            WaiMaiProductCell *cell = [[WaiMaiProductCell alloc] init];
            [cell setDataDic:_waimaiDetailModel.products[indexPath.row - 1]];
            return cell;
        }
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:_money];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(int i = 0; i < 2; i ++){
            UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, i * 43.5, WIDTH, 0.5)];
            thread.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:thread];
        }
        return cell;
    }else if(indexPath.section == 4){
        if([_waimaiDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
            return nil;
        }else{
            JHOrderCommentCell *cell = [[JHOrderCommentCell alloc] init];
            [cell setFrameModel:_commentFrameModel];
            return cell;
        }
        
    }
    return nil;
}
#pragma mark======商家电话点击事件=======
- (void)clickShopMobileButton{
    [self showMobile:_waimaiDetailModel.shop[@"phone"]];
}
#pragma mark=======客户电话点击事件=======
- (void)clickCustomerMobileButton{
    [self showMobile:_waimaiDetailModel.mobile];
}
#pragma mark========查看地图按钮点击事件=======
- (void)clickLookButton{
    JHWaiMaiMapVC *map = [[JHWaiMaiMapVC alloc] init];
    double o_lat = 0.00;
    double o_lng = 0.00;
    double lat = 0.00;
    double lng = 0.00;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[_waimaiDetailModel.o_lat doubleValue] WithBD_lon:[_waimaiDetailModel.o_lng doubleValue] WithGD_lat:&o_lat WithGD_lon:&o_lng];
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[_waimaiDetailModel.lat doubleValue] WithBD_lon:[_waimaiDetailModel.lng doubleValue] WithGD_lat:&lat WithGD_lon:&lng];
    map.o_lat = [NSString stringWithFormat:@"%f",o_lat];
    map.o_lng = [NSString stringWithFormat:@"%f",o_lng];
    map.lat = [NSString stringWithFormat:@"%f",lat];
    map.lng = [NSString stringWithFormat:@"%f",lng];
    map.pei_type = _waimaiDetailModel.pei_type;
    map.order_status = _waimaiDetailModel.order_status;
    map.order_status_label = _waimaiDetailModel.order_status_label;
    map.staff_id = _waimaiDetailModel.staff_id;
    map.online_pay = _waimaiDetailModel.online_pay;
    map.pay_status = _waimaiDetailModel.pay_status;
    map.paoTuiAmount = _waimaiDetailModel.pei_amount;
    map.comment_info = _waimaiDetailModel.comment_info;
    map.order_id = _waimaiDetailModel.order_id;
    [self.navigationController pushViewController:map animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"waimaiMapOrderStatusButton" object:nil];
}
@end
