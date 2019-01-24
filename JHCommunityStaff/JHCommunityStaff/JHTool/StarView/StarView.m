//
//  StarView.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "StarView.h"

@implementation StarView
- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    for(int i = 0; i < 5;i++){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:FRAME(i * 15, 0, 10, 10)];
        imgView.image = IMAGE(@"star_gray");
        imgView.tag = i + 1;
        [self addSubview:imgView];
    }
}
- (void)setStarWithValue:(NSInteger)star{
    for (int i = 0; i < 5;i++) {
       UIImageView *imgView = (UIImageView *)[self viewWithTag:i + 1];
        imgView.image = IMAGE(@"star_gray");
    }
    for(int i = 0 ; i < star;i++){
        UIImageView *imgView = (UIImageView *)[self viewWithTag:i + 1];
        imgView.image = IMAGE(@"star_orange");
    }
}
@end
