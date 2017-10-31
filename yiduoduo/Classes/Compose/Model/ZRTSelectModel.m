
//
//  ZRTSelectModel.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSelectModel.h"

@implementation ZRTSelectModel


+(instancetype)ModelWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
    
}



@end
