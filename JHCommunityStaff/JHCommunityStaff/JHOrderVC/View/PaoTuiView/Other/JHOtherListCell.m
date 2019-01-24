//
//  JHOtherListCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHOtherListCell.h"
#import "TransformTime.h"
@interface JHOtherListCell ()
@property (nonatomic,strong)UIImageView *typeImg;//类型图片:家庭保洁或洗衣洗鞋等
@property (nonatomic,strong)UILabel *typeLbel;//类型名称
@property (nonatomic,strong)UILabel *basic;//姓名 + 电话号码
@property (nonatomic,strong)UILabel *status;//订单状态
@property (nonatomic,strong)UILabel *order_id;//订单号
@property (nonatomic,strong)UILabel *order_time;//下单时间
@property (nonatomic,strong)UILabel *otherAddr;//其他地址
@property (nonatomic,strong)UILabel *otherDistant;//其他距离
@property (nonatomic,strong)UIImageView *lineImg;//蓝色线条
@property (nonatomic,strong)UILabel *money;//跑腿费
@end
@implementation JHOtherListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self addThread];
    }
    return self;
}
#pragma mark=====初始化子控件=======
- (void)initSubViews{
    _typeImg = [[UIImageView alloc] initWithFrame:FRAME(0, 7.5, 60, 25)];
    _typeImg.image = IMAGE(@"order_labelbg");
    [self.contentView addSubview:_typeImg];
    _typeLbel = [[UILabel alloc] initWithFrame:FRAME(0, 7.5, 50, 25)];
    _typeLbel.font = FONT(12);
    _typeLbel.textAlignment = NSTextAlignmentCenter;
    _typeLbel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_typeLbel];
    _basic = [[UILabel alloc] initWithFrame:FRAME(70, 12.5,WIDTH - 60 - 115, 15)];
    _basic.font = FONT(14);
    _basic.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:_basic];
    _status = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 115, 12.5, 100, 15)];
    _status.font = FONT(14);
    _status.textAlignment = NSTextAlignmentRight;
    _status.textColor = HEX(@"ff6600", 1.0f);
    [self.contentView addSubview:_status];
    _order_id = [[UILabel alloc] initWithFrame:FRAME(40, 15 + 40, WIDTH - 40 - 15 - 30, 15)];
    _order_id.textColor = HEX(@"666666", 1.0f);
    _order_id.font = FONT(12);
    [self.contentView addSubview:_order_id];
    _order_time = [[UILabel alloc] initWithFrame:FRAME(40, 45 + 40, WIDTH - 40 - 15 - 30, 15)];
    _order_time.textColor = HEX(@"666666", 1.0f);
    _order_time.font = FONT(12);
    [self.contentView addSubview:_order_time];
    _lineImg = [[UIImageView alloc] initWithFrame:FRAME(15,45 + 40 + 24.5 , WIDTH - 30, 0.5)];
    _lineImg.image = IMAGE(@"line_dashed");
    [self.contentView addSubview:_lineImg];
    _otherAddr = [[UILabel alloc] initWithFrame:FRAME(40, 45 + 10 + 65, WIDTH - 40 - 95, 15)];
    _otherAddr.textColor = HEX(@"666666", 1.0f);
    _otherAddr.font = FONT(12);
    [self.contentView addSubview:_otherAddr];
    _otherDistant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 45 + 10 + 65, 80, 15)];
    _otherDistant.textColor = HEX(@"ff6600", 1.0f);
    _otherDistant.font = FONT(12);
    _otherDistant.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_otherDistant];
    _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileButton.frame = FRAME(WIDTH - 45, 15 + 40, 30, 30);
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    _money = [[UILabel alloc] initWithFrame:FRAME(0, 150, WIDTH / 3, 44)];
    _money.font = FONT(14);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_money];
    _look = [UIButton buttonWithType:UIButtonTypeCustom];
    _look.frame = FRAME(WIDTH / 3, 150, WIDTH / 3, 44);
    _look.titleLabel.font = FONT(14);
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateNormal];
    [_look setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateSelected];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_look];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 * 2, 150, WIDTH / 3, 44);
    _statusButton.titleLabel.font = FONT(14);
    [self.contentView addSubview:_statusButton];
    NSArray *imgArray = @[@"order_icon01",@"order_icon02",@"order_icon03"];
    for(int i = 0 ; i < 3; i ++){
        UIImageView *img = [[UIImageView alloc] init];
        if(i == 0){
            img.frame = FRAME(15, 55, 15, 15);
        }else if(i == 1){
            img.frame = FRAME(15, 85, 15, 15);
        }else{
            img.frame = FRAME(15,45 + 10 + 65, 15, 15);
        }
        img.layer.cornerRadius = img.frame.size.width / 2;
        img.clipsToBounds = YES;
        img.image = IMAGE(imgArray[i]);
        [self.contentView addSubview:img];
    }
    
}
#pragma mark====添加线条=======
- (void)addThread{
    for(int i = 0; i < 4; i ++){
        UIView *thread = [[UIView alloc] init];
        thread.backgroundColor = LINE_COLOR;
        switch (i) {
            case 0:
            {
                thread.frame = FRAME(0, 0, WIDTH, 0.5);
            }
                break;
            case 1:
            {
                thread.frame = FRAME(0, 39.5, WIDTH, 0.5);
            }
                break;
                
            case 2:
            {
                thread.frame = FRAME(0, 149.5, WIDTH, 0.5);
            }
                break;
                
            case 3:
            {
                thread.frame = FRAME(0, 193.5, WIDTH, 0.5);
            }
                break;
                
            default:
                break;
        }
        [self.contentView addSubview:thread];
        
    }
    for(int i = 0; i < 2;i++){
        UIView *thread = [[UIView alloc] init];
        thread.backgroundColor = LINE_COLOR;
        thread.frame = FRAME((WIDTH / 3) * (i + 1) - 0.5, 150, 0.5, 44);
        [self.contentView addSubview:thread];
    }
    
}
- (void)setPaotuiListModel:(JHPaotuiListModel *)paotuiListModel{
    _paotuiListModel = paotuiListModel;
    if ([_paotuiListModel.type isEqualToString:@"seat"]){
        _typeLbel.text = NSLocalizedString(@"餐馆占座", nil);
    }else if([_paotuiListModel.type isEqualToString:@"paidui"]){
        _typeLbel.text = NSLocalizedString(@"代排队", nil);
    }else if([_paotuiListModel.type isEqualToString:@"chongwu"]){
        _typeLbel.text = NSLocalizedString(@"宠物照顾", nil);
    }else{
       _typeLbel.text = NSLocalizedString(@"其他", nil);
    }
    _basic.text = [NSString stringWithFormat:@"%@ %@",paotuiListModel.contact,paotuiListModel.mobile];
    _status.text = paotuiListModel.order_status_label;
    _order_id.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),paotuiListModel.order_id];
    _order_time.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:paotuiListModel.dateline]];
    _otherAddr.text = [NSString stringWithFormat:NSLocalizedString(@"服务地址:%@%@", nil),paotuiListModel.addr,paotuiListModel.house];
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"跑腿费:￥%@", nil),_paotuiListModel.paotui_amount];
    NSRange range = [_money.text rangeOfString:NSLocalizedString(@"跑腿费:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    _money.attributedText = attributed;
    _otherDistant.text = _paotuiListModel.juli_quancheng;
    [self handleOrderStatusButton];
}
#pragma mark=======处理订单状态按钮=====
- (void)handleOrderStatusButton{
    NSString *str = nil;
    if([_paotuiListModel.order_status isEqualToString:@"0"] ){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([_paotuiListModel.order_status isEqualToString:@"1"]  ||  [_paotuiListModel.order_status isEqualToString:@"2"]){
        if ([_paotuiListModel.type isEqualToString:@"seat"]){
            str = NSLocalizedString(@"开始占座", nil);
        }else if([_paotuiListModel.type isEqualToString:@"paidui"]){
            str = NSLocalizedString(@"开始排队", nil);
        }else if([_paotuiListModel.type isEqualToString:@"chongwu"]){
            str = NSLocalizedString(@"开始照顾", nil);
        }else{
            str = NSLocalizedString(@"开始服务", nil);
        }
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateSelected];
        [_statusButton setTitle:str forState:UIControlStateHighlighted];
    }else if([_paotuiListModel.order_status isEqualToString:@"3"]){
        if ([_paotuiListModel.type isEqualToString:@"seat"]){
            str = NSLocalizedString(@"占座结束", nil);
        }else if([_paotuiListModel.type isEqualToString:@"paidui"]){
            str = NSLocalizedString(@"排队结束", nil);
        }else if([_paotuiListModel.type isEqualToString:@"chongwu"]){
            str = NSLocalizedString(@"照顾结束", nil);
        }else{
            str = NSLocalizedString(@"完成服务", nil);
        }
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateNormal];
        [_statusButton setTitle:str forState:UIControlStateSelected];
        [_statusButton setTitle:str forState:UIControlStateHighlighted];
    }else if ([_paotuiListModel.order_status isEqualToString:@"8"] && [_paotuiListModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateHighlighted];
    }else if([_paotuiListModel.order_status isEqualToString:@"8"] && ![_paotuiListModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_paotuiListModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
            _statusButton.userInteractionEnabled = YES;
            [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateSelected];
            [_statusButton setTitle:NSLocalizedString(@"立即回复", nil) forState:UIControlStateHighlighted];
        }else{
            _statusButton.userInteractionEnabled = NO;
            [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateNormal];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateSelected];
            [_statusButton setTitle:NSLocalizedString(@"已回复", nil) forState:UIControlStateHighlighted];
        }
  }else{
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateNormal];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateSelected];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateHighlighted];
    }
}
@end
