//
//  OZHPickerView.h
//  yiduoduo
//
//  Created by Olivier on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OZHPickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong) UIPickerView *pickView;

@property (nonatomic,strong) NSArray *provinces;
@property (nonatomic,strong) NSArray *cities;

@property (nonatomic,strong) NSString *provinceStr;
@property (nonatomic,strong) NSString *cityStr;

@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIView *pickBackView;


@end
