//
//  ZRTNewsCollectionCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTNewsModel.h"
#import "ZRTNewsCellModel.h"

@protocol ZRTNewsCollectionCellDelegate <NSObject>

@optional

-(void)didClickHeadView:(ZRTNewsCellModel *)model;

-(void)didClickCell1:(ZRTNewsCellModel *)model;

-(void)didClickCell2:(ZRTNewsCellModel *)model;

-(void)didClickCell3:(ZRTNewsCellModel *)model;

@end


@interface ZRTNewsCollectionCell : UICollectionViewCell


// 背景图
@property(nonatomic ,strong)UIImageView *backView;


@property (nonatomic,strong) ZRTNewsModel *model;





@property (nonatomic,strong) id<ZRTNewsCollectionCellDelegate> delegate;


@end
