//
//  JHSetVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHSetVC.h"
#import "JHSetCellOne.h"
#import "JHSetCellTwo.h"
#import "JHSetCellThree.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "HttpTool.h"
#import "JHShowAlert.h"
#import "JHShareModel.h"
#define UPDATElINK @"itms-apps://itunes.apple.com/cn/app/jiang-hu-wai-mai-pei-song/id1080931079?mt=8"
@interface JHSetVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//指向表视图的
    NSString * str_value;//保存当前的音量的
    MPVolumeView *_mpVolumeView;//调节音量
    UIView * view;
    UILabel * label_state;
    BOOL isSwitch;
    BOOL isYes;
}
@end
@implementation JHSetVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_interactivePopDisabled = YES;
    //设置当前视图的标题
    [self addTitle:NSLocalizedString(@"设置", nil)];
    //创建表视图
    [self creatUITableView];
}
#pragma mark - 创建表
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.backgroundColor = BACK_COLOR;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(showRegsterID)];
    tap.numberOfTapsRequired = 10;
    [myTableView addGestureRecognizer:tap];
    [self.view addSubview:myTableView];
//    [myTableView registerClass:[JHSetCellOne class] forCellReuseIdentifier:@"cell1"];
//    [myTableView registerClass:[JHSetCellTwo class] forCellReuseIdentifier:@"cell2"];
//    [myTableView registerClass:[JHSetCellThree class] forCellReuseIdentifier:@"cell3"];
}
#pragma mark *******这是表格的代理和数据源方法**********
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 54;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (view == nil) {
        view = [[UIView alloc]init];
        view.frame = FRAME(10, 0, WIDTH, 54);
        view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        UIView * last_view = [UIView new];
        last_view.frame = FRAME(0, 10, WIDTH, 44);
        last_view.backgroundColor = [UIColor whiteColor];
        [view addSubview:last_view];
        label_state = [UILabel new];
        label_state.frame = FRAME(10, 10, 200, 20);
        label_state.font = [UIFont systemFontOfSize:14];
        label_state.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [last_view addSubview:label_state];
        if ([[JHShareModel shareModel].status isEqualToString:@"1"]) {
            label_state.text  = [NSString stringWithFormat:@"  %@     %@",NSLocalizedString(@"工作状态", nil),NSLocalizedString(@"上班", nil)];
        }else{
            label_state.text  =  [NSString stringWithFormat:@"  %@     %@",NSLocalizedString(@"工作状态", nil),NSLocalizedString(@"休息", nil)];
        }
        NSRange range = [label_state.text rangeOfString:NSLocalizedString(@"工作状态", nil)];
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:label_state.text];
        [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]} range:range];
        label_state.attributedText = attributed;
        UISwitch * switch_state = [[UISwitch alloc]init];
        switch_state.frame = FRAME(WIDTH - 60, 7, 60, 20);
        switch_state.onTintColor = THEME_COLOR;
        if ([[JHShareModel shareModel].status isEqualToString:@"1"]) {
            switch_state.on = YES;
        }else{
            switch_state.on = NO;
        }
        [switch_state addTarget:self action:@selector(setStatus:) forControlEvents:UIControlEventValueChanged];
        [last_view addSubview:switch_state];
//        UIView * new_view = [[UIView alloc]init];
//        new_view.frame = FRAME(0, 64, WIDTH, 44);
//        new_view.backgroundColor = [UIColor whiteColor];
//        [view addSubview:new_view];
//        UILabel * label = [[UILabel alloc]init];
//        label.frame = FRAME(10, 10, 200, 20);
//        label.text = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"开启语音播报", nil)];
//        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
//        label.font = [UIFont systemFontOfSize:14];
//        [new_view addSubview:label];
//        UISwitch * _switch = [[UISwitch alloc]init];
//        _switch.frame = FRAME(WIDTH - 60, 7, 60, 20);
//        _switch.onTintColor = THEME_COLOR;
//        NSLog(@"%@",[JHShareModel shareModel].mobile);
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"VoicePlay"]) {
//            _switch.on = YES;
//        }
//        else {
//            _switch.on = NO;
//        }
//        [_switch addTarget:self action:@selector(setPlayVoice:) forControlEvents:UIControlEventValueChanged];
//        [new_view addSubview:_switch];
    }
    return view;
}
#pragma mark - 这是是否播放语音的方法
-(void)setPlayVoice:(UISwitch *)sender{
    NSLog(@"%d",sender.on);
    if (sender.on) {
        isYes = NO;
    }else{
        isYes = YES;
    }
    [[NSUserDefaults standardUserDefaults] setBool:isYes forKey:@"VoicePlay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0 || indexPath.row == 4 || indexPath.row == 8) {
//        return 10;
//    }else if (indexPath.row == 6){
//        return 25;
//    }else if(indexPath.row == 2){
//        return 50;
//    }else if (indexPath.row == 10){
//        return 100;
//    }else if (indexPath.row == 7){
//        return 50;
//    }else if(indexPath.row == 9){
//        return 0;
//    }
//    else{
//        return 44;
//    }
    if (indexPath.row == 0 || indexPath.row == 4) {
        return 10;
    }else if (indexPath.row == 4){
        return 25;
    }else if(indexPath.row == 2){
        return 50;
    }else if (indexPath.row == 11){
        return 100;
    }else if (indexPath.row == 10 ||  indexPath.row == 8 || indexPath.row == 9 ){
        return 0;
    }else{
        return 44;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titieL = [[UILabel alloc] initWithFrame:FRAME(15, 0, 70, 44)];
        titieL.font = FONT(14);
        titieL.text = NSLocalizedString(@"关于我们", nil);
        titieL.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [cell addSubview:titieL];
        
        UILabel *detailL = [[UILabel alloc] initWithFrame:FRAME(WIDTH-150, 0, 140, 44)];
        NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
        NSString *version = dic[@"CFBundleShortVersionString"];
        detailL.text = version;
        detailL.font = FONT(14);
        detailL.textAlignment = NSTextAlignmentRight;
        detailL.textColor = [UIColor colorWithWhite:0.75 alpha:1];
        [cell addSubview:detailL];
        
        return cell;
    }
    if (indexPath.row % 2 == 0 && indexPath.row < 10) {
        static NSString * str1 = @"cell1";
        JHSetCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[JHSetCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str1];
        }
        cell.indexPath = indexPath;
        return cell;
    }else if (indexPath.row % 2 == 1 && indexPath.row <= 10){
        static NSString * str2 = @"cell2";
        JHSetCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[JHSetCellTwo alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str2];

        }
        cell.indexPath = indexPath;
        [cell.mySwitch addTarget:self action:@selector(isOn:) forControlEvents:UIControlEventValueChanged];
        //[cell.mySlider addTarget:self action:@selector(isChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else{
        static NSString * str3 = @"cell3";
        JHSetCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell = [[JHSetCellThree alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str3];
        }
        cell.indexPath = indexPath;
        [cell.myBtn addTarget:self action:@selector(clickToLogOut:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 9) {
//        //点击跳出提醒是否去升级
//        //[self creatUIAlertControlWithTitle:NSLocalizedString(@"立即更新", nil) withActionOne:NSLocalizedString(@"取消", nil) withActionTwo:NSLocalizedString(@"确定", nil)];
//    }else if(indexPath.row == 5){
//        NSLog(@"点击了语音提示音");
//    }
}
#pragma mark - 这是点击退出登录的方法
-(void)clickToLogOut:(UIButton *)sender{
    NSLog(@"这是点击退出的方法");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [HttpTool postWithAPI:@"staff/entry/loginout"
               withParams:@{}
                  success:^(id json) {} failure:^(NSError *error) {}];
    [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
}
#pragma mark - 这是设置工作状态的
-(void)setStatus:(UISwitch *)sender{
    NSString * str;
    if (sender.on) {
        str = @"1";
        }else{
        str = @"0";
    }
    [HttpTool postWithAPI:@"staff/account/set_status" withParams:@{@"status":str} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([str isEqualToString:@"1"]) {
                label_state.text  = [NSString stringWithFormat:@"  %@     %@",NSLocalizedString(@"工作状态", nil),NSLocalizedString(@"上班", nil)];
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"开启成功", nil) withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
            }else{
                label_state.text  =  [NSString stringWithFormat:@"  %@     %@",NSLocalizedString(@"工作状态", nil),NSLocalizedString(@"休息", nil)];
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"关闭成功", nil) withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
            }
            NSRange range = [label_state.text rangeOfString:NSLocalizedString(@"工作状态", nil)];
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:label_state.text];
            [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]} range:range];
            label_state.attributedText = attributed;
            [JHShareModel shareModel].status = str;
        }else{
            
            [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"message"] withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
        [ JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"服务器繁忙", nil) withBtn_cancel:nil withBtn_true:NSLocalizedString(@"知道了", nil) withVC:self];
    }];

}
#pragma mark - 这是是否开启震动的方法
-(void)isOn:(UISwitch *)sender{
    if (sender.on) {
        NSLog(@"开启震动");
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
         NSLog(@"关闭震动");
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - 展示regsterID
- (void)showRegsterID
{
    NSString *regID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    CopyString(regID?regID:@"")
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:@"RegsterID"
                                                                                  message:regID
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了(已复制到剪贴板)", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}
//#pragma mark - 这是音量改变调用的方法
//-(void)isChange:(UISlider *)sender{
//    NSLog(@"%.2f",sender.value);
//    JHSetCellTwo * cell = [myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
//    str_value = [NSString stringWithFormat:@"%d",(int)sender.value];
//    cell.label_value.text = str_value;
//    cell.label_value.frame = FRAME(25+(WIDTH - 70)*(float)sender.value / 100, 2, 25, 12);
//    //将数值存入沙盒中
//    [[NSUserDefaults standardUserDefaults] setObject:str_value forKey:@"value"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
#pragma mark - 这是弹出的提醒框
-(void)creatUIAlertControlWithTitle:(NSString *)title withActionOne:(NSString *)strOne withActionTwo:(NSString *)strTwo{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:strOne style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertControl addAction:[UIAlertAction actionWithTitle:strTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UPDATElINK]];
    }]];
    [self presentViewController:alertControl animated:YES completion:nil];
}
@end
