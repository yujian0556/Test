//
//  Interface.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#ifndef yiduoduo_Interface_h
#define yiduoduo_Interface_h


#pragma mark - 病例

//测试地址  域名出来后进行更换
#define KMainInterface @"http://www.yddmi.com/"
#define KTestInterface @"http://192.168.199.106"

#define KImageInterface @"http://www.yddmi.com/images/WallImages/imagepath/"

//首页
#define KHomeURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/GetIndex"



#define KCaseId @"?ClassId=%%@"

//请求病例数据
#define KGetCaseList @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/GetCaseList"
#define KCaseType KCaseId
//病例评论
#define KCaseComment @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/GetCaseReplyList"

#pragma mark - 视频
//请求视频数据
#define KGetVideoList @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/GetVideoList"
//请求视频评论
#define KGetVideoComment @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/GetVideoReplyList"


//请求新闻数据
#define KGetNewsList @"http://www.yddmi.com/WebServices/Ydd_News.asmx/GetArticleList"

//请求新闻详情数据
#define KGetNewsDetailList @"http://www.yddmi.com/WebServices/Ydd_News.asmx/GetArticleInfo"

#pragma mark - 其他

//请求学习园地数据
#define KGetStudyData @""

//请求滚动广告条数据
#define KGetAdData @""





#pragma mark - 会诊


//用户信息数据
#define KUserInfoURL @"http://www.yddmi.com/WebServices/Ydd_User.asmx/GetUserInfo"


//会诊信息列表
#define KConsultationDetailURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/GetConsultationReplayList"


//会诊list列表
#define KConsultationListURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/GetConList"

//会诊发送评论
#define KConsultationPublishURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/ConsultationPublish"




#pragma mark - 登录注册
//登录
#define KLoginURL @"http://www.yddmi.com/WebServices/Ydd_User.asmx/UserLogin"

//注册
#define KRegisterYZURL @"http://www.yddmi.com/WebServices/Ydd_Register.asmx/YZPhone"
#define KRegisterSendURL @"http://www.yddmi.com/WebServices/Ydd_Register.asmx/Send"
#define KUserRegisterURL @"http://www.yddmi.com/WebServices/Ydd_Register.asmx/userReg"

//修改密码
#define KChangePassWordURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/UpdatePwd"
//找回密码
#define KFindPassWordURL @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/FindPwd"


//提交健康档案
#define KPushHealthyData @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/AddCon"
//健康档案
#define KHealthyData @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/HealthyDoc"
//删除
#define KDeleteHealthyData @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/DelHealthy"

#define KChangeHealthyData @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/UpdateCon"


//我的医生2，我的患者1
#define KDoctorPatient @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/MyDoc_MyPat"
//搜索
#define KSearchDoctorPatient @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/Search"


//添加关注
#define KAddConcern @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/AddAttention"

//展示给医生
#define KShowToDoc @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/OpenHealthyDoc2Doctor"

// 删除自己发布的会诊
#define KDeleteConsultation @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/DelCon"

//发送举报
#define KSendReport @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/Report"

//获取科室数据
//#define KSectionOffice @"http://192.168.199.106/webservices/ydd_consultation.asmx/GetDepartment"
#define KSectionOffice @"http://www.yddmi.com/webservices/ydd_consultation.asmx/GetDepartment"

#pragma mark - 我的收藏

#define KCancleCaseCollection @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/RemoveCaseCollect"



#define KConsultationCollect @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/ConsultationCollect"
#define KCancleConsultationCollect @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/QXConsultationCollect"

#define KCancleVideoCollet @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/CancelVideoCollect"


#define KGetCaseCollection @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/GetCaseCollect"
#define KGetConsultationCollection @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/GetConsultationCollected"
#define KGetVideoCollection @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/GetVideoCollected"


#pragma mark - 完善用户信息

#define KPostUserInfo @"http://www.yddmi.com/WebServices/Ydd_User.asmx/UpdateUserInfo"
#define KValidateDoctor @"http://www.yddmi.com/WebServices/Ydd_User.asmx/ValidateDoctor"
//#define KValidateDoctor @"http://192.168.199.180:82/WebServices/Ydd_User.asmx/ValidateDoctor"

#endif
