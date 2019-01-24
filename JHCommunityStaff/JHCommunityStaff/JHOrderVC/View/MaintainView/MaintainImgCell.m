//
//  MaintainImgCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "MaintainImgCell.h"
#include "UIImageView+WebCache.h"
#import "MyTapGesture.h"
#import "DisplayImageInView.h"
@implementation MaintainImgCell
{
    DisplayImageInView *_displayView;//展示图片
    UIView *_topLine;
    UIView *_bottomLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        _topLine = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        _topLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_topLine];
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:_bottomLine];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark=====展示图片=======
- (void)tapImg:(MyTapGesture *)sender{
    if(_displayView == nil){
        _displayView = [[DisplayImageInView alloc] init];
        [_displayView showInViewWithImageUrlArray:_maintainDetailFrameModel.maintainDetailModel.photos withIndex:sender.tag withBlock:^{
            [_displayView removeFromSuperview];
            _displayView = nil;
        }];
    }
}
- (void)setMaintainDetailFrameModel:(MaintainOrderDetailFrameModel *)maintainDetailFrameModel{
    _maintainDetailFrameModel = maintainDetailFrameModel;
    for(int i = 0; i < maintainDetailFrameModel.maintainDetailModel.photos.count; i ++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(15 + ((WIDTH - 60) / 4  + 10) * i, 10,  (WIDTH - 60) / 4, (WIDTH - 60) / 4)];
        [img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:maintainDetailFrameModel.maintainDetailModel.photos[i]]] placeholderImage:IMAGE(@"pj_pic")];
        img.userInteractionEnabled = YES;
        MyTapGesture *tap = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImg:)];
        [img addGestureRecognizer:tap];
        tap.tag = i + 1;
        [self.contentView addSubview:img];
    }
    _bottomLine.frame = FRAME(0,  (WIDTH - 60) / 4 + 19.5, WIDTH, 0.5);
}
@end
