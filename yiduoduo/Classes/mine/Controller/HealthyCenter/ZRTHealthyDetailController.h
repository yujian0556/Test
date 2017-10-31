//
//  ZRTHealthyDetailController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTHealthyModel.h"


@protocol ZRTHealthyDetailControllerDelegate <NSObject>

-(void)HealthyDelete:(NSInteger)index;

-(void)CompileReloadData;

-(void)CompileCompose;

-(void)Compilefailure;

@end


@interface ZRTHealthyDetailController : UIViewController

@property (nonatomic,strong) ZRTHealthyModel *hmodel;


@property (nonatomic,strong) id<ZRTHealthyDetailControllerDelegate> delegate;

@property (nonatomic,assign) NSInteger index;



@end
