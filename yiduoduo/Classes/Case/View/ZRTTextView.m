//
//  ZRTTextView.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTextView.h"


@interface ZRTTextView  ()


@property (nonatomic, weak) UILabel *placeHolderLabel;

@end

@implementation ZRTTextView

#define TextColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:14];
        
        
    }
    return self;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    self.placeHolderLabel.font = font;
    
    self.placeHolderLabel.textColor = TextColor;
}

- (void)setIsHidePlaceHolder:(BOOL)isHidePlaceHolder
{
    _isHidePlaceHolder = isHidePlaceHolder;
    
    self.placeHolderLabel.hidden = _isHidePlaceHolder;
}



- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.placeHolderLabel.text = placeHolder;
    [self.placeHolderLabel sizeToFit];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.placeHolderLabel.x = 5;
    self.placeHolderLabel.y = 8;
    
    
}

- (UILabel *)placeHolderLabel
{
    if (_placeHolderLabel == nil) {
        UILabel *label = [[UILabel alloc] init];
        
        _placeHolderLabel = label;
        
        [self addSubview:label];
    }
    
    return _placeHolderLabel;
}



@end
