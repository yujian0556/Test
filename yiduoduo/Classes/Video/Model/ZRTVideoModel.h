//
//  ZRTVideoModel.h
//  yiduoduo
//
//  Created by 余健 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTVideoModel : NSObject

////唯一编号
//@property (nonatomic,strong) NSString *Id;
////视频分类
//@property (nonatomic,strong) NSString *SpClassId;
////上传用户编号
//@property (nonatomic,strong) NSString *UserId;
////视频名称
//@property (nonatomic,strong) NSString *Title;
////分类
//@property (nonatomic,strong) NSString *ClassId;
////是否加入学习园地
//@property (nonatomic,strong) NSString *IsXXYD;
////视频来源
//@property (nonatomic,strong) NSString *Froms;
////视频缩略图
//@property (nonatomic,strong) NSString *ImgUrl;
////视频地址
//@property (nonatomic,strong) NSString *VideoPath;
////视频大小
//@property (nonatomic,strong) NSString *Size;
////视频格式
//@property (nonatomic,strong) NSString *Format;
////视频介绍
//@property (nonatomic,strong) NSString *Remark;
////人工定义级别
//@property (nonatomic,strong) NSString *Levels;
////审核情况
//@property (nonatomic,strong) NSString *State;
////点击次数
//@property (nonatomic,strong) NSString *Click;
////一审时间
//@property (nonatomic,strong) NSString *FirstAuditTime;
////二审时间
//@property (nonatomic,strong) NSString *EndAuditTime;
////上传时间
//@property (nonatomic,strong) NSString *AddTime;
//
//
//
////是否首页显示
//@property (nonatomic,strong) NSString *IsShowIndex;
////排序
//@property (nonatomic,strong) NSString *PaiXu;
////医生id
//@property (nonatomic,strong) NSString *DocId;
////昵称
//@property (nonatomic,strong) NSString *NickName;
////头像
//@property (nonatomic,strong) NSString *ImgUrl1;
////科室
//@property (nonatomic,strong) NSString *SectionOffice;
////医生等级
//@property (nonatomic,strong) NSString *Professional;
//
//@property (nonatomic,strong) NSString *rowid;


@property (nonatomic, copy) NSString *DocId;

@property (nonatomic, copy) NSString *IsShowIndex;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *Click;

@property (nonatomic, copy) NSString *AddTime;

@property (nonatomic, copy) NSString *rowid;

@property (nonatomic, copy) NSString *FirstAuditTime;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *SectionOffice;

@property (nonatomic, copy) NSString *PaiXu;

@property (nonatomic, copy) NSString *Size;

@property (nonatomic, copy) NSString *replynum;

@property (nonatomic, copy) NSString *Format;

@property (nonatomic, copy) NSString *ImgUrl1;

@property (nonatomic, copy) NSString *State;

@property (nonatomic, copy) NSString *VideoPath;

@property (nonatomic, copy) NSString *ImgUrl;

@property (nonatomic, copy) NSString *NickName;

@property (nonatomic, copy) NSString *Professional;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *Levels;

@property (nonatomic, copy) NSString *ClassId;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *havescore;

@property (nonatomic, copy) NSString *SpClassId;

@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSString *havecollect;

@property (nonatomic, copy) NSString *IsXXYD;

@property (nonatomic, copy) NSString *Froms;

@property (nonatomic, copy) NSString *EndAuditTime;

@property (nonatomic,strong) NSDictionary *VideoReply;
@property (nonatomic, copy) NSString *collectTime;

+(instancetype)videoModelWithDict:(NSDictionary *)dict;

@end
