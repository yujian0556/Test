//
//  ZRTHome.h
//  yiwen
//
//  Created by 莫一凡 on 15/4/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTHome : NSObject

@property (nonatomic,copy) NSString *image1;
@property (nonatomic,copy) NSString *image2;
@property (nonatomic,copy) NSString *image3;
@property (nonatomic,copy) NSString *image4;
@property (nonatomic,copy) NSString *image5;
@property (nonatomic,copy) NSString *image6;
@property (nonatomic,copy) NSString *image7;



@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *bingli;

@property (nonatomic,copy) NSString *shiping;

@property (nonatomic,copy) NSString *xuexiyuandi;



+(instancetype)HomeWithDic:(NSDictionary *)dic;

@end
