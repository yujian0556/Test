//
//  ZRTHealthyListTableViewCell.m
//  yiduoduo
//
//  Created by Olivier on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHealthyListTableViewCell.h"

#import "ZRTHealthyModel.h"

#define KBGColor [UIColor colorWithRed:180/256.0 green:180/256.0 blue:180/256.0 alpha:1]

@implementation ZRTHealthyListTableViewCell
{
    CGFloat _lineWidth;
    CGFloat _lineOrgX;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithModel:(id)model AndCount:(NSInteger)count{
    
    ZRTHealthyModel *hModel = (ZRTHealthyModel *)model;
    
    [self BaseOnTheDevice];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBtn.frame = CGRectMake(20, 0, 15, 15);
    self.selectBtn.center = CGPointMake(20, 45/2);
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateSelected];
    [self.selectBtn addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *recordNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.selectBtn.frame) + 5, 1, KScreenWidth - 128 - 20 - CGRectGetMaxX(self.selectBtn.frame) - 5, self.height -2)];
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 128 - 20 + 1, 1, 128 - 2, self.height-2)];
    
    recordNameLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
    recordNameLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.font = [UIFont systemFontOfSize:14];
    
    NSString *date = hModel.HCreateDate;;
    NSArray *dateArr = [date componentsSeparatedByString:@" "];
    
    recordNameLabel.text = hModel.Topic;
    dateLabel.text = dateArr[0];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(recordNameLabel.frame), 0, 1, self.height)];
    line1.backgroundColor = KBGColor;
    [self.contentView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(dateLabel.frame), 0, 1, self.height)];
    line2.backgroundColor = KBGColor;
    [self.contentView addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame)-2, 0, 1, self.height)];
    line3.backgroundColor = KBGColor;
    [self.contentView addSubview:line3];
    
    if (count == 0) {
        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(line1.frame), 0, _lineWidth, 1)];
        line4.backgroundColor = KBGColor;
        [self.contentView addSubview:line4];
    }
    
    UIView *line5 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(line1.frame), self.height - 1, _lineWidth, 1)];
    line5.backgroundColor = KBGColor;
    [self.contentView addSubview:line5];
    
    [self.contentView addSubview:self.selectBtn];
    [self.contentView addSubview:recordNameLabel];
    [self.contentView addSubview:dateLabel];
}

- (void)BaseOnTheDevice {
    if (KScreenWidth == 320) {
        _lineWidth = 265;
    }
    else if (KScreenWidth == 375) {
        _lineWidth = self.width;
    }
    else {
        _lineWidth = 359;
    }
}

- (void)changeState:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    
    
}

@end
