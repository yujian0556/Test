//
//  ZRTConsultationDetailModel.h
//  yiduoduo
//
//  Created by Olivier on 15/6/1.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTConsultationDetailModel : NSObject
//科室id
@property (nonatomic,strong) NSNumber *ClassId;

//会诊id
@property (nonatomic,strong) NSNumber *ConsultationId;

//内容
@property (nonatomic,strong) NSString *Contents;

//发布时间
@property (nonatomic,strong) NSString *AddTime;

//用户id
@property (nonatomic,strong) NSNumber *UserId;

//是否收藏
@property (nonatomic,strong) NSNumber *isFavorite;



@property (nonatomic,strong) NSString *headerImageURLString;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *officeName;
@property (nonatomic,strong) NSString *doctorRank;

@property (nonatomic,strong) NSMutableArray *picturesArray;

@property (nonatomic,strong) NSNumber *favoriteNumber;
@property (nonatomic,strong) NSNumber *commentNumber;
@property (nonatomic,strong) NSNumber *shareNumber;

@property (nonatomic,strong) NSMutableArray *commentArray;

@end
