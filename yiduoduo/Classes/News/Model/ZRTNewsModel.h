//
//  ZRTNewsModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTNewsModel : NSObject


//// 时间
//@property (nonatomic,copy) NSString *time;
//
//
//// 大图
//@property (nonatomic,copy) NSString *imgType;
//
////
//@property (nonatomic,copy) NSString *imgTitle;
//
//
//// 普通图
//@property (nonatomic,copy) NSString *imgsrc1;
//
//@property (nonatomic,copy) NSString *imgsrc2;
//
//@property (nonatomic,copy) NSString *imgsrc3;
//
//
//// 标题
//@property (nonatomic,copy) NSString *imgsrcTitle1;
//
//@property (nonatomic,copy) NSString *imgsrcTitle2;
//
//@property (nonatomic,copy) NSString *imgsrcTitle3;
//
//
//@property (nonatomic,strong) NSDictionary *head;
//
//@property (nonatomic,strong) NSArray *Cell1;
//@property (nonatomic,strong) NSArray *Cell2;
//@property (nonatomic,strong) NSArray *Cell3;






//数组
@property (nonatomic,strong) NSArray *ds;



+ (instancetype)newsModelWithDict:(NSDictionary *)dict;



@end
