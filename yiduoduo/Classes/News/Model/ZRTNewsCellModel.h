//
//  ZRTNewsCellModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/24.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTNewsCellModel : NSObject


// 添加时间
@property (nonatomic,copy) NSString *add_time;

// 数据id
@property (nonatomic,copy) NSString *Id;

// 图片路径
@property (nonatomic,copy) NSString *img_url;

// 图片标题
@property (nonatomic,copy) NSString *title;


+ (instancetype)newsModelWithDict:(NSDictionary *)dict;
@end
