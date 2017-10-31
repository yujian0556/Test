//
//  ZRTSearchBar.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSearchBar.h"

@implementation ZRTSearchBar


-(instancetype)initWithFrame:(CGRect)frame WithColorNumber:(NSInteger)colorNumber
{
    if (self = [super initWithFrame:frame]) {
    
        //设置搜索栏的文字
        self.placeholder = @"请输入查找内容";

        UIImageView *leftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"glass"]];
        
        switch (colorNumber) {
            case 1:
                
                self.backgroundColor = [UIColor colorWithRed:0/256.0 green:138/256.0 blue:154/256.0 alpha:1];
                self.textColor = [UIColor whiteColor];
                self.tintColor = [UIColor whiteColor];
                [self setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
                
                break;
            case 2:
                
                self.backgroundColor = [UIColor whiteColor];
                self.textColor = KMainColor;
                self.tintColor = KMainColor;
                [self setValue:KMainColor forKeyPath:@"_placeholderLabel.textColor"];
                
                leftImage.image = [UIImage imageNamed:@"glass_search"];
                
                break;
                
            default:
                break;
        }
        
        //控制图片的现实方式,居中显示
        leftImage.contentMode = UIViewContentModeCenter;
        leftImage.width += 10;
        
        self.leftView = leftImage;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.font = [UIFont systemFontOfSize:13];
        
       
        
        self.returnKeyType = UIReturnKeySearch;
        
    }
    
    return self;
}




@end
