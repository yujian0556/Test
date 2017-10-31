//
//  ZRTRegistViewController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTRegistViewController.h"

#import "OZHNetWork.h"

#import "ZRTRZViewController.h"

#import "ZRTLoginViewController.h"
#import "MBProgressHUD+MJ.h"



//#import "AppDelegate.h"

static NSString *KTimeChanged = @"TimeChange";

@interface ZRTRegistViewController () <UITextFieldDelegate,ZRTRZViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *identifyingCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneIdentifyingCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordAgainTextField;
@property (weak, nonatomic) IBOutlet UIView *identifyingCodeView;
@property (weak, nonatomic) IBOutlet UIButton *RegistButton;
@property (nonatomic,copy) NSString *token;
@end

@implementation ZRTRegistViewController
{
    NSInteger _time;
    UILabel *_timeLabel;
    BOOL _isPhoneRegistered;
    BOOL _isPhoneIdentifiyPass;
    NSString *_phoneIdentifiy;
}

#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgationBar];
    
//    self.identifyingCodeButton.userInteractionEnabled = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isInputPhoneNumber) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - 验证手机号
/**
 根据是否为手机号,设置验证码按钮的状态
 */
//- (void)isInputPhoneNumber   没调用此方法
//{
//    
//    
//    if ([self isMobileNumber:self.phoneNumberTextField.text]) {
//        
//        NSLog(@"是不是手机号");
////        self.identifyingCodeButton.userInteractionEnabled = YES;
//        
//        
//        
//    }
//    else
//    {
//        NSLog(@"不是手机号");
//        
//        [MBProgressHUD showError:@"请输入正确的手机号码"];
//        
//        return;
//        
////        self.identifyingCodeButton.userInteractionEnabled = NO;
//    }
//    
//    
//
//}


- (void)isInputPassWord
{

    if ([self isPassWord:self.passWordTextField.text]) {
        
        
    }else{
        
        [MBProgressHUD showError:@"请重新输入密码"];
        
        return;
    }
    


}

/**
 *  正则解析 手机号
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189，181，177
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[156]|7[0-9])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }

    
}

- (BOOL)isPassWord:(NSString *)passWord
{

    
        NSString *pattern = @"^[A-Za-z_][A-Za-z0-9_]{6,18}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        //passWord作为接受对象    evaluateWitnObject返回一个BOOL值
        BOOL isMatch = [pred evaluateWithObject:passWord];

        return isMatch;

}

//获取验证码按钮点击事件
- (IBAction)GetIdentifyingCode:(id)sender {
    
    NSLog(@"点了没");
    
    
    if ([self isMobileNumber:self.phoneNumberTextField.text]) {
        
        NSLog(@"是手机号");
        
       
        
    }else{
    
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
    
    
//    if ([self isPassWord:self.passWordTextField.text]) {
//    
//        NSLog(@"是密码");
//    
//    }else{
//       
//        [MBProgressHUD showError:@"请输入正确的密码"];
//    
//    }
//
    [self testCellPhoneNumber];
    
    
    [self createMethod];
    
  
    double delayInSeconds = 3.0;
    __weak typeof(self) weakSelf = self;
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf delayMethod]; });
}

- (void)createMethod {
    self.stateLabel.hidden = NO;

    self.stateLabel.text = [NSString stringWithFormat:@"已发送短信至%@",self.phoneNumberTextField.text];
}

- (void)delayMethod {
    
    self.stateLabel.hidden = YES;
}

- (void)testCellPhoneNumber {
    
    //30秒
    //验证手机号是否注册过
    [[OZHNetWork sharedNetworkTools] testCellPhoneNumber:self.phoneNumberTextField.text withSuccess:^(OZHNetWork *manager, NSArray *jsonArr) {
        
        [self returnTestPhoneNumber:jsonArr[0][@"result"][0][@"type"]];
        
        if (_isPhoneRegistered) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前手机号已经被注册" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            
            [self sendMessage];
            
        }
        
 
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        NSLog(@"验证手机号 error == %@",error);
        
    }];
    
}

- (void)returnTestPhoneNumber:(NSString *)type {
   
    if ([type isEqualToString:@"success"]) {
        _isPhoneRegistered = NO;
    }
    else {
        _isPhoneRegistered = YES;
    }
    
    //NSLog(@"验证手机号结果为 %d",_isPhoneRegistered);
}

- (void)sendMessage {
    
    [[OZHNetWork sharedNetworkTools] sendIdentifyingCodeWithPhoneNumber:self.phoneNumberTextField.text withSuccess:^(OZHNetWork *manager, NSArray *jsonArr) {
        
        //NSLog(@"发送验证码:%@",[NSString stringWithFormat:@"%@",jsonArr[0][@"result"][0][@"message"]]);
        
        __block int timeout= 59; //倒计时时间
        //点击获取验证码后,进行倒计时
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
        dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(timer);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.identifyingCodeButton.userInteractionEnabled = YES;
                    //设置界面的按钮显示 根据自己需求设置
                    [self.identifyingCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                    
                    
                    
                });
            }else {
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                
                self.identifyingCodeButton.userInteractionEnabled = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //设置界面的按钮显示 根据自己需求设置
                    [self.identifyingCodeButton setTitle:[NSString stringWithFormat:@"重新发送%@",strTime] forState:UIControlStateNormal];
                    
                   
                    
                });
                timeout--;
                
            }
            
        });
        
        dispatch_resume(timer);
    
        NSLog(@" %@",jsonArr[0][@"result"][0][@"type"]);
        
        if ([jsonArr[0][@"result"][0][@"type"] isEqualToString:@"success"]) {
            
            [self judgeMessageIdentifiyWithCode:[NSString stringWithFormat:@"%@",jsonArr[0][@"result"][0][@"message"]]];
       
        }else{
        
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:jsonArr[0][@"result"][0][@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        
        }
 
       
     
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"发送验证码 error == %@",error);
    }];
    
}

- (void)judgeMessageIdentifiyWithCode:(NSString *)code
{
    _phoneIdentifiy = code;
    
    NSLog(@"验证码 %@",code);
    
}

#pragma mark - 点击注册按钮事件
- (IBAction)StartToRegist:(id)sender {
    
    typeof(self) weakSelf = self;
    
    //4个输入框是否有空
    if (self.phoneNumberTextField.text.length != 0 && self.phoneIdentifyingCodeTextField.text.length != 0 && self.passWordTextField.text.length != 0 && self.passWordAgainTextField.text.length != 0)
    {
        //2次密码输入是否相同
        if ([self.passWordTextField.text isEqualToString:self.passWordAgainTextField.text] && self.passWordAgainTextField.text.length != 0) {
           
            //2次输入密码相同,判断验证码是否正确
            if ([self.phoneIdentifyingCodeTextField.text isEqualToString:_phoneIdentifiy]) {
            
                //允许注册
                [[OZHNetWork sharedNetworkTools] postRegisterUserInfoWithPhoneNumber:self.phoneNumberTextField.text andPassword:self.passWordAgainTextField.text withSuccess:^(OZHNetWork *manager, NSArray *jsonArr) {
          
                    
                    NSString *type = jsonArr[0][@"result"][0][@"type"];
                    
                    NSString *message = jsonArr[0][@"result"][0][@"message"];
                    
                    NSRange range1 = [message rangeOfString:@"["];
                    
                    message = [message substringFromIndex:range1.location +1];
                    
                    NSRange range2 = [message rangeOfString:@"]"];
                    
                    message = [message substringToIndex:range2.location];
                    
//                    NSLog(@"123 %@",message);
                    
                    if ([type isEqualToString:@"error"]) {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注册失败" message:message preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:nil];
             
                        
                    }else{
                    
                    
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"backFrmoRegister" object:nil userInfo:@{@"account":weakSelf.phoneNumberTextField.text,@"password":weakSelf.passWordTextField.text}];
                        
                        [weakSelf LoginWithUserName:weakSelf.phoneNumberTextField.text AndPassword:weakSelf.passWordTextField.text];
                        
                        
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                    
                    }
        
                    
                } andFailure:^(OZHNetWork *manager, NSError *error) {
//                    NSLog(@"注册 error == %@",error);
                    
                    [MBProgressHUD showError:@"注册失败"];
                    
                }];
            
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码不正确" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                
                [alert addAction:cancel];
                
                [self presentViewController:alert animated:YES completion:nil];
            }

        }
        else
        {
            if([self isPassWord:self.passWordTextField.text]){
               
                [MBProgressHUD showError:@"请输入正确的密码"];
            
            }else{
            //不允许注册
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次密码输入不一致,请重新输入" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                self.passWordTextField.text = @"";
                self.passWordAgainTextField.text = @"";
            }];
            
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
            }
        }

    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

}


#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    self.title = @"新用户注册";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:[UIImage imageNamed:nil] target:self action:@selector(didClickLeft)];
}
/**
 *  首页导航栏左右按钮
 */
-(void)didClickLeft
{
    //返回上层ViewController
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 登录
- (void)LoginWithUserName:(NSString *)username AndPassword:(NSString *)password
{
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] LoginWithUserName:username AndPassWord:password Success:^(OZHNetWork *manager, id jsonObject) {
        
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *responseState = [[NSString alloc] initWithData:jsonObject encoding:encoding];
        
        
        if ([responseState isEqualToString:@"{\"Success\": \"0\"}"]) {
            
//            [MBProgressHUD hideHUD];
//            
//            [MBProgressHUD showError:@"账号或密码错误,请重试"];
            
        }
        else {//if (![responseState isEqualToString:@"{\"Tips\":\"0\"}"]){
            
            NSData *jsonData = [responseState dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
            
            for (NSDictionary *userDict in arr) {
                for (NSDictionary *infoDict in userDict[@"ds"]) {
                    [weakSelf inputUserInfoWithDict:infoDict];
                }
            }
        }
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        //NSLog(@"登录 error == %@",error);
        
    }];
}
- (void)inputUserInfoWithDict:(NSDictionary *)dict
{
    /* {
     AddTime = "2015/7/14 10:43:08";
     Address = "";
     Area = "";
     City = "";
     DBCoun = "";
     Email = "";
     GraduationDate = "";
     IDCard = "";
     Id = 30;
     ImgUrl = "";
     Major = "";
     NickName = "";
     PassWord = 123456;
     PracticeCard = "";
     Professional = "";
     Province = "";
     QDScore = "";
     R1 = "";
     R2 = "";
     R3 = "";
     R4 = "";
     R5 = "";
     RMBCount = "";
     RealName = "";
     SectionOffice = "";
     Sex = "";
     Specialty = "";
     Status = 1;
     Tel = 18707177018;
     UnitName = "";
     University = "";
     Workage = "";
     }*/
    
    //NSLog(@"%@",dict);
    [DEFAULT setObject:dict forKey:@"UserDict"];
    [DEFAULT setObject:[NSNumber numberWithBool:YES] forKey:@"isLogin"];
    
    
    NSMutableDictionary *RongyunDict = [[NSMutableDictionary alloc] init];
    [RongyunDict setObject:dict[@"Id"] forKey:@"UserId"];
    [RongyunDict setObject:dict[@"NickName"] forKey:@"NickName"];
    [RongyunDict setObject:dict[@"ImgUrl"] forKey:@"ImgUrl"];
    [RongyunDict setObject:dict[@"Tel"] forKey:@"PhoneNumber"];
    
    [DEFAULT setObject:RongyunDict forKey:@"RongyunDict"];
    
    [DEFAULT synchronize];
    
    
    [self getRongyunToken];
    
    //[self.navigationController popViewControllerAnimated:YES];
    
//    if ([self.delegate respondsToSelector:@selector(doNetWorking)]) {
//        
//        [self.delegate doNetWorking];
//        
//    }
    
    //[MBProgressHUD hideHUD];
    
    //    [MBProgressHUD showSuccess:@"登录成功~"];
    //
    //    [MBProgressHUD hideHUD];
    
}


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
#pragma mark - 代理方法
- (void)backFromZRTRZViewController {
    [self.navigationController popViewControllerAnimated:NO];
}
@end
