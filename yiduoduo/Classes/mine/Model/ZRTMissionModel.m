//
//  ZRTMissionModel.m
//  yiduoduo
//
//  Created by moyifan on 15/9/23.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTMissionModel.h"

@implementation ZRTMissionModel

+(instancetype)ModelWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}



+ (NSDictionary *)objectClassInArray{
    return @{@"ds" : [Ds class]};
}
@end


@implementation Ds

+(instancetype)ModelWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}

+ (NSDictionary *)objectClassInArray{
    return @{@"detail" : [Detail class]};
}

@end


@implementation Detail


+(instancetype)ModelWithDic:(NSDictionary *)dic
{
    
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dic];
    
    return obj;
}

@end


