//
//  ZRTDetailCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/5.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDetailCell.h"
#import "Helper.h"





@implementation ZRTDetailCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        
        [self setAllView];
        
        
    }
    return self;
}


-(void)setAllView
{
    
    
    //简介
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.width - 20, 25)];
    
    
    self.title.backgroundColor  = [UIColor clearColor];
//    self.title.textColor = KdetailTitleColor;
    self.title.textColor = KMainColor;
    self.title.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.title];
    
    //        NSLog(@"title %@",self.title.text);
    //        NSLog(@"title %@",NSStringFromCGRect(self.title.frame));
    
    //内容
    
    self.text = [[UILabel alloc]init];
    self.text.numberOfLines = 0;
    self.text.backgroundColor  = [UIColor clearColor];
    self.text.textColor = [UIColor blackColor];
    
    self.text.font = [UIFont systemFontOfSize:17];
    self.text.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    [self.contentView addSubview:self.text];
    
    
    
    
    self.motifImageView = [[UIView alloc] init];
    
    [self.contentView addSubview:self.motifImageView];

    
    

}



@end
