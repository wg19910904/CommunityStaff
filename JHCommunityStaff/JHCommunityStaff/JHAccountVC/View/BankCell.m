//
//  BankCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/6.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "BankCell.h"
#import "NSObject+CGSize.h"
@implementation BankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.title = [[UILabel alloc] initWithFrame:FRAME(10, 0, 120, 44)];
        self.title.font = FONT(14);
        self.title.textColor = HEX(@"333333", 1.0f);
        //self.title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.title];
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, self.bounds.size.width, 44)];
        view.backgroundColor = HEX(@"f7f7f7", 1.0f);
        self.selectedBackgroundView = view;
        UIView *thread = [[UIView alloc] initWithFrame:FRAME(0, 43.5, self.bounds.size.width, 0.5)];
        thread.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:thread];
    }
    return self;
}
- (void)setBankTitle:(NSString *)bankTitle{
    _bankTitle = bankTitle;
    
    self.title.text = bankTitle;
}
@end
