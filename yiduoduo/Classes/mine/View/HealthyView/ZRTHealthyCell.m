 //
//  ZRTHealthyCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHealthyCell.h"

#define KTitleColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]
#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]


@interface ZRTHealthyCell ()




@property (nonatomic,strong) NSIndexPath *indexPath;



@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat font;

@end


@implementation ZRTHealthyCell




+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HealthyCell";
    
    ZRTHealthyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTHealthyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        // 屏幕适配

        [self OSD];
        
        
        [self setAllView];
        
    }
    
    return self;
}


-(void)OSD
{
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

-(void)setAllView{
    
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
    
    NSString *time = self.model.HCreateDate;
    //2015/7/22 14:29:00
    
    time = [time substringWithRange:NSMakeRange(0, 9)];
    
    self.timeLabel.text = time;
    
    
    [self.timeLabel sizeToFit];
    
    
    CGFloat timeH = self.timeLabel.height;
    CGFloat timeWidth = self.timeLabel.width;
    
    
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.index.frame), (self.cellH - timeH)*0.5, timeWidth, timeH);
    
    
    [self.contentView addSubview:self.timeLabel];
    
    
    // 标题

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLabel.frame)+10, (self.cellH - labelH)*0.5, KScreenWidth - self.timeLabel.frame.size.width - self.index.frame.size.width - 30, labelH)];
    
    self.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    self.titleLabel.textColor = KTitleColor;
//    NSString *title = @"我的健康档案";  // 数据变化
    
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"标题 : %@",self.model.Topic]];
    
    
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







@end
