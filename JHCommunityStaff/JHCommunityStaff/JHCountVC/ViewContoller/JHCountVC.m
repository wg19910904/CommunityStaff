//
//  JHCountVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHCountVC.h"
#import "JHCountIncomeVC.h"
#import "JHCountOrderVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface JHCountVC ()
{
    UIView *_backView;//订单统计,收入统计按钮的白色背景
    UIButton *_orderBnt;//订单统计按钮
    UIButton *_incomeBnt;//收入统计按钮
    UIButton *_lastBnt;
    JHCountOrderVC *_orderCountVC;//订单统计
    JHCountIncomeVC *_incomeCountVC;//收入统计
}
@end

@implementation JHCountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"统计报表", nil)];
    self.fd_interactivePopDisabled = YES;
    [self createUI];
}
#pragma mark--======搭建UI界面===
- (void)createUI{
    _backView = [[UIView alloc] initWithFrame:FRAME(15, 15, WIDTH - 30, 44)];
    _backView.layer.cornerRadius = 4.0f;
    _backView.layer.borderColor = THEME_COLOR.CGColor;
    _backView.layer.borderWidth = 0.5f;
    _backView.clipsToBounds = YES;
    [self.view addSubview:_backView];
    _orderBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderBnt.titleLabel.font = FONT(14);
    _orderBnt.frame = FRAME(0, 0, (WIDTH - 30) / 2, 44);
    [_orderBnt setTitle:NSLocalizedString(@"订单统计", nil) forState:UIControlStateNormal];
    _orderBnt.layer.cornerRadius = 4.0f;
    _orderBnt.clipsToBounds = YES;
    _orderBnt.selected = YES;
    _orderBnt.tag = 1;
    _lastBnt = _orderBnt;
    [_orderBnt setTitleColor:HEX(@"333333", 1.0f) forState:UIControlStateNormal];
     [_orderBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_orderBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
    [_orderBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
    [_orderBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_orderBnt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_orderBnt];
    _incomeBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _incomeBnt.titleLabel.font = FONT(14);
    _incomeBnt.frame = FRAME((WIDTH - 30) / 2, 0, (WIDTH - 30) / 2, 44);
    [_incomeBnt setTitle:NSLocalizedString(@"收入统计", nil) forState:UIControlStateNormal];
    _incomeBnt.layer.cornerRadius = 4.0f;
    _incomeBnt.clipsToBounds = YES;
    _incomeBnt.tag = 2;
    [_incomeBnt setTitleColor:HEX(@"333333", 1.0f) forState:UIControlStateNormal];
    [_incomeBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_incomeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
    [_incomeBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
    [_incomeBnt setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_incomeBnt addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_incomeBnt];
    _orderCountVC = [[JHCountOrderVC alloc] init];
    _orderCountVC.view.frame = FRAME(0, 44 + 15, WIDTH, HEIGHT - 44 - 64 - 15);
    _incomeCountVC = [[JHCountIncomeVC alloc] init];
    _incomeCountVC.view.frame = FRAME(0, 44 + 15, WIDTH, HEIGHT - 44 - 64 - 15);
    [self.view addSubview:_orderCountVC.view];
}
#pragma mark=====订单统计按钮点击事件=========
- (void)clickButton:(UIButton *)sender{
    if(sender.tag == 1){
        [_incomeCountVC removeFromParentViewController];
        [_incomeCountVC.view removeFromSuperview];
        [self.view addSubview:_orderCountVC.view];
    }else{
        [_orderCountVC removeFromParentViewController];
        [_orderCountVC.view removeFromSuperview];
        [self.view addSubview:_incomeCountVC.view];
    }
    if(_lastBnt != nil){
        _lastBnt.selected = NO;
    }
    sender.selected = YES;
    _lastBnt = sender;
}
@end
