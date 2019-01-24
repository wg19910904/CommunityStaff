//
//  JHReachabiltyModel.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/13.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "JHShareModel.h"
#import "AppDelegate.h"
#import "HttpTool.h"
@implementation JHShareModel
static JHShareModel *model = nil;

+ (JHShareModel *)shareModel{
    static JHShareModel *model = nil;
    if (!model) {
        model = [[JHShareModel alloc] init];
        if (SHOW_COUNTRY_CODE) {
            [model get_def_code];
        }
    }
    return model;
}

//获取默认的区号
- (void)get_def_code{
    [HttpTool postWithAPI:@"magic/get_default_code"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"magic/get_default_code------------%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          self.def_code = json[@"data"][@"code_code"];
                      }
                  } failure:^(NSError *error) {
                      
                  }];
}


#pragma mark===========网络监听=================
- (void)addReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
     _hostReach = [Reachability reachabilityForInternetConnection];
    [_hostReach startNotifier];
}
#pragma mark=======网络监听响应方法============
- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability *curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self getNetStatusWithReachability:curReach];
}
#pragma mark=======获取当前网络的相关状态=======
- (void)getNetStatusWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    if(status == NotReachable){
        [self showAlertView:NSLocalizedString(@"网络连接失败,请重新链接", nil)];
    }else if(status ==  ReachableViaWWAN){
        [self showAlertView:NSLocalizedString(@"正在使用蜂窝网络", nil)];
    }else if(status == ReachableViaWiFi){
        [self showAlertView:NSLocalizedString(@"wifi已链接", nil)];
    }
}

#pragma mark=======提示框==========
- (void)showAlertView:(NSString *)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示", nil) message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}
-(NSString *)version{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *vers = dic[@"CFBundleShortVersionString"];
    return  vers;
}

- (NSString *)def_code{
    if (_def_code.length) {
        return _def_code;
    }
    return @"";
}

@end
