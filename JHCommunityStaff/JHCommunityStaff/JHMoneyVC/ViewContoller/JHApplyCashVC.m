//
//  JHApplyCashVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//申请提现

#import "JHApplyCashVC.h"
#import "JHWithdrawalVC.h"
#import "JHBankVC.h"
#import "JHForgetPasswordVC.h"
#import "HttpTool.h"
#import <IQKeyboardManager.h>
#import "InfoModel.h"
#import "MJRefresh.h"
#import "SecurityCode.h"
@interface JHApplyCashVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *_money;//当前提现金额
    UILabel *_account;//提现账户
    UITextField *_cash;//提现金额
    UITextField *_password;//登录密码
    UIButton *_forgetBnt;//忘记密码按钮
    UIButton *_certainBnt;//确认提现按钮
    UIView *_alertView;//提示余额不足
    UIView *_noNetBackView;//无网络状态下背景
    MJRefreshNormalHeader *_header;
}
@property (nonatomic,copy)NSString *accountName;
@property (nonatomic,copy)NSString *accountNumber;
@property (nonatomic,copy)NSString *accountTitle;
@property (nonatomic,copy)NSString *accountValue;
@property (nonatomic,copy)NSString *accountId;
@end

@implementation JHApplyCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"申请提现", nil)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"setBank" object:nil];
    [self createRightBarButton];
    [self initSubViews];
    [self requestData];
}
#pragma mark=====请求网络数据======
- (void)requestData{
    SHOW_HUD
    [HttpTool postWithAPI:@"staff/money/tixian" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_noNetBackView removeFromSuperview];
            _money.text = json[@"data"][@"accountMoney"];
            _accountName = json[@"data"][@"accountName"];
            _accountNumber = json[@"data"][@"accountNumber"];
            _accountTitle = json[@"data"][@"accountTitle"];
            _accountValue = json[@"data"][@"accountValue"];
            _accountId = json[@"data"][@"accountId"];
            _account.text = [NSString stringWithFormat:NSLocalizedString(@"提现账户  %@(%@ %@)", nil),_accountTitle,_accountName,_accountNumber];
            NSRange range = [_account.text rangeOfString:NSLocalizedString(@"提现账户", nil)];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_account.text];;
            [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
            _account.attributedText = attributed;
            [self createTableView];
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
        [_tableView.mj_header endRefreshing];
        [_tableView addSubview:_noNetBackView];
        NSLog(@"error%@",error.localizedDescription);
       
    }];
}
#pragma mark====创建导航栏右侧提现明细按钮=====
- (void)createRightBarButton{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 65, 20)];
    [rightBtn addTarget:self action:@selector(clickRightBnt)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:NSLocalizedString(@"提现明细", nil) forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(16);
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
 
}
#pragma mark======导航栏右侧提现明细按钮点击事件======
- (void)clickRightBnt{
    JHWithdrawalVC *withdraw = [[JHWithdrawalVC alloc] init];
    [self.navigationController pushViewController:withdraw animated:YES];
}
#pragma mark===初始化子控件=======
- (void)initSubViews{
    _money = [[UILabel alloc] initWithFrame:FRAME(15, 40, WIDTH - 15, 30)];
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.font = FONT(30);
    _account = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, WIDTH - 15 - 22, 15)];
    _account.textColor = HEX(@"333333", 1.0f);
    _account.font = FONT(14);
    _cash = [[UITextField alloc] initWithFrame:FRAME(89, 6, 120, 30)];
    _cash.delegate = self;
    _cash.backgroundColor = HEX(@"f0f0f0", 1.0f);
    _cash.textColor = HEX(@"ff6600", 1.0f);
    _cash.font = FONT(14);
    _cash.keyboardType = UIKeyboardTypeDecimalPad;
    _cash.placeholder = NSLocalizedString(@"提现金额", nil);
    _cash.textAlignment = NSTextAlignmentCenter;
    _password = [[UITextField alloc] initWithFrame:FRAME(89, 6, 120, 30)];
    _password.delegate = self;
    _password.backgroundColor = HEX(@"f0f0f0", 1.0f);
    _password.textColor = HEX(@"ff6600", 1.0f);
    _password.placeholder = NSLocalizedString(@"支付密码", nil);
    _password.font = FONT(14);
    _password.secureTextEntry = YES;
    _password.textAlignment = NSTextAlignmentCenter;
    _certainBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _certainBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _certainBnt.layer.cornerRadius = 4.0f;
    _certainBnt.clipsToBounds = YES;
    [_certainBnt setTitle:NSLocalizedString(@"申请提现", nil) forState:UIControlStateNormal];
    [_certainBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_certainBnt setBackgroundColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
    _certainBnt.titleLabel.font = FONT(16);
    [_certainBnt addTarget:self action:@selector(clickCertainButton) forControlEvents:UIControlEventTouchUpInside];
    _alertView = [[UIView alloc] initWithFrame:FRAME(WIDTH - 84, 14.5, 84, 15)];
    _alertView.backgroundColor = [UIColor whiteColor];
    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(0, 0, 15, 15)];
    img.image = IMAGE(@"zj_tips");
    [_alertView addSubview:img];
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:FRAME(20, 0, 64, 15)];
    alertLabel.font = FONT(12);
    alertLabel.text = NSLocalizedString(@"余额不足", nil);
    alertLabel.textColor = HEX(@"ff3300", 1.0f);
    [_alertView addSubview:alertLabel];
}
#pragma mark======确认提现按钮点击事件==========
- (void)clickCertainButton{
    NSLog(@"提现喽");
    if(_cash.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入申请提现金额", nil)];
    }else if (_password.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入申请提现密码", nil)];
    }else if([_cash.text floatValue] > [_money.text floatValue]){
        [self showAlertViewWithTitle:NSLocalizedString(@"余额不足", nil)];
    }else if (_accountNumber.length == 0){
        [self setAccount];
    }
    else{
        SHOW_HUD
        NSDictionary *dic = @{@"account_title":_accountTitle,@"account_id":_accountId,@"money":_cash.text,@"pswd":_password.text};
        [HttpTool postWithAPI:@"staff/money/sure_tixian" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                float data = [_money.text floatValue] - [_cash.text floatValue];
                _money.text = [NSString stringWithFormat:@"%.2f",data];
                [self.navigationController popViewControllerAnimated:YES];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"tixian" object:nil];
                if(self.applyCashBlock){
                    self.applyCashBlock();
                }
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"申请提现失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
    }
}
#pragma mark======创建表视图=======
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
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        [self.view addSubview:_tableView];
       _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
       _noNetBackView.backgroundColor = BACK_COLOR;
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200 / 1.36)];
        img.image = IMAGE(@"no_net");
        [_noNetBackView addSubview:img];
    }else{
        [_tableView reloadData];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1)
        return 2;
    else
        return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return 85;
    else
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2)
        return 45;
    else if(section == 3)
        return 25;
    else
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 15, WIDTH - 15, 15)];
        title.textColor = HEX(@"999999", 1.0f);
        title.font = FONT(14);
        title.text = NSLocalizedString(@"当前可提现金额", nil);
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:_money];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 84.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [cell.contentView addSubview:thread];
        return cell;
    }else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_account];
                UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 22, 14.5, 7, 12)];
                dirImg.image = IMAGE(@"arrow_right");
                [cell.contentView addSubview:dirImg];
                for(int i = 0; i < 2;i ++){
                    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5 * i, WIDTH, 0.5)];
                    thread.backgroundColor = LINE_COLOR;
                    [cell.contentView addSubview:thread];
                }
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                UILabel *title1 = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 64, 15)];
                title1.font = FONT(14);
                title1.text = NSLocalizedString(@"提现金额", nil);
                title1.textColor = HEX(@"999999", 1.0f);
                [cell.contentView addSubview:title1];
                UILabel *title2 = [[UILabel alloc] initWithFrame:FRAME(130 + 89, 14.5, 20, 15)];
                title2.font = FONT(14);
                title2.text = NSLocalizedString(@"元", nil);
                title2.textColor = HEX(@"999999", 1.0f);
                [cell.contentView addSubview:title2];
                [cell.contentView addSubview:_cash];
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
                return cell;
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *title = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 64, 15)];
        title.font = FONT(14);
        title.text = NSLocalizedString(@"登录密码", nil);
        title.textColor = HEX(@"999999", 1.0f);
        [cell.contentView addSubview:title];
        [cell.contentView addSubview:_password];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for(int i = 0; i < 2;i ++){
            UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5 * i, WIDTH, 0.5)];
            thread.backgroundColor = LINE_COLOR;
            [cell.contentView addSubview:thread];
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:_certainBnt];
        cell.contentView.backgroundColor = BACK_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 2){
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 45)];
        view.backgroundColor = BACK_COLOR;
        UIButton *forgetBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetBnt.frame = FRAME(15, 10, 70, 15);
        forgetBnt.layer.cornerRadius = 4.0f;
        forgetBnt.clipsToBounds = YES;
        forgetBnt.titleLabel.textAlignment = NSTextAlignmentLeft;
        [forgetBnt setTitle:NSLocalizedString(@"忘记密码?", nil) forState:UIControlStateNormal];
        [forgetBnt setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        forgetBnt.titleLabel.font = FONT(14);
        [forgetBnt addTarget:self action:@selector(clickForgetButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:forgetBnt];
        return view;
    }else if(section == 3){
        UILabel *alertLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, WIDTH, 15)];
        alertLabel.font = FONT(12);
        alertLabel.textColor = HEX(@"999999", 1.0f);
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = NSLocalizedString(@"注:每日只可提现一次", nil);
        return alertLabel;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            JHBankVC *bank = [[JHBankVC alloc] init];
            bank.accountTitle = _accountTitle;
            bank.accountName = _accountName;
            bank.accountValue = _accountValue;
            bank.accountNumber = _accountNumber;
            [self.navigationController pushViewController:bank animated:YES];
        }
    }
}
#pragma mark=====忘记密码按钮点击事件======
- (void)clickForgetButton{
    NSLog(@"忘记密码");
    JHForgetPasswordVC *forget = [[JHForgetPasswordVC alloc] init];
    forget.userMobile = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    [self.navigationController pushViewController:forget animated:YES];
}
#pragma mark====UITextFieldDelegate======
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField == _cash){
        if([_cash.text floatValue] > [_money.text floatValue]){
            UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            [cell.contentView addSubview:_alertView];
            
        }else{
            [_alertView removeFromSuperview];
        }
    }
}
#pragma mark======scrollViewDelegate==========
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if(manager.enable){
        
    }else{
        [self.view endEditing: YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setBank" object:nil];
}
- (void)setAccount{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil)  message:NSLocalizedString(@"您还未设置提现账户,暂时无法体现", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *certainAlert = [UIAlertAction actionWithTitle:NSLocalizedString(@"去设置", nil) style:0 handler:^(UIAlertAction * _Nonnull action) {
        JHBankVC *bank = [[JHBankVC alloc] init];
        [self.navigationController pushViewController:bank animated:YES];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:certainAlert];
    [alertController addAction:cancelAlert];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
