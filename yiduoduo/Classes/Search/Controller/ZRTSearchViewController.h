//
//  ZRTSearchViewController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>






@interface ZRTSearchViewController : UIViewController

//病例的模型
@property (nonatomic,strong) NSMutableArray *caseModel;

//视频的模型
@property (nonatomic,strong) NSMutableArray *videoModel;


@property (nonatomic,strong) NSString *searchTitle;


@end
