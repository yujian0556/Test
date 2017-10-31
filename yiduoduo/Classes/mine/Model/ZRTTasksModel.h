//
//  ZRTTasksModel.h
//  yiduoduo
//
//  Created by moyifan on 15/9/24.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DsForTask;
@interface ZRTTasksModel : NSObject



@property (nonatomic, assign) NSInteger score;

@property (nonatomic, strong) NSArray<DsForTask *> *ds;

+(instancetype)ModelWithDic:(NSDictionary *)dic;

@end
@interface DsForTask : NSObject

@property (nonatomic, copy) NSString *Memo3;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *Memo1;

@property (nonatomic, copy) NSString *AccessWay;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *Memo4;

@property (nonatomic, assign) NSInteger CurrentScore;

@property (nonatomic, assign) NSInteger SID;

@property (nonatomic, copy) NSString *SerialNumber;

@property (nonatomic, copy) NSString *Memo2;

@property (nonatomic, copy) NSString *CurrentDate;

@property (nonatomic, copy) NSString *Memo5;

+(instancetype)ModelWithDic:(NSDictionary *)dic;

@end

