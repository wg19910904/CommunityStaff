//
//  MaintainOrderdetailCell.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/25.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "MaintainOrderdetailCell.h"
#import "TransformTime.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "NSObject+CGSize.h"
@interface MaintainOrderdetailCell ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer *_player;//录音播放
    UIView *_bottomLine;//底部边线
}
@end
@implementation MaintainOrderdetailCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initSubView];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  self;
}
#pragma mark===初始化子控件=======
- (void)initSubView{
    _orderID = [[UILabel alloc] initWithFrame:FRAME(15, 15 , WIDTH - 30, 15)];
    _orderID.textColor = HEX(@"666666", 1.0f);
    _orderID.font = FONT(12);
    [self.contentView addSubview:_orderID];
    _project = [[UILabel alloc] initWithFrame:FRAME(15, 40 , WIDTH - 30, 15)];
    _project.textColor = HEX(@"666666", 1.0f);
    _project.font = FONT(12);
    [self.contentView addSubview:_project];
    _fuwutimeLabel = [[UILabel alloc] initWithFrame:FRAME(15, 65, WIDTH - 30, 15)];
    _fuwutimeLabel.textColor = HEX(@"666666", 1.0f);
    _fuwutimeLabel.font = FONT(12);
    [self.contentView addSubview:_fuwutimeLabel];
    
    _time = [[UILabel alloc] initWithFrame:FRAME(15, 90 , WIDTH  - 30, 15)];
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
    _recordImg = [[UIImageView alloc] initWithFrame:FRAME(50, 2.5, 15, 20)];
    NSArray *imgs = @[IMAGE(@"order_voice_signal"),IMAGE(@"order_voice_signal02"),IMAGE(@"order_voice_signal01")];
    _recordImg.image = IMAGE(@"order_voice_signal");
    _recordImg.animationImages = imgs;
    _recordImg.animationRepeatCount = 0;
    _recordBck.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecord:)];
    [_recordBck addGestureRecognizer:tap];
    [_recordBck addSubview:_recordImg];
    _recordSecond = [[UILabel alloc] init];
    _recordSecond.font = FONT(12);
    _recordSecond.textColor = HEX(@"666666", 1.0f);
    _bottomLine = [[UIView alloc] init];
    _bottomLine.backgroundColor = LINE_COLOR;
    [self.contentView addSubview:_bottomLine];
}
- (void)setMaintainOrderDetailFrameModel:(MaintainOrderDetailFrameModel *)maintainOrderDetailFrameModel{
    _maintainOrderDetailFrameModel = maintainOrderDetailFrameModel;
    _orderID.text = [NSString stringWithFormat:NSLocalizedString(@"订单ID:%@", nil),maintainOrderDetailFrameModel.maintainDetailModel.order_id];
    _fuwutimeLabel.text = [NSString stringWithFormat:NSLocalizedString(@"服务时间:%@", nil),[TransformTime transfromWithString:maintainOrderDetailFrameModel.maintainDetailModel.fuwu_time]];
    _project.text = [NSString stringWithFormat:NSLocalizedString(@"预约项目:%@", nil),maintainOrderDetailFrameModel.maintainDetailModel.cate_title];
    _time.text = [NSString stringWithFormat:NSLocalizedString(@"下单时间:%@", nil),[TransformTime transfromWithString:maintainOrderDetailFrameModel.maintainDetailModel.dateline]];
    _note.frame = maintainOrderDetailFrameModel.contentRect;
    if(maintainOrderDetailFrameModel.maintainDetailModel.intro.length == 0){
        _note.text = NSLocalizedString(@"备注: (无)", nil);
    }else{
        _note.text = [NSString stringWithFormat:NSLocalizedString(@"备注:%@", nil),maintainOrderDetailFrameModel.maintainDetailModel.intro];
    }
    _recordBck.frame = maintainOrderDetailFrameModel.recordRect;
    _recordSecond.frame = maintainOrderDetailFrameModel.recordSecondRect;
    _recordImg.animationDuration = [maintainOrderDetailFrameModel.maintainDetailModel.voice_info[@"voice_time"] floatValue];
    _recordSecond.text = [NSString stringWithFormat:@"%@s",maintainOrderDetailFrameModel.maintainDetailModel.voice_info[@"voice_time"]];
    if([maintainOrderDetailFrameModel.maintainDetailModel.voice_info[@"voice"] isEqualToString:@""]){
        [_recordSecond removeFromSuperview];
        [_recordBck removeFromSuperview];
    }else{
        [self.contentView addSubview:_recordBck];
        [self.contentView addSubview:_recordSecond];
    }
    _bottomLine.frame = FRAME(0, maintainOrderDetailFrameModel.orderDetailHeight - 0.5, WIDTH, 0.5);
}
#pragma mark ==========播放录音=====================
- (void)tapRecord:(UITapGestureRecognizer *)sender{
    if(_player.playing){
        [_recordImg stopAnimating];
        [_player pause];
        return;
    }
    NSData *myData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_maintainOrderDetailFrameModel.maintainDetailModel.voice_info[@"voice"]]]];
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
@end
