//
//  JHSetCellTwo.m
//  JHCommunityStaff
//
//  Created by ijianghu on 16/5/9.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHSetCellTwo.h"
#import <AVFoundation/AVFoundation.h>

@implementation JHSetCellTwo
{
    UIView * label_one;//分割线上
    UIView * label_two;//分割线下
    NSArray * array;
    UILabel * label_state;//显示是否已经开启订单提醒的
    UILabel * label_vison;//显示版本号的
    UILabel * label_voice;
    BOOL isOpen;//判断推送是否开启
    
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.row == 9) {
        
    }else{
        if (array == nil) {
            array = @[@"",NSLocalizedString(@"开启订单提醒", nil),@"",NSLocalizedString(@"震动", nil),@"",@"",@"",@"",@"",NSLocalizedString(@"检查更新", nil)];
        }
        isOpen = [self pushNotificationsEnabled];
        [[NSUserDefaults standardUserDefaults] setBool:isOpen forKey:@"orderRemind"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.text = array[indexPath.row];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 3) {
            if (_mySwitch == nil) {
                _mySwitch = [[UISwitch alloc]init];
                _mySwitch.frame = FRAME(WIDTH - 60, 7, 60, 20);
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] isEqualToString:@"yes"]) {
                    _mySwitch.on = YES;
                }else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] != nil && [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] isEqualToString:@"no"]){
                    _mySwitch.on = NO;
                }else{
                    _mySwitch.on = YES;
                }
                if(_mySwitch.on){
                    [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"switch"];
                    
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"switch"];
                }
                [[NSUserDefaults standardUserDefaults] synchronize];
                _mySwitch.onTintColor = THEME_COLOR;
                [self addSubview:_mySwitch];
                
            }
        }else if(indexPath.row == 7) {
            self.contentView.backgroundColor = BACK_COLOR;
//            if (_mySlider == nil) {
//                //创建左右两边的喇叭
//                UIImageView * imageView_left = [[UIImageView alloc]init];
//                imageView_left.frame = CGRectMake(10, 24, 10, 10);
//                imageView_left.image = [UIImage imageNamed:@"volume_left"];
//                [self.contentView addSubview:imageView_left];
//                UIImageView * imageView_right = [[UIImageView alloc]init];
//                imageView_right.frame = CGRectMake(WIDTH - 20, 24, 10, 10);
//                imageView_right.image = [UIImage imageNamed:@"volume_right"];
//                [self.contentView addSubview:imageView_right];
//                _mySlider = [[UISlider alloc] init];
//                _mySlider.frame = CGRectMake(25, 20, WIDTH - 50, 20);
//                _mySlider.minimumTrackTintColor = THEME_COLOR;
//                _mySlider.minimumValue = 0;
//                _mySlider.maximumValue = 100;
//                [self.contentView addSubview:_mySlider];
//                //创建显示音量的大小的label
//                _label_value = [[UILabel alloc]init];
//                _label_value.textAlignment = NSTextAlignmentCenter;
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"value"] != nil) {
//                    float num = [[[NSUserDefaults standardUserDefaults] objectForKey:@"value"] floatValue];
//                    float n = num / 100;
//                    _label_value.frame = FRAME(25+(WIDTH - 70) * n,2,25, 12);
//                    _label_value.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"value"];
//                    _mySlider.value = num;
//                    [_mySlider setValue:num animated:YES];
//                }else{
//                    _label_value.frame = FRAME(25+(WIDTH - 70)* 0.5, 2,25,12);
//                    _label_value.text = @"50";
//                    _mySlider.value = 50;
//                }
//                _label_value.textColor = THEME_COLOR;
//                _label_value.font = [UIFont systemFontOfSize:12];
//                [self.contentView addSubview:_label_value];
//                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",(int)_mySlider.value] forKey:@"value"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
        }
        if (indexPath.row != 9 ) {
            if (indexPath.row == 5) {
                self.contentView.backgroundColor = BACK_COLOR;
//                if (label_voice == nil) {
//                    label_voice = [[UILabel alloc]init];
//                    label_voice.frame = FRAME(WIDTH - 120, 10, 100, 24);
//                    label_voice.textAlignment = NSTextAlignmentCenter;
//                    label_voice.textColor = [UIColor colorWithWhite:0.75 alpha:1];;
//                    label_voice.font = [UIFont systemFontOfSize:14];
//                    [self.contentView addSubview:label_voice];
//                }
//                label_voice.text = NSLocalizedString(@"语音提示音", nil);
//                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                self.accessoryType = UITableViewCellAccessoryNone;
            }
        }else{
            self.contentView.backgroundColor = BACK_COLOR;
//            if(label_vison == nil){
//                label_vison  = [[UILabel alloc]init];
//                label_vison.frame = FRAME(WIDTH - 80, 10, 60, 24);
//                label_vison.textAlignment = NSTextAlignmentCenter;
//                label_vison.textColor = [UIColor colorWithWhite:0.75 alpha:1];
//                label_vison.font = [UIFont systemFontOfSize:14];
//                [self.contentView addSubview:label_vison];
//            }
//            label_vison.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
//            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if(indexPath.row == 1 && label_state == nil){
            label_state = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 70, 10, 60, 20)];
            label_state.textColor = [UIColor colorWithWhite:0.75 alpha:1];
            label_state.font = [UIFont systemFontOfSize:14];
            label_state.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:label_state];
        }
        if(isOpen){
            label_state.text = NSLocalizedString(@"已开启", nil);
        }else{
            label_state.text = NSLocalizedString(@"未开启", nil);
        }
        if (label_one == nil) {
            label_one = [[UIView alloc]init];
            label_one.frame = CGRectMake(0, 0, WIDTH, 0.5);
            label_one.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
            [self.contentView addSubview:label_one];
            label_two = [[UIView alloc]init];
            if(indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 6 || indexPath.row == 5){
                label_two.hidden = YES;
                label_one.hidden = YES;
                //label_two.frame = CGRectMake(0, 49.5, WIDTH, 0.5);
            }else{
                label_two.frame = CGRectMake(0, 43.5, WIDTH, 0.5);
            }
            label_two.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];;
            [self.contentView addSubview:label_two];
        }

    }
    
}
#pragma mark===当前推送状态=====
- (BOOL)pushNotificationsEnabled {
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
}
@end
