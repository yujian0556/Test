//
//  UIImage+YFImge.m
//  weibo
//
//  Created by moyifan on 15/3/21.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "UIImage+YFImge.h"

@implementation UIImage (YFImge)

// 让图片保持最原始的图片
+(UIImage *)imageWithOriginalImageName:(NSString *)imageName
{
    UIImage *selectImage = [UIImage imageNamed:imageName];
    
    return [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


// 拉伸图片
+ (UIImage *)imageWithStretchableImageName:(NSString *)imageName
{
    UIImage *img = [UIImage imageNamed:imageName];
    
   
    
    return [img stretchableImageWithLeftCapWidth:img.size.width * 0.5 topCapHeight:img.size.height * 0.5];
    
}


//+ (UIImage *)imageWithResizableImageName:(NSString *)imageName
//{
//    UIImage *image = [UIImage imageNamed:imageName];
//
//
//    CGFloat top = image.size.height*0.4; // 顶端盖高度
//    CGFloat bottom = image.size.height*0.4 ; // 底端盖高度
//    CGFloat left = image.size.width*0.4; // 左端盖宽度
//    CGFloat right =image.size.width*0.4; // 右端盖宽度
//    
//    
//    
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//
//    return [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];;
//}

@end
