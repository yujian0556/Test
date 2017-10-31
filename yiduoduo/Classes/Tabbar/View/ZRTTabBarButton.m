//
//  ZRTTabBarButton.m
//  yiduoduo
//
//  Created by moyifan on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTabBarButton.h"

@implementation ZRTTabBarButton


#pragma mark 懒加载




-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      //  [self setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}


-(void)setHighlighted:(BOOL)highlighted{}

-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [self setTitle:_item.title forState:UIControlStateNormal];
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    
    
    
    
}


-(void)dealloc
{
    [_item removeObserver:self forKeyPath:@"title"];
    [_item removeObserver:self forKeyPath:@"image"];
    [_item removeObserver:self forKeyPath:@"selectedImage"];
   
}


-(void)layoutSubviews
{
     [super layoutSubviews];
    
    CGFloat xy = 0;
    CGFloat imagew = self.width;
    CGFloat imageh = self.height *0.7;
    
    CGFloat titleH = self.height - imageh;
    CGFloat titleY = imageh -4;
   
 //   self.imageView.frame = CGRectMake(xy, xy, imagew, imageh);
    
    if (self.iser) {
        
       
        
        imageh = self.height;
        
        self.imageView.frame = CGRectMake(xy, xy, imagew, imageh);
        
        
        
    }else{
    
    
       
        self.imageView.frame = CGRectMake(xy, xy, imagew, imageh);
        
        
        
        self.titleLabel.frame = CGRectMake(xy, titleY, imagew, titleH);
        
       
        
        
    }
    
   
    
    
    
}




@end
