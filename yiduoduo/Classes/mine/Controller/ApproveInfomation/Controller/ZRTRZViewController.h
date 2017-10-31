//
//  ZRTRZViewController.h
//  yiduoduo
//
//  Created by Olivier on 15/6/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTRZViewControllerDelegate <NSObject>

- (void)backFromZRTRZViewController;

-(void)refreshNickName:(NSString *)nickName;


@end

@interface ZRTRZViewController : UIViewController

@property (nonatomic,weak) id <ZRTRZViewControllerDelegate> delegate;

@end
