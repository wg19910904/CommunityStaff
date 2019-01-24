//
//  JHMessageCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/7.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface JHMessageCell : UITableViewCell
@property (nonatomic,strong)UIImageView *readImg;//未读红点
@property (nonatomic,strong)UILabel *title;//标题
@property (nonatomic,strong)UILabel *time;//时间
@property (nonatomic,strong)MessageModel *messageModel;
@end
