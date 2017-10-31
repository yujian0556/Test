//
//  ZRTDiscovertowTableViewCell.m
//  yiduoduo
//
//  Created by mac on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDiscovertowTableViewCell.h"

@implementation ZRTDiscovertowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setCellView:(ZRTmodel *)model
{
    self.img.image = [UIImage imageNamed:model.image];
    self.title.text = model.title;
    self.detailTitle.text = model.detialTitle;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
