//
//  leftCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/4.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "leftCell.h"

@implementation leftCell
{
    UIView *_thread;
    UIImageView *_dirImg;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1];
        [self initSubView];
    }
    return self;
}
#pragma mark==初始化子控件====
- (void)initSubView{
    _img = [[UIImageView alloc] initWithFrame:FRAME(20, 15, 40, 40)];
    _img.image = IMAGE(@"sy_icon01");
    _img.layer.cornerRadius = _img.frame.size.width / 2;
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
    [self.contentView addSubview:_img];
    _title = [[UILabel alloc] init];
    _title.font = FONT(14);
    _title.text = NSLocalizedString(@"订单管理", nil);
    _title.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_title];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _thread = [[UIView alloc] init];
    _thread.backgroundColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];
    [self.contentView addSubview:_thread];
   _dirImg = [[UIImageView alloc] init];
    _dirImg.image = IMAGE(@"btn_arrowr_white");
    [self.contentView addSubview:_dirImg];
}
- (void)configSubViewWithImg:(UIImage *)img title:(NSString *)title frame:(NSInteger)frame{
    _img.image = img;
    _title.text = title;
    _title.frame = FRAME(75, 27.5, frame - 75 - 22, 14);
    _thread.frame =  FRAME(15, 69.5, frame - 30, 0.5);
    _dirImg.frame = FRAME(frame - 22, 29, 7, 12);
}
@end
