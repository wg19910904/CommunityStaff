//
//  WaiMaiCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/12.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "WaiMaiProductCell.h"

@implementation WaiMaiProductCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 39.5, WIDTH, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
        [self initSubViews];
    }
    return self;
}
#pragma mark======初始化子控件=======
- (void)initSubViews{
    self.title = [[UILabel alloc] initWithFrame:FRAME(15, 14.5, 200, 15)];
    self.title.font = FONT(12);
    self.title.textColor = HEX(@"333333", 1.0f);
    
    [self.contentView addSubview:self.title];
    self.num = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 115, 14.5, 100, 15)];
    self.num.font = FONT(12);
    self.num.textAlignment = NSTextAlignmentRight;
    self.num.textColor = HEX(@"333333", 1.0f);
    [self.contentView addSubview:self.num];
    
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.title.text = [NSString stringWithFormat:NSLocalizedString(@"%@ ￥%@", nil),dataDic[@"product_name"],dataDic[@"product_price"]];
    self.num.text = [NSString stringWithFormat:@"x%@",dataDic[@"product_number"]];
}
@end
