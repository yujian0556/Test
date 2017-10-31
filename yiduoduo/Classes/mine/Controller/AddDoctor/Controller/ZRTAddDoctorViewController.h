//
//  ZRTAddDoctorViewController.h
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTPatientModel.h"
#import "ZRTDoctorModel.h"


@protocol ZRTAddDoctorViewControllerDelegate <NSObject>



- (void)backToMyDocOrPati;

@end


@interface ZRTAddDoctorViewController : UIViewController

@property (nonatomic,getter=isDoctorOrNot) BOOL isDoctor;

@property (nonatomic,strong) ZRTPatientModel *pmodel;
@property (nonatomic,strong) ZRTDoctorModel *dmodel;

@property (nonatomic,strong) NSArray *concernArray;

@property (nonatomic,strong) NSArray *myHealthyData;

@property (nonatomic,strong) id<ZRTAddDoctorViewControllerDelegate> delegate;
@end
