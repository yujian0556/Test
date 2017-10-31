//
//  OZHNetWork.h
//  yiduoduo
//
//  Created by Olivier on 15/7/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OZHNetWork;

typedef void(^httpRequestSuccess)(OZHNetWork *manager,NSArray *dataArr);

typedef void(^httpRequestFailure)(OZHNetWork *manager,NSError *error);


//OlivierZhang's Block
typedef void (^successBlock)(OZHNetWork *manager,NSDictionary * jsonDict);
typedef void (^failureBlock)(OZHNetWork *manager,NSError *error);

typedef void (^arrayBlock)(OZHNetWork *manager,NSArray *jsonArr);

typedef void (^deatilBlock)(OZHNetWork *manager,NSArray *jsonArr);
typedef void (^publishBlock)(OZHNetWork *manager,NSString *publishState);

typedef void (^responeBlock)(OZHNetWork *manager,id jsonObject);
@interface OZHNetWork : NSObject



/**
 网络请求控制器
 */
+ (instancetype)sharedNetworkTools;

/**
 首页数据请求
 */
- (void)getMainDataWithUserId:(NSString *)userid Success:(successBlock)success andFailure:(failureBlock)failure;

/**
 病例数据请求
 */
- (void)getCaseDataWithOrderBy:(NSString *)type andStartCount:(NSInteger)start andStrWhere:(NSString *)strwhere andSuccess:(successBlock)success andFailure:(failureBlock)failure;


/**
 病例评论
 */
- (void)getCaseCommentDataWithCaseId:(NSString *)caseid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 视频数据请求
 */
- (void)getVideoDataWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strWhere andOrderBy:(NSString *)order andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 获取视频评论
 */
- (void)getVideoCommentDataWithvideoID:(NSString *)videoID andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 学习园地数据请求
 */
//- (void)getStudyData:(int)type andSuccess:(httpRequestSuccess)success andFailure:(httpRequestFailure)failure;

/**
 会诊内容列表数据请求
 */
- (void)getConsultationListWithIndexPage:(NSInteger)page andStrwhere:(NSString *)strwhere andSuccess:(successBlock)success andFailure:(failureBlock)failure;

//会诊信息单独获取
- (void)getConsultationListWithIndexPage:(NSInteger)page andStrwhere:(NSString *)strwhere Success:(successBlock)success andFailure:(failureBlock)failure;

/**
 会诊详细数据请求
 */
- (void)getConsultationDetailDataWithStartCount:(NSInteger)start AndTopId:(NSInteger)Id Success:(deatilBlock)success AndFailure:(failureBlock)failure;

/**
 发送会诊评论
 */
- (void)publishCommentWithContents:(NSString *)content andTopicId:(NSString *)topicId andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 病例详情数据请求
 */
//-(void)getCaseDetailData:(int)caseId andSuccess:(httpRequestSuccess)success andFailure:(httpRequestFailure)failure;


/**
 登录请求
 */
- (void)LoginWithUserName:(NSString *)username AndPassWord:(NSString *)password Success:(responeBlock)success andFailure:(failureBlock)failure;

/**
 获取用户信息
 */
- (void)getUserInfomationWithId:(NSString *)Id Success:(successBlock)success andFailure:(failureBlock)failure;

//修改密码
- (void)changePassWordWithUserID:(NSString *)ID andNew:(NSString *)newPW andSuccess:(successBlock)success andFailure:(failureBlock)failure;

//找回密码
- (void)findPassWordWithPhoneNumber:(NSString *)phoneNumber andNew:(NSString *)newPW andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 注册验证手机号
 */
- (void)testCellPhoneNumber:(NSString *)phoneNumber withSuccess:(arrayBlock)success andFailure:(failureBlock)failure;

/**
 注册发送手机验证码
 */
- (void)sendIdentifyingCodeWithPhoneNumber:(NSString *)phoneNumber withSuccess:(arrayBlock)success andFailure:(failureBlock)failure;
/**
 注册提交注册信息
 */

- (void)postRegisterUserInfoWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password withSuccess:(arrayBlock)success andFailure:(failureBlock)failure;


/**
 新闻数据请求
 */
- (void)getNewsDataWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strWhere andOrderBy:(NSString *)order andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 新闻详情数据请求
 */
-(void)getNewsDataWithId:(NSString *)Id andSuccess:(successBlock)success andFailure:(failureBlock)failure;



/**
 请求健康档案
 */
- (void)getHealthyDataWithUserId:(NSString *)Id andStrWhere:(NSString *)strwhere andOrderBy:(NSString *)orderby andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 删除健康档案
 */
- (void)deleteHealthyDataWithID:(NSString *)ID andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 修改健康档案
 */
- (void)changeHealthyDataWithHealthyID:(NSString *)ID andUserID:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andImg:(NSString *)img andRemark:(NSString *)remark andSuccess:(successBlock)success andFailure:(failureBlock)failure;


/**
 我的医生2，我的患者1
 */
- (void)getDoctorOrPatientDataWithUserId:(NSString *)Id andDocOrPat:(NSString *)type andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 搜索医生患者,医生2,患者1
 */
- (void)searchDoctorPatientWithUserId:(NSString *)Id andDocOrPat:(NSString *)type andSearchText:(NSString *)text andSuccess:(successBlock)success andFailure:(failureBlock)failure;


/**
 添加关注
 */
- (void)addConcernWithUserId:(NSString *)Id andObject:(NSString *)concernId andSuccess:(successBlock)success andFailure:(failureBlock)failure;



/**
 展示给医生
 */
- (void)showToDoctorWithUserId:(NSString *)Id andDoctorID:(NSString *)docID andHealthyDataList:(NSString *)list andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 发送举报
 */
- (void)sendReportWithConsultationId:(NSString *)ConsultationId andUserId:(NSString *)userId andReason:(NSString *)reason andSuccess:(successBlock)success andFailure:(failureBlock)failure;


/**
 获取病例收藏
 */
- (void)getCaseCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 获取视频收藏
 */
- (void)getVideoCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 获取会诊收藏
 */
- (void)getConsultationCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 获取科室信息
 */
- (void)getSectionOfficeDataType:(NSString *)type Success:(successBlock)success andFailure:(failureBlock)failure;

/**
 完善用户信息
 */
- (void)postUserInfoWithDictionary:(NSDictionary *)userInfoDict andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 医生认证
 */
-(void)ValidateDoctorWithDictionary:(NSDictionary *)docInfoDict andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 取消病例收藏
 */
- (void)cancleCollectCaseWithUserId:(NSString *)userid andCaseId:(NSString *)caseid andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 收藏会诊
 */
- (void)collectConsultationWithUserId:(NSString *)userid andConsultationId:(NSString *)consultationid andSuccess:(successBlock)success andFailure:(failureBlock)failure;

/**
 取消收藏会诊
 */
- (void)cancleCollectConsultationWithUserId:(NSString *)userid andConsultationId:(NSString *)consultationid andSuccess:(successBlock)success andFailure:(failureBlock)failure;


/**
 取消视频收藏
 */
- (void)cancleCollectVideoWithUserId:(NSString *)userid andVideoId:(NSString *)videoid andSuccess:(successBlock)success andFailure:(failureBlock)failure;


@end
