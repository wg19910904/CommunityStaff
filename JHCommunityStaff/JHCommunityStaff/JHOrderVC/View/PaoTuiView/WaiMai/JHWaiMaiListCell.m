//
//  JHPaoTuiCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//外卖

#import "JHWaiMaiListCell.h"
#import "TransformTime.h"
@interface JHWaiMaiListCell  ()
@property (nonatomic,strong)UIImageView *typeImg;//类型图片:家庭保洁或洗衣洗鞋等
@property (nonatomic,strong)UILabel *typeLbel;//类型名称
@property (nonatomic,strong)UILabel *basic;//姓名 + 电话号码
@property (nonatomic,strong)UILabel *status;//订单状态
@property (nonatomic,strong)UILabel *order_id;//订单号
@property (nonatomic,strong)UILabel *order_time;//下单时间
@property (nonatomic,strong)UILabel *onTimer;//准时
@property (nonatomic,strong)UILabel *shopName;//店家名
@property (nonatomic,strong)UILabel *shopAddr;//商家地址
@property (nonatomic,strong)UILabel *customerAddr;//客户地址
@property (nonatomic,strong)UILabel *shopDistant;//商家距离
@property (nonatomic,strong)UILabel *customerDistant;//客户距离
@property (nonatomic,strong)UIImageView *lineImg;//蓝色线条
@property (nonatomic,strong)UILabel *money;//定金
@end

@implementation JHWaiMaiListCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubViews];
        [self addThread];
    }
    return  self;
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
    _typeLbel.text = NSLocalizedString(@"外卖单", nil);
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
    _onTimer = [[UILabel alloc] initWithFrame:FRAME(90, 45 + 40 + 25, WIDTH - 90, 15)];
    _onTimer.textColor = THEME_COLOR;
    _onTimer.font = FONT(12);
    
    [self.contentView addSubview:_onTimer];
    _lineImg = [[UIImageView alloc] initWithFrame:FRAME(15,45 + 40 + 49.5 , WIDTH - 30, 0.5)];
    _lineImg.image = IMAGE(@"line_dashed");
    [self.contentView addSubview:_lineImg];
    _shopName = [[UILabel alloc] initWithFrame:FRAME(40, 145, WIDTH - 40 - 55, 15)];
    _shopName.textColor = HEX(@"666666", 1.0f);
    _shopName.font = FONT(12);
    
    [self.contentView addSubview:_shopName];
    _shopDistant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 145, 80, 15)];
    _shopDistant.textColor = HEX(@"ff6600", 1.0f);
    _shopDistant.font = FONT(12);
    
    _shopDistant.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_shopDistant];
    _shopAddr = [[UILabel alloc] initWithFrame:FRAME(65, 145 + 25, WIDTH - 65 - 95, 15)];
    _shopAddr.textColor = HEX(@"666666", 1.0f);
    _shopAddr.font = FONT(12);
    
    [self.contentView addSubview:_shopAddr];
    _customerAddr = [[UILabel alloc] initWithFrame:FRAME(40, 145 + 55, WIDTH - 40 - 95, 15)];
    _customerAddr.textColor = HEX(@"666666", 1.0f);
    _customerAddr.font = FONT(12);
    
    [self.contentView addSubview:_customerAddr];
    _customerDistant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 145 + 55, 80, 15)];
    _customerDistant.textColor = HEX(@"ff6600", 1.0f);
    _customerDistant.font = FONT(12);
    
    _customerDistant.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_customerDistant];
    _mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileButton.frame = FRAME(WIDTH - 45, 15 + 40, 30, 30);
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    _money = [[UILabel alloc] initWithFrame:FRAME(0, 230, WIDTH / 3, 44)];
    _money.font = FONT(14);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_money];
    _look = [UIButton buttonWithType:UIButtonTypeCustom];
    _look.frame = FRAME(WIDTH / 3, 230, WIDTH / 3, 44);
    _look.titleLabel.font = FONT(14);
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateNormal];
    [_look setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateSelected];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_look];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 * 2, 230, WIDTH / 3, 44);
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
            img.frame = FRAME(15, 85 + 60, 15, 15);
        }else{
            img.frame = FRAME(15, 85 + 60 + 55, 15, 15);
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
                thread.frame = FRAME(0, 229.5, WIDTH, 0.5);
            }
                break;
                
            case 3:
            {
                thread.frame = FRAME(0, 273.5, WIDTH, 0.5);
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
        thread.frame = FRAME((WIDTH / 3) * (i + 1) - 0.5, 230, 0.5, 44);
        [self.contentView addSubview:thread];
    }
    
}
- (void)setPaotuiListModel:(JHPaotuiListModel *)paotuiListModel{
    _paotuiListModel = paotuiListModel;
    _basic.text = [NSString stringWithFormat:@"%@ %@",paotuiListModel.contact,paotuiListModel.mobile];
    _status.text = paotuiListModel.order_status_label;
    _order_id.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),paotuiListModel.order_id];
    _order_time.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:paotuiListModel.dateline]];
    _onTimer.text = GLOBAL(_paotuiListModel.pei_time_label);
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"配送费:￥%@", nil),_paotuiListModel.paotui_amount];
    NSRange range = [_money.text rangeOfString:NSLocalizedString(@"配送费:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    _money.attributedText = attributed;
    _shopName.text = [NSString stringWithFormat:NSLocalizedString(@"商家:%@", nil),paotuiListModel.shop_name];
    _shopDistant.text = paotuiListModel.juli_qidian;
    _shopAddr.text = [NSString stringWithFormat:@"%@%@",paotuiListModel.o_addr,paotuiListModel.o_house];
    _customerAddr.text = [NSString stringWithFormat:NSLocalizedString(@"客户:%@%@", nil),paotuiListModel.addr,paotuiListModel.house];
    _customerDistant.text = paotuiListModel.juli_zhongdian;
    [self handleOrderStatusButton];
}
#pragma mark====处理订单按钮状态========
- (void)handleOrderStatusButton{
    if([_paotuiListModel.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if (([_paotuiListModel.order_status isEqualToString:@"1"] || [_paotuiListModel.order_status isEqualToString:@"2"]) && ![_paotuiListModel.staff_id isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"开始配送", nil) forState:UIControlStateHighlighted];
    }else if ([_paotuiListModel.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已送达", nil) forState:UIControlStateHighlighted];
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
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateNormal];
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateNormal];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateSelected];
        [_statusButton setTitle:_paotuiListModel.order_status_label forState:UIControlStateHighlighted];
    }
}
//时间戳转换时间
- (NSString *)transfromWithStr:(NSString *)string
{
    NSTimeInterval time = [string doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentdateStr = [dateFormatter stringFromDate:detailDate];
    return currentdateStr;
}
@end
