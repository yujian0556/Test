//
//  OZHAlertView.h
//  yiduoduo
//
//  Created by Olivier on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OZHAlertViewAction <NSObject>

- (void)dismissView;

@end

@interface OZHAlertView : UIView

@property (nonatomic,weak) id <OZHAlertViewAction> delegate;

- (NSDictionary *)alertViewWithTitle:(NSString *)title AndButtonTitle:(NSString *)btnTitle AndTarget:(id)target;

- (void)sure;

@end
