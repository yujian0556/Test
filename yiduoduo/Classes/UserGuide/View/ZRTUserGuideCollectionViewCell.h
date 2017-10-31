//
//  ZRTUserGuideCollectionViewCell.h
//  yiduoduo
//
//  Created by olivier on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^jumpBlock)(void);

@interface ZRTUserGuideCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) jumpBlock block;

- (void)fillCellWithImg:(NSString *)img;

- (void)fillButtonCellWithImg:(NSString *)img;

@end
