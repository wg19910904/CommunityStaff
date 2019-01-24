//
//  JHMainVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMainVC.h"
#import "leftCell.h"
#import "AppDelegate.h"
#import "JHSetVC.h"
#import "JHAccountVC.h"
#import "JHCommentVC.h"
#import "HttpTool.h"
#import "JHMoneyVC.h"
#import "JHMessageVC.h"
#import "JHCountVC.h"
#import "JHHouseingOrderListVC.h"
#import "JHMaintainOrderListVC.h"
#import "JHPaoTuiOrderListVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "JHVerifyVC.h"
#import "InfoModel.h"
#import "JHShareModel.h"
#import "JHGlobalSearchVC.h"
#import "JHShowAlert.h"
#import "JHLoginVC.h"
@interface JHMainVC ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,CDRTranslucentSideBarDelegate>
{
    //
    
    UITableView *_leftTableView;
    UIImageView *_img;//头像
    UILabel *_mobile;//电话号
    UILabel *_nameLabel;//姓名
    NSArray *_imgArray;
    NSArray *_titleArray;
    JHHouseingOrderListVC *_houseing;//家政
    JHMaintainOrderListVC *_maintain;//维修
    JHPaoTuiOrderListVC *_paoTui;//跑腿类
    UIView *_noNetBackView;//无网络状态下背景
    MJRefreshNormalHeader *_header;
    UIView *_verifyView;//认证试图
    UIButton *_verifyButton;//认证按钮
    UILabel *_verifyLabel;//认证标签
    InfoModel *_infoModel;
    UILabel *_tag;//标签
}
@end

@implementation JHMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSearchResult) {
        [self addTitle:NSLocalizedString(@"筛选结果", nil)];
        [self requestData];
    }else{
        [self addTitle:NSLocalizedString(@"首页", nil)];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(foreground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        self.backBtn.hidden = YES;
        self.fd_interactivePopDisabled = YES;
        [self createVerifyView];
        [self createTableView];
        [self requestData];
        [self addNotification];
        [self handleData];
        [self createBarBnt];
        [self handleLeft];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(version) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
}
- (void)foreground:(NSNotification *)noti{
    [self createVerifyView];
    [self createTableView];
    [self requestData];
    [self handleData];
    [self createBarBnt];
    [self handleLeft];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (!_isSearchResult) {
        //验证版本的
        [self version];
    }
    if (_paoTui) {
        [_paoTui loadNewData];
    }
}
-(void)version{
    if (![JHShareModel shareModel].isNotUpdate) {
        [self postToSureThatIsNeedUpgradeVersion];
    }
     [self requestData];
}
-(void)postToSureThatIsNeedUpgradeVersion{
    [HttpTool postWithAPI:@"client/v2/data/appver" withParams:@{} success:^(id json) {
        NSLog(@"更新版本的信息%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"ios_staff_version"] compare:[JHShareModel shareModel].version] != NSOrderedDescending) {
                return;
            }
            if ([[json[@"data"][@"ios_staff_force_update"] description] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"data"][@"ios_staff_intro"] withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:^{
                    [JHShareModel shareModel].isNotUpdate =YES;
                }withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_staff_download"]]];
                }];
            }else{
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:json[@"data"][@"ios_staff_intro"] withBtn_cancel:nil withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:nil withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_staff_download"]]];
                }];
            }
        }
    } failure:^(NSError *error) {
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sideBar dismiss];
}
#pragma mark==导航栏右侧按钮=====
- (void)clickRightBnt{
    JHGlobalSearchVC *vc = [[JHGlobalSearchVC alloc]init];
    vc.searchImgStr = @"btn_search";
    vc.choseTimeArrow = @"btn_arrow_r";
    vc.tintColor = THEME_COLOR;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark====创建底部认证视图=====
- (void)createVerifyView{
    _infoModel = [[InfoModel alloc] init];
    _verifyView = [[UIView alloc] initWithFrame:FRAME(0, HEIGHT- 40 - 64,WIDTH, 40)];
    _verifyView.backgroundColor = HEX(@"ff6600", 1.0f);
    _verifyLabel = [[UILabel alloc] initWithFrame:FRAME(15, 12.5, WIDTH - 100, 15)];
    _verifyLabel.font = FONT(14);
    _verifyLabel.textColor = [UIColor whiteColor];
    [_verifyView addSubview:_verifyLabel];
    _verifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verifyButton.frame = FRAME(WIDTH - 95, 5, 80, 30);
    _verifyButton.titleLabel.font = FONT(16);
    _verifyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _verifyButton.layer.cornerRadius = 4.0f;
    _verifyButton.clipsToBounds = YES;
    [_verifyButton setTitleColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
    [_verifyButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_verifyButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_verifyButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_verifyButton addTarget:self action:@selector(clickVerifyButton) forControlEvents:UIControlEventTouchUpInside];
    [_verifyView addSubview:_verifyButton];
    _tag = [[UILabel alloc] init];
    _tag.layer.cornerRadius = 4.0f;
    _tag.clipsToBounds = YES;
    _tag.backgroundColor = THEME_COLOR;
    _tag.textAlignment = NSTextAlignmentCenter;
    _tag.textColor = [UIColor whiteColor];
    _tag.font = FONT(10);
}
#pragma mark======认证按钮点击事件======
- (void)clickVerifyButton{
    JHVerifyVC *verifyVc = [[JHVerifyVC alloc] init];
    verifyVc.userName = _infoModel.verify[@"id_name"];
    verifyVc.userId = _infoModel.verify[@"id_number"];
    verifyVc.img = _infoModel.verify[@"id_photo"];
    verifyVc.verifyStatus = _infoModel.verify[@"verify"];
    verifyVc.reason = _infoModel.verify[@"reason"];
    [self.navigationController pushViewController:verifyVc animated:YES];
}
#pragma mark=====添加通知=====
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"verify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"changeMobile" object:nil];
}
#pragma mark===网络请求数据======
- (void)requestData{
    [HttpTool postWithAPI:@"staff/account/index" withParams:@{} success:^(id json) {
        NSLog(@"json%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            [_noNetBackView removeFromSuperview];
            [_infoModel setValuesForKeysWithDictionary:json[@"data"]];
            JHShareModel * model = [JHShareModel shareModel];
            model.status = _infoModel.status;
            model.mobile = _infoModel.mobile;
            [_img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:json[@"data"][@"face"]]] placeholderImage:IMAGE(@"sy_head")];
            _nameLabel.text = json[@"data"][@"name"];
            NSMutableString *str = [[NSMutableString alloc] initWithString:json[@"data"][@"mobile"]];
            NSRange range = NSMakeRange(3, 4);
            [str  replaceCharactersInRange:range withString:@"****"];
            _mobile.text = [NSString stringWithFormat:@"%@",str];
            if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"3"]){
               _verifyLabel.text = NSLocalizedString(@"需要提交认证资料进行身份认证", nil);
                [_verifyButton setTitle:NSLocalizedString(@"立即认证", nil) forState:UIControlStateNormal];
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"0"]){
                _verifyLabel.text = NSLocalizedString(@"正在进行身份审核", nil);
                [_verifyButton setTitle:NSLocalizedString(@"等待审核", nil) forState:UIControlStateNormal];
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"2"]){
                _verifyLabel.text = NSLocalizedString(@"认证被拒绝,请重新认证", nil);
                [_verifyButton setTitle:NSLocalizedString(@"重新认证", nil) forState:UIControlStateNormal];
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"1"]){
                [_verifyView removeFromSuperview];
                _verifyView = nil;
            }
            [self initViewController];
            [_leftTableView reloadData];
        }else if([json[@"error"] isEqualToString:@"101"]){
            //未登录或者登录失效
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [self.navigationController  popViewControllerAnimated:YES];
            [app.locationModel initMap];
        }else{
            
        }
        [_leftTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
         [_leftTableView.mj_header endRefreshing];
        NSLog(@"error%@",error.localizedDescription);
    }];
}
#pragma mark======初始化待接单,待处理,已完成视图控制器========
- (void)initViewController{
    NSString *from = [[NSUserDefaults standardUserDefaults] objectForKey:@"from"];
    __unsafe_unretained typeof (self)weakSelf = self;
    if([from isEqualToString:@"house"]){
        _tag.text = NSLocalizedString(@"家政", nil);
        [_maintain.view removeFromSuperview];
        [_maintain removeFromParentViewController];
        [_paoTui.view removeFromSuperview];
        [_paoTui removeFromParentViewController];
        if(_houseing == nil){
            _houseing = [[JHHouseingOrderListVC alloc] initWithFrame:FRAME(0, 0, WIDTH, self.view.bounds.size.height) withVerify:_infoModel.verify[@"verify"] withBool:_isSearchResult withCondition:_conditionDic];
        }
        _houseing.view.layer.masksToBounds = YES;
        _houseing.houseBlock = ^(JHBaseVC *vc){
            if(vc != nil){
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            if([_infoModel.verify[@"verify"] integerValue] != 1){
                [weakSelf requestData];
            }
        };
        [self.view addSubview:_houseing.view];
    }else if([from isEqualToString:@"weixiu"]){
         _tag.text = NSLocalizedString(@"维修", nil);
        [_houseing.view removeFromSuperview];
        [_houseing removeFromParentViewController];
        [_paoTui.view removeFromSuperview];
        [_paoTui removeFromParentViewController];
        if(_maintain == nil){
            _maintain = [[JHMaintainOrderListVC alloc] initWithFrame:FRAME(0, 0, WIDTH, self.view.bounds.size.height) withVerify:_infoModel.verify[@"verify"] withBool:_isSearchResult withCondition:_conditionDic];
        }
        _maintain.maintainBlock = ^(JHBaseVC *vc){
            if(vc != nil){
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            if([_infoModel.verify[@"verify"] integerValue] != 1){
                [weakSelf requestData];
            }
        };
        [self.view addSubview:_maintain.view];
    }else{
         _tag.text = NSLocalizedString(@"跑腿", nil);
        [_houseing.view removeFromSuperview];
        [_paoTui removeFromParentViewController];
        [_maintain.view removeFromSuperview];
        [_maintain removeFromParentViewController];
        if(_paoTui == nil){
          _paoTui = [[JHPaoTuiOrderListVC alloc] initWithFrame:FRAME(0, 0, WIDTH, self.view.bounds.size.height) withVerify:_infoModel.verify[@"verify"] withBool:self.isSearchResult withCondition:_conditionDic];
        }
        _paoTui.paoTuiBlock = ^(JHBaseVC *vc){
            if(vc != nil){
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
            if([_infoModel.verify[@"verify"] integerValue] != 1){
                [weakSelf requestData];
            }
        };
        [self.view addSubview:_paoTui.view];
    }
    [self.view addSubview:_verifyView];
}
#pragma mark===创建导航栏左右按钮======
- (void)createBarBnt{
    if (!self.isSearchResult) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setFrame:CGRectMake(0, 0, 44, 44)];
        [leftBtn addTarget:self action:@selector(clickLeftBtn)
          forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"btn_nav"] forState:UIControlStateNormal];
        leftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 0, 12, 24);
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBtnItem;
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
        [rightBtn addTarget:self action:@selector(clickRightBnt)
           forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setImage:[UIImage imageNamed:@"btn_shaixuan"] forState:UIControlStateNormal];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 24, 12, 0);
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
}
#pragma mark =====处理左侧视图====
- (void)handleLeft{
    _sideBar = [[CDRTranslucentSideBar alloc] init];
    _sideBar.sideBarWidth = self.view.frame.size.width * 0.66;
    _sideBar.delegate = self;
    _sideBar.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    _sideBar.tag = 0;
    // Add PanGesture to Show SideBar by PanGesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    [_sideBar setContentViewInSideBar:_leftTableView];
}
#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    // if you have left and right sidebar, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        // Left SideBar
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            self.sideBar.isCurrentPanGestureTarget = YES;
        }
    }
    [self.sideBar handlePanGestureToShow:recognizer inView:self.view];
}
#pragma mark====处理控件===
- (void)handleData{
    _img = [[UIImageView alloc] init];
    _mobile = [[UILabel alloc] init];
    _mobile.font = FONT(14);
    _mobile.textColor = [UIColor whiteColor];
   
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT(12);
    _nameLabel.textColor = [UIColor whiteColor];
    _imgArray = @[IMAGE(@"sy_icon02"),IMAGE(@"sy_icon03"),IMAGE(@"sy_icon04"),IMAGE(@"sy_icon05"),IMAGE(@"nav05")];
    _titleArray = @[NSLocalizedString(@"评价管理", nil),NSLocalizedString(@"账单管理", nil),NSLocalizedString(@"消息管理", nil),NSLocalizedString(@"统计报表", nil),NSLocalizedString(@"设置中心", nil)];
    _noNetBackView = [[UIView alloc] initWithFrame:FRAME(0, 0, _leftTableView.bounds.size.width, _leftTableView.bounds.size.height)];
    _noNetBackView.backgroundColor = BACK_COLOR;
    UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME( self.view.bounds.size.width / 3 + (_leftTableView.bounds.size.width - 150) / 2, 100, 150, 150 / 1.36)];
    img.image = IMAGE(@"no_net");
    [_noNetBackView addSubview:img];
}
#pragma mark====创建表视图=====
- (void)createTableView{
    if(_leftTableView == nil){
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, _leftTableView.frame.size.width, _leftTableView.frame.size.height)];
        view.backgroundColor = HEX(@"f6f5f1", 1.0f);
        view.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1];
        _leftTableView.backgroundView = view;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        //_leftTableView.mj_header = _header;
    }else{
        [_leftTableView reloadData];
    }
}
#pragma mark=======UITableViewDelegate=====
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){
        if(indexPath.row == 0){
            return 110;
        }else{
            return 70;
        }
 
    }else{
             return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(tableView == _leftTableView)
        return 6;
    else
        return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){
        if(indexPath.row == 0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            _img.frame = FRAME(15, 45, 50, 50);
            _img.layer.cornerRadius = _img.frame.size.width / 2;
            _img.contentMode = UIViewContentModeScaleAspectFill;
            _img.clipsToBounds = YES;
            [cell.contentView addSubview:_img];
            _mobile.frame = FRAME(75, 45, _leftTableView.frame.size.width - 100, 15);
            [cell.contentView addSubview:_mobile];
            _tag.frame = FRAME(75, 75,25,15);
            _nameLabel.frame = FRAME(105, 75, _leftTableView.frame.size.width - 130, 15);
            [cell.contentView addSubview:_nameLabel];
            [cell.contentView addSubview:_tag];
            cell.contentView.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *thread = [[UIView alloc] initWithFrame:FRAME(15, 109.5, _leftTableView.frame.size.width - 30, 0.5)];
            thread.backgroundColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
            [cell.contentView addSubview:thread];
            UIImageView *dirImg = [[UIImageView alloc] initWithFrame:FRAME(_leftTableView.frame.size.width - 22, 69, 7, 12)];
            dirImg.image = IMAGE(@"btn_arrowr_white");
            [cell.contentView addSubview:dirImg];
            return cell;
        }else{
            static NSString *identifier = @"left";
            leftCell *cell = [[leftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            if(cell == nil){
                cell = [_leftTableView dequeueReusableCellWithIdentifier:identifier];
            }
            [cell configSubViewWithImg:_imgArray[indexPath.row - 1] title:_titleArray[indexPath.row - 1] frame:_leftTableView.frame.size.width];
            return cell;
        }

    }else
        return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _leftTableView){
        [_sideBar dismissAnimated:NO];
        if(indexPath.row == 0){
            JHAccountVC *account= [[JHAccountVC alloc] init];
            [self.navigationController pushViewController:account animated:YES];
        }else if(indexPath.row == 1){
            JHCommentVC *comment = [[JHCommentVC alloc] init];
            [self.navigationController pushViewController:comment animated:YES];
        }else if(indexPath.row == 2){
            JHMoneyVC *money = [[JHMoneyVC alloc] init];
            [self.navigationController pushViewController:money animated:YES];
        }else if(indexPath.row == 3){
            JHMessageVC *message = [[JHMessageVC alloc] init];
            [self.navigationController pushViewController:message animated:YES];
        }else if (indexPath.row == 4){
            JHCountVC *count = [[JHCountVC alloc] init];
            [self.navigationController pushViewController:count animated:YES];
        }else{
            JHSetVC *set = [[JHSetVC alloc] init];
            [self.navigationController pushViewController:set animated:YES];
        }
        
    }else{
        
    }
 
}
#pragma mark======导航栏左侧按钮=====
- (void)clickLeftBtn{
    [self.sideBar show];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"verify" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateImg" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeName" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeMobile" object:nil];
}
@end
