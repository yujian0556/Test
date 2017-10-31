//
//  ZRTHealthyModel.m
//  yiduoduo
//
//  Created by Olivier on 15/7/22.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHealthyModel.h"

@implementation ZRTHealthyModel

+(instancetype)HealthyWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}
@end
