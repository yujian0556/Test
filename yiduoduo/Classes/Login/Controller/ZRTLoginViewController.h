//
//  ZRTLoginViewController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTLoginViewControllerDelegate <NSObject>

@optional

- (void)doNetWorking;

@end

@interface ZRTLoginViewController : UIViewController

@property (nonatomic,strong) id <ZRTLoginViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;

- (void)inputUserInfoWithDict:(NSDictionary *)dict;
@end
