//
//  ZRTHealthyCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTHealthyModel.h"

@interface ZRTHealthyCell : UITableViewCell

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *index;

@property (nonatomic,strong) ZRTHealthyModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setAllView;

@end
