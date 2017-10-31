//
//  ZRTConsultationModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZRTConsultationModel : NSObject

@property (nonatomic, copy) NSString *DocId;

@property (nonatomic, copy) NSString *IsShowIndex;

@property (nonatomic, strong) NSDictionary *ConsultationReplay;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *IsIndexImg;

@property (nonatomic, copy) NSString *AddTime;

@property (nonatomic, strong) NSDictionary *ImgList;

@property (nonatomic, copy) NSString *rowid;

@property (nonatomic, copy) NSString *SectionOffice;

@property (nonatomic, copy) NSString *PaiXu;

@property (nonatomic, copy) NSString *Professional;

@property (nonatomic, copy) NSString *Title2;

@property (nonatomic, copy) NSString *ReplayCount;

@property (nonatomic, copy) NSString *State;

@property (nonatomic, copy) NSString *NickName;

@property (nonatomic, copy) NSString *ImgUrl;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *ClassId;

@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSString *havecollect;

@property (nonatomic, copy) NSString *Contents;

@property (nonatomic, copy) NSString *collectnum;

@property (nonatomic,copy) NSString *collectTime;
/*
 
 "ConsultationReplay":[
 {
 "Id":"55",
 "TopicId":"27",
 "UserId":"7",
 "Contents":"6546rtyrtyrt547546546546",
 "AddTime":"2015/6/23 10:53:02"
 },*/

+(instancetype)consultationModelWithDict:(NSDictionary *)dict;

@end


