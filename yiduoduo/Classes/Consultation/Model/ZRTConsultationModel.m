
//
//  ZRTConsultationModel.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationModel.h"

@implementation ZRTConsultationModel

+(instancetype)consultationModelWithDict:(NSDictionary *)dict
{
    id obj = [[self alloc] init];
    
    [obj setValuesForKeysWithDictionary:dict];
    
    return obj;
    
}

@end