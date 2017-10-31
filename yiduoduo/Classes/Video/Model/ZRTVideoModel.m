//
//  ZRTVideoModel.m
//  yiduoduo
//
//  Created by 余健 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTVideoModel.h"

@implementation ZRTVideoModel
+(instancetype)videoModelWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
    
}
@end
