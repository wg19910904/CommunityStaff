//
//  JHHouseingOrderDetailVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/11.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHHouseingOrderDetailVC.h"

#import "NSObject+CGSize.h"
#import "StarView.h"
#import "JHOrderCommentCell.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "JHHouseOrderDetailModel.h"
#import "JHHouseMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHOrderReplyVC.h"
#import "UIImageView+WebCache.h"
#import "JHOrderCommentCell.h"
#import "OrderCommentFrameModel.h"
#import "CommentModel.h"
#import "MyTapGesture.h"
#import "CancelOrderMenBan.h"
#import "HouseSetMoneyMenBan.h"
#import "HouseSetMoneyMenBan.h"
#import "JHHouseOrderDetailFrameModel.h"
#import "HouseOrderDeatilCell.h"
#import "HouseCustomerMessageCell.h"
#import "HouseImgCell.h"
#import "HouseMoneyCell.h"
@interface JHHouseingOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *_status;//订单状态
    UIButton *_lookBnt;//查看路线
    UIButton *_statusButton;//订单状态按钮
    UIView *_bottomView;//底部白色视图
    UIButton *_barBnt;//不接单或者取消订单
    JHHouseOrderDetailModel *_houseDetailModel;
    JHHouseOrderDetailFrameModel *_houseDetailFrameModel;
    OrderCommentFrameModel *_commentFrameModel;
    MJRefreshNormalHeader *_header;
    UIView *_noNetBackView;//无网络状态下背景
    BOOL _isYes;
    
}

@end

@implementation JHHouseingOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"订单详情", nil)];
    [self addNotification];
    [self initSubViews];
    [self createTableView];
    [self requestData];
    [self createBottomView];
}
#pragma mark-===添加通知======
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"houseMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"houseSetMoney" object:nil];
}
#pragma mark======创建不接单或者取消订单=====
- (void)createBarButtonWithOrderStatus:(NSString *)order_status{
    if([order_status isEqualToString:@"1"] || [order_status isEqualToString:@"2"] || [order_status isEqualToString:@"3"]){
        if(_barBnt ==nil){
            _barBnt = [UIButton buttonWithType:UIButtonTypeCustom];
            [_barBnt setTitle:NSLocalizedString(@"取消订单", nil) forState:UIControlStateNormal];
            _barBnt.frame = FRAME(0, 0, 70, 25);
            _barBnt.layer.cornerRadius = 4.0f;
            _barBnt.layer.borderColor = [UIColor whiteColor].CGColor;
            _barBnt.layer.borderWidth = 0.5;
            _barBnt.titleLabel.font = FONT(16);
            [_barBnt setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            [_barBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
            _barBnt.clipsToBounds = YES;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_barBnt];
            [_barBnt addTarget:self action:@selector(clickBarButton:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        [_barBnt removeFromSuperview];
        _barBnt = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
}
#pragma mark=====BarBnt按钮点击事件=========
- (void)clickBarButton:(UIButton *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CancelOrderMenBan createCanCelOrderMenBanWithOrderId:self.order_id from:@"house" viewControllwer:self success:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    });
}
#pragma mark======初始化子控件========
- (void)initSubViews{
    _status = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 115, 12.5, 100, 15)];
    _status.font = FONT(14);
    _status.textAlignment = NSTextAlignmentRight;
    _status.textColor = HEX(@"ff6600", 1.0f);
}
#pragma mark-=======电话按钮点击事件=========
- (void)clickMobile{
    NSString *title = _houseDetailModel.mobile;
    [self showMobile:title];
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
    [_lookBnt addTarget:self action:@selector(clickLookButton:) forControlEvents:UIControlEventTouchUpInside];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 , 0, WIDTH / 3 * 2, 44);
    _statusButton.titleLabel.font = FONT(14);
    [_statusButton addTarget:self action:@selector(clickStatusButton) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark-======处理订单状态按钮上面的状态=========
- (void)handleStatusButton{
    if([_houseDetailModel.order_status isEqualToString:@"0"] ){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([_houseDetailModel.order_status isEqualToString:@"1"]  ||  [_houseDetailModel.order_status isEqualToString:@"2"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateHighlighted];
    }else if([_houseDetailModel.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateHighlighted];
    }
    else if ([_houseDetailModel.order_status isEqualToString:@"4"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateHighlighted];
        
    }else if ([_houseDetailModel.order_status isEqualToString:@"5"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateHighlighted];
    }
    else if ([_houseDetailModel.order_status isEqualToString:@"8"] && [_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateHighlighted];
    }else if([_houseDetailModel.order_status isEqualToString:@"8"] && ![_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_houseDetailModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
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
    }
}
#pragma mark--=========请求网络数据========
- (void)requestData{
    SHOW_HUD
    NSDictionary *dic = @{@"order_id":self.order_id};
    [HttpTool postWithAPI:@"staff/house/order/detail" withParams:dic success:^(id json) {
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
            _houseDetailFrameModel = [[JHHouseOrderDetailFrameModel alloc] init];
            _houseDetailModel = [[JHHouseOrderDetailModel alloc] init];
            [_houseDetailModel setValuesForKeysWithDictionary:json[@"data"]];
            _houseDetailFrameModel.houseDetailModel = _houseDetailModel;
            _status.text = _houseDetailModel.order_status_label;
            [self createBarButtonWithOrderStatus:json[@"data"][@"order_status"]];
            [self handleStatusButton];
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
        [_tableView.mj_header endRefreshing];
        [_tableView addSubview:_noNetBackView];
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
        else
            return 1;
    }else
        return 0;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if(_houseDetailModel.photos.count == 0)
            return 3;
        else
            return 4;
    }else{
        if(_houseDetailModel.photos.count == 0)
            return 4;
        else
            return 5;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0)
            return 40;
        else
            return _houseDetailFrameModel.orderDetailHeight;
    }
    if(indexPath.section == 1){
        if(indexPath.row == 0)
            return 40;
        else
            return _houseDetailFrameModel.customerMessageHeight;
    }
    if (indexPath.section == 2){
        if(_houseDetailModel.photos.count == 0)
            return _houseDetailFrameModel.moneyHeight;
        else
            return _houseDetailFrameModel.imgHeight;
    }
    if(indexPath.section == 3){
        if(_houseDetailModel.photos.count == 0){
            if([_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"])
                return 0;
            else
                return _commentFrameModel.rowHeight;
        }else{
            return _houseDetailFrameModel.moneyHeight;
            
        }
    }
    if(indexPath.section == 4){
        if(_houseDetailModel.photos.count == 0)
            return 0;
        else{
            if([_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"])
                return 0;
            else
                return _commentFrameModel.rowHeight;
            
        }
        
    }
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
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for(int i = 0; i < 2; i ++){
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5 * i, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
            }
            return cell;
        }else{
            HouseOrderDeatilCell *orderDetailCell = [[HouseOrderDeatilCell alloc] init];
            [orderDetailCell setHouseOrderDetailFrameModel:_houseDetailFrameModel];
            return orderDetailCell;
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 12.5, 100, 15)];
            title.font = FONT(14);
            title.textColor = HEX(@"333333", 1.0f);
            title.text = NSLocalizedString(@"客户信息", nil);
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
            HouseCustomerMessageCell *customerCell =[[HouseCustomerMessageCell alloc] init];
            [customerCell.mobileButton addTarget:self action:@selector(clickMobile) forControlEvents:UIControlEventTouchUpInside];
            [customerCell setHouseOrderDetailFrame:_houseDetailFrameModel];
            return customerCell;
        }
    }else if (indexPath.section == 2){
        if(_houseDetailModel.photos.count == 0){
            if (indexPath.row == 0) {
                HouseMoneyCell *moneyCell = [[HouseMoneyCell alloc] init];
                [moneyCell setHouseOrderDetailFrame:_houseDetailFrameModel];
                return moneyCell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 13, 80, 12)];
                titleLabel.font = FONT(12);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text = NSLocalizedString(@"红包抵扣", nil);
                [cell.contentView addSubview:titleLabel];
                
                UILabel *amountLab = [UILabel new];
                [cell.contentView addSubview:amountLab];
                [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset=-10;
                    make.centerY.offset=0;
                    make.height.offset=20;
                }];
                amountLab.font = FONT(12);
                amountLab.textColor = HEX(@"f85357", 1.0f);
                amountLab.textAlignment = NSTextAlignmentRight;
                if ([_houseDetailModel.hongbao floatValue] == 0) {
                   amountLab.text =  NSLocalizedString(@"未使用红包", NSStringFromClass([self class]));
                }else{
                   amountLab.text = [NSString stringWithFormat:@"-¥%@",_houseDetailModel.hongbao];
                }

                return cell;
            }
        }else{
            HouseImgCell *imgCell = [[HouseImgCell alloc] init];
            [imgCell setHouseOrderDetailFrameModel:_houseDetailFrameModel];
            return imgCell;
        }
    }else if(indexPath.section == 3){
        if(_houseDetailModel.photos.count == 0){
            if([_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@""])
                return nil;
            else{
                JHOrderCommentCell *commentCell = [[JHOrderCommentCell alloc] init];
                [commentCell setFrameModel:_commentFrameModel];
                return commentCell;
            }
            
        }else{
            HouseMoneyCell *moneyCell = [[HouseMoneyCell alloc] init];
            [moneyCell setHouseOrderDetailFrame:_houseDetailFrameModel];
            return moneyCell;
        }
    }else if(indexPath.section == 4){
        if(_houseDetailModel.photos.count == 0)
            return nil;
        else{
            if([_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@""]){
                return nil;
            }else{
                JHOrderCommentCell *commentCell = [[JHOrderCommentCell alloc] init];
                [commentCell setFrameModel:_commentFrameModel];
                return commentCell;
            }
        }
    }
    return nil;
}


#pragma mark=====查看路线按钮点击事件======
- (void)clickLookButton:(UIButton *)sender{
    NSLog(@"查看路线");
    
    JHHouseMapVC *map = [[JHHouseMapVC alloc] init];
    map.order_id = _houseDetailModel.order_id;
    map.order_status = _houseDetailModel.order_status;
    map.comment_info = _houseDetailModel.comment_info;
    map.status_label = _houseDetailModel.order_status_label;
    map.pay_status = _houseDetailModel.pay_status;
    map.danBao = _houseDetailModel.danbao_amount;
    double lat = 0.0;
    double lng = 0.0;
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:[_houseDetailModel.lat doubleValue]
                                                 WithBD_lon:[_houseDetailModel.lng doubleValue]
                                                 WithGD_lat:&lat
                                                 WithGD_lon:&lng];
    map.lat = [NSString stringWithFormat:@"%f",lat];
    map.lng = [NSString stringWithFormat:@"%f",lng];
    [self.navigationController pushViewController:map animated:YES];
}
#pragma mark======订单状态按钮点击事件========
- (void)clickStatusButton{
    NSDictionary *dic = @{@"order_id":self.order_id};
    NSString *api = nil;
    NSString *alertStr = nil;
    if([_houseDetailModel.order_status isEqualToString:@"0"] ){
        api = @"staff/house/order/qiang";
        alertStr = NSLocalizedString(@"接单", nil);
        [self requestWitApi:api dic:dic alert:alertStr];
    }else if([_houseDetailModel.order_status isEqualToString:@"1"]  ||  [_houseDetailModel.order_status isEqualToString:@"2"]){
        api = @"staff/house/order/startwork";
        alertStr = NSLocalizedString(@"开始服务", nil);
        [self requestWitApi:api dic:dic alert:alertStr];
    }else if([_houseDetailModel.order_status isEqualToString:@"3"]){
        api = @"staff/house/order/finshed";
        alertStr = NSLocalizedString(@"完成服务", nil);
        [self requestWitApi:api dic:dic alert:alertStr];
    }else if ([_houseDetailModel.order_status isEqualToString:@"4"]){
        [HouseSetMoneyMenBan creatSetMoneyMenBanWithOrderId:self.order_id viewController:self success:^{
            NSLog(@"家政设定总额成功");
        } cancel:^{
            NSLog(@"取消了");
        }];
    }else if ([_houseDetailModel.order_status isEqualToString:@"5"]){
        
    }else if ([_houseDetailModel.order_status isEqualToString:@"8"] && [_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        
    }else if([_houseDetailModel.order_status isEqualToString:@"8"] && ![_houseDetailModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_houseDetailModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
            JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
            reply.comment_id = _houseDetailModel.comment_info[@"comment_id"];
            reply.isMap = NO;
            [self.navigationController pushViewController:reply animated:YES];
        }else{
            
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
            if([_houseDetailModel.order_status isEqualToString:@"3"]){
                [HouseSetMoneyMenBan creatSetMoneyMenBanWithOrderId:self.order_id viewController:self success:^{
                    NSLog(@"家政设定总额成功");
                } cancel:^{
                    NSLog(@"取消了");
                }];
            }
             [self requestData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"houseDetailStautusButton" object:nil];
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
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OrderReplySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"houseMapStautusButton" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"houseSetMoney" object:nil];
}
@end
