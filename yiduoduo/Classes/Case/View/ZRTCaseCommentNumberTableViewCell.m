//
//  ZRTCaseCommentNumberTableViewCell.m
//  yiduoduo
//
//  Created by olivier on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCaseCommentNumberTableViewCell.h"

#import "Helper.h"

@implementation ZRTCaseCommentNumberTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define XDistance 20
#define YDistance 9
#define FontSize 14

#define cellHeight 25
#define CommentNumberLabelCenterX ([Helper widthOfString:[NSString stringWithFormat:@"评论(%@)",data] font:[UIFont systemFontOfSize:FontSize] height:FontSize] / 2 )+ 20

- (CGFloat)fillCellWithData:(NSDictionary *)data {
    
    NSString *commentNumber = data[@"replycount"];
    NSString *favoriteNumber = data[@"collectcount"];
    
    CGFloat width = [Helper widthOfString:[NSString stringWithFormat:@"评论(%@)",commentNumber] font:[UIFont systemFontOfSize:FontSize] height:FontSize];
    
    UILabel *commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(XDistance, YDistance, width, FontSize)];
    
    //commentNumberLabel.center = CGPointMake(CommentNumberLabelCenterX, cellHeight/2);
    
    commentNumberLabel.text = [NSString stringWithFormat:@"评论(%@)",commentNumber];
    commentNumberLabel.font = [UIFont systemFontOfSize:FontSize];
    
    
    
    CGFloat favoriteWidth = [Helper widthOfString:[NSString stringWithFormat:@"收藏(%@)",favoriteNumber] font:[UIFont systemFontOfSize:FontSize] height:FontSize];
    
    UILabel *favoriteNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - favoriteWidth - 14, CGRectGetMinY(commentNumberLabel.frame), favoriteWidth, FontSize)];
    
    favoriteNumberLabel.text = [NSString stringWithFormat:@"收藏(%@)",favoriteNumber];
    favoriteNumberLabel.font = [UIFont systemFontOfSize:FontSize];
    favoriteNumberLabel.textColor = KTimeColor;
    
    [self.contentView addSubview:commentNumberLabel];
    [self.contentView addSubview:favoriteNumberLabel];
    
    return cellHeight;
}


- (CGFloat)fillVideoCellWithData:(NSString *)data {
    
    CGFloat width = [Helper widthOfString:[NSString stringWithFormat:@"评论数量(%@)",data] font:[UIFont systemFontOfSize:FontSize] height:FontSize];
    
    UILabel *commentNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(XDistance, YDistance, width, FontSize)];
    
    commentNumberLabel.center = CGPointMake(CommentNumberLabelCenterX, cellHeight/2);
    
    commentNumberLabel.text = [NSString stringWithFormat:@"评论数量(%@)",data];
    commentNumberLabel.font = [UIFont systemFontOfSize:FontSize];
    
    
    [self.contentView addSubview:commentNumberLabel];
    
    return cellHeight;
}

@end
