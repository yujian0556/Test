//
//  ZRTSearchCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTCaseModel.h"
#import "ZRTVideoModel.h"

@interface ZRTSearchCell : UITableViewCell


+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setAllView;


@property (nonatomic,strong) ZRTCaseModel *caseModel;

@property (nonatomic,strong) ZRTVideoModel *videoModel;

-(void)setAllView;

@end
