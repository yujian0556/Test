//
//  ZRTMoreButton.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTMoreButton.h"

@implementation ZRTMoreButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:@"更多" forState:UIControlStateNormal];
        [self setTitleColor:KMainColor forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"首页green"] forState:UIControlStateNormal];
//        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateSelected];
        
        //设置高亮状态下的图片无效果
        self.adjustsImageWhenHighlighted = NO;
        
        [self sizeToFit];
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self sizeToFit];
}


-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
   // if (self.currentImage) {
        self.titleLabel.x = self.imageView.x;
        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
  //  }
    
    
}

@end
