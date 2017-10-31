//
//  ZRTMissionCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/10.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTMissionModel.h"

@interface ZRTMissionCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setAllView;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,assign) NSInteger progress;

@property (nonatomic,assign) NSInteger *score;

@property (nonatomic,assign) BOOL isSuccess;

@end
