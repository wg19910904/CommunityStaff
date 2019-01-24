//
//  JHPaiotuiOtherMapVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHPaotuiOtherMapVC.h"
#import "HttpTool.h"
#import "JHOrderReplyVC.h"
#import "CancelOrderMenBan.h"
#import "JHMainVC.h"
@interface JHPaotuiOtherMapVC ()
{
    XHMapView *_mapView;
    UIView *_bottomView;//底部白色视图
    UIButton *_statusButton;//订单状态按钮
    UILabel *_money;//跑腿费
    UIButton *_barBnt;//导航栏不接单或者取消订单按钮
    MAPointAnnotation *_selfLoaction;//自己
    MAPointAnnotation *_customerLocation;//客户
}
@end

@implementation JHPaotuiOtherMapVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"查看线路", nil)];
    [self createBottomView];
    [self initMap];
    [self createBarButton];
}
#pragma mark=====创建底部查看线路按钮,状态按钮的白色视图=====
- (void)createBottomView{
    _bottomView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT - 44 - 64 , WIDTH, 44)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    _money = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH / 3, 44)];
    _money.font = FONT(14);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.textAlignment = NSTextAlignmentCenter;
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"跑腿费:￥%@", nil),self.paoTuiAmount];
    NSRange range = [ _money.text rangeOfString:NSLocalizedString(@"跑腿费:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString: _money.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    _money.attributedText = attributed;
    [_bottomView addSubview:_money];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 , 0, WIDTH / 3 * 2, 44);
    _statusButton.titleLabel.font = FONT(14);
    [_statusButton addTarget:self action:@selector(clickStatusButton) forControlEvents:UIControlEventTouchUpInside];
    [self handleStatusButton];
    [_bottomView addSubview:_statusButton];
    for(int i = 0; i < 2; i ++){
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5 * i, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [_bottomView addSubview:thread];
    }
    UIView *bottomLine = [[UIView alloc] initWithFrame:FRAME(WIDTH / 3, 0, 0.5, 44)];
    bottomLine.backgroundColor = LINE_COLOR;
    [_bottomView addSubview:bottomLine];
}
#pragma mark======订单状态按钮点击事件=======
- (void)clickStatusButton{
    NSDictionary *dic = @{@"order_id":self.order_id};
    NSString *api = nil;
    NSString *alert = nil;
    if([self.order_status isEqualToString:@"0"] && [self.staff_id isEqualToString:@"0"]){
        api = @"staff/paotui/order/qiang";
        alert = NSLocalizedString(@"接单", nil);
        [self requestWitApi:api dic:dic alert:alert];
    }else if([self.order_status isEqualToString:@"1"] || [self.order_status isEqualToString:@"2"]){
        if ([self.type isEqualToString:@"seat"]){
            alert = NSLocalizedString(@"开始占座", nil);
        }else if([self.type isEqualToString:@"paidui"]){
            alert = NSLocalizedString(@"开始排队", nil);
        }else if([self.type isEqualToString:@"chongwu"]){
            alert = NSLocalizedString(@"开始照顾", nil);
        }else{
            alert = NSLocalizedString(@"开始服务", nil);
        }
        api = @"staff/paotui/order/startwork";
        [self requestWitApi:api dic:dic alert:alert];
    }else if ([self.order_status isEqualToString:@"3"]){
        if ([self.type isEqualToString:@"seat"]){
            alert = NSLocalizedString(@"占座结束", nil);
        }else if([self.type isEqualToString:@"paidui"]){
            alert = NSLocalizedString(@"排队结束", nil);
        }else if([self.type isEqualToString:@"chongwu"]){
            alert = NSLocalizedString(@"照顾结束", nil);
        }else{
            alert = NSLocalizedString(@"完成服务", nil);
        }
        api = @"staff/paotui/order/finshed";
        [self requestWitApi:api dic:dic alert:alert];
    }else if([self.order_status isEqualToString:@"8"] && ![self.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([self.comment_info[@"reply_time"] isEqualToString:@"0"]){
            JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
            reply.comment_id = self.comment_info[@"comment_id"];
            reply.isMap = YES;
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
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paotuiOtherMapStautusButton" object:nil];
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
#pragma mark======创建不接单或者取消订单=====
- (void)createBarButton{
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
    if([self.order_status isEqualToString:@"1"] || [self.order_status isEqualToString:@"2"] || [self.order_status isEqualToString:@"3"]){
    }else{
        [_barBnt removeFromSuperview];
        _barBnt = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark======取消订单按钮点击事件========
- (void)clickBarButton{
    dispatch_async(dispatch_get_main_queue(), ^{
        [CancelOrderMenBan createCanCelOrderMenBanWithOrderId:self.order_id from:@"paotui" viewControllwer:self success:^{
            for(JHBaseVC *vc in self.navigationController.viewControllers){
                if([vc isKindOfClass:[JHMainVC class]]){
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        }];
    });
}
#pragma mark=====处理订单状态按钮点击事件======
- (void)handleStatusButton{
    NSString *str = nil;
    if([self.order_status isEqualToString:@"0"] ){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([self.order_status isEqualToString:@"1"]  ||  [self.order_status isEqualToString:@"2"]){
        if ([self.type isEqualToString:@"seat"]){
            str = NSLocalizedString(@"开始占座", nil);
        }else if([self.type isEqualToString:@"paidui"]){
            str = NSLocalizedString(@"开始排队", nil);
        }else if([self.type isEqualToString:@"chongwu"]){
            str = NSLocalizedString(@"开始照顾", nil);
        }else{
            str = NSLocalizedString(@"开始服务", nil);
        }
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateSelected];
        [_statusButton setTitle:str forState:UIControlStateHighlighted];
    }else if([self.order_status isEqualToString:@"3"]){
        if ([self.type isEqualToString:@"seat"]){
            str = NSLocalizedString(@"占座结束", nil);
        }else if([self.type isEqualToString:@"paidui"]){
            str = NSLocalizedString(@"排队结束", nil);
        }else if([self.type isEqualToString:@"chongwu"]){
            str = NSLocalizedString(@"照顾结束", nil);
        }else{
            str = NSLocalizedString(@"完成服务", nil);
        }
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateSelected];
        [_statusButton setTitle:str forState:UIControlStateHighlighted];
    }else if ([self.order_status isEqualToString:@"8"] && [self.comment_info[@"comment_id"] isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateHighlighted];
    }else if([self.order_status isEqualToString:@"8"] && ![self.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([self.comment_info[@"reply_time"] isEqualToString:@"0"]){
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
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:_order_status_label forState:UIControlStateNormal];
        [_statusButton setTitle:_order_status_label forState:UIControlStateSelected];
        [_statusButton setTitle:_order_status_label forState:UIControlStateHighlighted];
    }
}
#pragma mark=====初始化地图======
- (void)initMap{
    _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT  - 44 )];
    [self.view addSubview:_mapView];
    //添加大头针
    XHMapKitManager *manager = [XHMapKitManager shareManager];
    [_mapView addAnnotation:CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue])
                      title:@""
                     imgStr:@"destination"
                   selected:NO];
    [_mapView addAnnotation:CLLocationCoordinate2DMake(manager.lat, manager.lng)
                      title:@""
                     imgStr:@""
                   selected:NO];
    //路径规划
    [_mapView createRouteSearchWithDestination_lat:[self.lat floatValue]
                                   destination_lng:[self.lng floatValue]];
    

}

@end
