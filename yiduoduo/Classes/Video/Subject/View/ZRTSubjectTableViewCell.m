//
//  ZRTSubjectTableViewCell.m
//  yiduoduo
//
//  Created by Olivier on 15/6/17.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSubjectTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "Helper.h"

@implementation ZRTSubjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(CGFloat)fillCellWithModel:(ZRTSubjectModel *)model {
    
    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, KScreenWidth - 20, 100)];
    bgIV.image = [UIImage imageNamed:@"1_03"];
//    [bgIV sd_setImageWithURL:[NSURL URLWithString:model.imageURLString]];
    
    CGFloat titleHeight = [Helper heightOfString:model.titleString font:[UIFont systemFontOfSize:24] width:KScreenWidth - 20];
    
    UIImageView *titleLabelBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgIV.frame.size.height - titleHeight, bgIV.frame.size.width, titleHeight)];
    titleLabelBG.image = [UIImage imageNamed:@"2_03"];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, bgIV.frame.size.height - titleHeight, bgIV.frame.size.width, titleHeight)];
    titleLabel.text = model.titleString;
    titleLabel.font = [UIFont systemFontOfSize:24];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bgIV.frame), CGRectGetMaxY(bgIV.frame) + 5, bgIV.frame.size.width, [Helper heightOfString:model.introduceString font:[UIFont systemFontOfSize:17] width:bgIV.frame.size.width])];
    introduceLabel.text = model.introduceString;
    introduceLabel.numberOfLines = 0;
    introduceLabel.textColor = [UIColor lightGrayColor];
    
    
    [bgIV addSubview:introduceLabel];
    [bgIV addSubview:titleLabelBG];
    [bgIV addSubview:titleLabel];
    [self addSubview:bgIV];
    
    return CGRectGetMaxY(introduceLabel.frame) + 17;
}

@end
