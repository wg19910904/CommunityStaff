//
//  JHOtherListCell.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/30.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPaotuiListModel.h"
@interface JHOtherListCell : UITableViewCell
@property (nonatomic,strong)UIButton *mobileButton;//打电话按钮
@property (nonatomic,strong)UIButton *look;//查看路线
@property (nonatomic,strong)UIButton *statusButton;//状态按钮
@property (nonatomic,strong)JHPaotuiListModel *paotuiListModel;@end
