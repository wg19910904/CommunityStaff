//
//  JHVCommentVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//评价管理

#import "JHCommentVC.h"
#import "JHCommentCell.h"
#import "StarView.h"
#import "JHOrderReplyVC.h"
#import "HttpTool.h"
#import "MJRefresh.h"
#import "CommentFrameModel.h"
#import "CommentModel.h"
#import "YFStartView.h"
@interface JHCommentVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_rateBack;//好评率背景视图
    UILabel *_rateLabel;//好评率
    UIImageView *_backImg;//没有评价时背景图片
    UILabel *_backLabel;//没有评价时的标签
    MJRefreshNormalHeader *_header;//下拉刷新
    MJRefreshAutoNormalFooter *_footer;//上拉加载更多
    NSInteger _page;//分页
    NSMutableArray *_dataArray;//数据源
    NSString *_totalPercent;//好评率
    NSString *_totalScore;//总评
    NSString *_count;//共几人评论

}
@property(nonatomic,strong)YFStartView *starView;//可以用来评价的星星
@end

@implementation JHCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"评价管理", nil)];
    _dataArray = [@[] mutableCopy];
    [self initSubViews];
    [self createTableView];
    [self loadNewData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"OrderReplySuccess" object:nil];
}
#pragma mark=====加载第一页数据=========
- (void)loadNewData{
    SHOW_HUD
    _page = 1;
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/comment/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
             HIDE_HUD
            _totalPercent = json[@"data"][@"total_precent"];
            _totalScore = json[@"data"][@"total_score"];
            _count = json[@"data"][@"count"];
            _rateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"好评率:%.0f%@", nil),[_totalPercent floatValue] *100,@"%"];
            NSRange range = [_rateLabel.text rangeOfString:NSLocalizedString(@"好评率:", nil)];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_rateLabel.text];
            [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
             _rateLabel.attributedText = attributed;
             _starView.currentStarScore = [_totalScore floatValue];
             [_dataArray removeAllObjects];
            NSArray *itemArray = json[@"data"][@"items"];
            for(NSDictionary *dic in itemArray){
                CommentModel *model = [[CommentModel alloc] init];
                CommentFrameModel *frameModel = [[CommentFrameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                frameModel.commentModel = model;
                [_dataArray addObject:frameModel];
            }
            [self createTableView];
            _backImg.image = IMAGE(@"no_data");
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
            }else{
                [_backImg removeFromSuperview];
            }
            _tableView.mj_footer.userInteractionEnabled = YES;
        }else{
            HIDE_HUD
            [_dataArray removeAllObjects];
            [self createTableView];
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
        [self createTableView];
        _backImg.image = IMAGE(@"no_net");
        [_tableView addSubview:_backImg];
        _tableView.mj_footer.userInteractionEnabled = NO;
    }];
}
#pragma mark=====加载更多数据==========
- (void)loadMoreData{
    _page ++;
    SHOW_HUD
    NSDictionary *dic = @{@"page":@(_page)};
    [HttpTool postWithAPI:@"staff/comment/items" withParams:dic success:^(id json) {
        NSLog(@"json%@",json);
        HIDE_HUD
        if([json[@"error"] isEqualToString:@"0"]){
            _totalPercent = json[@"data"][@"total_precent"];
            _totalScore = json[@"data"][@"total_score"];
            _count = json[@"data"][@"count"];
            _rateLabel.text = [NSString stringWithFormat:NSLocalizedString(@"好评率:%.0f%@", nil),[_totalPercent floatValue] *100,@"%"];
            NSRange range = [_rateLabel.text rangeOfString:NSLocalizedString(@"好评率:", nil)];
            NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_rateLabel.text];
            [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1.0f)} range:range];
            _rateLabel.attributedText = attributed;
//            [_starView setStarWithValue:[_totalScore intValue]];
            NSArray *itemArray = json[@"data"][@"items"];
            if(itemArray.count == 0){
                [self showHaveNoMoreData];
                [_tableView.mj_header endRefreshing];
                [_tableView.mj_footer endRefreshing];
                HIDE_HUD
                return ;
            }
            for(NSDictionary *dic in itemArray){
                CommentModel *model = [[CommentModel alloc] init];
                CommentFrameModel *frameModel = [[CommentFrameModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                frameModel.commentModel = model;
                [_dataArray addObject:frameModel];
            }
            [self createTableView];
            if(_dataArray.count == 0){
                [_tableView addSubview:_backImg];
                [_tableView addSubview:_backLabel];
            }else{
                [_backLabel removeFromSuperview];
                [_backImg removeFromSuperview];
            }
        }else{
            HIDE_HUD
            [self showAlertViewWithTitle:NSLocalizedString(@"数据请求失败", nil)];
        }
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark====初始化子控件======
- (void)initSubViews{
    _rateBack = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
    _rateBack.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rateBack];
    UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
    thread.backgroundColor = LINE_COLOR;
    [_rateBack addSubview:thread];
    _rateLabel = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 150, 15)];
    _rateLabel.font = FONT(14);
    _rateLabel.textColor= HEX(@"ff7d14", 1.0f);
    [_rateBack addSubview:_rateLabel];
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(WIDTH -130, 14.5, 45, 15)];
    label.font = FONT(14);
    label.textColor = HEX(@"999999", 1.0f);
    label.text = NSLocalizedString(@"总评:", nil);
    [_rateBack addSubview:label];
    _starView = [[YFStartView alloc]init];
    _starView.frame = FRAME(WIDTH - 90, 14, 80,10);
    _starView.imgSize = CGSizeMake(13, 13);
    _starView.interSpace = 5;
    _starView.userInteractionEnabled = NO;
    _starView.starType = YFStarViewFloat;
    
    [_rateBack addSubview:_starView];
}
#pragma mark=====创建表视图=======
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
        _backImg = [[UIImageView alloc] initWithFrame:FRAME((WIDTH - 200) / 2, 100, 200, 200 / 1.36)];
    }else{
        [_tableView reloadData];
    }
}
#pragma mark========UITableViewDelegate=======
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return [_dataArray[indexPath.section] rowHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return 89;
    else
        return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == _dataArray.count - 1)
        return CGFLOAT_MIN;
    else
        return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"comment";
    JHCommentCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifer];
    if(cell == nil){
        cell = [[JHCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.frameModel = _dataArray[indexPath.section];
    cell.replyBnt.tag = indexPath.section + 1;
    [cell.replyBnt addTarget:self action:@selector(clickReplyBnt:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH , 89)];
        view.backgroundColor = BACK_COLOR;
        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(15, 59, WIDTH - 15, 15)];
        label.font = FONT(12);
        label.textColor = HEX(@"999999", 1.0f);
        label.text = [NSString stringWithFormat:NSLocalizedString(@"共有%@人评价", nil),_count];
        [view addSubview:label];
        [view addSubview:_rateBack];
        return view;
    }
    return nil;
}
#pragma mark=====回复按钮点击事件=====
- (void)clickReplyBnt:(UIButton *)sender{
    JHOrderReplyVC *reply = [[JHOrderReplyVC alloc] init];
    reply.comment_id = [_dataArray[sender.tag - 1] commentModel].comment_id;
    reply.isMap = NO;
    [self.navigationController pushViewController:reply animated:YES];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"OrderReplySuccess" object:nil];
}
@end
