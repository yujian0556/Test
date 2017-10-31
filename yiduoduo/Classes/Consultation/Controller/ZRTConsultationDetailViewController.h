//
//  ZRTConsultationDetailViewController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTConsultationModel.h"

@interface ZRTConsultationDetailViewController : UIViewController

@property (nonatomic,strong) ZRTConsultationModel *model;

@property (nonatomic,assign) NSInteger ConsultationId;

@end
