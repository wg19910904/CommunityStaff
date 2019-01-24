//
//  JHMessageVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMessageVC.h"
#import "JHMessageCell.h"
#import "NSObject+CGSize.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "MessageModel.h"
@interface JHMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIImageView *_backImg;//无消息时背景视图
    UILabel *_backLabel;//无消息时提示暂无消息
    MJRefreshNormalHeader *_header;//下拉刷新
    MJRefreshAutoNormalFooter *_footer;//上拉加载更多
    NSInteger _page;//分页
    NSMutableArray *_dataArray;//数据源数据组
    
}
@end

@implementation JHMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"消息提示", nil)];
    _dataArray = [@[] mutableCopy];
    [self createTabelView];
    [self loadNewData];
}
#pragma mark=====创建表视图=====
- (void)createTabelView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _tableView.bounds.size.width, _tableView.bounds.size.height)];
        view.backgroundColor = BACK_COLOR;
        _tableView.backgroundView = view;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _tableView.mj_footer = _footer;
        [self.view addSubview:_tableView];
        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200/1.36)];
    }else{
        [_tableView reloadData];
    }

}
#pragma mark=======添加第一页数据======
- (void)loadNewData{
    _page = 1;
    SHOW_HUD
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/mesg/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            [_dataArray removeAllObjects];
            NSArray *data = json[@"data"][@"items"];
            for(NSDictionary * dic in data){
                MessageModel *model = [[MessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self createTabelView];
            _backImg.image = IMAGE(@"no_data");
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
            }else{
                [_backImg removeFromSuperview];
            }
            _tableView.mj_footer.userInteractionEnabled = YES;
        }else{
            HIDE_HUD;
            [_dataArray removeAllObjects];
            [self createTabelView];
            _backImg.image = IMAGE(@"no_net");
            [_tableView addSubview:_backImg];
            _tableView.mj_footer.userInteractionEnabled = NO;
        }
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [_dataArray removeAllObjects];
        [self createTabelView];
        _backImg.image = IMAGE(@"no_net");
        [_tableView addSubview:_backImg];
        _tableView.mj_footer.userInteractionEnabled = NO;

    }];
}
#pragma mark===加载更多数据======
- (void)loadMoreData{
    _page ++;
    SHOW_HUD
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/mesg/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            HIDE_HUD
            NSArray *data = json[@"data"][@"items"];
            if(data.count == 0){
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in data){
                MessageModel *model = [[MessageModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
               [_dataArray addObject:model];
            }
            [self createTabelView];
        }else{
            HIDE_HUD;
            [self showAlertViewWithTitle:NSLocalizedString(@"数据请求失败", nil)];
        }
        
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        NSLog(@"error%@",error.localizedDescription);
    }];

}
#pragma mark========UITableViewDelegate========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%@:%@",[_dataArray[indexPath.section] title],[_dataArray[indexPath.section] content]];
    CGSize size = [self currentSizeWithString:str font:FONT(14) withWidth:30];
    return 60 + size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == _dataArray.count - 1)
        return CGFLOAT_MIN;
    else 
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"message";
    JHMessageCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[JHMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.messageModel = _dataArray[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   //点击单元格代表该消息已读
    MessageModel *model = _dataArray[indexPath.section];
    JHMessageCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if([model.is_read isEqualToString:@"0"]){
        [cell.readImg removeFromSuperview];
        cell.title.textColor = HEX(@"999999", 1.0f);
        [self uploadReadMessageWithMsg:model.msg_id];
    }
}
#pragma mark=======点击未读信息变成已读信息=========
- (void)uploadReadMessageWithMsg:(NSString *)msg_id{
    
    NSDictionary *dic = @{@"msg_id":msg_id};
    [HttpTool postWithAPI:@"staff/mesg/read" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            
        }else{
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
