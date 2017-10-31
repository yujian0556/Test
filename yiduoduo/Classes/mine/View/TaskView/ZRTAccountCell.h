//
//  ZRTAccountCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/8.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTTasksModel.h"

@class DsForTask;
@interface ZRTAccountCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setAllView;

@property (nonatomic,strong) DsForTask *model;

@end
