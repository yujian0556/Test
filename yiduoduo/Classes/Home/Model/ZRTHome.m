//
//  ZRTHome.m
//  yiwen
//
//  Created by 莫一凡 on 15/4/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHome.h"

@implementation ZRTHome

+(instancetype)HomeWithDic:(NSDictionary *)dic
{

    id obj = [[self alloc] init];

    [obj setValuesForKeysWithDictionary:dic];

    return obj;
}

@end
