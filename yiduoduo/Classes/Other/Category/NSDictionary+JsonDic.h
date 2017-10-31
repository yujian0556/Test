//
//  NSDictionary+JsonDic.h
//  yiduoduo
//
//  Created by moyifan on 15/9/23.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JsonDic)


+ (NSDictionary *)StringToJsonDictWithJsonString:(NSString *)jsonString;

@end
