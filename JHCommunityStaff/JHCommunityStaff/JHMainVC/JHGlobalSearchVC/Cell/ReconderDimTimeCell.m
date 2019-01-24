//
//  ReconderDimTimeCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderDimTimeCell.h"
@interface ReconderDimTimeCell()
{
    UIButton *oldBtn;
}
@end
@implementation ReconderDimTimeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)creatSubUI{
    UILabel *label = [UILabel new];
    label.text = NSLocalizedString(@"交易时间", nil);
    label.textColor = HEX(@"333333", 1);
    label.font = FONT(14);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 15;
        make.height.offset = 16;
    }];
    NSArray *titleArr = @[NSLocalizedString(@"近7天", nil),NSLocalizedString(@"近30天", nil)];
    CGFloat width = (WIDTH - 44)/3;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
        btn.titleLabel.font =FONT(14);
        [self addSubview:btn];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset = 12+(40+12)*(i/3);
            make.left.offset = 12+(width + 10)*(i%3);
            make.width.offset = width;
            make.height.offset = 40;
            if (i == titleArr.count - 1) {
                make.bottom.offset = -15;
            }
        }];
        
    }
    UIView *line = [UIView new];
    line.backgroundColor = HEX(@"e6e6e6", 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
}
-(void)clickBtn:(UIButton *)sender{
    NSLog(@"选择的时间类型是%ld",sender.tag);
    oldBtn.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
    [oldBtn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
    sender.layer.borderColor =  _tintColor.CGColor;
    [sender setTitleColor:_tintColor forState:UIControlStateNormal];
    oldBtn = sender;
    if (self.clickBlock) {
        self.clickBlock(sender.tag-100);
    }
}
//进入当前页面时  展示上次选中的
-(void)selectBtnWithIndex:(NSInteger)index{
    UIButton *selectedBtn = (UIButton *)[self viewWithTag:100+index];
    [self clickBtn:selectedBtn];
}

-(void)removeSelecter{
    oldBtn.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
    [oldBtn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
}
@end

