//
//  ZRTHealthyModel.h
//  yiduoduo
//
//  Created by Olivier on 15/7/22.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTHealthyModel : NSObject


@property (nonatomic, copy) NSString *UserID;

@property (nonatomic, copy) NSString *TypeID;

@property (nonatomic, copy) NSString *HContent;

@property (nonatomic, copy) NSString *HCreateDate;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *Memo2;

@property (nonatomic, strong) NSDictionary *PicList;

@property (nonatomic, copy) NSString *Topic;

@property (nonatomic, copy) NSString *Memo1;

@property (nonatomic, copy) NSString *Memo3;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *rowid;

+(instancetype)HealthyWithDic:(NSDictionary *)dic;

@end
