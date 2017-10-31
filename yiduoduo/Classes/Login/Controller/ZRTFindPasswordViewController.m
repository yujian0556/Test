//
//  ZRTFindPasswordViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/7/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTFindPasswordViewController.h"

#import "OZHNetWork.h"

#import "ZRTLoginViewController.h"
#import "LGAlertView.h"
#import "MBProgressHUD+MJ.h"

static NSString *KTimeChanged = @"TimeChange";

@interface ZRTFindPasswordViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *identifyingCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneIdentifyingCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordAgainTextField;
@property (weak, nonatomic) IBOutlet UIView *identifyingCodeView;
@property (weak, nonatomic) IBOutlet UIButton *RegistButton;
@end

@implementation ZRTFindPasswordViewController
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
    
    [self createDelegate];
    
    [self setNavgationBar];
    
//    self.identifyingCodeButton.userInteractionEnabled = NO;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isInputPhoneNumber) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)createDelegate {
    self.phoneNumberTextField.delegate = self;
    self.phoneIdentifyingCodeTextField.delegate = self;
    self.passWordTextField.delegate = self;
    self.passWordAgainTextField.delegate = self;
}

#pragma mark - 验证手机号
/**
 根据是否为手机号,设置验证码按钮的状态
 */
- (void)isInputPhoneNumber
{
   
    
    if ([self isMobileNumber:self.phoneNumberTextField.text]) {
        
        NSLog(@"是不是手机号");
        
        
        
    }
    else
    {
        NSLog(@"不是手机号");
        
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        
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
     * 电信：133,1349,153,180,189
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

//获取验证码按钮点击事件
- (IBAction)GetIdentifyingCode:(id)sender {
    
    
    NSLog(@"点了没");
    
    
    if ([self isMobileNumber:self.phoneNumberTextField.text]) {
        
        NSLog(@"是手机号");
        
        
        
    }else{
        
        [MBProgressHUD showError:@"请输入正确的手机号码"];
        return;
    }
 
    
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
    
    [self sendMessage];

}

- (void)sendMessage {
    
    [[OZHNetWork sharedNetworkTools] sendIdentifyingCodeWithPhoneNumber:self.phoneNumberTextField.text withSuccess:^(OZHNetWork *manager, NSArray *jsonArr) {
        
        ////NSLog(@"发送验证码:%@",[NSString stringWithFormat:@"%@",jsonArr[0][@"result"][0][@"message"]]);
        
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
        
        
//        [self judgeMessageIdentifiyWithCode:[NSString stringWithFormat:@"%@",jsonArr[0][@"result"][0][@"message"]]];
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
                //允许找回密码
                
                
                //限制密码最小输入长度  6
                if (self.passWordAgainTextField.text.length >= 6) {
                    [[OZHNetWork sharedNetworkTools] findPassWordWithPhoneNumber:self.phoneNumberTextField.text andNew:self.passWordAgainTextField.text andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
                        
                        //找回成功
                        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
                            
                            [weakSelf chagePW];
                            
                        }else{
                        
                            LGAlertView *alert = [LGAlertView alertViewWithTitle:@"错误" message:@"请重新输入" buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil];
                            
                            [alert showAnimated:YES completionHandler:nil];
                        
                        }
                        
                        
                        
                    } andFailure:^(OZHNetWork *manager, NSError *error) {
                        //NSLog(@"找回密码 error == %@",error);
                    }];
                }
                else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码长度不足6位" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alert addAction:cancel];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
 
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
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)chagePW {
    //登录状态 修改 本地PW
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        
        //修改本机储存的旧密码
        NSMutableDictionary *userDict = (NSMutableDictionary *)[DEFAULT objectForKey:@"UserDict"];
        
        [userDict removeObjectForKey:@"PassWord"];
        
        [userDict setValue:self.passWordAgainTextField.text forKey:@"PassWord"];
        
        [DEFAULT setObject:userDict forKey:@"UserDict"];
        [DEFAULT synchronize];
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"找回密码成功" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    self.title = @"找回密码";
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


@end
