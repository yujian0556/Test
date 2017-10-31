//
//  OZHAlertView.m
//  yiduoduo
//
//  Created by Olivier on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "OZHAlertView.h"
#define KIVWidth 235
#define KIVHeight 105
#define KSepHeight 65
@implementation OZHAlertView
{
   
    NSDictionary *_dict;
}

- (NSDictionary *)alertViewWithTitle:(NSString *)title AndButtonTitle:(NSString *)btnTitle AndTarget:(id)target {
    
    UIView *alert = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    alert.backgroundColor = [UIColor blackColor];
    alert.alpha = 0.3;
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, KIVWidth, KIVHeight)];
    iv.image = [UIImage imageNamed:@"弹框_03"];
    iv.center = CGPointMake(KScreenWidth/2, KScreenHeight/2-44);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KIVWidth, KSepHeight)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    
//    UILabel *sureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), KIVWidth, KIVHeight - KSepHeight)];
//    sureLabel.text = btnTitle;
//    sureLabel.textAlignment = NSTextAlignmentCenter;
//    sureLabel.userInteractionEnabled = YES;
//    
   
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, CGRectGetMaxY(label.frame), KIVWidth, KIVHeight - KSepHeight);
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:alert action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(sure)];
    [btn addGestureRecognizer:tap];
    
    
    
    
    
    iv.userInteractionEnabled = YES;
//    self.userInteractionEnabled = YES;
    
   // _sureBlock = block;
    
    [iv addSubview:label];
    [iv addSubview:btn];
    
    [self addSubview:alert];
    [self addSubview:iv];
    
    _dict = @{@"alert":alert,@"iv":iv};
    
    return _dict;
}

- (void)sure {
    //NSLog(@"提示框消失");
    [_dict[@"alert"] removeFromSuperview];
    [_dict[@"iv"] removeFromSuperview];
}

@end
