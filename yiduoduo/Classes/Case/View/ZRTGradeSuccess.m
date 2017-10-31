//
//  ZRTGradeSuccess.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTGradeSuccess.h"


@interface ZRTGradeSuccess  ()


@property (nonatomic,strong) UIView *meng;


@property (nonatomic,strong) UIImageView *image;


@end


@implementation ZRTGradeSuccess


+(instancetype)initWithSuccess:(BOOL)isSuccess
{
    
    ZRTGradeSuccess *success = [[ZRTGradeSuccess alloc] init];

    
    UIImageView *image = [[UIImageView alloc] init];
    
    if (isSuccess) {
        
    
        
        image.image = [UIImage imageNamed:@"comment"];
        
        
    }else{
        
        image.image = [UIImage imageNamed:@"error"];
    }


    [ZRTKeyWindow addSubview:image];
    
    
    
    [image sizeToFit];
    
    CGFloat width = image.width;
    CGFloat height = image.height;
    
    image.frame = CGRectMake(0, 0, width, height);
    
    image.center = ZRTKeyWindow.center;

    
    success.image = image;
    
    
    [success performSelector:@selector(hide) withObject:nil afterDelay:1.0];
    
    

    return success;

}




-(instancetype)init
{

    if (self = [super init]) {
        
        
        self.frame = ZRTKeyWindow.bounds;
        
        
        self.meng = [[UIView alloc] initWithFrame:ZRTKeyWindow.bounds];
        
        self.meng.userInteractionEnabled = YES;
        
        self.meng.backgroundColor = [UIColor blackColor];
        
        self.meng.alpha = 0.6;
        
        
        
        
        [ZRTKeyWindow addSubview:self.meng];
        
        
        
        
    }


    return self;

}



-(void)hide
{

    
    [self.meng removeFromSuperview];

    [self.image removeFromSuperview];
    
   

}






@end
