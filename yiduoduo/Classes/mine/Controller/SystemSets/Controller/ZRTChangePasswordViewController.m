//
//  ZRTChangePasswordViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTChangePasswordViewController.h"

@interface ZRTChangePasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *oncePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;

@end

@implementation ZRTChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setNavgationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    self.title = @"系统设置";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
}

/**
 *  导航栏左右按钮
 */
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 提交
 */
- (IBAction)postPassword:(id)sender {

    __weak typeof(self) weakSelf = self;
#if 1
    //判断老密码是否一致
    if ([self.oldPasswordTextField.text isEqualToString:[DEFAULT objectForKey:@"UserDict"][@"PassWord"]]) {
        
        //判断两次新密码是否一致
        if ([self.oncePasswordTextField.text isEqualToString:self.againPasswordTextField.text]) {
            
            
            //输入密码长度 大于 6位
            if (self.againPasswordTextField.text.length >= 6) {
                
                //连接服务器修改密码
                [[OZHNetWork sharedNetworkTools] changePassWordWithUserID:[DEFAULT objectForKey:@"UserDict"][@"Id"] andNew:self.againPasswordTextField.text andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
                    
                    //请求成功
                    if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
                        
                        [weakSelf changePW];
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改密码成功" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        
                        [alert addAction:cancle];
                        
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                    //请求失败
                    else {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改密码失败" preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                        
                        [alert addAction:cancle];
                        
                        [weakSelf presentViewController:alert animated:YES completion:nil];
                    }
                    
                } andFailure:^(OZHNetWork *manager, NSError *error) {
                    
                    //NSLog(@"修改密码error == %@",error);
                    
                }];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码长度不能小于6位,请重试!" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    self.oncePasswordTextField.text = @"";
                    self.againPasswordTextField.text = @"";
                }];
                
                [alert addAction:cancle];
                
                [self presentViewController:alert animated:YES completion:nil];
            }

        }
        //两次新密码不一致
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入的密码不一致,请重试!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancle];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    //旧密码判定错误
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"旧密码错误" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancle];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
#endif
}

- (void)changePW {
    //修改本机储存的旧密码
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithDictionary:[DEFAULT objectForKey:@"UserDict"]];
    
    NSLog(@" %@",[userDict objectForKey:@"PassWord"]);
    
    [userDict removeObjectForKey:@"PassWord"];
    
    [userDict setValue:self.againPasswordTextField.text forKey:@"PassWord"];
    
    [DEFAULT setObject:userDict forKey:@"UserDict"];
    [DEFAULT synchronize];
}



@end
