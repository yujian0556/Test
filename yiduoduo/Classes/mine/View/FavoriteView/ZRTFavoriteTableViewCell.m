//
//  ZRTFavoriteTableViewCell.m
//  yiduoduo
//
//  Created by olivier on 15/8/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTFavoriteTableViewCell.h"

@interface ZRTFavoriteTableViewCell ()

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *titleLabel;




@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat font;
@end

@implementation ZRTFavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

#define KTitleColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]
#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]

- (void)OSD {
    if (KScreenHeight == 480) {  // 4s
        
        _cellH = 40;
        _font = 12;
        
    }else if (KScreenHeight == 568){  // 5s
        _cellH = 50;
        _font = 14;
        
    }else if (KScreenHeight == 667){  // 6
        
        _cellH = 60;
        _font = 16;
        
    }else{  // 6p
        
        _cellH = 70;
        _font = 20;
    }
}

#define IndexWidth 40

- (void)fillCellWithCaseModel:(ZRTCaseModel *)model {
    
    [self OSD];
    
    CGFloat margin = 20;
    
    CGFloat labelH = 30;
    
    CGFloat timeW = 120;
    
    
    
    
    
    // 标号
    
    self.index = [[UILabel alloc] initWithFrame:CGRectMake(margin, (self.cellH - labelH)*0.5, IndexWidth, labelH)];
    
    self.index.font = [UIFont systemFontOfSize:self.font];
    
    [self.contentView addSubview:self.index];
    
    
    
    // 时间
    
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - labelH)*0.5, timeW, labelH)];
    
    self.timeLabel.font = [UIFont systemFontOfSize:self.font];
    
    NSString *time = model.CollectTime;
    //2015/7/22 14:29:00
    
    time = [time substringWithRange:NSMakeRange(0, 9)];
    
    self.timeLabel.text = time;
    
    
    [self.timeLabel sizeToFit];
    
    
    CGFloat timeH = self.timeLabel.height;
    CGFloat timeWidth = self.timeLabel.width;
    
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - timeH)*0.5, timeWidth, timeH);
    
    
    [self.contentView addSubview:self.timeLabel];
    
    
    // 标题
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10, (self.cellH - labelH)*0.5, KScreenWidth - CGRectGetMaxX(self.timeLabel.frame) - 10, labelH)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    self.titleLabel.textColor = KTitleColor;
    //    NSString *title = @"我的健康档案";  // 数据变化
    
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"标题 : %@",model.Title]];
    
    
    NSRange redRange = NSMakeRange(0, [[titleStr string] rangeOfString:@":"].location +1);
    
    
    [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    [self.titleLabel setAttributedText:titleStr] ;
    
    
    [self.contentView addSubview:self.titleLabel];
    
    
    
    
    
    //  分割线
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH -1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];
    
}

- (void)fillCellWithConsultationModel:(ZRTConsultationModel *)model {
    [self OSD];
    
    CGFloat margin = 20;
    
    CGFloat labelH = 30;
    
    CGFloat timeW = 120;
    
    
    
    
    
    // 标号
    
    self.index = [[UILabel alloc] initWithFrame:CGRectMake(margin, (self.cellH - labelH)*0.5, IndexWidth, labelH)];
    
    self.index.font = [UIFont systemFontOfSize:self.font];
    
    [self.contentView addSubview:self.index];
    
    
    
    // 时间
    
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - labelH)*0.5, timeW, labelH)];
    
    self.timeLabel.font = [UIFont systemFontOfSize:self.font];
    
    NSString *time = model.collectTime;
    //2015/7/22 14:29:00
    
    time = [time substringWithRange:NSMakeRange(0, 9)];
    
    self.timeLabel.text = time;
    
    
    [self.timeLabel sizeToFit];
    
    
    CGFloat timeH = self.timeLabel.height;
    CGFloat timeWidth = self.timeLabel.width;
    
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - timeH)*0.5, timeWidth, timeH);
    
    
    [self.contentView addSubview:self.timeLabel];
    
    
    // 标题
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10, (self.cellH - labelH)*0.5, KScreenWidth - CGRectGetMaxX(self.timeLabel.frame) - 10, labelH)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    self.titleLabel.textColor = KTitleColor;
    //    NSString *title = @"我的健康档案";  // 数据变化
    
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"标题 : %@",model.Title]];
    
    
    NSRange redRange = NSMakeRange(0, [[titleStr string] rangeOfString:@":"].location +1);
    
    
    [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    [self.titleLabel setAttributedText:titleStr] ;
    
    
    [self.contentView addSubview:self.titleLabel];
    
    
    
    
    
    //  分割线
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH -1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];
}



- (void)fillCellWithVideoModel:(ZRTVideoModel *)model {
    [self OSD];
    
    CGFloat margin = 20;
    
    CGFloat labelH = 30;
    
    CGFloat timeW = 120;
    
    
    
    
    
    // 标号
    
    self.index = [[UILabel alloc] initWithFrame:CGRectMake(margin, (self.cellH - labelH)*0.5, IndexWidth, labelH)];
    
    self.index.font = [UIFont systemFontOfSize:self.font];
    
    [self.contentView addSubview:self.index];
    
    
    
    // 时间
    
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - labelH)*0.5, timeW, labelH)];
    
    self.timeLabel.font = [UIFont systemFontOfSize:self.font];
    
    NSString *time = model.collectTime;
    //2015/7/22 14:29:00
    
    time = [time substringWithRange:NSMakeRange(0, 9)];
    
    self.timeLabel.text = time;
    
    
    [self.timeLabel sizeToFit];
    
    
    CGFloat timeH = self.timeLabel.height;
    CGFloat timeWidth = self.timeLabel.width;
    
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - timeH)*0.5, timeWidth, timeH);
    
    
    [self.contentView addSubview:self.timeLabel];
    
    
    // 标题
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10, (self.cellH - labelH)*0.5, KScreenWidth - CGRectGetMaxX(self.timeLabel.frame) - 10, labelH)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    self.titleLabel.textColor = KTitleColor;
    //    NSString *title = @"我的健康档案";  // 数据变化
    
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"标题 : %@",model.Title]];
    
    
    NSRange redRange = NSMakeRange(0, [[titleStr string] rangeOfString:@":"].location +1);
    
    
    [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    [self.titleLabel setAttributedText:titleStr] ;
    
    
    [self.contentView addSubview:self.titleLabel];
    
    
    
    
    
    //  分割线
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH -1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
