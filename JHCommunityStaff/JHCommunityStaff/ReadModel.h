//
//  ReadModel.h
//  ReadText
//
//  Created by ijianghu on 16/6/27.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface ReadModel : NSObject
{
         NSMutableDictionary* soundSet;  //声音设置
         NSString* path;  //配置文件路径
}
@property(nonatomic,assign)float rate;   //语速

@property(nonatomic,assign)float volume; //音量

@property(nonatomic,assign)float pitchMultiplier;  //音调

@property(nonatomic,assign)BOOL autoPlay;  //自动播放
+(ReadModel*)soundPlayerInstance;

-(void)play:(NSString*)text;

-(void)setDefault;

-(void)writeSoundSet;
@end
