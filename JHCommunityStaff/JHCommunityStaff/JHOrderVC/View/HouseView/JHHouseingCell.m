//
//  JHHouseingCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHHouseingCell.h"
#import "HttpTool.h"
#import "TransformTime.h"
#import "AppDelegate.h"
@interface JHHouseingCell ()
@property (nonatomic,strong)UIImageView *typeImg;//类型图片:家庭保洁或洗衣洗鞋等
@property (nonatomic,strong)UILabel *typeLbel;//类型名称
@property (nonatomic,strong)UILabel *basic;//姓名 + 电话号码
//@property (nonatomic,strong)UILabel *mobile;//
@property (nonatomic,strong)UILabel *status;//订单状态
@property (nonatomic,strong)UILabel *orderId;//订单号
@property (nonatomic,strong)UILabel *orderTime;//下单时间
@property (nonatomic,strong)UILabel *destination;//目的地
@property (nonatomic,strong)UILabel *note;//备注
@property (nonatomic,strong)UILabel *distant;//距离
@property (nonatomic,strong)UILabel *money;//定金

@end

@implementation JHHouseingCell
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
    NSArray *imgArray = @[@"order_icon01",@"order_icon02",@"order_icon03",@"order_icon07"];
    for(int i = 0; i < 4;i++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15 ,55 + 30 * i, 15, 15)];
        img.layer.cornerRadius = img.frame.size.width / 2;
        img.clipsToBounds = YES;
        img.image = IMAGE(imgArray[i]);
        [self.contentView addSubview:img];
    }
    _orderId = [[UILabel alloc] initWithFrame:FRAME(40, 15 + 40, WIDTH - 40 - 15 - 30, 15)];
    _orderId.textColor = HEX(@"666666", 1.0f);
    _orderId.font = FONT(12);
    
    [self.contentView addSubview:_orderId];
    _orderTime = [[UILabel alloc] initWithFrame:FRAME(40, 45 + 40, WIDTH - 40 - 15 - 30, 15)];
    _orderTime.textColor = HEX(@"666666", 1.0f);
    _orderTime.font = FONT(12);
   
    [self.contentView addSubview:_orderTime];
    _destination = [[UILabel alloc] initWithFrame:FRAME(40, 75 + 40, WIDTH - 40 - 95, 15)];
    _destination.textColor = HEX(@"666666", 1.0f);
    _destination.font = FONT(12);
   
    [self.contentView addSubview:_destination];
    _note = [[UILabel alloc] initWithFrame:FRAME(40, 105 + 40, WIDTH - 40 - 15 - 30, 15)];
    _note.textColor = HEX(@"666666", 1.0f);
    _note.font = FONT(12);
    
    [self.contentView addSubview:_note];
    self.mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mobileButton.frame = FRAME(WIDTH - 45, 15 + 40, 30, 30);
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateNormal];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateSelected];
    [_mobileButton setBackgroundImage:IMAGE(@"order_call") forState:UIControlStateHighlighted];
    [self.contentView addSubview:_mobileButton];
    _distant = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 95, 115, 80, 15)];
    _distant.font = FONT(12);
    _distant.textAlignment = NSTextAlignmentRight;
    _distant.textColor = HEX(@"ff6600", 1.0f);
    
    [self.contentView addSubview:_distant];
    _money = [[UILabel alloc] initWithFrame:FRAME(0, 175, WIDTH / 3, 44)];
    _money.font = FONT(14);
    _money.textColor = HEX(@"ff6600", 1.0f);
    _money.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_money];
    _look = [UIButton buttonWithType:UIButtonTypeCustom];
    _look.frame = FRAME(WIDTH / 3, 175, WIDTH / 3, 44);
     _look.titleLabel.font = FONT(14);
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateNormal];
    [_look setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateSelected];
    [_look setTitle:NSLocalizedString(@"查看路线", nil) forState:UIControlStateHighlighted];
    [self.contentView addSubview:_look];
    _statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusButton.frame = FRAME(WIDTH / 3 * 2, 175, WIDTH / 3, 44);
    _statusButton.titleLabel.font = FONT(14);
    [self.contentView addSubview:_statusButton];
}

#pragma mark======添加线条======
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
                thread.frame = FRAME(0, 134.5 + 40, WIDTH, 0.5);
            }
                break;

            case 3:
            {
                thread.frame = FRAME(0, 135 + 40 + 43.5, WIDTH, 0.5);
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
        thread.frame = FRAME((WIDTH / 3) * (i + 1) - 0.5, 175, 0.5, 44);
        [self.contentView addSubview:thread];
    }
    
}
- (void)setHouseingModel:(JHHouseingListModel *)houseingModel{
    _houseingModel = houseingModel;
    _typeLbel.text = houseingModel.cate_title;
    _basic.text = [NSString stringWithFormat:@"%@ %@",houseingModel.contact,houseingModel.mobile];
    _status.text = houseingModel.order_status_label;
    _orderId.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),houseingModel.order_id];
    _orderTime.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:houseingModel.dateline]];
    _destination.text = [NSString stringWithFormat:NSLocalizedString(@"目的地:%@%@", nil),houseingModel.addr,houseingModel.house];
    _distant.text = houseingModel.juli_label;
    if(houseingModel.intro.length == 0){
        _note.text = NSLocalizedString(@"备注: (无)", nil);
    }else{
        _note.text = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),houseingModel.intro];
    }
    _money.text = [NSString stringWithFormat:NSLocalizedString(@"定金:￥%@", nil),houseingModel.danbao_amount];
    NSRange range = [_money.text rangeOfString:NSLocalizedString(@"定金:", nil)];
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:_money.text];
    [attributed addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1.0f)} range:range];
    _money.attributedText = attributed;
    [self handleStatusButton];
}
#pragma mark=====处理订单状态按钮点击事件======
- (void)handleStatusButton{

    if([_houseingModel.order_status isEqualToString:@"0"] ){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"接单", nil) forState:UIControlStateHighlighted];
    }else if([_houseingModel.order_status isEqualToString:@"1"]  ||  [_houseingModel.order_status isEqualToString:@"2"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"开始服务", nil) forState:UIControlStateHighlighted];
    }else if([_houseingModel.order_status isEqualToString:@"3"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"完成服务", nil) forState:UIControlStateHighlighted];
    }
    else if ([_houseingModel.order_status isEqualToString:@"4"]){
        _statusButton.userInteractionEnabled = YES;
        [_statusButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"设定总额", nil) forState:UIControlStateHighlighted];
        
    }else if ([_houseingModel.order_status isEqualToString:@"5"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"已设定总额", nil) forState:UIControlStateHighlighted];
    }
    else if ([_houseingModel.order_status isEqualToString:@"8"] && [_houseingModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        _statusButton.userInteractionEnabled = NO;
        [_statusButton setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateNormal];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateSelected];
        [_statusButton setTitle:NSLocalizedString(@"订单完成", nil) forState:UIControlStateHighlighted];
    }else if([_houseingModel.order_status isEqualToString:@"8"] && ![_houseingModel.comment_info[@"comment_id"] isEqualToString:@"0"]){
        if([_houseingModel.comment_info[@"reply_time"] isEqualToString:@"0"]){
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
    }

}
@end
