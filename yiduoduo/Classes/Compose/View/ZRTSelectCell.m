//
//  ZRTSelectCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSelectCell.h"

#import "ZRTSelectModel.h"

#define KTitleColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]
#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]

#define margin 20


@interface ZRTSelectCell ()


@property (nonatomic,assign) CGFloat cellH;

@property (nonatomic,assign) CGFloat font;

@end


@implementation ZRTSelectCell





+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SelectCell";
    
    ZRTSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[ZRTSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    
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


-(void)setAllView
{

    
    
    // 科室
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, (self.height-30)*0.5, self.width, 30)];
    
    [self.contentView addSubview:self.titleLabel];
    
    
    self.titleLabel.textColor = [UIColor darkGrayColor];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    
    
    

    //  分割线
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(margin-4, self.height -1, KScreenWidth-margin, 1)];
    
    view.backgroundColor = KfengeColor;
    
    view.alpha = 0.5;
    
    [self.contentView addSubview:view];
    
    
    

}









@end
