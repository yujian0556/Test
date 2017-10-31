//
//  AppDelegate.m
//  yiwen
//
//  Created by 余健 on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "AppDelegate.h"
#import "ZRTTabbarController.h"
#import "ZRTHomeViewController.h"
#import "ZRTNavViewController.h"

#import "AFNetworking.h"
#import "ZRTDoctorModel.h"
#import "Interface.h"


#import "Reachability.h"
#import "LGAlertView.h"

#import "ZRTUserGuideViewController.h"


#define DEFAULTS [NSUserDefaults standardUserDefaults]



#import <AudioToolbox/AudioToolbox.h>



#define iPhone6                                                                \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
[[UIScreen mainScreen] currentMode].size)           \
: NO)
#define iPhone6Plus                                                            \
([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
[[UIScreen mainScreen] currentMode].size)           \
: NO)



@interface AppDelegate ()

@property (nonatomic,copy) NSString *token;

@property (nonatomic,strong) NSString *userID;

@property (nonatomic,strong) NSString *NickName;

@property (nonatomic,strong) NSString *ImgUrl;



@end

@implementation AppDelegate
{
    NSInteger _lostConnectCount;
    
    Reachability *_hostReach;//网络状态
    NetworkStatus _netstatus;
    BOOL _isConnected;//判断是否已经连接
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
       
    ZRTTabbarController *tabbar = [[ZRTTabbarController alloc] init];
    
    
   // ZRTNavViewController *Nav = [[ZRTNavViewController alloc] initWithRootViewController:tabbar];
    
    [self setNetWorkingJudge];
   
    self.window.rootViewController = tabbar;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    

    if(![DEFAULT boolForKey:@"firstStart"]){
        
        [DEFAULT setBool:YES forKey:@"firstStart"];
        
        [DEFAULT synchronize];
    
        ZRTUserGuideViewController *ugVC = [[ZRTUserGuideViewController alloc] init];
        
        [self.window.rootViewController presentViewController:ugVC animated:YES completion:nil];
        
    }

//#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge
                                                                                         |UIUserNotificationTypeSound
                                                                                         |UIUserNotificationTypeAlert) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//#else
//    // 注册苹果推送，申请推送权限。
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
//#endif
    
    [self registerRongyunSDK];
    
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginState) name:@"UserIsLogined" object:nil];
    

    if ([[DEFAULTS objectForKey:@"isLogin"] boolValue]){
    
        [self reloadUserData];
    
    }
 
    
    // ios 版本更新
    
    [self VersionButton];
    
    return YES;
}

#pragma mark 版本更新

-(void)VersionButton
{

    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Misc.asmx/GetIosVersion";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        //        NSLog(@" %@",jsonDict);
        
        [self checkAppUpdate:jsonDict];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"获取版本错误 %@",error);
        
    }];
  
 
}

-(void)checkAppUpdate:(NSDictionary *)appInfo
{
    // 获取当前版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
//    NSString *appInfoVersion = [appInfo substringFromIndex:[appInfo rangeOfString:@"softwareVersion"].location+17];
//
//    appInfoVersion = [appInfoVersion substringToIndex:[appInfoVersion rangeOfString:@"<"].location];

    NSString *appInfoVersion = appInfo[@"version"];

    NSLog(@"版本号 %@ %@",version,appInfoVersion);
    
   // 判断当前版本和网上不同
    
    
    if (![appInfoVersion isEqualToString:version]) {
        
       LGAlertView *alert = [LGAlertView alertViewWithTitle:@"提示" message:@"新版本已发布" buttonTitles:nil cancelButtonTitle:@"前往更新" destructiveButtonTitle:@"知道了" actionHandler:^(LGAlertView *alertView, NSString *title, NSUInteger index) {
            
        } cancelHandler:^(LGAlertView *alertView, BOOL onButton) {
            
            NSString *url = appInfo[@"url"];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
        } destructiveHandler:^(LGAlertView *alertView) {
            
        }];
        
        
        [alert showAnimated:YES completionHandler:nil];
        
        
    }

    
}



-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    
    if (self.allowRotation) {
        
        
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
    
    
}


     





- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}



- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}



- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}






#pragma mark - Rongyun
- (void)registerRongyunSDK {
    //如果登录才开始调用以下代码
    
    [[RCIM sharedRCIM] initWithAppKey:APPKEY];
    
    
    if (iPhone6Plus) {
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
    } else {
        NSLog(@"iPhone6 %d", iPhone6);
        [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
    }
    
    // 设置用户用户信息源5
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    
//    [[RCIM sharedRCIM] rc:self]; // 状态监听
    
    [RCIM sharedRCIM].connectionStatusDelegate = self;
    
    
    
    if ([[DEFAULTS objectForKey:@"isLogin"] boolValue]) {
        NSDictionary *RongyunDict=[DEFAULTS objectForKey:@"RongyunDict"];
        
        NSString *ID = [RongyunDict objectForKey:@"UserId"];

        self.userID = ID;
        
        NSString *NickName;
        if ([[RongyunDict objectForKey:@"NickName"] isEqualToString:@""]) {
            NickName = [NSString stringWithFormat:@"用户%@",ID];
        }
        else {
            NickName = [RongyunDict objectForKey:@"NickName"];
        }
        
        // NSString *ImgUrl = [RongyunDict objectForKey:@"ImgUrl"];
        
        NSString *ImgUrl = @"http://img.name2012.com/uploads/allimg/2015-04/23-051839_1925.jpg";
        
        // 设置当前的用户信息对象
        
        
        self.NickName = NickName;
        self.ImgUrl = ImgUrl;
        
        RCUserInfo *currentUserInfo =
        [[RCUserInfo alloc] initWithUserId:ID
                                      name:NickName
                                  portrait:ImgUrl];

        [RCIM sharedRCIM].currentUserInfo = currentUserInfo;
        
        //   NSLog(@"currentUserInfo %@",self.userID);
        
    }
    
    
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue] ) {
        [self connect];
    }
  
    
    
}
- (void)changeLoginState {
    
    BOOL Login = [[DEFAULT objectForKey:@"isLogin"] boolValue];
    
    if (Login) {
        NSLog(@"连接");
        [self connect];
        
        _lostConnectCount = 0;
    }
    else {
        
        NSLog(@"失去链接");
        [[RCIM sharedRCIM] disconnect];
        _lostConnectCount = 0;
    }

}
// 连接服务器
-(void)connect
{
    self.token = [DEFAULT objectForKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    
    // NSLog(@"%@",self.token);
    [[RCIM sharedRCIM] connectWithToken:self.token success:^(NSString *userId) {
        
        NSLog(@"成功");
        
    } error:^(RCConnectErrorCode status) {
        
        NSLog(@"失败");
        
    } tokenIncorrect:^{
        
        [weakSelf getRongyunToken];
        
    }];
    
    
}



//
//NSDictionary *dict = @{@"UserId":model.Id,@"ImgUrl":model.ImgUrl,@"NickName":model.NickName};
//[DEFAULT setObject:doctorArray forKey:@"DoctorArray"];
//[DEFAULT setObject:patientArray forKey:@"PatientArray"];



//// 设置用户信息
- (void)getUserInfoWithUserId:(NSString *)userId
                   completion:(void (^)(RCUserInfo *userInfo))completion
{
 
    // 设置医生信息
    
    for (NSDictionary *dict in [DEFAULT objectForKey:@"DoctorArray"]) {
        
        
        NSString *ID = dict[@"UserId"];
        
        NSString *NickName = dict[@"NickName"];
        
        NSString *ImgUrl = dict[@"ImgUrl"];
        
        if ([ID isEqual:userId]) {
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
      
            user.userId = userId;
            user.name = NickName;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",KImageInterface,ImgUrl];
            
            user.portraitUri = url;
            
            return completion(user);
 
            
        }
        
    }
    
    
    
    // 设置患者信息
    
    for (NSDictionary *dict in [DEFAULT objectForKey:@"PatientArray"]) {
        
        
        NSString *ID = dict[@"UserId"];
        
        NSString *NickName = dict[@"NickName"];
        
        NSString *ImgUrl = dict[@"ImgUrl"];
        
        if ([ID isEqual:userId]) {
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            
            user.userId = userId;
            user.name = NickName;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",KImageInterface,ImgUrl];
            
            user.portraitUri = url;
            
            return completion(user);
            
            
        }
        
    }
    
    
    
    // 设置自己的信息
    
    if ([self.userID isEqual:userId]) {
        RCUserInfo *user = [[RCUserInfo alloc]init];
        
    //    NSLog(@"info %@",user.userId);
        
        
        user.userId = userId;
        user.name = self.NickName;
    //    user.portraitUri = @"http://img.name2012.com/uploads/allimg/2015-04/23-051839_195.jpg";
        
        user.portraitUri = self.ImgUrl;
        
        return completion(user);
    }
    

    
    
}




- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesPlaySystemSound(1007);
}



- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {


}


// 返回后台后
- (void)applicationDidEnterBackground:(UIApplication *)application {

    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE)
                                                                    
                                                                         ]];
    application.applicationIconBadgeNumber = unreadMsgCount;
}

 //进入前台

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"进入前台");
    
    if ([[DEFAULTS objectForKey:@"isLogin"] boolValue]){
        
        [self reloadUserData];
        
    }
    
}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    [UIApplication sharedApplication].applicationIconBadgeNumber =
    [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}




#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    //NSLog(@"%ld",status);
//    if (status == 6) {
//        
//        
//        
//        if (_lostConnectCount++ == 0) {
//            NSLog(@"您的帐号在别的设备上登录，您被迫下线！ ");
//            
//            
//            LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"您的账号在别的设备上登录" buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
//            
//            
//            [alert showAnimated:YES completionHandler:^{
//                
//                [DEFAULTS setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
//                
//                [DEFAULTS synchronize];
//                
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
//                
//                
//            }];
//            
//        }
//        
//    }

 
    
}


// 接收消息
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UnreadMessage" object:nil];
    
}






// 销毁后移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:RCKitDispatchMessageNotification
     object:nil];
}

#pragma mark 网络判断
- (void)setNetWorkingJudge {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    
    _hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_hostReach startNotifier];
}
//启用网络监视
-(void)reachabilityChanged:(NSNotification *)note{
    
    Reachability * curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    _netstatus = [curReach currentReachabilityStatus];
    
    switch (_netstatus) {
        case NotReachable:
            _isConnected =NO;
            break;
            
        case ReachableViaWiFi:
            _isConnected =YES;
            break;
            
        case ReachableViaWWAN:
            _isConnected =YES;
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - 重新获取token

- (void)getRongyunToken {
    
    NSDictionary *RongyunDict = [DEFAULT objectForKey:@"RongyunDict"];
    
    
    NSString *ID = [RongyunDict objectForKey:@"UserId"];
    
    
    NSString *NickName;
    if ([[RongyunDict objectForKey:@"NickName"] isEqualToString:@""]) {
        NickName = [NSString stringWithFormat:@"用户%@",ID];
    }
    else {
        NickName = [RongyunDict objectForKey:@"NickName"];
    }
    
    NSString *ImgUrl = [RongyunDict objectForKey:@"ImgUrl"];
    
    
    NSString * nonce = [NSString stringWithFormat:@"%d",arc4random()];
    
    NSString * timestamp = [[NSString alloc] initWithFormat:@"%ld",(NSInteger)[NSDate timeIntervalSinceReferenceDate]];
    
    
    // post 方法中，url中没有参数
    NSURL *url = [NSURL URLWithString:@"https://api.cn.ronghub.com/user/getToken.json"];
    
    // post 方法中，数据应该在请求的数据体中
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    request.timeoutInterval = 10;
    
    request.HTTPMethod = @"POST";
    
    //配置http header
    [request setValue:APPKEY forHTTPHeaderField:@"App-Key"];
    [request setValue:nonce forHTTPHeaderField:@"Nonce"];
    [request setValue:timestamp forHTTPHeaderField:@"Timestamp"];
    [request setValue:APPSecret forHTTPHeaderField:@"appSecret"];
    
    //生成hashcode 用以验证签名
    [request setValue:[self base64Encode:[NSString stringWithFormat:@"%@%@%@",APPKEY,nonce,timestamp]]forHTTPHeaderField:@"Signature"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *bodyString = [NSString stringWithFormat:@"userId=%@&name=%@&portraitUri=%@" ,ID,NickName,ImgUrl];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    [NSURLConnection sendAsynchronousRequest:request  queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        //        NSLog(@"POST!!! %@", result);
        
        self.token = result[@"token"];
        
        [DEFAULT setObject:self.token forKey:@"token"];
        
        [DEFAULT synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
        
        if (connectionError) {
            
            NSLog(@"error %@",connectionError);
        }
        
    }];
    
    
}

- (NSString *)base64Encode:(NSString *)str {
    
    // 1. 将字符串转换成二进制数据
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2. 返回 NSData 编码后的结果
    return [data base64EncodedStringWithOptions:0];
}



#pragma mark 刷新用户信息

-(void)reloadUserData
{
    
    OZHNetWork *user = [[OZHNetWork alloc] init];
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    [user getUserInfomationWithId:userDict[@"Id"] Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        for (NSDictionary *dic in jsonDict) {
            
            dict = dic;
            
        }
        
        for (NSDictionary *infoDict in dict[@"ds"]) {
            
            
            [DEFAULT setObject:infoDict forKey:@"UserDict"];
            
        }
   
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"重新刷新用户信息失败 %@",error);
        
    }];
    
    
}


@end
