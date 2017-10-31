//
//  UIImage+YFImge.h
//  weibo
//
//  Created by moyifan on 15/3/21.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YFImge)

//让图片默认不渲染
+(UIImage *)imageWithOriginalImageName:(NSString *)imageName;

//让图片保持合适的拉伸
+ (UIImage *)imageWithStretchableImageName:(NSString *)imageName;


//+ (UIImage *)imageWithResizableImageName:(NSString *)imageName;

@end
