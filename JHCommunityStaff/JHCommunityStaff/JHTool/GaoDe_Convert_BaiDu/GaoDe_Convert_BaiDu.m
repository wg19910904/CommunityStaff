//
//  GaoDe_To_BaiDu.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/24.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "GaoDe_Convert_BaiDu.h"

@implementation GaoDe_Convert_BaiDu
const double MAP_x_pi_p = M_PI * 3000.0 / 180.0;
/**
 *  实现高德坐标转换为百度坐标
 */
+(void)transform_gaode_to_baiduWithGD_lat:(double)gd_lat
                                WithGD_lon:(double)gd_lon
                                WithBD_lat:(double *)bd_lat
                                WithBD_lon:(double *)bd_lon
{
//    double x = gd_lon, y = gd_lat;
//    double z = sqrt(x * x + y * y) + 0.00002 * sin(y *  MAP_x_pi_p);
//    double theta = atan2(y, x) + 0.000003 * cos(x *  MAP_x_pi_p);
//    *bd_lon = z * cos(theta) + 0.0065;
//    *bd_lat = z * sin(theta) + 0.006;
     *bd_lon = gd_lon;
     *bd_lat = gd_lat;
}

/**
 *  实现百度坐标转换为高德坐标
 */
+(void)transform_baidu_to_gaodeWithBD_lat:(double)bd_lat
                               WithBD_lon:(double)bd_lon
                               WithGD_lat:(double *)gd_lat
                               WithGD_lon:(double *)gd_lon
{
//    double x_pi = M_PI * 3000.0 / 180.0;
//    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
//    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
//    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
//    *gd_lon = z * cos(theta);
//    *gd_lat = z * sin(theta);
    *gd_lon = bd_lon;
    *gd_lat = bd_lat;
}

@end
