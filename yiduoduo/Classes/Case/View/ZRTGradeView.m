//
//  ZRTGradeView.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/11.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTGradeView.h"

@implementation ZRTGradeView



-(instancetype)init
{

    if (self = [super init]) {


        
        //空星级imageView
        _starEmptyImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lov-half"]];
        

      
        [_starEmptyImageView sizeToFit];
  
        CGFloat width = _starEmptyImageView.width;
        CGFloat height = _starEmptyImageView.height;
        
   
        
        
        self.frame = CGRectMake(0, 0, width, height);
        
     
        
        _starEmptyImageView.userInteractionEnabled=YES;
        
        [self addSubview:_starEmptyImageView];
        
        
        
        _starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lov-ful"]];
        
        _starImageView.frame=CGRectMake(0,0,0,height);
        _starImageView.contentMode=UIViewContentModeLeft;
        _starImageView.clipsToBounds=YES;
        
        
        [self addSubview:_starImageView];
        
        //单击手势
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGR:)];
        [_starEmptyImageView addGestureRecognizer:tapGR];
        
        
        
    }

    return self;
}



#pragma mark 手势
//单击手势
-(void)tapGR:(UITapGestureRecognizer *)tapGR{
    CGPoint tapPoint=[tapGR locationInView:_starEmptyImageView];
  //  _width=tapPoint.x/_starEmptyImageView.bounds.size.width;
    
    
    
    CGFloat width = _starEmptyImageView.width/5;
    CGFloat fen = 0;
    
//    NSLog(@"width %f",width);
//    
//    NSLog(@"point %f",tapPoint.x);
    
    if (0<tapPoint.x && width>tapPoint.x) {
        
        tapPoint.x = width;
        fen = 1;
        
        
    }else if (width<tapPoint.x && width*2>tapPoint.x){
    
        tapPoint.x = width*2;
        fen = 2;
    
    }else if (width*2<tapPoint.x && width*3>tapPoint.x){
    
        tapPoint.x = width*3;
        fen = 3;
        
    }else if (width*3<tapPoint.x && width*4>tapPoint.x){
    
        tapPoint.x = width*4;
        fen = 4;
        
    }else{
        
        tapPoint.x = width*5;
        fen = 5;
    }
    
    
    
   
    
    _starImageView.frame=CGRectMake(0,0,tapPoint.x,_starEmptyImageView.height);
    
   
    
    if ([self.delegate respondsToSelector:@selector(chooseGrade:)]) {
        
        [self.delegate chooseGrade:fen];
        
    }
    

}


@end
