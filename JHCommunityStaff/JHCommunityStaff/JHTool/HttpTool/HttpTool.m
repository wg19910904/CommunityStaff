//
//  HttpTool.m
//  Lunch
//
//  Created by xixixi on 16/2/18.
//  Copyright © 2016年 xixixi. All rights reserved.
//  基于AFNetWoking3.0的网络封装工具

#import "HttpTool.h"
#import "JHShareModel.h"
@implementation HttpTool
@class JHShareModel;
//将字典转换为json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


+ (void)postWithAPI:(NSString *)api withParams:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError * error))failure
{
    //获取当前版本号
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [dic objectForKey:@"CFBundleShortVersionString"];
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString *jsonString = [self dictionaryToJson:params];
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"STAFF",
                                @"CLIENT_OS":@"IOS",
                                @"CLIENT_VER":version,
                                @"CITY_ID":@"0",
                                @"REGISTER_ID":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]? [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]:@"",
                                @"city_code":[JHShareModel shareModel].cityCode ? [JHShareModel shareModel].cityCode : @"0551",
                                @"TOKEN":token,
                                @"data":jsonString,
                                };
    //发起请求
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSLog(@"%@%@",systemDic,IMAGEADDRESS);
    [mgr POST:IPADDRESS parameters:systemDic progress:^(NSProgress * _Nonnull uploadProgress) {}
     
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          
          NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
          NSError *error;
          NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
          

          if (error) {
              NSLog(@"%@-----%@",error.localizedDescription,string);
              error = nil;
              string = nil;
              UIImage * image = [[UIImage alloc]initWithData:responseObject];
              if (success) {
                  success(image);
              }
              return ;
          }
          string = nil;
          if (success) {
              success(JSON);
              NSLog(@" message ===== %@",JSON[@"message"]);
          }
      }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
          if (failure) {
              failure(error);
          }
      }];
}

//http协议上传文件(图片,音频等)
+ (void)postWithAPI:(NSString *)api
             params:(NSDictionary *)params
      fromDataDic:(NSDictionary *)dataDic
            success:(void (^)(id json))success
            failure:(void (^)(NSError *error))failure
{
    //获取当前版本号
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [dic objectForKey:@"CFBundleShortVersionString"];
    //获取token
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"token"];
    token = token == nil ? @"" : token;
    
    //将业务数据转换为json串
    NSString *jsonString = [self dictionaryToJson:params];
    //定义系统级参数字典
    NSDictionary *systemDic = @{@"API":api,
                                @"CLIENT_API":@"STAFF",
                                @"CLIENT_OS":@"IOS",
                                 @"CITY_ID":@"0",
                                @"CLIENT_VER":version,
                                @"city_code":[JHShareModel shareModel].cityCode ? [JHShareModel shareModel].cityCode : @"0551",
                                @"TOKEN":token,
                                @"data":jsonString,
                                };
    NSLog(@"%@",jsonString);
    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",nil];
    [mgr POST:IPADDRESS parameters:systemDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (dataDic.count == 0) {
            // do nothing
        }else{
            for (NSString *key in dataDic) {
                //上传的参数名
                NSData *data = dataDic[key];
                //上传的fileName
                if ([key containsString:@"face"] || [key containsString:@"photo"]) {
                   
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".png"] //文件名
                                            mimeType:@"image/png"];

                }else{
                    [formData appendPartWithFileData:data
                                                name:key
                                            fileName:[key stringByAppendingString:@".mp3"] //文件名
                                            mimeType:@"audio/mpeg"];
                }
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) { }
      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          if (success) {
              success(responseObject);
              NSLog(@" message ===== %@",responseObject[@"message"]);
          }
      }
      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          if (failure) {
              failure(error);
          }
      }];
}
@end
