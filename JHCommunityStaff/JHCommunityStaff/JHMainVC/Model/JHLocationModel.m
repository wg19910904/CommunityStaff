//
//             cationbModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/10.
//  Copyright © 2016年 jianghu2. All rights reserved.
//实时上报位置

#import "JHLocationModel.h"
#import "HttpTool.h"
#import "AppDelegate.h"
@interface JHLocationModel ()<MAMapViewDelegate>
{
    NSInteger _new_order;
}
@property (nonatomic,assign)CLLocationCoordinate2D nowLocation;//当前坐标
@property (nonatomic,assign)CLLocationCoordinate2D lastLoaction;//上一次坐标
@property (nonatomic,assign)BOOL isScope;//是否在100米范围内
@property (nonatomic,strong)MAMapView *map;//地图
@end
@implementation JHLocationModel
- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}

#pragma mark=====创建地图=========
- (void)initMap{
    _isScope = YES;
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
        
        //上传位置
        NSDictionary *dic = @{@"lat":[NSString stringWithFormat:@"%f",model.bdCoordinate.latitude],
                              @"lng":[NSString stringWithFormat:@"%f",model.bdCoordinate.longitude],
                              @"dateline":@""};
        [HttpTool postWithAPI:@"staff/entry/position" withParams:dic success:^(id json) {
            NSLog(@"%@",json);
            if([json[@"error"] isEqualToString:@"0"]){
                [[NSUserDefaults standardUserDefaults] setObject:json[@"data"][@"dateline"] forKey:@"dateline"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSLog(@"上报位置成功%f=====%f",model.bdCoordinate.latitude,model.bdCoordinate.longitude);
            }else{
                NSLog(@"上报位置失败");

            }
        } failure:^(NSError *error) {
            NSLog(@"error%@",error.localizedDescription);
        }];
  
    } failure:^(NSString *error) {
        
    }];
    
    //60S后 主动上报
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initMap];
    });
}
@end
