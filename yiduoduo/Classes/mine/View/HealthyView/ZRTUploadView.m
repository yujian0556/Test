//
//  ZRTUploadView.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTUploadView.h"


#define kImagesMargin 15


@implementation ZRTUploadView

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    _photoItemArray = photoItemArray;
    
  //  NSLog(@"array%ld",photoItemArray.count);
    
    
  //  [self removeAllBtn];
    
    [photoItemArray enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        [btn setImage:obj forState:UIControlStateNormal];
        btn.tag = idx;
        
    
      //  [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }];
    
    
    
    
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    
    CGFloat w = 80;
    CGFloat h = 80;
    
    if (KScreenHeight == 480) {  // 4s
        
        
        w = 70;
        h = 70;
        
    }else if (KScreenHeight == 568){  // 5s
        
        w = 70;
        h = 70;
        
    }else if (KScreenHeight == 667){  // 6
        
        w = 90;
        h = 90;
        
    }else{  // 6p
        
        w = 100;
        h = 100;
        
    }
   
   
    
    [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        
        long rowIndex = idx / perRowImageCount;
        int columnIndex = idx % perRowImageCount;
        CGFloat x = columnIndex * (w + kImagesMargin);
        CGFloat y = rowIndex * (h + kImagesMargin);
        btn.frame = CGRectMake(x, y, w, h);
        
        
 //       NSLog(@"btn %@",NSStringFromCGRect(btn.frame));
        
//        CGFloat MaxBtnY = 
        
    
        UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(w-w*0.2, 0, w*0.2, h*0.2)];
        
        [btn addSubview:delete];
        
        delete.tag = idx;
        
        [delete setImage:[UIImage imageNamed:@"kr-video-player-close"] forState:UIControlStateNormal];
        
        [delete addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
       
    }];
    
   
    
    totalRowCount = ceil(self.subviews.count / perRowImageCountF);
    
    self.frame = CGRectMake(0, 0, 280, totalRowCount * (kImagesMargin + h));
    
   
    CGFloat maxY = totalRowCount * (kImagesMargin + h);
    
    if ([self.delegete respondsToSelector:@selector(changeFrame:)]) {
        
        [self.delegete changeFrame:maxY];
        
    }
    
}






-(void)didClickBtn:(UIButton *)btn
{

    
    
    
    if ([self.delegete respondsToSelector:@selector(deleteObjectInPhotoArray:)]) {
        [self.delegete deleteObjectInPhotoArray:btn.tag];
    }

    
    UIButton *imageBtn = self.subviews[btn.tag];
    
    
    [imageBtn removeFromSuperview];
    
    
    
    
    //[self.imageArray removeObjectAtIndex:btn.tag];
    
    
    
}




@end
