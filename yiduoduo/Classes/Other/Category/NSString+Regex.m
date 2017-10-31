//
//  NSString+Regex.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "NSString+Regex.h"

@implementation NSString (Regex)

+ (NSString *)UTF8StringWithHZGB2312Data:(NSData *)data
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc] initWithData:data encoding:encoding];
}





+ (NSString *)stringByReplacing:(NSString *)string

{

    string = [string stringByReplacingOccurrencesOfString:@"huiche" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"kongge" withString:@"\r"];

    return string;
}




@end
