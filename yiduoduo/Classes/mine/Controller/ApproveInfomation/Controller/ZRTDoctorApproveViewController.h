//
//  ZRTDoctorApproveViewController.h
//  yiduoduo
//
//  Created by Olivier on 15/6/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTDoctorApproveViewControllerDelegate <NSObject>

- (void)backFromZRTDoctorApproveViewController;

@end

@interface ZRTDoctorApproveViewController : UIViewController

@property (nonatomic,weak) id <ZRTDoctorApproveViewControllerDelegate> delegate;

//@property (nonatomic,strong) NSString *realName;
//@property (nonatomic,strong) NSString *cityName;

@end
