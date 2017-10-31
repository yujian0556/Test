//
//  ZRTMissionCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/10.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTMissionCell.h"

@class Detail;

@interface ZRTMissionCell ()


@property (nonatomic,strong) UIImageView *iconView;

@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,strong) UILabel *MissionName;

@property (nonatomic,strong) UIImageView *progressView;

@property (nonatomic,strong) UIImageView *progressViewFull;

@property (nonatomic,strong) UILabel *progressLabel;

@property (nonatomic,strong) UILabel *Success;



@end


@implementation ZRTMissionCell




+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"MissionCell";
    
    ZRTMissionCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTMissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
        
        _cellH = 70;
        
    }else if (KScreenHeight == 568){  // 5s
        _cellH = 70;
        
    }else if (KScreenHeight == 667){  // 6
        
        _cellH = 70;
        
    }else{  // 6p
        
        _cellH = 80;
        
    }
    
}




#define marginX 20
#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]
#define textCR [UIColor colorWithRed:145/256.0 green:146/256.0 blue:147/256.0 alpha:1]

-(void)setAllView
{
    
    // 头像
    
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, 0, 0, 0)];
    
    self.iconView.image = [UIImage imageNamed:@"pic_placeHodel"];
    
    [self.iconView sizeToFit];
    
    self.iconView.y = (_cellH - self.iconView.height)/2;
    
    
//    NSLog(@" %f",_cellH);
//    
//    NSLog(@" %f",self.iconView.y);
    
    [self.contentView addSubview:self.iconView];
    
    
    
    
    //  分割线
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.cellH - 1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];

    
    
   // 任务名称
    
    self.MissionName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame)+marginX/2, 10, 0, 0)];
    
    [self.contentView addSubview:self.MissionName];

    self.MissionName.textColor = textCR;
    
    
    
    // 任务进度条(空)
    
    self.progressView = [[UIImageView alloc] init];
    
    [self.contentView addSubview:self.progressView];
    
    
    // 任务进度条(满)
    
    self.progressViewFull = [[UIImageView alloc] init];
    
    [self.progressView addSubview:self.progressViewFull];
    
    
  // 任务进度百分比
    
    self.progressLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:self.progressLabel];
    
    self.progressLabel.font = [UIFont systemFontOfSize:15];
    
    self.progressLabel.textColor = KMainColor;
    
    
    
    
    
    
}


// 设置名字

-(void)setName:(NSString *)name
{
    
    CGFloat font;
    if (IPHONE6P) {
        
        font = 17;
    }else{
    
        font = 16;
    }
    
    _name = name;

    self.MissionName.text = name;
    
    self.MissionName.font = [UIFont systemFontOfSize:font];
    
    [self.MissionName sizeToFit];
    
    
}
    
    
//设置进度条

-(void)setProgress:(NSInteger )progress
{

    _progress = progress;

  //  NSLog(@" %@",progress);

    
    self.progressView.image = [UIImage imageNamed:@"0"];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%ld%%",(long)progress];
    
    self.progressViewFull.image = [UIImage imageNamed:@"100"];
    

//    if ([progress isEqualToString:@"0"]) {
//        
//        self.progressView.image = [UIImage imageNamed:@"0"];
//        
//        self.progressLabel.text = @"0%";
//        
//    }else if ([progress isEqualToString:@"1"]){
//    
//        self.progressView.image = [UIImage imageNamed:@"30"];
//        
//        self.progressLabel.text = @"30%";
//    
//    }else if ([progress isEqualToString:@"2"]){
//    
//        self.progressView.image = [UIImage imageNamed:@"60"];
//        
//        self.progressLabel.text = @"60%";
//    
//    }else if ([progress isEqualToString:@"3"]){
//    
//        self.progressView.image = [UIImage imageNamed:@"100"];
//        
//        self.progressLabel.text = @"100%";
//    }
    
    
    // 空进度条
    
    [self.progressView sizeToFit];
    
    self.progressView.x = self.MissionName.x;
    
    self.progressView.y = CGRectGetMaxY(self.MissionName.frame) + 5;
    
    
    
    // 满进度条
    
    self.progressViewFull.frame = CGRectMake(0, 0, self.progressView.width, self.progressView.height);
    
    CGFloat FullW = self.progressView.width/100;
    
    self.progressViewFull.width = FullW * progress;
    

    
    
    [self.progressLabel sizeToFit];
    
    self.progressLabel.center = self.progressView.center;
    
    self.progressLabel.x = CGRectGetMaxX(self.progressView.frame);
    
    
    
    if (progress == 100) {
        
        self.isSuccess = YES;
    }
    
    
    
}



-(void)setScore:(NSInteger *)score
{

    _score = score;
    // 增加的积分
    
    UILabel *jifen = [[UILabel alloc] initWithFrame:CGRectMake(self.MissionName.x, CGRectGetMaxY(self.progressView.frame)+5, 0, 0)];
    
    if (score>=0) {
        
        jifen.text = [NSString stringWithFormat:@"+%tu",score];
    
    }else{
    
        jifen.text = [NSString stringWithFormat:@"%tu",score];;
    }
 
    
    jifen.textColor = KLineColor;
    
    [jifen sizeToFit];
    
    [self.contentView addSubview:jifen];
    
    
    
    UILabel *jifen2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(jifen.frame), jifen.y, 0, 0)];
    
    jifen2.text = @"积分";
    
    jifen2.textColor = [UIColor darkGrayColor];
    
    jifen2.font = [UIFont systemFontOfSize:14];

    [jifen2 sizeToFit];
    
    [self.contentView addSubview:jifen2];
    
    jifen2.y = CGRectGetMaxY(jifen.frame) - jifen2.height -2;
    
    
    // 设置完成文字

    [self setUpSuccess];
    
}



-(void)setUpSuccess
{
    
    UIView *fenge = [[UIView alloc] init];
    
    
    if (KScreenHeight == 736) {  //6p
        
        fenge.frame = CGRectMake(KScreenWidth-marginX*3-marginX/2, 10, 1, _cellH - 10*2);
        
    }else{
        
        fenge.frame = CGRectMake(self.width-marginX*3-marginX/2, 5, 1, _cellH - 5*2);
        
    }
    
    
    
    fenge.backgroundColor = KfengeColor;
    
    [self.contentView addSubview:fenge];
    
    
    [self.Success removeFromSuperview];
    
    self.Success = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fenge.frame)+marginX/2, 0, 0, 0)];
    
    
    if (self.isSuccess) {
        
        self.Success.text = @"完成";
    }else{
        
        self.Success.text = @"未完成";
        
    }
    
    [self.contentView addSubview:self.Success];
    
    [self.Success sizeToFit];
    
    self.Success.y = (_cellH - self.Success.height)/2;



}


@end
