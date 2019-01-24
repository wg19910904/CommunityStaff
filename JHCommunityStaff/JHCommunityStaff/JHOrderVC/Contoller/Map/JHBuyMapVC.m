//
//  JHBuyMapVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBuyMapVC.h"
#import "HttpTool.h"
#import "JHMainVC.h"
#import "JHOrderReplyVC.h"
#import "CancelOrderMenBan.h"
#import "PaoTuiSetMoneyMenBan.h"
@interface JHBuyMapVC ()
{
    XHMapView *_mapView;
    UIView *_bottomView;//底部白色视图
    UIButton *_statusButton;//订单状态按钮
    UILabel *_money;//跑腿费
    UIButton *_barBnt;//导航栏不接单或者取消订单按钮
}

@end

@implementation JHBuyMapVC
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
    [self handleOrderStatusButton];
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
#pragma mark=====订单状态按钮点击事件====
- (void)clickStatusButton{
    NSDictionary *dic = @{@"order_id":self.order_id};
    NSString *api = nil;
    NSString *alert = nil;
    if([self.order_status isEqualToString:@"0"] && [self.staff_id isEqualToString:@"0"]){
        api = @"staff/paotui/order/qiang";
        alert = NSLocalizedString(@"接单", nil);
        [self requestWitApi:api dic:dic alert:alert];
    }else if([self.order_status isEqualToString:@"1"] || [self.order_status isEqualToString:@"2"]){
        alert = NSLocalizedString(@"已购买", nil);
        api = @"staff/paotui/order/startwork";
        [self requestWitApi:api dic:dic alert:alert];
    }else if ([self.order_status isEqualToString:@"3"]){
        alert = NSLocalizedString(@"已送达", nil);
        api = @"staff/paotui/order/finshed";
        [self requestWitApi:api dic:dic alert:alert];
    }else if ([self.order_status isEqualToString:@"4"]){
        [PaoTuiSetMoneyMenBan creatSetMoneyMenBanWithOrderId:self.order_id viewController:self success:^{
            [self.navigationController popViewControllerAnimated:YES];
        } cancel:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if([self.order_status isEqualToString:@"8"] && ![self.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([self.comment_info[@"reply_time"] isEqualToString:@"0"]){
            JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
            reply.comment_id = self.comment_info[@"comment_id"];
            reply.isMap = YES;
            [self.navigationController pushViewController:reply animated:YES];
        }
    }
}
#pragma mark=====处理订单状态按钮=========
- (void)handleOrderStatusButton{
    if([self.order_status isEqualToString:@"0"] && [self.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([self.order_status isEqualToString:@"1"] || [self.order_status isEqualToString:@"2"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已购买", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已购买", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已购买", nil) forState:UIControlStateHighlighted];
    }else if ([self.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateHighlighted];
    }else if ([self.order_status isEqualToString:@"4"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateHighlighted];
        
    }else if ([self.order_status isEqualToString:@"5"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateHighlighted];
    }
    else if ([self.order_status isEqualToString:@"8"] && [self.comment_info[@"comment_id"] isEqualToString:@"0"]){
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
    }
}
#pragma mark=====订单状态按钮网络请求=====
- (void)requestWitApi:(NSString *)api dic:(NSDictionary *)dic alert:(NSString *)alert{
    SHOW_HUD
    [HttpTool postWithAPI:api withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            if([self.order_status isEqualToString:@"3"]){
                [PaoTuiSetMoneyMenBan creatSetMoneyMenBanWithOrderId:self.order_id viewController:self success:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } cancel:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"buyMapStatusButton" object:nil];
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
#pragma mark=====初始化地图======
- (void)initMap{
    _mapView = [[XHMapView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT  - 44 )];
    [self.view addSubview:_mapView];
    //添加大头针
    [_mapView addAnnotation:CLLocationCoordinate2DMake([self.o_lat floatValue], [self.o_lng floatValue])
                      title:@""
                     imgStr:@"shop"
                   selected:NO];
    [_mapView addAnnotation:CLLocationCoordinate2DMake([self.lat floatValue], [self.lng floatValue])
                      title:@""
                     imgStr:@"destination"
                   selected:NO];
    
//        [_mapView addAnnotation:CLLocationCoordinate2DMake(manager.lat, manager.lng)
//                          title:@""
//                         imgStr:@"runner"
//                       selected:NO];
    //路径规划
    if (self.o_addr.length == 0) {
        
        [_mapView createRouteSearchWithDestination_lat:[self.lat floatValue]
                                       destination_lng:[self.lng floatValue]];
        
    }else{
        
        [_mapView createRouteSearchWithPassingPoint_lat:[self.o_lat floatValue]
                                       passingPoint_lng:[self.o_lng floatValue]
                                        destination_lat:[self.lat floatValue]
                                        destination_lng:[self.lng floatValue]];
    }
        

    
}

@end
