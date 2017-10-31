//
//  ZRTComposeController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/22.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRTSelectModel;

@protocol ZRTComposeControllerDelegate <NSObject>


-(void)Compose;

-(void)ComposeSuccess;

-(void)Composefailure;

@end


@interface ZRTComposeController : UIViewController

@property (nonatomic,strong) id<ZRTComposeControllerDelegate> delegate;

@end
