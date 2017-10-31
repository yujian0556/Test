//
//  ZRTSelectModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTSelectModel : NSObject




@property (nonatomic, copy) NSString *Digest;

@property (nonatomic, copy) NSString *KindId;

@property (nonatomic, copy) NSString *Id;              // 科室ID

@property (nonatomic, copy) NSString *ClassList;

@property (nonatomic, copy) NSString *ParentId;

@property (nonatomic, copy) NSString *ClassLayer;

@property (nonatomic, copy) NSString *Title;          //  科室名称

@property (nonatomic, copy) NSString *ClassOrder;


+(instancetype)ModelWithDict:(NSDictionary *)dict;


@end
