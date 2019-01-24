//
//  NSBundle+Language.m
//  Lunch
//
//  Created by jianghu1 on 16/5/6.
//  Copyright © 2016年 jianghu. All rights reserved.
//

#import "NSBundle+Language.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
static const char _bundle=0;

@interface BundleEx : NSBundle
@end


@implementation BundleEx
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName{

    NSBundle * bundle = objc_getAssociatedObject(self, &_bundle);
    if (bundle) {
        
        return [bundle localizedStringForKey:key value:value table:tableName];
        
    }
    else{
    
        return  [super localizedStringForKey:key value:value table:tableName];
    }
}
@end

@implementation NSBundle (Language)
+(void)setCurrentLanguage:(NSString *)code{

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        object_setClass([NSBundle mainBundle],[BundleEx class]);
        
    });
    
    objc_setAssociatedObject([NSBundle mainBundle], &_bundle,code ? [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:code ofType:@"lproj" ]]:nil,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
