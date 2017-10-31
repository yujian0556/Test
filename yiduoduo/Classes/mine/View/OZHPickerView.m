//
//  OZHPickerView.m
//  yiduoduo
//
//  Created by Olivier on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "OZHPickerView.h"

@implementation OZHPickerView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        _pickView = [[UIPickerView alloc] initWithFrame:self.bounds];
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        [self addSubview:_pickView];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _sureBtn.frame = CGRectMake(self.frame.size.width-50, self.frame.size.height-260, 50, 30);
        _sureBtn.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sureBtn];
        
        [self loadDataIntoPicker];
        
    }
    return self;
}

- (void)loadDataIntoPicker{
    
    _provinces = [[NSArray array] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"city" ofType:@"plist"]];
    
    _cities = [_provinces[0] objectForKey:@"cities"];
    
//     NSLog(@" 一般 %@ %@",_provinces,_cities[0]);
    
    _cityStr= _cities[0];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return _provinces.count;
            break;
        case 1:
            return _cities.count;
            break;
        default:
            return 0;
            break;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
            
        case 0:
            return _provinces[row][@"state"];
            break;
        case 1:
            return _cities[row];
            break;
        default:
            return @"";
            break;
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            _cities = _provinces[row][@"cities"];
            [_pickView selectRow:0 inComponent:1 animated:YES];
            [_pickView reloadComponent:1];
            
            
            _provinceStr = _provinces[row][@"state"];
            _cityStr = _cities[0];
            
            break;
        case 1:
            
            _cityStr =_cities[row];
            
            break;
        default:
            break;
    }
    
}


@end
