//
//  JHLocationbModel.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface JHLocationModel : NSObject
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy)NSString *shock;
@property (nonatomic,assign)BOOL orderRemind;
@property (nonatomic,strong)AVAudioPlayer *player;
- (void)initMap;
@end
