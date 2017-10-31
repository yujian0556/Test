//
//  ZRTCaseModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTCaseModel : NSObject



@property (nonatomic, copy) NSString *SFJL;

@property (nonatomic, copy) NSString *Nation;

@property (nonatomic, copy) NSString *JBZD;

@property (nonatomic, copy) NSString *CKWX;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *IsShowIndex;

@property (nonatomic, copy) NSString *YWTitle;

@property (nonatomic, copy) NSString *Birthday;

@property (nonatomic, copy) NSString *OldCaseContent;

@property (nonatomic, copy) NSString *YJS;

@property (nonatomic, copy) NSString *ZKJC;

@property (nonatomic, copy) NSString *ZLJS_img;

@property (nonatomic, copy) NSString *ZLSL;

@property (nonatomic, copy) NSString *KeyWords;

@property (nonatomic, copy) NSString *TLDP_img;

@property (nonatomic, copy) NSString *ShiYan_img;

@property (nonatomic, copy) NSString *PaiXu;

@property (nonatomic, copy) NSString *PDLB;

@property (nonatomic, copy) NSString *Levels;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *GMS;

@property (nonatomic, copy) NSString *AddTime;

@property (nonatomic, copy) NSString *YXX_img;

@property (nonatomic, copy) NSString *Profession;

@property (nonatomic, copy) NSString *SMTZ;

@property (nonatomic, copy) NSString *GRS;

@property (nonatomic, copy) NSString *MedicalHistory;

@property (nonatomic, copy) NSString *ChuZhen;

@property (nonatomic, copy) NSString *YXX;

@property (nonatomic, copy) NSString *OldMedicalHistory;

@property (nonatomic, copy) NSString *YWZZ;

@property (nonatomic, copy) NSString *XTHG;

@property (nonatomic, copy) NSString *ZLJS;

@property (nonatomic, copy) NSString *PublishTime;

@property (nonatomic, copy) NSString *EndAuditTime;

@property (nonatomic, copy) NSString *ImgUrl;

@property (nonatomic, copy) NSString *XZZD;

@property (nonatomic, copy) NSString *UserId;

@property (nonatomic, copy) NSString *ZhenDuan;

@property (nonatomic, copy) NSString *havecollect;

@property (nonatomic, copy) NSString *havescore;

@property (nonatomic, copy) NSString *CaseFrom;

@property (nonatomic, copy) NSString *BQZG;

@property (nonatomic, copy) NSString *QTFZJC;

@property (nonatomic, copy) NSString *rowid;

@property (nonatomic, copy) NSString *HunYu;

@property (nonatomic, copy) NSString *TGJC;

@property (nonatomic, copy) NSString *State;

@property (nonatomic, copy) NSString *Sex;

@property (nonatomic, copy) NSString *Title;

@property (nonatomic, copy) NSString *VisitTime;

@property (nonatomic, copy) NSString *BirthPlace;

@property (nonatomic, copy) NSString *OperationHistory;

@property (nonatomic, copy) NSString *DocId;

@property (nonatomic, copy) NSString *Click;

@property (nonatomic, copy) NSString *CaseCardId;

@property (nonatomic, copy) NSString *TGJC_img;

@property (nonatomic, copy) NSString *TransfusionHistory;

@property (nonatomic, copy) NSString *ZKJC_img;

@property (nonatomic, copy) NSString *Professional;

@property (nonatomic, copy) NSString *Remark;

@property (nonatomic, copy) NSString *FirstAuditTime;

@property (nonatomic, copy) NSString *NickName;

@property (nonatomic, copy) NSString *ShiYan;

@property (nonatomic, copy) NSString *SectionOffice;

@property (nonatomic, copy) NSString *IsXXYD;

@property (nonatomic, copy) NSString *ClassId;

@property (nonatomic, copy) NSString *JiaZu;

@property (nonatomic, copy) NSString *Address;

@property (nonatomic, copy) NSString *ZhuShu;

@property (nonatomic, copy) NSString *TLDP;


@property (nonatomic, copy) NSString *CollectTime;

////标题
//@property (nonatomic,strong) NSString *Title;
////原始病例图片内容
//@property (nonatomic,strong) NSString *OldCaseContent;
//
//
////原文标题
//@property (nonatomic,strong) NSString *YWTitle;
////发布时间
//@property (nonatomic,strong) NSString *PublishTime;
////关键词
//@property (nonatomic,strong) NSString *KeyWords;
////原文杂志
//@property (nonatomic,strong) NSString *YWZZ;
//
//
////患者性别
//@property (nonatomic,strong) NSString *Sex;
////出生年月
//@property (nonatomic,strong) NSString *Birthday;
////民族
//@property (nonatomic,strong) NSString *Nation;
////患者职业
//@property (nonatomic,strong) NSString *Profession;
////出生地
//@property (nonatomic,strong) NSString *BirthPlace;
////居住地
//@property (nonatomic,strong) NSString *Address;
////就诊时间
//@property (nonatomic,strong) NSString *VisitTime;
//
//
////病例来源
//@property (nonatomic,strong) NSString *CaseFrom;
////病历卡id
//@property (nonatomic,strong) NSString *CaseCardId;
////是否加入学习园地
//@property (nonatomic,strong) NSString *IsXXYD;
//
////病例分类
//@property (nonatomic,strong) NSString *ClassId;
//
////主述
//@property (nonatomic,strong) NSString *ZhuShu;
////现病史
//@property (nonatomic,strong) NSString *MedicalHistory;
////既往病史
//@property (nonatomic,strong) NSString *OldMedicalHistory;
////系统回顾
//@property (nonatomic,strong) NSString *XTHG;
////个人史
//@property (nonatomic,strong) NSString *GRS;
////过敏史
//@property (nonatomic,strong) NSString *GMS;
////婚育情况
//@property (nonatomic,strong) NSString *HunYu;
////家族史
//@property (nonatomic,strong) NSString *JiaZu;
////体格检查
//@property (nonatomic,strong) NSString *TGJC;
////实验室检查
//@property (nonatomic,strong) NSString *ShiYan;
////影像学检查
//@property (nonatomic,strong) NSString *YXX;
////其他辅助检查
//@property (nonatomic,strong) NSString *QTFZJC;
////诊断
//@property (nonatomic,strong) NSString *ZhenDuan;
////治疗简述
//@property (nonatomic,strong) NSString *ZLJS;
////修正诊断
//@property (nonatomic,strong) NSString *XZZD;
////诊疗思路
//@property (nonatomic,strong) NSString *ZLSL;
////随访记录
//@property (nonatomic,strong) NSString *SFJL;
////讨论与点评
//@property (nonatomic,strong) NSString *TLDP;
//
////参考文献
//@property (nonatomic,strong) NSString *CKWX;
////病例介绍
//@property (nonatomic,strong) NSString *Remark;
////人工定义级别
//@property (nonatomic,strong) NSString *Levels;
////审核情况
//@property (nonatomic,strong) NSString *State;
//
////一审时间
//@property (nonatomic,strong) NSString *FirstAuditTime;
////二审时间
//@property (nonatomic,strong) NSString *EndAuditTime;
////上传时间
//@property (nonatomic,strong) NSString *AddTime;
//
//
////手术外伤史
//@property (nonatomic,strong) NSString *OperationHistory;
////输血史
//@property (nonatomic,strong) NSString *TransfusionHistory;
////月经史
//@property (nonatomic,strong) NSString *YJS;
////生命体征
//@property (nonatomic,strong) NSString *SMTZ;
////初诊
//@property (nonatomic,strong) NSString *ChuZhen;
////专科检查
//@property (nonatomic,strong) NSString *ZKJC;
////评定量表
//@property (nonatomic,strong) NSString *PDLB;
////鉴别诊断
//@property (nonatomic,strong) NSString *JBZD;
////病情转归
//@property (nonatomic,strong) NSString *BQZG;
//
//
//
//
//
////是否在首页显示    0．显示1.不显示
//@property (nonatomic,strong) NSString *IsShowIndex;
////排序    默认为99
//@property (nonatomic,strong) NSString *PaiXu;
//
//
////id
//@property (nonatomic,strong) NSString *Id;
////userID
//@property (nonatomic,strong) NSString *UserId;
////医生编号
//@property (nonatomic,strong) NSString *DocId;
////用户昵称
//@property (nonatomic,strong) NSString *NickName;
////用户图像
//@property (nonatomic,strong) NSString *ImgUrl;
////科室
//@property (nonatomic,strong) NSString *SectionOffice;
////医生等级
//@property (nonatomic,strong) NSString *Professional;
//
//1
//
////点击次数
//@property (nonatomic,strong) NSString *Click;
//
//
//
//
//
//@property (nonatomic,strong) NSString *rowid;
//// 评分
//@property (nonatomic,strong) NSString *score;
//
// 是否收藏
//@property (nonatomic,strong) NSString *havecollect;


//// 是否评分
//@property (nonatomic,strong) NSString *havescore;
//
//
//@property (nonatomic,strong) NSString *CollectTime;

+(instancetype)caseModelWithDict:(NSDictionary *)dict;


@end
