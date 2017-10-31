//
//  ZRTTabBar.m
//  yiduoduo
//
//  Created by moyifan on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTabBar.h"
#import "ZRTTabBarButton.h"


@interface ZRTTabBar ()

//@property (nonatomic,weak) UIButton *plusButton;

@property (nonatomic,strong) NSMutableArray *tabBarButtons;



@end



@implementation ZRTTabBar



-(void)setItem:(NSArray *)item
{
    
    _item = item;
    
    for (UIView *childView in self.subviews) {
        [childView removeFromSuperview];
    }
    
    for (int i = 0; i < _item.count; i++) {
        
        UITabBarItem *item = self.item[i];
        
        ZRTTabBarButton *btn = [ZRTTabBarButton buttonWithType:UIButtonTypeCustom];
        
        if (i == 2) {
            
            btn.iser = YES;
        }
       
        
        btn.item = item;
        
        btn.tag = self.tabBarButtons.count;
        
        
        
        
        
        
//        if (btn.tag == 2) {
//            
//            [self btnClick:btn];
//        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        
        [self addSubview:btn];
        
        [self.tabBarButtons addObject:btn];
        
        
//        NSLog(@"tabbar   %lu",(unsigned long)self.tabBarButtons.count);
//        
//        NSLog(@"item     %lu",(unsigned long)self.item.count);
        
        
       
        
        
        
    }
    
}


-(void)btnClick:(UIButton *)button
{
    self.selectBtn.selected = NO;
    button.selected = YES;
    self.selectBtn = button;
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didClickBtn:)]) {
        
        [self.delegate tabBar:self didClickBtn:button.tag];
    }
    
}



- (void)plusClick
{
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidClickPlusBtn:)]) {
        [self.delegate tabBarDidClickPlusBtn:self];
    }
    
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    NSUInteger count = 5;
    CGFloat w = self.bounds.size.width / (count );
    CGFloat h = self.bounds.size.height;
    
    
//    NSLog(@"item     %lu",(unsigned long)self.item.count);
//    
//    NSLog(@"tabbar   %lu",(unsigned long)self.tabBarButtons.count);
    
    NSInteger i = 0;
    for (UIView *tabBarButton in self.tabBarButtons) {
        
//        if (i == 2) {
//            i = 3;
//        }
        
        x = i * w;
        
        tabBarButton.frame = CGRectMake(x, y, w, h);
        
      //  NSLog(@"%@",NSStringFromCGRect(tabBarButton.frame));
        
        i++;
    }
    
//    self.plusButton.center = CGPointMake(self.bounds.size.width * 0.5, h * 0.5);
//    [self.plusButton sizeToFit];
}



-(NSMutableArray *)tabBarButtons
{
    
    if (!_tabBarButtons) {
        
        _tabBarButtons = [NSMutableArray array];
        
    }
    return _tabBarButtons;
}


//-(UIButton *)plusButton
//{
//    
//    if (!_plusButton) {
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [btn setBackgroundImage:[UIImage imageNamed:@"menu_home_default"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"menu_home_selected"] forState:UIControlStateHighlighted];
//        
//        [btn addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
//        
//        self.plusButton = btn;
//        
//        [self addSubview:btn];
//        
//        
//    }
//    
//    
//    return _plusButton;
//}









@end
