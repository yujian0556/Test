//
//  ZRTCaseTableViewCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTCaseModel.h"

@interface ZRTHomeCaseTableViewCell : UITableViewCell

@property (nonatomic,strong) NSArray *CaseDataArray;

@property (nonatomic,copy) void (^jumpBlock)(ZRTCaseModel *model);

- (void)PassDataArray:(NSArray *)array;

@end
