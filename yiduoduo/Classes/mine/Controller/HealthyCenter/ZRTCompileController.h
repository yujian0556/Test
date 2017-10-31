//
//  ZRTCompileController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTCompileControllerDelegate <NSObject>

@optional
-(void)ComposeSuccess;

-(void)Composefailure;

-(void)Compose;

- (void)backFromChangeHealthyData;

-(void)CompileReloadData;

-(void)CompileComposefailure;

@end






@interface ZRTCompileController : UIViewController


@property (nonatomic,strong) id<ZRTCompileControllerDelegate> delegate;

@property (nonatomic,getter=isCompile) BOOL compile;

@property (nonatomic,strong) NSDictionary *compileDict;




@end
