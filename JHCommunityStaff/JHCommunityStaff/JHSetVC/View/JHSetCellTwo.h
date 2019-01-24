//
//  JHSetCellTwo.h
//  JHCommunityStaff
//
//  Created by ijianghu on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface JHSetCellTwo : UITableViewCell
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)UISwitch * mySwitch;
@property(nonatomic,retain)UISlider * mySlider;
@property(nonatomic,retain)UILabel * label_value;//展示音量的值
@property(nonatomic,strong)MPVolumeView *mpVolumeView;
@end
