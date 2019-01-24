//
//  PaoTuiOtherDetailCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/6/2.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "PaoTuiOtherDetailCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "TransformTime.h"
#import "MyTapGesture.h"
#import "DisplayImageInView.h"
#include "UIImageView+WebCache.h"
@interface PaoTuiOtherDetailCell ()<AVAudioPlayerDelegate>
{
    UILabel *_orderID;//订单ID
    UILabel *_time;//服务时间
    UILabel *_note;//备注
    UIImageView *_recordBck;//录音灰色背景
    UIImageView *_recordImg;//录音图标
    UILabel *_recordSecond;//录音秒数
    AVAudioPlayer *_player;//录音播放
    UIView *_imgBackView;
    DisplayImageInView *_displayView;
    UIView *_bottomLine;
}
@end
@implementation PaoTuiOtherDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma  mark=====初始化子控件====
- (void)initSubViews{
    _orderID = [[UILabel alloc] initWithFrame:FRAME(15, 15 , WIDTH - 30, 15)];
    _orderID.textColor = HEX(@"666666", 1.0f);
    _orderID.font = FONT(12);
    [self.contentView addSubview:_orderID];
    _time = [[UILabel alloc] initWithFrame:FRAME(15, 40 , WIDTH  - 30, 15)];
    _time.textColor = HEX(@"666666", 1.0f);
    _time.font = FONT(12);
    [self.contentView addSubview:_time];
    _note = [[UILabel alloc] init];
    _note.textColor = HEX(@"666666", 1.0f);
    _note.font = FONT(12);
    _note.numberOfLines = 0;
    [self.contentView addSubview:_note];
    _recordBck = [[UIImageView alloc] init];
    _recordBck.image = IMAGE(@"order_voicebg");
    _recordBck.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecord:)];
    [_recordBck addGestureRecognizer:tap];
    _recordImg = [[UIImageView alloc] initWithFrame:FRAME(50, 2.5, 15, 20)];
    NSArray *imgs = @[IMAGE(@"order_voice_signal"),IMAGE(@"order_voice_signal02"),IMAGE(@"order_voice_signal01")];
    _recordImg.image = IMAGE(@"order_voice_signal");
    _recordImg.animationImages = imgs;
    _recordImg.animationRepeatCount = 0;
    _recordImg.animationDuration = 3;
    [_recordBck addSubview:_recordImg];
    _recordSecond = [[UILabel alloc] init];
    _recordSecond.font = FONT(12);
    _recordSecond.textColor = HEX(@"666666", 1.0f);
    _imgBackView = [[UIView alloc] init];
    _imgBackView.backgroundColor = [UIColor whiteColor];
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
}
- (void)setPaotuiFrameModel:(PaoTuiOrderDetailFrameModel *)paotuiFrameModel{
    _paotuiFrameModel = paotuiFrameModel;
    _orderID.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),_paotuiFrameModel.paoTuiDetailModel.order_id];
    _time.text = [NSString stringWithFormat:NSLocalizedString(@"服务时间:%@", nil),[TransformTime transfromWithString:_paotuiFrameModel.paoTuiDetailModel.time]];
    if(_paotuiFrameModel.paoTuiDetailModel.intro.length == 0){
        _note.text = NSLocalizedString(@"备注: (无)", nil);
    }else{
        _note.text = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),_paotuiFrameModel.paoTuiDetailModel.intro];
    }
    _note.frame = _paotuiFrameModel.otherNoteRect;
    _recordBck.frame =  FRAME(15, 75 + _note.frame.size.height, 100, 25);
    _recordSecond.frame = FRAME(120, 80 + _note.frame.size.height , 100, 15);
   _recordSecond.text = [NSString stringWithFormat:@"%@s",_paotuiFrameModel.paoTuiDetailModel.voice_info[@"voice_time"]];
    if(![_paotuiFrameModel.paoTuiDetailModel.voice_info[@"voice"] isEqualToString:@""]){
        [self.contentView addSubview:_recordBck];
        [self.contentView addSubview:_recordSecond];
    }else{
        [_recordBck removeFromSuperview];
        [_recordSecond removeFromSuperview];
    }
    _imgBackView.frame = FRAME(15,_paotuiFrameModel.otherOrderDeatailHeight - 15  - (WIDTH - 60) / 4, WIDTH - 30, (WIDTH - 60) / 4);
    if(_paotuiFrameModel.paoTuiDetailModel.photos.count != 0){
        [self.contentView addSubview:_imgBackView];
        for(int i = 0 ; i < _paotuiFrameModel.paoTuiDetailModel.photos.count ; i ++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:FRAME(((WIDTH - 60) / 4  + 10) * i, 0,  (WIDTH - 60) / 4, (WIDTH - 60) / 4)];
            [img sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_paotuiFrameModel.paoTuiDetailModel.photos[i]]] placeholderImage:IMAGE(@"pj_pic")];
            img.userInteractionEnabled = YES;
            MyTapGesture *tap = [[MyTapGesture alloc] initWithTarget:self action:@selector(tapImg:)];
            [img addGestureRecognizer:tap];
            tap.tag = i + 1;
            [_imgBackView addSubview:img];
        }
    }else{
        [_imgBackView removeFromSuperview];
    }
    _bottomLine.frame = FRAME(0, _paotuiFrameModel.otherOrderDeatailHeight - 0.5, WIDTH, 0.5);
}
#pragma mark ==========播放录音=====================
- (void)tapRecord:(UITapGestureRecognizer *)sender{
    if(_player.playing){
        [_recordImg stopAnimating];
        [_player pause];
        return;
    }
    NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,_paotuiFrameModel.paoTuiDetailModel.voice_info[@"voice"]]]];
    _player = [[AVAudioPlayer alloc] initWithData:myData error:nil];
    _player.delegate = self;
    [_player play];
    [_recordImg startAnimating];
    NSLog(@"播放录音了");
}
#pragma mark ==========音频播放结束执行=====================
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    [_recordImg stopAnimating];
    NSLog(@"歌曲播放完毕");
}
#pragma mark ==========音频播放出现错误=====================
-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"error:%@",error.localizedDescription);
}
#pragma mark=====展示图片=======
- (void)tapImg:(MyTapGesture *)sender{
    if(_displayView == nil){
        _displayView = [[DisplayImageInView alloc] init];
        [_displayView showInViewWithImageUrlArray:_paotuiFrameModel.paoTuiDetailModel.photos withIndex:sender.tag withBlock:^{
            [_displayView removeFromSuperview];
            _displayView = nil;
        }];
    }
}
@end
