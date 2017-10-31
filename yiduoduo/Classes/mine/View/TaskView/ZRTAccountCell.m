//
//  ZRTAccountCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/8.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTAccountCell.h"



@interface ZRTAccountCell ()

@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,strong) UILabel *time;

@property (nonatomic,strong) UILabel *award;

@property (nonatomic,strong) UILabel *source;

@property (nonatomic,strong) UILabel *count;

@property (nonatomic,copy) NSString *sourceStr;

@property (nonatomic,assign) NSInteger sourceCount;

@property (nonatomic,copy) NSString *date;


@end


@implementation ZRTAccountCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"AccountCell";
    
    ZRTAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        // 屏幕适配
        
       //  [self OSD];
        
        
        [self setAllView];
        
    }
    
    return self;
}








#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]
-(void)setAllView
{
    
    CGFloat marginX;
    
    if (IPHONE6P) {
        
        marginX = 40;
    }else{
    
        marginX = 20;
    }

    
    // 时间
    
    self.time = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, 0, 0)];
    
    [self.contentView addSubview:self.time];
    
//    NSLog(@" %@",self.date);
    
    self.time.text = self.date;
    
    self.time.font = [UIFont systemFontOfSize:15];
    
    self.time.textColor = [UIColor orangeColor];
    
    [self.time sizeToFit];
    
    self.time.y = (self.height - self.time.height)/2;
    
    
    // 分割线
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height -1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    [self.contentView addSubview:view];
    
    
    // 奖励类型
    
//    self.award = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.time.frame)+marginX, 0, 0, 0)];
//    
//    [self.contentView addSubview:self.award];
//    
//     self.award.text = @"系统奖励";
//    
//    self.award.font = [UIFont systemFontOfSize:17];
//    
//    [self.award sizeToFit];
//    
//    self.award.y = (self.height - self.award.height)/2;

    
   
    // 奖励来源
    
    self.source = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.time.frame)+marginX, 0, 0, 0)];
    
    [self.contentView addSubview:self.source];
    
    self.source.text = self.sourceStr;
    
    self.source.textColor = KMainColor;
    
    self.source.font = [UIFont systemFontOfSize:17];
    
    [self.source sizeToFit];
    
    self.source.y = (self.height - self.source.height)/2;
    
    
    
    // 增加的积分
    
    
    self.count = [[UILabel alloc] init];
    
    
    if (self.sourceCount == 0) {
        
    }
    
    if (self.sourceCount >0 ) {
        
       self.count.text = [NSString stringWithFormat:@"+%ld",(long)self.sourceCount];
    
    }else if(self.sourceCount < 0){
    
        self.count.text = [NSString stringWithFormat:@"%ld",(long)self.sourceCount];
    }
    
    
    
    self.count.textColor = KLineColor;
    
    [self.contentView addSubview:self.count];
    
    [self.count sizeToFit];
    
    self.count.x = KScreenWidth - self.count.width - marginX;
    
    self.count.y = (self.height - self.count.height)/2;
    
}



-(void)setModel:(DsForTask *)model
{
    _model = model;

    NSRange range = [model.Remark rangeOfString:@"["];

    NSString *result = [model.Remark substringFromIndex:range.location+1];
    
    NSRange range1 = [result rangeOfString:@"]"];
    
    NSString *result1 = [result substringToIndex:range1.location];
    
    // 奖励来源
    self.sourceStr = result1;
    
    // 奖励分数
    
    self.sourceCount = model.CurrentScore;
    
    // 时间
    
    self.date = model.CurrentDate;

}







@end
