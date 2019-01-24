//
//  JHPaiotuiOtherMapVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/31.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHPaotuiOtherMapVC : JHBaseVC
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *staff_id;
@property (nonatomic,strong)NSDictionary *comment_info;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@property (nonatomic,copy)NSString *paoTuiAmount;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *order_status_label;
@end
