//
//  JHBankVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//开户行设置

#import "JHBankVC.h"
#import "BankBnt.h"
#import "HttpTool.h"
#import "BankCell.h"
#import "BankModel.h"
#import <IQKeyboardManager.h>
#import "MJRefresh.h"
@interface JHBankVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;//开户行表视图
    UITextField *_bank;//开户行
    UITextField *_name;//开户人
    UITextField *_account;//账号
    UIButton *_submitBnt;//保存按钮
    UIView *_bankView;//开户行背景
    NSString *_bankValue;//用于传给后台
    UIView *_nameView;//开户人背景
    UIView *_accountView;//账号背景
    UILabel *_bankLabel;//开户行标签
    UILabel *_nameLabel;//开户人标签
    UILabel *_accountLabel;//账号标签
    BankBnt *_bankBtn;//选择开户行的按钮
    NSMutableArray *_dataArray;//开户行数据源
    BOOL _isSelected;//记录_bankBtn的状态
    UIView *_noNetBackView;//无网络背景
    MJRefreshNormalHeader *_header;
}
@property (nonatomic,strong)UITableView *mainTableView;//主视图
@end

@implementation JHBankVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"开户行设置", nil)];
    _dataArray = [@[] mutableCopy];
    [self initSubViews];
    [self.view addSubview:self.mainTableView];
    [self requestBank];
}
#pragma mark=====初始化子控件=======
- (void)initSubViews{
   
    _bankView = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _bankView.layer.cornerRadius = 4.0f;
    _bankView.clipsToBounds = YES;
    _bankView.backgroundColor = [UIColor whiteColor];
    _bankView.layer.borderColor = LINE_COLOR.CGColor;
    _bankView.layer.borderWidth = 0.5f;
    _bankLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 44)];
    _bankLabel.font = FONT(14);
    _bankLabel.text = NSLocalizedString(@"开户行", nil);
    _bankLabel.textAlignment = NSTextAlignmentCenter;
    _bankLabel.textColor = HEX(@"666666", 1.0f);
    [_bankView addSubview:_bankLabel];
    _bank = [[UITextField alloc] initWithFrame:FRAME(60, 0, _bankView.bounds.size.width - 90, 44)];
    _bank.font = FONT(14);
    _bank.textColor = HEX(@"333333", 1.0f);
    _bank.enabled = NO;
    _bank.delegate = self;
    if(_accountTitle.length != 0){
        _bank.text = _accountTitle;
        _bankValue = _accountValue;
    }
    _bank.placeholder = NSLocalizedString(@"请选择开户行", nil);
    _bank.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _bank.leftView.backgroundColor = [UIColor whiteColor];
    _bank.leftViewMode = UITextFieldViewModeAlways;
    [_bankView addSubview:_bank];
    _bankBtn = [[BankBnt alloc] initWithFrame:FRAME(_bankView.bounds.size.width - 29, 0, 28, 44)];
    [_bankBtn setImage:IMAGE(@"zl_arrowdown") forState:UIControlStateNormal];
    [_bankBtn setImage:IMAGE(@"zl_arrowup") forState:UIControlStateSelected];
    [_bankBtn addTarget:self action:@selector(clickBankBnt:) forControlEvents:UIControlEventTouchUpInside];
    _bankBtn.selected = _isSelected;
    _bankBtn.userInteractionEnabled = ! self.status;
    [_bankView addSubview:_bankBtn];
    _nameView = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _nameView.layer.cornerRadius = 4.0f;
    _nameView.clipsToBounds = YES;
    _nameView.backgroundColor = [UIColor whiteColor];
    _nameView.layer.borderColor = LINE_COLOR.CGColor;
    _nameView.layer.borderWidth = 0.5f;
    _nameLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 44)];
    _nameLabel.font = FONT(14);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = HEX(@"666666", 1.0f);
    _nameLabel.text = NSLocalizedString(@"开户人", nil);
    [_nameView addSubview:_nameLabel];
    _name = [[UITextField alloc] initWithFrame:FRAME(60, 0, _bankView.bounds.size.width - 60, 44)];
    _name.font = FONT(14);
    _name.delegate = self;
    if(_accountName.length != 0){
        _name.text = _accountName;
    }
    _name.textColor = HEX(@"333333", 1.0f);
    _name.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _name.leftView.backgroundColor = [UIColor whiteColor];
    _name.leftViewMode = UITextFieldViewModeAlways;
    _name.placeholder = NSLocalizedString(@"请输入开户人姓名", nil);
    _name.userInteractionEnabled = ! self.status;
    [_nameView addSubview:_name];
    _accountView = [[UIView alloc] initWithFrame:FRAME(15, 0, WIDTH - 30, 44)];
    _accountView.layer.cornerRadius = 4.0f;
    _accountView.clipsToBounds = YES;
    _accountView.backgroundColor = [UIColor whiteColor];
    _accountView.layer.borderColor = LINE_COLOR.CGColor;
    _accountView.layer.borderWidth = 0.5f;
    _accountLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 60, 44)];
    _accountLabel.font = FONT(14);
    _accountLabel.textAlignment = NSTextAlignmentCenter;
    _accountLabel.textColor = HEX(@"666666", 1.0f);
    _accountLabel.text = NSLocalizedString(@"账户", nil);
    [_accountView addSubview:_accountLabel];
    _account = [[UITextField alloc] initWithFrame:FRAME(60, 0, _bankView.bounds.size.width - 60, 44)];
    _account.font = FONT(14);
    _account.delegate = self;
    if(_accountTitle.length != 0){
        _account.text = _accountNumber;
    }
    _account.textColor = HEX(@"333333", 1.0f);
    _account.leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 0)];
    _account.leftView.backgroundColor = [UIColor whiteColor];
    _account.leftViewMode = UITextFieldViewModeAlways;
    _account.placeholder = NSLocalizedString(@"请输入开户账号", nil);
    _account.userInteractionEnabled = ! self.status;
    [_accountView addSubview:_account];
    _submitBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _submitBnt.layer.cornerRadius = 4.0f;
    _submitBnt.clipsToBounds = YES;
    [_submitBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
    [_submitBnt setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
    _submitBnt.titleLabel.font = FONT(16);
    if(_status){
        [_submitBnt setBackgroundColor:LINE_COLOR forState:0];
        [_submitBnt setTitle:NSLocalizedString(@"已设置", nil) forState:UIControlStateNormal];
        _submitBnt.enabled = NO;
    }else{
        [_submitBnt setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    }
    [_submitBnt addTarget:self action:@selector(clickSubmitBnt) forControlEvents:UIControlEventTouchUpInside];
    for(int i = 0 ; i < 4; i ++){
        UIView  *thread = [[UIView alloc] initWithFrame:FRAME(59.5, 0, 0.5, 44)];
        thread.backgroundColor = LINE_COLOR;
        if(i == 0){
            [_bankView addSubview:thread];
        }else if(i == 1){
            thread.frame = FRAME(_bankView.bounds.size.width - 30, 0, 0.5, 44);
            [_bankView addSubview:thread];
        }else if(i == 2){
            [_nameView addSubview:thread];
        }else{
            [_accountView addSubview:thread];
        }
    }
}
#pragma mark====获取开户行=====
- (void)requestBank{
    SHOW_HUD
    [HttpTool postWithAPI:@"staff/account/account_set" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            NSArray *data = json[@"data"][@"items"];
            for(NSString *str  in data){
                BankModel *model = [[BankModel alloc] init];
                model.title = str;
                [_dataArray addObject:model];
            }
            [self.mainTableView reloadData];
            [_noNetBackView removeFromSuperview];
        }else{
            HIDE_HUD
            [self.mainTableView reloadData];
            [self showAlertViewWithTitle:NSLocalizedString(@"数据请求失败", nil)];
        }
        [_mainTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [self.mainTableView reloadData];
        [_mainTableView.mj_header endRefreshing];
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark==开户行选择按钮点击事件====
- (void)clickBankBnt:(BankBnt *)sender{
    if(_isSelected){
        sender.selected = NO;
        [_tableView removeFromSuperview];
        _tableView = nil;
    }else{
        sender.selected = YES;
        [self createTableView];
    }
    _isSelected = !_isSelected;
}
#pragma mark============保存按钮点击事件==
- (void)clickSubmitBnt{
    NSLog(@"保存按钮");
    if(_bank.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请选择开户行", nil)];
    }else if (_name.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入开户人姓名", nil)];
    }else if (_account.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入开户账号", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"account_type":_bankValue,@"account_name":_name.text,@"account":_account.text,@"account_title":_bank.text};
        [HttpTool postWithAPI:@"staff/account/account_set" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setBank" object:nil];
            }else{
              HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"保存失败,原因:%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
    }
}


#pragma mark=====创建主表视图========
- (UITableView *)mainTableView{
    if(_mainTableView == nil){
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _mainTableView.bounds.size.width, _mainTableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _mainTableView.backgroundView = view;
        _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
        _noNetBackView.backgroundColor = BACK_COLOR;
        [_mainTableView addSubview:_noNetBackView];
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200/1.36)];
        img.image = IMAGE(@"no_net");
        [_noNetBackView addSubview:img];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestBank)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _mainTableView.mj_header = _header;
        _mainTableView.scrollEnabled = NO;
    }
    return _mainTableView;
}
#pragma mark=====创建选择开户行表视图========
- (void)createTableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(75,59,_bank.bounds.size.width,44 * 5) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.layer.borderWidth = 0.5f;
        _tableView.layer.borderColor = LINE_COLOR.CGColor;
        _tableView.clipsToBounds = YES;
        [_mainTableView addSubview:_tableView];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark=======UITableViewDelegate======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == _mainTableView)
        return 4;
    else
        return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _mainTableView)
        return 1;
    else
       return  _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == _mainTableView){
        if(section == 0)
            return 15;
        else
            return CGFLOAT_MIN;
    }else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(tableView == _mainTableView){
        if(section == 1 || section == 0)
            return 10;
        else if(section == 2)
            return 20;
        else return CGFLOAT_MIN;
    }else
        return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _mainTableView){
        switch (indexPath.section) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_bankView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = BACK_COLOR;
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_nameView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = BACK_COLOR;
                return cell;
            }
                break;
            case 2:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_accountView];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = BACK_COLOR;
                return cell;
                
            }
                break;
            case 3:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                [cell.contentView addSubview:_submitBnt];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentView.backgroundColor = BACK_COLOR;
                return cell;
            }
                break;
            default:
                break;
        }
    }else{
        static NSString *identifier = @"bank";
        BankCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[BankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.bankTitle = [_dataArray[indexPath.row] title];
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _tableView){
        _bank.text = [_dataArray[indexPath.row] title];
        _bankValue = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] title_value]];
        [_tableView removeFromSuperview];
        _tableView = nil;
        _bankBtn.selected = NO;
        _isSelected = NO;
    }else{
        
    }
}
#pragma mark=======UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    [_tableView removeFromSuperview];
    _tableView = nil;
    _bankBtn.selected = NO;
    _isSelected = NO;
    [self.view endEditing:YES];
}
@end
