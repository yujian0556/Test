//
//  ZRTGradeView.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZRTGradeViewDelegate <NSObject>

-(void)chooseGrade:(CGFloat)grade;

@end



@interface ZRTGradeView : UIView


@property (nonatomic,strong) UIImageView *starEmptyImageView;//空五星imageView


@property (nonatomic,strong) UIImageView *starImageView;//满五星imageView

@property (nonatomic,strong) id<ZRTGradeViewDelegate> delegate;

@end
