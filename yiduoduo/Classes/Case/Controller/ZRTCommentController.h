//
//  ZRTCommentController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRTCaseModel,ZRTVideoModel;

@protocol ZRTCommentControllerDelegate <NSObject>

-(void)commentReload;

@end


@interface ZRTCommentController : UIViewController


@property (nonatomic,strong) ZRTCaseModel *model;

@property (nonatomic,strong) ZRTVideoModel *videoModel;

@property (nonatomic,assign) BOOL isCase;

@property (nonatomic,strong) id<ZRTCommentControllerDelegate> delegate;

@end
