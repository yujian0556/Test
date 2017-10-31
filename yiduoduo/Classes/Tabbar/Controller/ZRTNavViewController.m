//
//  ZRTNavViewController.m
//  yiwen
//
//  Created by moyifan on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTNavViewController.h"
#import "ZRTTabBar.h"
#import "ZRTHomeViewController.h"


@interface ZRTNavViewController ()<ZRTTabBarDelegate>



@end

@implementation ZRTNavViewController



+(void)initialize
{
    //获取整个项目中NavigationController下的导航条
    UINavigationBar *navigationBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    navigationBar.translucent = NO;//    Bar的模糊效果，默认为YES
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"home_top_bg"] forBarMetrics:UIBarMetricsDefault];

    
    //定义整个项目中的导航条文字
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[NSForegroundColorAttributeName] = [UIColor whiteColor];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    ZRTTabBar *tabBar = [[ZRTTabBar alloc] init];
    
    
    tabBar.delegate = self;

   
}


-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (viewController == self.viewControllers[0]) {
        
        UITabBarController *tabbar = ZRTKeyWindow.rootViewController;
        
        for (UIView *tabButton in tabbar.tabBar.subviews) {
            
            if ([tabButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                
                [tabButton removeFromSuperview];
            }
        }
        
        
    }
    
}



















@end
