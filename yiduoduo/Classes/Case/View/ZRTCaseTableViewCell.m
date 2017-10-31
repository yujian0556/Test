//
//  ZRTCase2TableViewCell.m
//  yiduoduo
//
//  Created by Chen on 15/10/24.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTCaseTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"


@implementation ZRTCaseTableViewCell
{
    CGFloat cellH;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"HotCell";
    ZRTCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    
    if (cell == nil) {
        
        cell = [[ZRTCaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setAllView];
    }
    return self;
}

#define marginX 20
#define marginY 10

- (void)setAllView
{
    if (IPHONE6P) {
        
        cellH = 100;
    }else{
        
        cellH = 80;
    }
    NSString *url;
    NSString *title;
    
    
    
    if (self.caseModel) {
        
        url = self.caseModel.OldCaseContent;
        title = self.caseModel.YWTitle;
    
    }
    
    CGFloat imageH = cellH - marginY*2;
    CGFloat imageW = imageH /9*16;
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, imageW, imageH)];
    
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,url]] placeholderImage:[UIImage imageNamed:@"图片延迟加载"]];
    
//    NSLog(@"url %@",url);
    
    [self.contentView addSubview:image];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+marginX/2, image.y, KScreenWidth - CGRectGetMaxX(image.frame) - marginX, 0)];
    
    
    label.text = title;
    
    label.numberOfLines = 0;
    
    [self.contentView addSubview:label];
    
    [label sizeToFit];
    
    
    
    
    
    
  //  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cellH, KScreenWidth, 15)];
    
   // [self.contentView addSubview:view];
    
    //view.backgroundColor = KRGBColor(238, 238, 238);
    
}


@end
