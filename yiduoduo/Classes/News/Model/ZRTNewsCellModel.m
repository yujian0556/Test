//
//  ZRTNewsCellModel.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/24.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTNewsCellModel.h"

@implementation ZRTNewsCellModel


+(instancetype)newsModelWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
    
}



@end
