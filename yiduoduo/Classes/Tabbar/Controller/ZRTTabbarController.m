//
//  ZRTTabbarController.m
//  yiwen
//
//  Created by moyifan on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTabbarController.h"
#import "ZRTCaseViewController.h"
#import "ZRTVideoViewController.h"
#import "ZRTDiscoverViewController.h"
#import "ZRTMineViewController.h"
#import "ZRTNavViewController.h"
#import "ZRTHomeViewController.h"
#import "ZRTTabBar.h"
#import "ZRTConsultationViewController.h"


@interface ZRTTabbarController ()<ZRTTabBarDelegate>

@property (nonatomic,strong) NSMutableArray *item;

@property (nonatomic,strong) ZRTHomeViewController *homeVC;

@property (nonatomic,strong) ZRTCaseViewController *caseVC;

@property (nonatomic,strong) ZRTVideoViewController *videoVC;

@property (nonatomic,strong) ZRTDiscoverViewController *discoverVC;

@property (nonatomic,strong) ZRTMineViewController *mineVC;

@property (nonatomic,strong) ZRTConsultationViewController *consultationVC;

@property (nonatomic,strong) NSMutableArray *AllControllerOne;

@property (nonatomic,strong) NSMutableArray *AllControllerTwo;

@property (nonatomic,assign) BOOL isHome;

@property (nonatomic,assign) BOOL isHomeNow;

@property (nonatomic,weak) UIButton *homeBtn;



@end

@implementation ZRTTabbarController


//- (BOOL)shouldAutorotate
//{
//    //返回顶层视图的设置（顶层控制器需要覆盖shouldAutorotate方法）
//    
//    
//    UINavigationController *nav = (UINavigationController *)[self.viewControllers objectAtIndex:self.selectedIndex];
//    return nav.topViewController.shouldAutorotate;
//    
//    return NO;
//}
////6.0之后系统调用该方法
//-(NSUInteger)supportedInterfaceOrientations
//{
//    //返回顶层视图支持的旋转方向
//    UINavigationController *nav = (UINavigationController *)[self.viewControllers objectAtIndex:self.selectedIndex];
//    return nav.topViewController.supportedInterfaceOrientations;
//    return 0;
//}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            
            [tabBarButton removeFromSuperview];
        }
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setAllTabbarController];
    
    
    self.AllControllerOne = self.viewControllers;

  //  NSLog(@"1%@",self.AllControllerOne);
    
    [self setTabBar];
    
    self.selectedViewController = self.viewControllers[2];
    
    self.isHome = YES;
    

}

#pragma tabbar代理方法
-(void)tabBar:(ZRTTabBar *)tabBar didClickBtn:(NSInteger)index
{
    
    if (index == 2 && self.selectedIndex != index){
    
        self.homeBtn = tabBar.selectBtn;

        if (self.isHome) {
            
            tabBar.selectBtn.selected = NO;
            
        }else{
        
            tabBar.selectBtn.selected = YES;
        }
    
    }

   
    if (index == 2 && self.selectedIndex == index) {
        
        self.viewControllers = nil;
        
        if (self.isHome) {
            
            static dispatch_once_t onceToken;
            
            dispatch_once(&onceToken, ^{
                
                
                [self setAllTabbarController2];
                
                self.AllControllerTwo = self.viewControllers;
            });
            
            
            
//            tabBar.selectBtn.selected = YES;
            
           // self.selectedIndex = 2;
            
           // NSLog(@"AllControllerTwo%@",self.AllControllerTwo);
           // NSLog(@"viewControllersTwo%@",self.viewControllers);
            
            //此行代码底层做了非常多的事情，只能绕开，利用取巧的方法取得系统的数组然后重新赋值
            self.viewControllers = self.AllControllerTwo;
            
           // [self setViewControllers:self.AllControllerTwo];
            
            //  NSLog(@"ishome%@",self.tabBar.subviews);
            
            
            for (UIView *tabBarButton in self.tabBar.subviews) {
                
                if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    
                    [tabBarButton removeFromSuperview];
                }
            }
            
            self.isHome = NO;
            
            self.isHomeNow = YES;
            
        }
        else {
        
            tabBar.selectBtn.selected = NO;
           // self.selectedIndex = 2;
           // [self setAllTabbarController];
            
            self.viewControllers = nil;
            
           // NSLog(@"AllControllerOne%@",self.AllControllerOne);
           // NSLog(@"viewControllersOne%@",self.viewControllers);
            
            self.viewControllers = self.AllControllerOne;
            
          //  NSLog(@"nothome%@",self.tabBar.subviews);
           
            
            
            for (UIView *tabBarButton in self.tabBar.subviews) {
                
                if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                    
                    [tabBarButton removeFromSuperview];
                }
            }
            
            self.isHome = YES;
            
            self.isHomeNow = NO;
            
        }
        
        
    }
  
    
    if (index != 2) {
        
        if (self.isHomeNow) {
            
            self.homeBtn.selected = YES;
            
        }else{
        
            self.homeBtn.selected = NO;
        }
        
    }
    
    
    
    self.selectedIndex = index;
    
}


-(void)setTabBar
{
    ZRTTabBar *tabBar = [[ZRTTabBar alloc] initWithFrame:self.tabBar.bounds];
    
    tabBar.item = self.item;
    tabBar.delegate = self;
    
    
    [self.tabBar addSubview:tabBar];

}

-(void)setAllTabbarController
{
    
    
    //病例
   
    ZRTCaseViewController *caseVC = [[ZRTCaseViewController alloc] init];
    [self addChildViewController:caseVC image:@"menu_case_default" selectImage:@"menu_case_selected" title:@"病例"];
    
    
    //视频
    
    
    ZRTVideoViewController *videoVC = [[ZRTVideoViewController alloc] init];
    [self addChildViewController:videoVC image:@"menu_video_default" selectImage:@"menu_video_selected" title:@"视频"];
    
    
    //首页
  
    ZRTHomeViewController *homeVC = [[ZRTHomeViewController alloc] init];
    [self addChildViewController:homeVC image:@"home_menu_consultation_default" selectImage:@"home_menu_consultation_selected" title:@""];
    
    
    
    //发现
  
    ZRTDiscoverViewController *discover = [[ZRTDiscoverViewController alloc] init];
    [self addChildViewController:discover image:@"menu_found_default" selectImage:@"menu_found_selected" title:@"发现"];
    
    
    //个人中心
    

    ZRTMineViewController *mineVC = [[ZRTMineViewController alloc] init];
    
    
    [self addChildViewController:mineVC image:@"menu_mine_default" selectImage:@"menu_mine_selected" title:@"我"];
  
    
    
}




-(void)setAllTabbarController2
{
    
    
    ZRTCaseViewController *caseVC = [[ZRTCaseViewController alloc] init];
    [self addChildViewController:caseVC image:@"menu_case_default" selectImage:@"menu_case_selected" title:@"病例"];
    
    
    
    //视频
    ZRTVideoViewController *videoVC = [[ZRTVideoViewController alloc] init];
    [self addChildViewController:videoVC image:@"menu_video_default" selectImage:@"menu_video_selected" title:@"视频"];
    
    
    
    
    //会诊   
    ZRTConsultationViewController *consultationVC = [[ZRTConsultationViewController alloc] init];
    consultationVC.RightBtnHidden = YES;
    [self addChildViewController:consultationVC image:@"hhome_menu_consultation_default" selectImage:@"home_menu_consultation_selected" title:@""];
    

    ZRTDiscoverViewController *discover = [[ZRTDiscoverViewController alloc] init];
    [self addChildViewController:discover image:@"menu_found_default" selectImage:@"menu_found_selected" title:@"发现"];
    
  
    

    ZRTMineViewController *mineVC = [[ZRTMineViewController alloc] init];
    [self addChildViewController:mineVC image:@"menu_mine_default" selectImage:@"menu_mine_selected" title:@"我"];
    
   
    
    
}




-(void)addChildViewController:(UIViewController *)child image:(NSString *)image selectImage:(NSString *)selectImage title:(NSString *)title
{

    child.title = title;

    child.tabBarItem.image = [UIImage imageNamed:image];
    child.tabBarItem.selectedImage = [UIImage imageWithOriginalImageName:selectImage];
    
    [self.item addObject:child.tabBarItem];
    
    
    
    
   
    ZRTNavViewController *nav = [[ZRTNavViewController alloc] initWithRootViewController:child];
    
    [self addChildViewController:nav];

}






#pragma mark 懒加载
-(NSMutableArray *)item
{
    if (!_item) {
        _item = [NSMutableArray array];
        
    }
    
    return _item;
}


-(NSArray *)AllControllerOne
{
    if (!_AllControllerOne) {
        
        _AllControllerOne = [NSMutableArray array];
    }

    return _AllControllerOne;
}

-(NSArray *)AllControllerTwo
{
    if (!_AllControllerTwo) {
        
        _AllControllerTwo = [NSMutableArray array];
    }
    
    return _AllControllerTwo;
}

//-(ZRTHomeViewController *)homeVC
//{
//    if (_homeVC == nil) {
//        
//        _homeVC = [[ZRTHomeViewController alloc] init];
//    }
//
//    return _homeVC;
//}
//
//-(ZRTCaseViewController *)caseVC
//{
//    if (_caseVC == nil) {
//        
//        _caseVC = [[ZRTCaseViewController alloc] init];
//    }
//
//    return _caseVC;
//
//}
//
//-(ZRTVideoViewController *)videoVC
//{
//
//    if (_videoVC == nil) {
//        
//        _videoVC = [[ZRTVideoViewController alloc] init];
//    }
//
//    return _videoVC;
//
//}
//
//-(ZRTDiscoverViewController *)discoverVC
//{
//
//    if (_discoverVC == nil) {
//        
//        _discoverVC = [[ZRTDiscoverViewController alloc] init];
//    }
//
//    return _discoverVC;
//
//}
//
//-(ZRTMineViewController *)mineVC
//{
//
//    if (_mineVC == nil) {
//        
//        
//        _mineVC = [[ZRTMineViewController alloc] init];
//    }
//
//    return _mineVC;
//
//
//}
//
//
//-(ZRTMeetTableViewController *)meetVC
//{
//
//    if (_meetVC == nil) {
//        
//        _meetVC = [[ZRTMeetTableViewController alloc] init];
//        
//    }
//
//    return _meetVC;
//
//}
//
//-(ZRTConsultationViewController *)consultationVC
//{
//    
//    if (_consultationVC == nil) {
//        
//        _consultationVC = [[ZRTConsultationViewController alloc] init];
//    }
//
//    return _consultationVC;
//}











@end
