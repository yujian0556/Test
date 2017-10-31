//
//  ZRTTasksModel.m
//  yiduoduo
//
//  Created by moyifan on 15/9/24.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTTasksModel.h"

@implementation ZRTTasksModel


+(instancetype)ModelWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}



+ (NSDictionary *)objectClassInArray{
    return @{@"ds" : [DsForTask class]};
}
@end

@implementation DsForTask

+(instancetype)ModelWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}

@end


