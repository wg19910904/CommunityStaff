//
//  JHOrderReplyVC.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/19.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHOrderReplyVC.h"
#import "HttpTool.h"
#import <IQKeyboardManager.h>
#import "JHOrderCommentCell.h"
#import "HttpTool.h"
#import "CommentModel.h"
#import "OrderCommentFrameModel.h"
@interface JHOrderReplyVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView *_tableView;//表视图
    UITextView *_textView;//评价内容
    UILabel *_describleLabel;//请输入你想回复的内容标签
    UILabel *_numLabel;//字数标签
    UIButton *_replyBnt;//确认回复按钮
    UIView *_backView;//灰色背景
    OrderCommentFrameModel *_frameModel;//评论数据模型
}
@end

@implementation JHOrderReplyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTitle:NSLocalizedString(@"回复", nil)];
    [self initSubViews];
    [self requestData];
}
#pragma mark======初始化子控件======
- (void)initSubViews{
    _backView = [[UIView alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 180)];
    _backView.layer.cornerRadius = 2.0f;
    _backView.clipsToBounds = YES;
    _backView.backgroundColor = HEX(@"f5f5f5", 1.0f);
    _textView = [[UITextView alloc] initWithFrame:FRAME(10, 0, WIDTH - 40, 150)];
    _textView.delegate = self;
    _textView.font = FONT(12);
    _textView.backgroundColor = HEX(@"f5f5f5", 1.0f);
    [_backView addSubview:_textView];
    _describleLabel = [[UILabel alloc] initWithFrame:FRAME(0, 10, WIDTH - 40, 15)];
    _describleLabel.font = FONT(12);
    _describleLabel.textColor = HEX(@"cccccc", 1.0f);
    _describleLabel.text = NSLocalizedString(@"请输入您想回复的内容", nil);
    [_textView addSubview:_describleLabel];
    _numLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 160, 155, 130, 15)];
    _numLabel.text = NSLocalizedString(@"200字", nil);
    _numLabel.font = FONT(12);
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.textColor = HEX(@"cccccc", 1.0f);
    [_backView addSubview:_numLabel];
    _replyBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyBnt.frame = FRAME(15, 0, WIDTH - 30, 44);
    _replyBnt.layer.cornerRadius = 4.0f;
    _replyBnt.clipsToBounds = YES;
    [_replyBnt setTitle:NSLocalizedString(@"确认回复", nil) forState:UIControlStateNormal];
    [_replyBnt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_replyBnt setBackgroundColor:HEX(@"ff6600", 1.0f) forState:UIControlStateNormal];
    [_replyBnt setBackgroundColor:HEX(@"ff6600", 0.6f) forState:UIControlStateHighlighted];
    [_replyBnt setBackgroundColor:HEX(@"ff6600", 0.6f) forState:UIControlStateSelected];
    _replyBnt.titleLabel.font = FONT(16);
    [_replyBnt addTarget:self action:@selector(clickReplyBnt) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark---======请求网络数据========
- (void)requestData{
    SHOW_HUD
    NSDictionary *dic = @{@"comment_id":self.comment_id};
    [HttpTool postWithAPI:@"staff/comment/detail" withParams:dic success:^(id json) {
        NSLog(@"jsion%@",json);
        if([json[@"error"] isEqualToString:@"0"]){
            NSDictionary *data = json[@"data"];
            _frameModel = [[OrderCommentFrameModel alloc] init];
            CommentModel *model = [[CommentModel alloc] init];
            [model setValuesForKeysWithDictionary:data];
            _frameModel.commentModel = model;
            [self createTableView];
            HIDE_HUD
        }else{
          HIDE_HUD
            [self showAlertViewWithTitle:NSLocalizedString(@"数据请求失败", nil)];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"error%@",error.localizedDescription);
        [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
    }];
}
#pragma mark===点击确认回复按钮事件====
- (void)clickReplyBnt{
    NSLog(@"确认回复");
    if(_textView.text.length == 0){
        [self showAlertViewWithTitle:NSLocalizedString(@"请输入回复内容", nil)];
    }else{
        SHOW_HUD
        NSDictionary *dic = @{@"comment_id":self.comment_id,@"reply":_textView.text};
        [HttpTool postWithAPI:@"staff/comment/reply" withParams:dic success:^(id json) {
            NSLog(@"json%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                HIDE_HUD
                if(_isMap){
                    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OrderReplySuccess" object:nil];
            }else{
                HIDE_HUD
                [self showAlertViewWithTitle:[NSString stringWithFormat:NSLocalizedString(@"回复失败,原因%@", nil),json[@"message"]]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            NSLog(@"error%@",error.localizedDescription);
            [self showAlertViewWithTitle:NSLocalizedString(@"抱歉,无法访问服务器", nil)];
        }];
    }
}
#pragma mark=======创建表视图=======
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
    }else{
        [_tableView reloadData];
    }
}
#pragma mark========UITableViewDelegate=========
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0)
        return _frameModel.rowHeight;
    else if(indexPath.section == 1)
        return 200;
    else
        return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
        return CGFLOAT_MIN;
    else if(section == 1)
        return 10;
    else
        return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            JHOrderCommentCell *cell = [[JHOrderCommentCell alloc] init];
            cell.orderCommentBlock = ^{
                [self.view endEditing:YES];
            };
            [cell setFrameModel:_frameModel];
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_backView];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for(int i = 0; i < 2; i++){
                UIView * thread = [[UIView alloc] initWithFrame:FRAME(0, i * 199.5, WIDTH, 0.5)];
                thread.backgroundColor = LINE_COLOR;
                [cell.contentView addSubview:thread];
             }
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:_replyBnt];
            cell.contentView.backgroundColor = BACK_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark=======UITextViewDelegate=======
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    _describleLabel.hidden = YES;
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if(_textView.text.length == 0){
        _describleLabel.hidden = NO;
        _numLabel.text = NSLocalizedString(@"200字", nil);
    }else if (_textView.text.length < 200 && _textView.text.length > 0){
        NSInteger num = 200 - (_textView.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }else{
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if(_textView.text.length >= 200){
        [self textViewShouldEndEditing:_textView];
        [self.view endEditing:YES];
        _numLabel.text = NSLocalizedString(@"不能再输入喽", nil);
    }else{
        NSInteger num = 200 - (_textView.text.length);
        _numLabel.text = [NSString stringWithFormat:NSLocalizedString(@"可输入%ld字", nil),(long)num];
    }
}
#pragma mark======scrollViewDelegate==========
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    if(manager.enable){
    }else{
        [self.view endEditing:YES];
        if(_textView.text.length == 0){
            _describleLabel.hidden = NO;
        }
    }
}
@end
