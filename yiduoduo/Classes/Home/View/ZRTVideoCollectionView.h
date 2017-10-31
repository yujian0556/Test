//
//  ZRTVideoCollectionView.h
//  yiduoduo
//
//  Created by 余健 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTVideoModel.h"

@interface ZRTVideoCollectionView : UITableViewCell

@property (nonatomic,strong) NSArray *DataArray;

@property (nonatomic,copy) void (^jumpBlock)(ZRTVideoModel *model);

- (void)PassDataArray:(NSArray *)dataArray;

@end
