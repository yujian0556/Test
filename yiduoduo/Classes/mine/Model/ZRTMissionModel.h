//
//  ZRTMissionModel.h
//  yiduoduo
//
//  Created by moyifan on 15/9/23.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class Ds,Detail;
@interface ZRTMissionModel : NSObject<MJKeyValue>


@property (nonatomic, strong) NSArray<Ds *> *ds;

+(instancetype)ModelWithDic:(NSDictionary *)dic;

@end

@interface Ds : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray<Detail *> *detail;

@property (nonatomic, copy) NSString *tasktype;

@property (nonatomic, copy) NSString *typeid;

+(instancetype)ModelWithDic:(NSDictionary *)dic;

@end

@interface Detail : NSObject

@property (nonatomic, assign) NSInteger taskid;

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) NSString *taskname;

@property (nonatomic, assign) NSInteger datapercent;

@property (nonatomic, copy) NSString *remark;


+(instancetype)ModelWithDic:(NSDictionary *)dic;

@end

