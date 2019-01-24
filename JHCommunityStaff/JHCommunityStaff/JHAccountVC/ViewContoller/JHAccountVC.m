//
//  JHAccountVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHAccountVC.h"
#import "JHBasicVC.h"
#import "JHChangePasswordVC.h"
#import "JHSkiilsVC.h"
#import "JHBankVC.h"
#import "JHVerifyVC.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "InfoModel.h"
#import "JHIndividualVC.h"
#import "JHAccountCellTwo.h"
#import "JHAccountCellOne.h"
@interface JHAccountVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    MJRefreshNormalHeader *_header;//下拉刷新
    InfoModel *_infoModel;//资料管理数据模型
    UIView *_noNetBackView;//无网络等情况的背景图
    
}
@end

@implementation JHAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"资料管理", nil)];
    _infoModel = [[InfoModel alloc] init];
    [self addNotification];
    [self requestData];
}
#pragma mark===相关通知======
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeMobile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"setVerify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"setBank" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeSkill" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"verify" object:nil];
}
#pragma mark=======创建表视图======
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0,0, WIDTH, HEIGHT - 64)];
        _noNetBackView.backgroundColor = BACK_COLOR;
        [_tableView addSubview:_noNetBackView];
        UIImageView *img = [UIImageView new];
        img.frame = FRAME((WIDTH - 200) / 2, 100, 200, 200/1.36);
        img.image = IMAGE(@"no_net");
        [_noNetBackView addSubview:img];
        [self.view addSubview:_tableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
    }else{
        [_tableView reloadData];
    }
}
#pragma mark=======请求数据======
- (void)requestData{
    SHOW_HUD
    [HttpTool postWithAPI:@"staff/account/index" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
            [self createTableView];
            [_noNetBackView removeFromSuperview];
            HIDE_HUD
        }else{
            HIDE_HUD
            [self createTableView];
            [_tableView addSubview:_noNetBackView];
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [self createTableView];
        [_tableView addSubview:_noNetBackView];
        [_tableView.mj_header endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
    }];
}

#pragma mark====UITableViewDelegate======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if(_infoModel.from.length == 0 && _infoModel.from == nil)
        return 0;
    else{
        if([_infoModel.from  isEqualToString:@"paotui"])
            return 6;
        else
            return 7;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 70;
    else
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if([_infoModel.from  isEqualToString:@"paotui"]){
        if(section == 5)
            return CGFLOAT_MIN;
        else
            return 10;
    }else{
        if(section == 6)
            return CGFLOAT_MIN;
        else
            return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identifier = @"accountOneCell";
        JHAccountCellOne *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[JHAccountCellOne alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setInfoModel:_infoModel];
        return cell;
    }else{
        static NSString *identifier = @"accountTwoCell";
        JHAccountCellTwo *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[JHAccountCellTwo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setInfoModel:_infoModel indexPath:indexPath];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        JHBasicVC *basic = [[JHBasicVC alloc] init];
        basic.verify = _infoModel.verify[@"verify"];
        basic.face = _infoModel.face;
        basic.userName = _infoModel.name;
        basic.mobile = _infoModel.mobile;
        [self.navigationController pushViewController:basic animated:YES];
    }else if(indexPath.section == 1){
        [self selectSex];
    }else if(indexPath.section == 2){
        JHVerifyVC *verify = [[JHVerifyVC alloc] init];
        verify.userName = _infoModel.verify[@"id_name"];
        verify.userId = _infoModel.verify[@"id_number"];
        verify.img = _infoModel.verify[@"id_photo"];
        verify.verifyStatus = _infoModel.verify[@"verify"];
        verify.reason = _infoModel.verify[@"reason"];
        [self.navigationController pushViewController:verify animated:YES];
        
    }else if(indexPath.section  == 3){
        JHBankVC *bank = [[JHBankVC alloc] init];
        bank.accountTitle = _infoModel.account_info[@"account_title"];
        bank.accountName = _infoModel.account_info[@"account_name"];
        bank.accountValue = _infoModel.account_info[@"account_value"];
        bank.accountNumber = _infoModel.account_info[@"account_number"];
        bank.status = [_infoModel.is_account isEqualToString:@"1"]? YES : NO;
        [self.navigationController pushViewController:bank animated:YES];
        
    }else if(indexPath.section == 4){
        if([_infoModel.from isEqualToString:@"paotui"]){
            JHChangePasswordVC *password = [[JHChangePasswordVC alloc] init];
            password.phone = _infoModel.mobile;
            [self.navigationController pushViewController:password animated:YES];
        }else{
            JHSkiilsVC *skill = [[JHSkiilsVC alloc] init];
            if([_infoModel.from isEqualToString:@"weixiu"]){
                skill.barTitle = NSLocalizedString(@"维修技能", nil);
            }else{
                skill.barTitle = NSLocalizedString(@"家政技能", nil);
            }
            [self.navigationController pushViewController:skill animated:YES];
        }
        
    }else if(indexPath.section == 5){
        if ([_infoModel.from isEqualToString:@"paotui"]) {
            JHIndividualVC * vc = [[JHIndividualVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            JHChangePasswordVC *password = [[JHChangePasswordVC alloc] init];
            password.phone = _infoModel.mobile;
            [self.navigationController pushViewController:password animated:YES];
        }
    }else{
        JHIndividualVC * vc = [[JHIndividualVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark======选择性别======
- (void)selectSex{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:0];
    UIAlertAction *man = [UIAlertAction actionWithTitle:NSLocalizedString(@"男", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self uploadSexWithStatus:1];
    }];
    UIAlertAction *woman = [UIAlertAction actionWithTitle:NSLocalizedString(@"女", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self uploadSexWithStatus:2];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:man];
    [alertController addAction:woman];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark=====上传性别====
- (void)uploadSexWithStatus:(NSInteger)status{
    SHOW_HUD
    NSDictionary *dic = @{@"sex":@(status)};
    [HttpTool postWithAPI:@"staff/account/sex" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            JHAccountCellTwo *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            if(status == 1)
                cell.rightTitle.text = NSLocalizedString(@"男", nil);
            else
                cell.rightTitle.text = NSLocalizedString(@"女", nil);
        }else{
            HIDE_HUD
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"更改性别失败,原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeMobile" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setVerify" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setBank" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"verify" object:nil];
}

@end
