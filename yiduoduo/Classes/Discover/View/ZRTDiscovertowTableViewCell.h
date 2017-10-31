//
//  ZRTDiscovertowTableViewCell.h
//  yiduoduo
//
//  Created by mac on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTmodel.h"
@interface ZRTDiscovertowTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
-(void)setCellView:(ZRTmodel *)model;
@end
