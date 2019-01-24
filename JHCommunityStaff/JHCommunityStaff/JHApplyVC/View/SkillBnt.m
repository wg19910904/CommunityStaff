//
//  SkillBnt.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/5.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "SkillBnt.h"

@implementation SkillBnt
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.font = FONT(12);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:HEX(@"cccccc", 1.0f) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setBackgroundColor:THEME_COLOR forState:UIControlStateSelected];
        [self setBackgroundColor:THEME_COLOR forState:UIControlStateHighlighted];
        self.layer.cornerRadius = 4.0f;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = LINE_COLOR.CGColor;
        self.clipsToBounds = YES;
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(50, 0, 10, 10);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return  CGRectMake(0, 0, 60, 30);
}
@end
