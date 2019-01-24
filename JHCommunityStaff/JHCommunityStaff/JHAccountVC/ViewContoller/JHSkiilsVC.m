//
//  JHSkiilsVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//修改接那个

#import "JHSkiilsVC.h"
#import "HttpTool.h"
#import "SkillBnt.h"
#import "SkillModel.h"
#import "MJRefresh.h"
@interface JHSkiilsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_skillView;//技能背景
    UILabel *_skillLabel;//技能标签
    NSMutableArray *_skillDataArray;//技能数组
    NSMutableArray *_dataArray;//全部技能数据源
    UIButton *_saveBtn;//保存按钮
    UIView *_noNetBackView;
    MJRefreshNormalHeader *_header;
}
@end

@implementation JHSkiilsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _skillDataArray = [[NSMutableArray alloc] init];
    _dataArray = [@[] mutableCopy];
    [self addTitle:self.barTitle];
    [self createTableView];
    [self initSubViews];
    [self requestData];
}
#pragma mark====初始化子控件=====
- (void)initSubViews{
    _skillView = [[UIView alloc] init];
    _skillView.layer.cornerRadius = 4.0f;
    _skillView.clipsToBounds = YES;
    _skillView.backgroundColor = [UIColor whiteColor];
    _skillView.layer.borderColor = LINE_COLOR.CGColor;
    _skillView.layer.borderWidth = 0.5f;
    _skillLabel = [[UILabel alloc] init];
    _skillLabel.font = FONT(14);
    _skillLabel.textColor = HEX(@"333333", 1.0f);
    _skillLabel.text = [NSString stringWithFormat:NSLocalizedString(@"通过单击以下标签选择%@", nil),self.barTitle];
    NSRange range1 = [_skillLabel.text rangeOfString:[NSString stringWithFormat:NSLocalizedString(@"选择%@", nil),self.barTitle]];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_skillLabel.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range1];
    _skillLabel.attributedText = attributed;
    [_skillView addSubview:_skillLabel];
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = FRAME(15, 0, WIDTH - 30, 44);
    _saveBtn.layer.cornerRadius = 4.0f;
    _saveBtn.clipsToBounds = YES;
    [_saveBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn setBackgroundColor:THEME_COLOR forState:UIControlStateNormal];
    _saveBtn.titleLabel.font = FONT(16);
    [_saveBtn addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark=====保存按钮点击事件=========
- (void)clickSaveButton{
    
    if (_skillDataArray.count == 0) {
        
        [self showAlertViewWithTitle:NSLocalizedString(@"当前未选择任何技能,此时提交不会做任何修改", nil)];
        return;
    }
    SHOW_HUD
    NSMutableArray *dataArray = [@[] mutableCopy];//上传服务器的技能数组
    for(int i = 0 ; i < _skillDataArray.count; i ++){
        NSMutableDictionary *dic = [@{} mutableCopy];
        [dic setObject:[_skillDataArray[i] title] forKey:@"cate_title"];
        [dic setObject:[_skillDataArray[i] cate_id] forKey:@"cate_id"];
        [dataArray addObject:dic];
    }
    NSDictionary *dic = @{@"options":dataArray};
    [HttpTool postWithAPI:@"staff/account/techs" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSkill" object:nil];
        }else{
            HIDE_HUD
            [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"更新技能失败.原因:%@", nil),json[@"message"]]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
    
}
#pragma mark======请求技能数据=====
- (void)requestData{
    SHOW_HUD
    [HttpTool postWithAPI:@"staff/account/techs" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [_noNetBackView removeFromSuperview];
            [_skillDataArray removeAllObjects];
            [_dataArray removeAllObjects];
            NSArray *itemArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemArray){
                SkillModel *model = [[SkillModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                if([model.is_selected isEqualToString:@"1"]){
                    [_skillDataArray addObject:model];
                }
                [_dataArray addObject:model];
            }
            _skillView.frame = FRAME(15, 0, WIDTH - 30,  40 + ((_dataArray.count - 1) / 4 + 1) * 40);
            _skillLabel.frame = FRAME(15, 15, _skillView.bounds.size.width - 15, 15);
            [self createTableView];
        }else{
            HIDE_HUD
            [_tableView addSubview:_noNetBackView];
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView addSubview:_noNetBackView];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark====创建表视图=======
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
        [self.view addSubview:_tableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 34, 200, 200/1.36)];
        img.image = IMAGE(@"no_net");
        _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)];
        _noNetBackView.backgroundColor = BACK_COLOR;
        [_noNetBackView addSubview:img];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark======UITableViewDelegate========
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return  40 + ((_dataArray.count - 1) / 4 + 1) * 40;
    }else
        return 44;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 15;
    else
        return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        [cell.contentView addSubview:_skillView];
        [self addSkills];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACK_COLOR;
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell.contentView addSubview:_saveBtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = BACK_COLOR;
        return cell;
    }
    return nil;
    
}
#pragma mark======添加技能=======
- (void)addSkills{
    CGFloat space = (_skillView.bounds.size.width - 60 * 4 - 30) / 3;
    for(int i= 0;i < _dataArray.count; i++){
        SkillBnt *skillBnt = [[SkillBnt alloc] initWithFrame:FRAME(15 + (i % 4) * (space + 60), 40 + (i / 4) * 40, 60, 30)];
        [skillBnt setTitle:[_dataArray[i] title]forState:UIControlStateNormal];
        skillBnt.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        skillBnt.tag = i + 1;
        for(SkillModel *model in _skillDataArray){
            if([model.title isEqualToString:[_dataArray[i] title]]){
                skillBnt.selected = YES;
            }
        }
        [skillBnt setImage:IMAGE(@"sq_close") forState:UIControlStateSelected];
        [skillBnt addTarget:self action:@selector(clickSkillBnt:) forControlEvents:UIControlEventTouchUpInside];
        [_skillView addSubview:skillBnt];
    }
}
- (void)clickSkillBnt:(UIButton *)sender{
    if(sender.selected){
        [_skillDataArray removeObject:_dataArray[sender.tag - 1]];
        sender.selected = NO;
    }else{
        if (_skillDataArray.count >= 10000) {
            [self creatUIAlertView];
        }else{
            [_skillDataArray addObject:_dataArray[sender.tag - 1]];
            sender.selected = YES;
        }
    }
}
-(void)creatUIAlertView{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"最多只能选择8个技能", nil) message:NSLocalizedString(@"知道了", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
