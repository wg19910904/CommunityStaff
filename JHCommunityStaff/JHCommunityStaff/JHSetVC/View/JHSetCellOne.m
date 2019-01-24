//
//  JHSetCellOne.m
//  JHCommunityStaff
//
//  Created by ijianghu on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHSetCellOne.h"

@implementation JHSetCellOne
{
    UILabel * label_intro;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     
    
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.backgroundColor = BACK_COLOR;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 6) {
//           self.textLabel.text = NSLocalizedString(@"音量", nil);
//           self.textLabel.font = [UIFont systemFontOfSize:14];
//           self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    }else if (indexPath.row == 2 && label_intro == nil){
        label_intro = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, WIDTH - 45, 35)];
        label_intro.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        label_intro.text = NSLocalizedString(@"如果你要开启或者关闭该应用的订单提醒通知,请在iPhone的'设置'-'通知'功能中,找到应用程序更改状态", nil);
        label_intro.numberOfLines = 0;
        label_intro.adjustsFontSizeToFitWidth = YES;
        label_intro.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_intro];
    }
}
@end
