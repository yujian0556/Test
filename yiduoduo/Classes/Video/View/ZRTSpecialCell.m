//
//  ZRTSpecialCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSpecialCell.h"

#import "UIImageView+WebCache.h"
#import "Interface.h"
#import "ZRTVideoModel.h"



@interface ZRTSpecialCell ()

@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat font;

@property (nonatomic,strong) UIImageView *image;

@property (nonatomic,strong) UILabel *title;

@property (nonatomic,strong) UILabel *playCount;

@property (nonatomic,strong) UILabel *commentCount;

@property (nonatomic,strong) UIView *line;
@end



@implementation ZRTSpecialCell



+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SpecialCell";
    
    ZRTSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTSpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self OSD];
        
        [self setAllView];
        
    }
    
    return self;
}



-(void)OSD
{
    if (KScreenHeight == 480) {  // 4s
        
        _cellH = 80;
        _font = 12;
        
    }else if (KScreenHeight == 568){  // 5s
        _cellH = 90;
        _font = 14;
        
    }else if (KScreenHeight == 667){  // 6
        
        _cellH = 90;
        _font = 16;
        
    }else{  // 6p
        
        _cellH = 100;
        _font = 18;
    }
    
}



#define marginX 15
#define marginY 10
#define lineColor [UIColor colorWithRed:226/256.0 green:226/256.0 blue:226/256.0 alpha:1]
#define playColor [UIColor colorWithRed:102/256.0 green:102/256.0 blue:102/256.0 alpha:1]
#define commentCountColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]

-(void)setAllView
{

    NSLog(@" %f",self.cellH);
//    NSLog(@" %f",KScreenHeight);
    
    
//    NSLog(@" %f",self.height);
    
    
    CGFloat imageH = self.cellH - marginY*2;
    CGFloat imageW = imageH/3*5;
    
    self.image = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, imageW, imageH)];

  //  self.image.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.contentView addSubview:self.image];

   
    
    
//    NSLog(@" %@",NSStringFromCGRect(self.image.frame));
    
    
  
    
    
    
    
    // 标题
    
    CGFloat titleX = CGRectGetMaxX(self.image.frame)+marginX;
    
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(titleX, marginY, KScreenWidth-titleX-marginX, 0)];
    
    [self.contentView addSubview:self.title];
    
   
    
    self.title.font = [UIFont systemFontOfSize:self.font];
    
    self.title.numberOfLines = 0;
    
    
    
    
    
    // 播放量
    
    UILabel *play = [[UILabel alloc] initWithFrame:CGRectMake(titleX, 0, 0, 0)];
    
    play.text = @"播放:";
    
    play.textColor = playColor;
    
    play.font = [UIFont systemFontOfSize:self.font];
    
    [self.contentView addSubview:play];
    
    [play sizeToFit];
    
    play.y = CGRectGetMaxY(self.image.frame) - play.height;
    
    
    
    
    
    self.playCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(play.frame), play.y, 0, 0)];
    
    
    
    self.playCount.textColor = playColor;
    
    self.playCount.font = [UIFont systemFontOfSize:self.font];
    
    [self.contentView addSubview:self.playCount];
    
    
  
    
    
    
    // 评论数
    
    CGFloat commentCountW = KScreenWidth - CGRectGetMaxX(self.playCount.frame) - marginX;
    
    self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(0, play.y, commentCountW, 0)];
    
    [self.contentView addSubview:self.commentCount];
    
    
    
    self.commentCount.font = [UIFont systemFontOfSize:self.font -1];
    
    self.commentCount.textColor = commentCountColor;
   
    
    
    // 分割线
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH-1, KScreenWidth, 1)];
    
    self.line.backgroundColor = lineColor;
    
    [self.contentView addSubview:self.line];
    
    
    
}






-(void)setModel:(ZRTVideoModel *)model
{

    _model = model;

  // 设置图片
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgUrl]];
    
    [self.image sd_setImageWithURL:url];

    
  // 设置标题
    
     self.title.text = model.Title;
    
    [self.title sizeToFit];
    
  // 设置播放量
   
  //  self.playCount.text = @"18.3万";
    
    if ([model.Click integerValue]<10000) {
        
        self.playCount.text = model.Click;
        
    }else{
        
        NSInteger count = [model.Click integerValue];
        
        self.playCount.text = [NSString stringWithFormat:@"%ld万",count];
        
    }

    [self.playCount sizeToFit];
    
    
    
   // 设置评论数
    
    self.commentCount.text = [NSString stringWithFormat:@"评论数%@",model.replynum];
    
    [self.commentCount sizeToFit];
    
    self.commentCount.x = KScreenWidth - self.commentCount.width - marginX;
    
    self.commentCount.y = CGRectGetMaxY(self.playCount.frame) - self.commentCount.height;
    
}




-(CGFloat)CellHight
{

    return self.cellH;

}






@end
