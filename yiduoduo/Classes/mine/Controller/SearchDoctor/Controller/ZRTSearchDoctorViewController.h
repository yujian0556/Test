//
//  ZRTSearchDoctorViewController.h
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRTSearchDoctorViewController : UIViewController

@property (nonatomic,getter=isAddDoctor) BOOL addDoctor;

@property (nonatomic,strong) NSArray *getDoctorInfo;

@property (nonatomic,strong) NSArray *myHealthyData;

@end
