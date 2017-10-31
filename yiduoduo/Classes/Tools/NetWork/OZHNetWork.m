//
//  OZHNetWork.m
//  yiduoduo
//
//  Created by Olivier on 15/7/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "OZHNetWork.h"
#import "AFNetworking.h"
#import "Interface.h"


@implementation OZHNetWork

/**
 网络请求控制器
 */
+(instancetype)sharedNetworkTools
{
    static OZHNetWork *tools;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        
        tools = [[OZHNetWork alloc]init];
        
        
        //        NSURL *url = [NSURL URLWithString:@"123"];
        //
        //        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //
        //        tools = [[ZRTNetworkTools alloc] initWithBaseURL:url sessionConfiguration:config];
        //
        //
        //        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        //
    });
    return tools;
}

/**
 首页数据请求
 */
- (void)getMainDataWithCasePageSize:(NSInteger)size andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetCaseList parameters:@{@"PageSize":[NSString stringWithFormat:@"%ld",(long)size],@"IndexPage":@"1",@"OrderBy":@"addtime desc",@"StrWhere":@"isShowIndex=1"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
    }];
    
}

- (void)getMainDataWithVideoPageSize:(NSInteger)size andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetVideoList parameters:@{@"PageSize":[NSString stringWithFormat:@"%ld",(long)size],@"IndexPage":@"1",@"StrWhere":@"isShowIndex=1",@"OrderBy":@"addtime desc"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
        ////NSLog(@"error  %@",error);
        
    }];
}

#define pagesize KScreenWidth==414?@"8":@"6"

/**
 病例数据请求
 */
- (void)getCaseDataWithOrderBy:(NSString *)type andStartCount:(NSInteger)start andStrWhere:(NSString *)strwhere andSuccess:(successBlock)success andFailure:(failureBlock)failure
{
    //strWhere : IsShowIndex=1 显示首页类似
    //StartCount 从1开始
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *IndexPage = [NSString stringWithFormat:@"%ld",(long)start];
   
                                            //几条数据              //第几页              //根据ID和classID判断是谁和什么病例
                                                                                                        //排序
    [manager POST:KGetCaseList parameters:@{@"PageSize":pagesize,@"IndexPage":IndexPage,@"OrderBy":type,@"StrWhere":strwhere} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //将服务器返回的数据解析成能够读取的数据
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
    }];
}

- (void)getCaseCommentDataWithCaseId:(NSString *)caseid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KCaseComment parameters:@{@"pageSize":pageSize,@"pageIndex":pageIndex,@"CaseId":caseid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
    
}

/**
 视频数据请求
 */

//- (void)getCaseDataWithOrderBy:(NSString *)type andStartCount:(NSInteger)start

//- (void)getVideoDataWithIndexPage:(NSInteger)page  andOrderBy:(NSString *)order

- (void)getVideoDataWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strWhere andOrderBy:(NSString *)order andSuccess:(successBlock)success andFailure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [manager POST:KGetVideoList parameters:@{@"PageSize":@"6",@"IndexPage":[NSString stringWithFormat:@"%ld",(long)page],@"StrWhere":strWhere,@"OrderBy":order} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(self,error);
        
        NSLog(@"视频  error  %@",error);
        
    }];
    
}

- (void)getVideoCommentDataWithvideoID:(NSString *)videoID andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetVideoComment parameters:@{@"pageSize":@"6",@"pageIndex":pageIndex,@"videoID":videoID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        failure(self,error);
        
        ////NSLog(@"error  %@",error);
        
    }];
    
}

- (void)getMainDataWithUserId:(NSString *)userid Success:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KHomeURL parameters:@{@"UserID":userid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}


/**
 学习园地数据请求
 */


/**
 会诊列表数据请求
 */
- (void)getConsultationListWithIndexPage:(NSInteger)page andStrwhere:(NSString *)strwhere andSuccess:(successBlock)success andFailure:(failureBlock)failure
{
    NSDictionary *para = @{@"IndexPage":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":pagesize,@"OrderBy":@"addtime desc",@"StrWhere":strwhere};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KConsultationListURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
//        NSLog(@"jsonDict %@",jsonDict);
        
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
    }];
}

- (void)getConsultationListWithIndexPage:(NSInteger)page andStrwhere:(NSString *)strwhere Success:(successBlock)success andFailure:(failureBlock)failure{
    NSDictionary *para = @{@"IndexPage":[NSString stringWithFormat:@"%ld",(long)page],@"PageSize":@"1",@"OrderBy":@"",@"StrWhere":strwhere};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KConsultationListURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
    }];
}


/**
 会诊详细数据请求(返回的是数组)
 */
- (void)getConsultationDetailDataWithStartCount:(NSInteger)start AndTopId:(NSInteger)Id Success:(deatilBlock)success AndFailure:(failureBlock)failure
{
    NSDictionary *para = @{@"TopicId":[NSNumber numberWithInteger:Id],@"StartCount":[NSNumber numberWithInteger:1],@"OrderField":@"addtime",@"OrderModal":@"desc",@"PageCount":@"10"};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KConsultationDetailURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSArray *jsonArr = [self StringToJsonArrayWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

#if 0

/**
 会诊评论列表数据请求
 */
- (void)getConsultationCommentsListWithStartCount:(NSInteger)start AndTopId:(NSInteger)Id Success:(successBlock)success AndFailure:(failureBlock)failure
{
    NSDictionary *para = @{@"TopicId":[NSNumber numberWithInteger:Id],@"StartCount":[NSNumber numberWithInteger:start],@"OrderField":@"addtime",@"OrderModal":@"desc",@"PageCount":@"10"};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KConsultationCommentListURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}
#endif
/**
 发送会诊评论
 */
- (void)publishCommentWithContents:(NSString *)content andTopicId:(NSString *)topicId andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    //    //NSLog(@"%@",[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"][@"Id"]]);
    
    NSDictionary *para = @{@"UserId":[NSString stringWithFormat:@"%@",[DEFAULT objectForKey:@"UserDict"][@"Id"]],@"ConsultationId":topicId,@"Contents":content};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KConsultationPublishURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

/**
 登录
 */
- (void)LoginWithUserName:(NSString *)username AndPassWord:(NSString *)password Success:(responeBlock)success andFailure:(failureBlock)failure
{
    NSDictionary *para = @{@"UserName":username,@"UserPWD":password};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KLoginURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        //        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //
        //        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

/**
 获取用户信息
 */
- (void)getUserInfomationWithId:(NSString *)Id Success:(successBlock)success andFailure:(failureBlock)failure {
    NSDictionary *para = @{@"UserId":Id};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KUserInfoURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

/**
 注册验证手机号
 */
- (void)testCellPhoneNumber:(NSString *)phoneNumber withSuccess:(arrayBlock)success andFailure:(failureBlock)failure {
    
    NSDictionary *para = @{@"strPhone":phoneNumber};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KRegisterYZURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSArray *jsonArr = [self StringToJsonArrayWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
    
}

/**
 注册发送手机验证码
 */
- (void)sendIdentifyingCodeWithPhoneNumber:(NSString *)phoneNumber withSuccess:(arrayBlock)success andFailure:(failureBlock)failure {
    NSDictionary *para = @{@"strPhone":phoneNumber};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KRegisterSendURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSArray *jsonArr = [self StringToJsonArrayWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}
/**
 注册提交注册信息
 */

- (void)postRegisterUserInfoWithPhoneNumber:(NSString *)phoneNumber andPassword:(NSString *)password withSuccess:(arrayBlock)success andFailure:(failureBlock)failure {
    
    NSDictionary *para = @{@"strPhone":phoneNumber,@"strPassword":password};
    
    AFHTTPRequestOperationManager *OperationManager = [AFHTTPRequestOperationManager manager];
    
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [OperationManager POST:KUserRegisterURL parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //KBG格式
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSArray *jsonArr = [self StringToJsonArrayWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonArr);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}



/**
 新闻数据请求
 */
- (void)getNewsDataWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strWhere andOrderBy:(NSString *)order andSuccess:(successBlock)success andFailure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:KGetNewsList parameters:@{@"PageSize":@"4",@"IndexPage":[NSString stringWithFormat:@"%ld",(long)page],@"StrWhere":strWhere,@"OrderBy":order} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
     
        
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
        ////NSLog(@"error  %@",error);
        
    }];
    
}


/**
 新闻详情数据请求
 */
- (void)getNewsDataWithId:(NSString *)Id andSuccess:(successBlock)success andFailure:(failureBlock)failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetNewsDetailList parameters:@{@"Id":Id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //  //NSLog(@"%@",responseObject);
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
        ////NSLog(@"error  %@",error);
        
    }];
    
    
    
}





// 健康档案
- (void)getHealthyDataWithUserId:(NSString *)Id andStrWhere:(NSString *)strwhere andOrderBy:(NSString *)orderby andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KHealthyData parameters:@{@"UserID":Id,@"PageSize":@"10000",@"IndexPage":@"1",@"StrWhere":@"",@"OrderBy":@""} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
      //  NSLog(@"---->%@",responseObject);
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}
-(void)deleteHealthyDataWithID:(NSString *)ID andSuccess:(successBlock)success andFailure:(failureBlock)failure{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:KDeleteHealthyData parameters:@{@"HealthyID":ID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ////NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        ////NSLog(@"error == %@",error);
        
    }];
}

- (void)changeHealthyDataWithHealthyID:(NSString *)ID andUserID:(NSString *)userID andTitle:(NSString *)title andContent:(NSString *)content andImg:(NSString *)img andRemark:(NSString *)remark andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KChangeHealthyData parameters:@{@"ID":ID,@"UserID":userID,@"Title":title,@"Content":content,@"Img":img,@"Remark":remark} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
    
}


- (void)getDoctorOrPatientDataWithUserId:(NSString *)Id andDocOrPat:(NSString *)type andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KDoctorPatient parameters:@{@"UserID":Id,@"Tip":type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}

- (void)searchDoctorPatientWithUserId:(NSString *)Id andDocOrPat:(NSString *)type andSearchText:(NSString *)text andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KSearchDoctorPatient parameters:@{@"UserID":Id,@"Tip":type,@"UserName":text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}

- (void)addConcernWithUserId:(NSString *)Id andObject:(NSString *)concernId andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KAddConcern parameters:@{@"PatId":Id,@"DocId":concernId} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
    
}


- (void)changePassWordWithUserID:(NSString *)ID andNew:(NSString *)newPW andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KChangePassWordURL parameters:@{@"UserId":ID,@"NewPwd":newPW} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}


- (void)findPassWordWithPhoneNumber:(NSString *)phoneNumber andNew:(NSString *)newPW andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KFindPassWordURL parameters:@{@"Tel":phoneNumber,@"NewPwd":newPW} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}


- (void)sendReportWithConsultationId:(NSString *)ConsultationId andUserId:(NSString *)userId andReason:(NSString *)reason andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KSendReport parameters:@{@"UserID":userId,@"TypeID":@"1",@"InfoID":ConsultationId,@"ReportContent":reason} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

- (void)showToDoctorWithUserId:(NSString *)Id andDoctorID:(NSString *)docID andHealthyDataList:(NSString *)list andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:KShowToDoc parameters:@{@"UserID":Id,@"DocRegID":docID,@"HealthyIds":list} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(self,error);
    }];
}

- (void)getCaseCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetCaseCollection parameters:@{@"UserID":userid,@"pageIndex":pageIndex,@"pageSize":pageSize} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        failure(self,error);
        
    }];
}


-(void)getConsultationCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetConsultationCollection parameters:@{@"UserID":userid,@"pageIndex":pageIndex,@"pageSize":pageSize} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}

- (void)getVideoCollectionWithUserId:(NSString *)userid andPageIndex:(NSString *)pageIndex andPageSize:(NSString *)pageSize andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KGetVideoCollection parameters:@{@"UserID":userid,@"pageIndex":pageIndex,@"pageSize":pageSize} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
         
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
    
}

- (void)getSectionOfficeDataType:(NSString *)type Success:(successBlock)success andFailure:(failureBlock)failure {
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KSectionOffice parameters:@{@"type":type} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        failure(self,error);
        
    }];
    
}


- (void)postUserInfoWithDictionary:(NSDictionary *)userInfoDict andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KPostUserInfo parameters:userInfoDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        failure(self,error);
        
    }];
}


-(void)ValidateDoctorWithDictionary:(NSDictionary *)docInfoDict andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KValidateDoctor parameters:docInfoDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
    
}

- (void)cancleCollectCaseWithUserId:(NSString *)userid andCaseId:(NSString *)caseid andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KCancleCaseCollection parameters:@{@"UserID":userid,@"CaseID":caseid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}


- (void)collectConsultationWithUserId:(NSString *)userid andConsultationId:(NSString *)consultationid andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KConsultationCollect parameters:@{@"UserId":userid,@"ConsultationId":consultationid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}


- (void)cancleCollectConsultationWithUserId:(NSString *)userid andConsultationId:(NSString *)consultationid andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KCancleConsultationCollect parameters:@{@"UserId":userid,@"ConsultationId":consultationid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}


- (void)cancleCollectVideoWithUserId:(NSString *)userid andVideoId:(NSString *)videoid andSuccess:(successBlock)success andFailure:(failureBlock)failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KCancleVideoCollet parameters:@{@"UserID":userid,@"VideoID":videoid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        success(self,jsonDict);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(self,error);
        
    }];
}









#pragma mark - json字符串 转换
/**
 json字符串转为字典
 */
- (NSDictionary *)StringToJsonDictWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@"huiche"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"<p>" withString:@"huiche"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"<br />" withString:@"huiche"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r" withString:@"kongge"];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
  //  jsonString = [jsonString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        ////NSLog(@"字典json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 json字符串转为数组
 */

- (NSArray *)StringToJsonArrayWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {
        ////NSLog(@"数组json解析失败：%@",err);
        return nil;
    }
    return arr;
}
@end
