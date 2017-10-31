//
//  ZRTTabBar.h
//  yiduoduo
//
//  Created by moyifan on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZRTTabBar;
@protocol ZRTTabBarDelegate <NSObject>

@optional

-(void)tabBar:(ZRTTabBar *)tabBar didClickBtn:(NSInteger)index;

-(void)tabBarDidClickPlusBtn:(ZRTTabBar *)tabBar;

@end

@interface ZRTTabBar : UIView

@property (nonatomic,weak) id<ZRTTabBarDelegate> delegate;

@property (nonatomic,strong) NSArray *item;

@property (nonatomic,weak) UIButton *selectBtn;



@end
