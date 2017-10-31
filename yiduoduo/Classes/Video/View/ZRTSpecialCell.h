//
//  ZRTSpecialCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZRTVideoModel;
@interface ZRTSpecialCell : UITableViewCell


@property (nonatomic,strong) ZRTVideoModel *model;


- (void)setAllView;


+(instancetype)cellWithTableView:(UITableView *)tableView;

-(CGFloat)CellHight;



@end
