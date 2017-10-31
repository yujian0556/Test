//
//  OZHPictureView.h
//  yiduoduo
//
//  Created by Olivier on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTConsultationModel.h"
#import "Interface.h"

@interface OZHPictureView : UIView

//朋友圈图片属性
#define KPictureSize KScreenWidth == 375 ? 80 : 75
#define KPictureOrignX 90
#define KpictureOrignY 90
//根据模型生成View,模型中要有图片数组
+ (UIView *)createPictureViewWithCGRect:(CGRect)rect AndModel:(ZRTConsultationModel *)model;

//根据图片数组生成View
+ (UIView *)createPictureViewWithCGRect:(CGRect)rect AndArray:(NSArray *)picArr;
@end
