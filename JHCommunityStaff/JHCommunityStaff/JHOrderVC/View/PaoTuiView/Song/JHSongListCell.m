//
//  JHSongCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/11.
//  Copyright © 2016年 jianghu2. All rights reserved.
//帮我送

#import "JHSongListCell.h"
#import "TransformTime.h"
@interface JHSongListCell ()
@property (nonatomic,strong)UIImageView *typeImg;//类型图片:家庭保洁或洗衣洗鞋等
@property (nonatomic,strong)UILabel *typeLbel;//类型名称
@property (nonatomic,strong)UILabel *basic;//姓名 + 电话号码
@property (nonatomic,strong)UILabel *status;//订单状态
@property (nonatomic,strong)UILabel *order_id;//订单号
@property (nonatomic,strong)UILabel *order_time;//下单时间
@property (nonatomic,strong)UILabel *pickAddr;//取货地址
@property (nonatomic,strong)UILabel *deliverAddr;//收货地址
@property (nonatomic,strong)UILabel *pickDistant;//取货距离
@property (nonatomic,strong)UILabel *deliverDistant;//收货距离
@property (nonatomic,strong)UIImageView *lineImg;//蓝色线条
@property (nonatomic,strong)UILabel *money;//定金
@end
@implementation JHSongListCell
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
    _typeLbel.text = NSLocalizedString(@"帮我送", nil);
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
    _pickAddr = [[UILabel alloc] initWithFrame:FRAME(40, 45 + 40 + 35, WIDTH - 40 - 95, 15)];
    _pickAddr.textColor = HEX(@"666666", 1.0f);
    _pickAddr.font = FONT(12);
    [self.contentView addSubview:_pickAddr];
    _deliverAddr = [[UILabel alloc] initWithFrame:FRAME(40, 45 + 40 + 65, WIDTH - 40 - 95, 15)];
    _deliverAddr.textColor = HEX(@"666666", 1.0f);
    _deliverAddr.font = FONT(12);
    [self.contentView addSubview:_deliverAddr];
    _pickDistant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 45 + 40 + 35, 80, 15)];
    _pickDistant.textColor = HEX(@"ff6600", 1.0f);
    _pickDistant.font = FONT(12);
    _pickDistant.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_pickDistant];
    _deliverDistant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 45 + 40 + 65, 80, 15)];
    _deliverDistant.textColor = HEX(@"ff6600", 1.0f);
    _deliverDistant.font = FONT(12);
    _deliverDistant.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_deliverDistant];
    _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileButton.frame = FRAME(WIDTH - 45, 15 + 40, 30, 30);
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    _money = [[UILabel alloc] initWithFrame:FRAME(0, 180, WIDTH / 3, 44)];
    _money.font = FONT(14);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_money];
    _look = [UIButton buttonWithType:UIButtonTypeCustom];
    _look.frame = FRAME(WIDTH / 3, 180, WIDTH / 3, 44);
    _look.titleLabel.font = FONT(14);
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateNormal];
    [_look setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateSelected];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_look];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 * 2, 180, WIDTH / 3, 44);
    _statusButton.titleLabel.font = FONT(14);
    [self.contentView addSubview:_statusButton];
    NSArray *imgArray = @[@"order_icon01",@"order_icon02",@"order_icon03",@"order_icon04"];
    for(int i = 0 ; i < 4; i ++){
        UIImageView *img = [[UIImageView alloc] init];
        if(i == 0){
            img.frame = FRAME(15, 55, 15, 15);
        }else if(i == 1){
            img.frame = FRAME(15, 85, 15, 15);
        }else if(i == 2){
            img.frame = FRAME(15, 45 + 40 + 35, 15, 15);
        }else{
            img.frame = FRAME(15,45 + 40 + 65, 15, 15);
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
                thread.frame = FRAME(0, 179.5, WIDTH, 0.5);
            }
                break;
                
            case 3:
            {
                thread.frame = FRAME(0, 223.5, WIDTH, 0.5);
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
        thread.frame = FRAME((WIDTH / 3) * (i + 1) - 0.5, 180, 0.5, 44);
        [self.contentView addSubview:thread];
    }
}
- (void)setPaotuiListModel:(JHPaotuiListModel *)paotuiListModel{
    _paotuiListModel = paotuiListModel;
    _basic.text =[NSString stringWithFormat:NSLocalizedString(@"收货人:%@ %@", nil),paotuiListModel.contact,paotuiListModel.mobile];
    _status.text = paotuiListModel.order_status_label;
    _order_id.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),paotuiListModel.order_id];
    _order_time.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:paotuiListModel.dateline]];
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"跑腿费:￥%@", nil),_paotuiListModel.paotui_amount];
    NSRange range = [_money.text rangeOfString:NSLocalizedString(@"跑腿费:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    _money.attributedText = attributed;
    _pickAddr.text = [NSString stringWithFormat:NSLocalizedString(@"取货地址:%@%@", nil),paotuiListModel.o_addr,paotuiListModel.o_house];
    _deliverAddr.text = [NSString stringWithFormat:NSLocalizedString(@"收货地址:%@%@", nil),paotuiListModel.addr,paotuiListModel.house];
    _pickDistant.text = paotuiListModel.juli_qidian;
    _deliverDistant.text = paotuiListModel.juli_zhongdian;
    [self handleOrderStatusButton];
}
#pragma mark=======处理订单状态按钮====
- (void)handleOrderStatusButton{
    
    NSLog(@"");
    if([_paotuiListModel.order_status isEqualToString:@"0"] && [_paotuiListModel.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([_paotuiListModel.order_status isEqualToString:@"1"] || [_paotuiListModel.order_status isEqualToString:@"2"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已取件", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已取件", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已取件", nil) forState:UIControlStateHighlighted];
    }else if ([_paotuiListModel.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateHighlighted];
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
