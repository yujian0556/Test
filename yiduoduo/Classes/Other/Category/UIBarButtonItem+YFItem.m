//
//  UIBarButtonItem+YFItem.m
//  weibo
//
//  Created by moyifan on 15/3/24.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "UIBarButtonItem+YFItem.h"

@implementation UIBarButtonItem (YFItem)



+(UIBarButtonItem *)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn sizeToFit];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
