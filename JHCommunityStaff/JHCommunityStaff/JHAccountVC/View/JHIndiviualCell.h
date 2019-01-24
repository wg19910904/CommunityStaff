//
//  JHIndiviualCell.h
//  JHCommunityStaff
//
//  Created by ijianghu on 16/6/23.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHIndiviualCell : UITableViewCell
@property(nonatomic,copy)NSString * info;
@property(nonatomic,retain)UITextView * textView;
@property(nonatomic,retain)UIButton * btn;
@end
