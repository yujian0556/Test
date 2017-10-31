//
//  ZRTSelectorController.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZRTSelectModel;

@protocol ZRTSelectorControllerDelegate <NSObject>

-(void)changeContent:(ZRTSelectModel *)model;

@end

@interface ZRTSelectorController : UITableViewController


@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,strong) id<ZRTSelectorControllerDelegate> delegate;


@end
