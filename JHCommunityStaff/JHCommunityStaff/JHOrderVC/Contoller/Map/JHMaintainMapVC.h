//
//  JHMaintainMapVC.h
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/13.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHMaintainMapVC : JHBaseVC
@property (nonatomic,copy)NSString *order_status;
@property (nonatomic,copy)NSString *pay_status;
@property (nonatomic,strong)NSDictionary *comment_info;
@property (nonatomic,copy)NSString *status_label;
@property (nonatomic,copy)NSString *order_id;
@property (nonatomic,copy)NSString *danBao;
@property (nonatomic,copy)NSString *lat;
@property (nonatomic,copy)NSString *lng;
@end
