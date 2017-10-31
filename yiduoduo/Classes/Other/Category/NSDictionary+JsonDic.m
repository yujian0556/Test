//
//  NSDictionary+JsonDic.m
//  yiduoduo
//
//  Created by moyifan on 15/9/23.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "NSDictionary+JsonDic.h"

@implementation NSDictionary (JsonDic)


+ (NSDictionary *)StringToJsonDictWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}




@end
