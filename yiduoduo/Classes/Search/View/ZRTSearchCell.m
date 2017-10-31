//
//  ZRTSearchCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSearchCell.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"

@implementation ZRTSearchCell
{

    CGFloat cellH;

}


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SearchCell";
    
    ZRTSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    
    if (cell == nil) {
        
        cell = [[ZRTSearchCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    
    return cell;
}





-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
      //  [self OSD];
        
        [self setAllView];
        
    }
    
    return self;
}



#define marginX 20
#define marginY 10

-(void)setAllView
{

    //当屏幕为i6p的时候,cell的高
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
        
    }else{
    
        url = self.videoModel.ImgUrl;
        title = self.videoModel.Title;
    }
    
    
    
    //图片的高为cell的高度减去两倍margin的高
    CGFloat imageH = cellH - marginY*2;
    //按照比例的出image的宽
    CGFloat imageW = imageH /9*16;
    
    //cell中图片的大小
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, imageW, imageH)];
    
    //SDwebImage异步下载图片 以及占位图片
    [image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,url]] placeholderImage:[UIImage imageNamed:@"图片延迟加载"]];
    
    NSLog(@" %@",url);
    
    [self.contentView addSubview:image];
    
    
    
    
    //cell中文字的位置                                            
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+marginX/2, image.y, KScreenWidth - CGRectGetMaxX(image.frame) - marginX, 0)];
    
    
    label.text = title;
    //行数设置为0实现自动换行
    label.numberOfLines = 0;
    
    [self.contentView addSubview:label];
    
    [label sizeToFit];


    //cell中的分隔栏
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cellH, KScreenWidth, 15)];
    
    [self.contentView addSubview:view];

    view.backgroundColor = KRGBColor(238, 238, 238);
    
    
}




@end
