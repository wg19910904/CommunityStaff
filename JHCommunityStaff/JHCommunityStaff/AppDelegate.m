//
//  AppDelegate.m
//  JHCommunityStaff
//
//  Created by jianghu2 on 16/5/3.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "AppDelegate.h"
#import "JHLoginVC.h"
#import <IQKeyboardManager.h>
#import "JHShareModel.h"
#import "Reachability.h"
#import "AFNetworkReachabilityManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "JPUSHService.h"
#import "OpenUDID.h"
#import <AVFoundation/AVFoundation.h>
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>
#import "ReadModel.h"
@interface AppDelegate ()
{
    NSInteger num;
    AVAudioPlayer *_palyer;
    AVAudioPlayer * newOrder_audioPlay;
    AVAudioPlayer * newMsg_audioPlay;
}
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //bugly
    [Bugly startWithAppId:@"1f55ea026a"];
    //友盟统计
    [UMConfigure initWithAppkey:@"5bfdf779f1f556483600089e" channel:@"App Store"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    JHLoginVC *login = [[JHLoginVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    newOrder_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newOrder" ofType:@"mp3"]] error:nil];
    newMsg_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newMsg" ofType:@"mp3"]] error:nil];
    
    //地图相关
    if ([GAODE_KEY length] > 0) {
        [XHMapKitManager shareManager].gaodeKey = GAODE_KEY;
        
    }else if ([GMS_MapKey length] > 0){
        [XHMapKitManager shareManager].gmsMapKey = GMS_MapKey;
        [XHMapKitManager shareManager].theme_color = THEME_COLOR;
    }
    
    //实时上报位置
    _locationModel = [[JHLocationModel alloc] init];
    //断网通知
    [[JHShareModel shareModel] addReachability];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //IQKeyboard
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //注册极光推送
    [self setupJPushWithDic:launchOptions];
   
    //友盟统计
    //保证程序后台运行
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: &setCategoryErr];
    [[AVAudioSession sharedInstance] setActive: YES  error: &activationErr];
    
    [self setUserAgent];
 
    return YES;
}

-(void)setUserAgent{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@/%@",userAgent, @"com.jhcms.ios.sq"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

//注册极光推送
-(void)setupJPushWithDic:(NSDictionary *)dic{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert) categories:nil];
    
    //注册极光推送
    [JPUSHService setupWithOption:dic appKey:JPUSH_KEY channel:@"Publish channel" apsForProduction:NO advertisingIdentifier:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
}
#pragma mark - =====获取极光推送的registrationID=====
-(void)getRegistrationID{
    NSString * registrationID = [JPUSHService registrationID];
    [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //获取极光推送的OPenUDID
    [self getOpenUDID];
}
#pragma mark ========获取极光推送的OPenUDID=========
-(void)getOpenUDID{
    NSString * openUDID = [OpenUDID value];
    [[NSUserDefaults standardUserDefaults] setObject:openUDID forKey:@"openUDID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark =====极光推送必要的方法注册 DeviceToken=====
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    //注册DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark=======注册远程推送失败============
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册远程推送失败%@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:
(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Require
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSString * str = userInfo[@"aps"][@"sound"];
    if ([str containsString:@"newOrder"]) {
        newOrder_audioPlay.volume = 1;
        if (newOrder_audioPlay.isPlaying == NO) {
            [newOrder_audioPlay play];
        }
        //通知有新订单
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEWORDER" object:nil];
    }else if ([str containsString:@"newMsg"]){
        newMsg_audioPlay.volume = 1;
        if (newMsg_audioPlay.isPlaying == NO) {
            [newMsg_audioPlay play];
        }
    }
    
    NSString *shock = [[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] : @"yes";
    
    if([shock isEqualToString:@"yes"]){
        //震动
        AudioServicesAddSystemSoundCompletion(kSystemSoundID_Vibrate, NULL, NULL, systemAudioCallback, NULL);
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        //3秒后移除震动
        [self performSelector:@selector(stopShock) withObject:nil afterDelay:4];
    }else{
        [self stopShock];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    UIApplication *app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
            }
        });
    });
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //程序即将进入前台的一些操作
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];

}
- (void)applicationWillTerminate:(UIApplication *)application {
}
#pragma mark=====关闭振动=========
- (void)stopShock{
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
}
#pragma mark=========震动=======
void systemAudioCallback(){
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
@end
