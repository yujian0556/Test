//
//  ZRTConsultationDetailCommentTableViewCell.m
//  yiduoduo
//
//  Created by Olivier on 15/5/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationDetailCommentTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "Helper.h"
#import "Interface.h"

@interface ZRTConsultationDetailCommentTableViewCell ()

@property (nonatomic,strong) UIImageView *headerImageView;//头像
@property (nonatomic,strong) UILabel *userNameLabel;//用户名
@property (nonatomic,strong) UIView *separateLineView;//分割线
@property (nonatomic,strong) UILabel *doctorInfomationLabel;//医生信息，包含科室和等级
@property (nonatomic,strong) UILabel *contentLabel;//内容

@end

@implementation ZRTConsultationDetailCommentTableViewCell
{
    UILabel *_timeLabel;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)fillCellWithDictionary:(NSDictionary *)dict
{
    
    //设置头像
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",ImagePath,dict[@"ImgUrl"]];
    
//    NSLog(@"会诊 %@",path);
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    //设置用户名
    NSString *name;
    if ([dict[@"NickName"] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"用户%@",dict[@"UserId"]];
    }
    else {
        name = dict[@"NickName"];
    }
    
    
    self.userNameLabel = [[UILabel alloc] init];
    self.userNameLabel.textColor = KMainColor;
    NSString *userNameString;
    NSRange range = [dict[@"Contents"] rangeOfString:@":回复"];
    if (range.length) {
        userNameString = [dict[@"Contents"] substringToIndex:range.location];
    }
    else {
        userNameString = dict[@"Contents"];
    }
    self.userNameLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 5, 15, KScreenWidth-(CGRectGetMaxX(self.headerImageView.frame) + 5), 17);
    self.userNameLabel.text = name;
#if 0
    //设置分割线
    self.separateLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame) + 5, 15, 1, 17)];
    self.separateLineView.backgroundColor = [UIColor lightGrayColor];
    
    //设置科室和医生等级
    NSString *doctorInfomation = [NSString stringWithFormat:@"%@ %@",dict[@"SectionOffice"],dict[@"Professional"]];
    self.doctorInfomationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.separateLineView.frame) + 5, 15, [OZHHelper widthOfString:doctorInfomation font:[UIFont systemFontOfSize:17] height:17], 17)];
    self.doctorInfomationLabel.text = doctorInfomation;
    self.doctorInfomationLabel.textColor = [UIColor lightGrayColor];
#endif
    
    //评论内容
    self.contentLabel = [[UILabel alloc] init];
    NSString *originalString;
//    NSMutableAttributedString *contentString;
//    if (range.length) {
//        
        originalString = [NSString stringWithFormat:@"%@ : %@",name/*[dict[@"NickName"] substringFromIndex:range.location]*/,dict[@"Contents"]];
//        contentString = [[NSMutableAttributedString alloc] initWithString:originalString];
//        
//        NSRange colonRange = [originalString rangeOfString:@":"];
//
//        [contentString addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(0, colonRange.location)];
//    }
//    else {
//        originalString = dict[@"Contents"];
//        contentString = [[NSMutableAttributedString alloc] initWithString:originalString];
//    }
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame), CGRectGetMaxY(self.userNameLabel.frame) + 10, KScreenWidth - 10 - 40, [Helper heightOfString:originalString font:[UIFont systemFontOfSize:17] width:KScreenWidth - 10 - 40]);
//    self.contentLabel.attributedText = contentString;
    self.contentLabel.text = originalString;
    self.contentLabel.numberOfLines = 0;

    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.userNameLabel];
//    [self.contentView addSubview:self.separateLineView];
//    [self.contentView addSubview:self.doctorInfomationLabel];
    [self.contentView addSubview:self.contentLabel];

    return CGRectGetMaxY(self.contentLabel.frame);
}




- (CGFloat)fillCaseCommentCellWithData:(NSDictionary *)dict {
    
    
    
    
    //设置头像
    UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",ImagePath,dict[@"ImgUrl"]];
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    
    
    //设置用户名
    NSString *name;
    if ([dict[@"NickName"] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"用户%@",dict[@"UserId"]];
    }
    else {
        name = dict[@"NickName"];
    }
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = KMainColor;
    userNameLabel.frame = CGRectMake(CGRectGetMaxX(headerImageView.frame) + 5, 15, KScreenWidth-(CGRectGetMaxX(headerImageView.frame) + 5), 17);
    userNameLabel.text = name;
    
    
#define FontSize 9
#define TimeString dict[@"AddTime"]

    
    //发布时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(userNameLabel.frame), CGRectGetMaxY(userNameLabel.frame) + 7, [Helper widthOfString:TimeString font:[UIFont systemFontOfSize:FontSize] height:FontSize], FontSize)];
    
    timeLabel.text = TimeString;
    timeLabel.font = [UIFont systemFontOfSize:FontSize];
    timeLabel.textColor = KTimeColor;
    
    
    //评论内容
    UILabel *contentLabel = [[UILabel alloc] init];
    NSString *originalString;
    
    originalString = [NSString stringWithFormat:@"%@",dict[@"Remark"]];

    contentLabel.frame = CGRectMake(CGRectGetMaxX(headerImageView.frame), CGRectGetMaxY(timeLabel.frame) + 10, KScreenWidth - 10 - 40, [Helper heightOfString:originalString font:[UIFont systemFontOfSize:17] width:KScreenWidth - 10 - 40]);
    contentLabel.text = originalString;
    contentLabel.numberOfLines = 0;
    
    [self.contentView addSubview:headerImageView];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:timeLabel];
    
    
    return CGRectGetMaxY(contentLabel.frame);
    
}

-(CGFloat)fillVideoCommentCellWithData:(NSDictionary *)dict {
    //设置头像
    UIImageView* headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    
    NSString *path = [NSString stringWithFormat:@"%@%@",ImagePath,dict[@"ImgUrl"]];
//    
//    NSLog(@" %@",dict[@"ImgUrl"]);
    
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    
    
    //设置用户名
    NSString *name;
    if ([dict[@"NickName"] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"用户%@",dict[@"UserId"]];
    }
    else {
        name = dict[@"NickName"];
    }
    
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.textColor = KMainColor;
    userNameLabel.frame = CGRectMake(CGRectGetMaxX(headerImageView.frame) + 5, 15, KScreenWidth-(CGRectGetMaxX(headerImageView.frame) + 5), 17);
    userNameLabel.text = name;
    
    //发布时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(userNameLabel.frame), CGRectGetMaxY(userNameLabel.frame) + 7, [Helper widthOfString:TimeString font:[UIFont systemFontOfSize:FontSize] height:FontSize], FontSize)];
    
    timeLabel.text = TimeString;
    timeLabel.font = [UIFont systemFontOfSize:FontSize];
    timeLabel.textColor = KTimeColor;
    
    
    //评论内容
    UILabel *contentLabel = [[UILabel alloc] init];
    NSString *originalString;
    
    originalString = [NSString stringWithFormat:@"%@",dict[@"Remark"]];
    
    contentLabel.frame = CGRectMake(CGRectGetMaxX(headerImageView.frame), CGRectGetMaxY(timeLabel.frame) + 10, KScreenWidth - 10 - 40, [Helper heightOfString:originalString font:[UIFont systemFontOfSize:17] width:KScreenWidth - 10 - 40]);
    contentLabel.text = originalString;
    contentLabel.numberOfLines = 0;
    
    [self.contentView addSubview:headerImageView];
    [self.contentView addSubview:contentLabel];
    [self.contentView addSubview:userNameLabel];
    [self.contentView addSubview:timeLabel];
    
    
    return CGRectGetMaxY(contentLabel.frame);
}

@end
