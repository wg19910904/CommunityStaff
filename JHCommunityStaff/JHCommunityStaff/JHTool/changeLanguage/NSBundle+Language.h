//
//  NSBundle+Language.h
//  Lunch
//
//  Created by jianghu1 on 16/5/6.
//  Copyright © 2016年 jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Language)

/*
 
 设置当前app的语言
 @param   要设置的语言的标志
 
 */
+(void)setCurrentLanguage:(NSString *)code;
@end
