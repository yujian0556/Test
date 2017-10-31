//
//  ZRTLoginViewController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTLoginViewController.h"
#import "ZRTRegistViewController.h"
#import "ZRTFindPasswordViewController.h"
#import "ZRTProvisionViewController.h"

#import "MBProgressHUD+MJ.h"

@interface ZRTLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *NewUserRegistView;
@property (weak, nonatomic) IBOutlet UIView *ForgetPasswordView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (nonatomic,copy) NSString *token;
@end

@implementation ZRTLoginViewController

#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
    [self setNavgationBar];
        
    [self createNotificationCenter];
    
    self.registBtn.userInteractionEnabled = NO;
    
    [self.registBtn setTitleColor:[UIColor colorWithRed:244/256.0 green:204/256.0 blue:173/256.0 alpha:1] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 按钮点击事件
/**
 登录按钮
 */
- (IBAction)Login:(id)sender {
    
    [self LoginWithUserName:self.userNameTextField.text AndPassword:self.passWordTextField.text];
    
    
}
- (IBAction)regist:(id)sender {
    [self JumpToRegistVC];
}
- (IBAction)forgetPassword:(id)sender {
    [self JumpToForgetPassWordVC];
}

#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:[UIImage imageNamed:nil] target:self action:@selector(didClickLeft)];
}
/**
 *  首页导航栏左右按钮
 */
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 跳转界面

- (void)JumpToRegistVC
{
    ZRTRegistViewController *registVC = [[ZRTRegistViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:registVC animated:YES];
    
//    self.hidesBottomBarWhenPushed = NO;
}

- (void)JumpToForgetPassWordVC
{
    ZRTFindPasswordViewController *findPWVC = [[ZRTFindPasswordViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:findPWVC animated:YES];
    
//    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - NetWorking
- (void)LoginWithUserName:(NSString *)username AndPassword:(NSString *)password
{
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] LoginWithUserName:username AndPassWord:password Success:^(OZHNetWork *manager, id jsonObject) {
        
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSString *responseState = [[NSString alloc] initWithData:jsonObject encoding:encoding];
        
        
        if ([responseState isEqualToString:@"{\"Success\": \"0\"}"]) {
            
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:@"账号或密码错误,请重试"];
            
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

- (NSDictionary *)getDetailUserInfoWithId:(NSString *)Id {
    
    __block NSDictionary *detailInfoDict;
    
    
    [[OZHNetWork sharedNetworkTools] getUserInfomationWithId:Id Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        for (NSDictionary *userDict in jsonDict) {
            for (NSDictionary *infoDict in userDict[@"ds"]) {
                detailInfoDict = infoDict;
            }
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        //NSLog(@"获取用户信息 error == %@",error);
    }];
    
    return detailInfoDict;
}

#pragma mark - 登录成功,录入用户信息
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
    
    [DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:@"firstTime"];
    
    [DEFAULT synchronize];
    
    [self getRongyunToken];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self.delegate respondsToSelector:@selector(doNetWorking)]) {
        
        [self.delegate doNetWorking];
        
    }
    
    [MBProgressHUD hideHUD];
    
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





#pragma mark - 通知中心
- (void)createNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFrmoRegister:) name:@"backFrmoRegister" object:nil];
}

- (void)backFrmoRegister:(NSNotification *)sender {
    
    //NSLog(@"%@",sender.userInfo);
    
    self.phoneNumber.text = sender.userInfo[@"account"];
    self.passWordTextField.text = sender.userInfo[@"password"];
    
    [self LoginWithUserName:self.phoneNumber.text AndPassword:self.passWordTextField.text];
    
    [MBProgressHUD showMessage:@"正在进行登录~"];
    
}

- (void)textFieldChange:(NSNotification *)notification {
    if ([self.phoneNumber.text isEqualToString:@""] || [self.passWord.text isEqualToString:@""]) {
        self.registBtn.userInteractionEnabled = NO;
        [self.registBtn setTitleColor:[UIColor colorWithRed:244/256.0 green:204/256.0 blue:173/256.0 alpha:1] forState:UIControlStateNormal];
    }
    else {
        self.registBtn.userInteractionEnabled = YES;
        [self.registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}
- (IBAction)showToUser:(id)sender {
    
    ZRTProvisionViewController *pVC = [[ZRTProvisionViewController alloc] init];
    
    pVC.isReport = NO;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

@end
