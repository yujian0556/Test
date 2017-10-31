//
//  NSString+Regex.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

/** 将GBK编码的二进制数据转换成字符串 */
+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data;



+ (NSString *)stringByReplacing:(NSString *)string;


@end
