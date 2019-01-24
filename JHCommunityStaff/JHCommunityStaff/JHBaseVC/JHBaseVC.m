//
//  JHBaseVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/3.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"
#import "DSToast.h"

@interface JHBaseVC ()
{
    DSToast *toast;
}
@end

@implementation JHBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACK_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:IMAGE(@"top_bg") forBarMetrics:UIBarMetricsDefault];
    //创建左边的按纽
    [self createBackBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"\n\n\n\n%@\n\n\n\n",NSStringFromClass([self class]));
   
}

#pragma mark===创建导航栏标题======
- (void)addTitle:(NSString *)title{
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 100, 44)];
    label.text = title;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:18];
    self.navigationItem.titleView=label;
//    self.navigationItem.title = title;
}
#pragma mark - 创建左边按钮
- (void)createBackBtn
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [self.backBtn addTarget:self action:@selector(clickBackBtn)
           forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView: self.backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
#pragma mark=====返回按钮点击事件======
- (void)clickBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark=====提示框方法========
- (void)showAlertViewWithTitle:(NSString *)title{
        UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
        [alertViewController addAction:cancelAction];
        [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 没有数据时展示
- (void)showHaveNoMoreData
{
    if (toast == nil) {
        toast = [[DSToast alloc] initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
        [toast showInView:self.view showType:(DSToastShowTypeCenter) withBlock:^{
            toast = nil;
        }];
    }
    
}
#pragma mark=====打电话提示框方法========
- (void)showMobile:(NSString *)title{
    UIAlertController * alertViewController = [UIAlertController  alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *certainAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"呼叫", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",title]]];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [alertViewController addAction:certainAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
- (void)showAlertWithMsg:(NSString *)msg
           withBtnTitle:(NSString *)title
           withBtnBlock:(void(^)())btnBlock{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", @"JHShowAlert")
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if (btnBlock) {
                                                           btnBlock();
                                                       }
                                                   }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
@end
