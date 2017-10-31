//
//  ZRTUploadView.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZRTUploadViewDelegete <NSObject>

-(void)changeFrame:(CGFloat)maxY;

- (void)deleteObjectInPhotoArray:(NSInteger)index;

@end



@interface ZRTUploadView : UIView




@property (nonatomic, strong) NSArray *photoItemArray;

@property (nonatomic,strong) id<ZRTUploadViewDelegete> delegete;


@end
