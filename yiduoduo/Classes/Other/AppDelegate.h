//
//  AppDelegate.h
//  yiwen
//
//  Created by 余健 on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoDataSource,RCIMConnectionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,assign) BOOL allowRotation;

@end

