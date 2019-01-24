//
//  JHMainTainSkillCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/7/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHMaintainSkillCell.h"
#import "SkillBnt.h"
@implementation JHMaintainSkillCell
{
    UIView *_skillView;
    UILabel *_skillLabel;
    NSMutableArray *_skillDataArray;//技能数组
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSkillView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACK_COLOR;
    }
    return  self;
}
- (void)initSkillView{
    _skillDataArray = [@[] mutableCopy];
    _skillView = [UIView new];
    [self.contentView addSubview:_skillView];
    _skillView.layer.cornerRadius = 4.0f;
    _skillView.clipsToBounds = YES;
    _skillView.backgroundColor = [UIColor whiteColor];
    _skillView.layer.borderColor = LINE_COLOR.CGColor;
    _skillView.layer.borderWidth = 0.5f;
    _skillLabel = [[UILabel alloc] init];
    _skillLabel.font = FONT(14);
    _skillLabel.textColor = HEX(@"333333", 1.0f);
    NSString *str = NSLocalizedString(@"通过单击以下标签选择维修技能", nil);
    NSRange range1 = [str rangeOfString:NSLocalizedString(@"选择维修技能", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range1];
    _skillLabel.attributedText = attributed;
    
}
#pragma mark======添加技能=======
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [_skillDataArray removeAllObjects];
    for(UIView *view in _skillView.subviews){
        [view removeFromSuperview];
    }
    _skillView.frame = FRAME(15, 0, WIDTH - 30, 40 + ((_dataArray.count -1) / 4 + 1) * 40);
    _skillLabel.frame =  FRAME(15, 15, _skillView.bounds.size.width - 15, 15);
    [_skillView addSubview:_skillLabel];
    CGFloat space = (_skillView.bounds.size.width - 60 * 4 - 30) / 3;
    for(int i= 0;i < dataArray.count; i++){
        SkillBnt *skillBnt = [[SkillBnt alloc] initWithFrame:FRAME(15 + (i % 4) * (space + 60), 40 + (i / 4) * 40, 60, 30)];
        [skillBnt setTitle:[dataArray[i] title] forState:UIControlStateNormal];
        skillBnt.tag = i + 1;
        skillBnt.titleLabel.adjustsFontSizeToFitWidth = YES;
        [skillBnt setImage:IMAGE(@"sq_close") forState:UIControlStateSelected];
        [skillBnt addTarget:self action:@selector(clickSkillBnt:) forControlEvents:UIControlEventTouchUpInside];
        [_skillView addSubview:skillBnt];
    }
}
- (void)clickSkillBnt:(UIButton *)sender{
    if(_skillDataArray.count == 0){
        [_skillDataArray addObject:_dataArray[sender.tag - 1]];
        sender.selected = YES;
    }else{
        if(sender.selected){
            [_skillDataArray removeObject:_dataArray[sender.tag - 1]];
            sender.selected = NO;
        }else{
            if (_skillDataArray.count >= 10000) {
                [self showAlert];
            }else{
                [_skillDataArray addObject:_dataArray[sender.tag - 1]];
                sender.selected = YES;
            }
            
        }
    }
    if(self.maintainSkillBlock){
        self.maintainSkillBlock(_skillDataArray);
    }
}
#pragma mark - 弹出警告款
-(void)showAlert{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:NSLocalizedString(@"技能最多只能选择8个", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil]];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:alertControl animated:YES completion:nil];
}

@end
