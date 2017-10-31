//
//  ZRTTaskCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/8.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTaskCell.h"

@interface ZRTTaskCell ()




@end


@implementation ZRTTaskCell


+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"TaskCell";
    
    ZRTTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        // 屏幕适配
        
       // [self OSD];
        
        
        [self setAllView];
        
    }
    
    return self;
}


#define marginX 20
#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]
-(void)setAllView
{

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, 0, 0)];

    self.label = label;
    
   
    [self.contentView addSubview:label];


    // 分割线
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height -1, KScreenWidth, 1)];
    
    view.backgroundColor = KfengeColor;
    
    [self.contentView addSubview:view];
    
    // 箭头
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(KScreenWidth - marginX, 0, 0, 0)];
    
    image.image = [UIImage imageNamed:@"arrow_task"];
    
    [image sizeToFit];
    
    image.y = (self.height - image.height)/2;
    
    [self.contentView addSubview:image];
    
    
}






@end
