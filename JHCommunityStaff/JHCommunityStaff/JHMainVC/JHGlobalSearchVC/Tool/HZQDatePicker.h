//
//  HZQDatePicker.h
//  时间选择器
//
//  Created by ijianghu on 16/8/3.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HZQDatePickerDelegate<NSObject>
@optional
-(void)getDatePickerTime:(NSString *)time;
@end
@interface HZQDatePicker : UIView
@property(nonatomic,assign)id<HZQDatePickerDelegate>delegate;
@property(nonatomic,copy)void(^(myBlock))(NSString * time);
@property(nonatomic,assign)BOOL iscanSelectPassTime;
-(void)creatDatePickerWithObj:(HZQDatePicker *)datePicker withDate:(NSDate *)selecterDate;
@end
