//
//  ZRTCaseHeadController.h
//  yiduoduo
//
//  Created by moyifan on 15/6/4.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTCaseModel.h"


@protocol ZRTCaseHeadViewDelegete <NSObject>

-(void)headViewHeight:(CGFloat)height;

@end

@interface ZRTCaseHeadView : UIView


@property (nonatomic,strong) ZRTCaseModel *model;


@property (nonatomic,copy) NSString *headFen;

@property (nonatomic,strong) id<ZRTCaseHeadViewDelegete> delegete;

@property (nonatomic,copy) NSString *caseID;

@end
