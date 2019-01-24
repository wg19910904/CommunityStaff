//
//  SelectedApplyBnt.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/5.
//  Copyright © 2016年 jianghu2. All rights reserved.
//  选择申请按钮,家政阿姨,维修师傅,跑腿哥

#import "SelectedApplyBnt.h"

@implementation SelectedApplyBnt

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setTitleColor:HEX(@"333333", 1.0f) forState:UIControlStateNormal];
        self.titleLabel.font = FONT(14);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 105, 90, 15);
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 90, 90);
}
@end
