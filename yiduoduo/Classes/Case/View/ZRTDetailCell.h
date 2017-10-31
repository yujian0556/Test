//
//  ZRTDetailCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/5.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRTDetailCell : UITableViewCell


@property (nonatomic,retain) UILabel *title;


@property (nonatomic,retain) UILabel *text;




@property (nonatomic,strong) UIView *motifImageView;   // 图片view

-(void)setAllView;

@end
