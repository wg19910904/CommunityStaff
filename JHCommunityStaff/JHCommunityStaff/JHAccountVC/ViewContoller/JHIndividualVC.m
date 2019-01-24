//
//  JHIndividualVC.m
//  JHCommunityStaff
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHIndividualVC.h"
#import "JHIndiviualCell.h"
#import <IQKeyboardManager.h>
#import "HttpTool.h"
#import "JHShowAlert.h"
@interface JHIndividualVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView * myTableView;
    UITextView * mytextView;
}
@end

@implementation JHIndividualVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].enable = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"个人简介", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    //添加表视图
    [self creatUITableView];
    //请求当前简介
    [self getIntro];
}
#pragma mark ----创建表格-----
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHIndiviualCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 280;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHIndiviualCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.info = NSLocalizedString(@"请输入个人简介", nil);
    cell.textView.delegate = self;
    mytextView = cell.textView;
    [cell.btn addTarget:self action:@selector(clickToSure) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"%@==%@",mytextView.text,textView.text);
    if ([mytextView.text isEqualToString:NSLocalizedString(@"请输入个人简介", nil)]) {
         mytextView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    [self.view endEditing:YES];
    if ([mytextView.text isEqualToString:@""]) {
        mytextView.text = NSLocalizedString(@"请输入个人简介", nil);
    }
}
#pragma mark - 点击提交个人简介的方法
-(void)clickToSure{
    SHOW_HUD
    [self.view endEditing:YES];
    NSLog(@"点击了完成");
    [HttpTool postWithAPI:@"staff/account/update_intro" withParams:@{@"intro":mytextView.text} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self showAlertControlWithMsg:NSLocalizedString(@"提交成功", nil)];
        }else{
            
            [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"message"] withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
        [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"服务器繁忙", nil) withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
    }];
}
- (void)getIntro
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HttpTool postWithAPI:@"staff/account/index" withParams:@{} success:^(id json) {
        
            NSString *intro = json[@"data"][@"intro"];
            if (intro.length > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    mytextView.text = intro;
                });
            }
        }failure:^(NSError *error) {    }];
    });
}
-(void)showAlertControlWithMsg:(NSString *)msg{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:msg preferredStyle:UIAlertControllerStyleAlert];
    
        [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
    [self presentViewController:alertControl animated:YES completion:nil];

}
@end
