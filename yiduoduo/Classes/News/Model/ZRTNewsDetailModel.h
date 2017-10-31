//
//  ZRTNewsDetailModel.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/24.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZRTNewsDetailModel : NSObject


/*
 
 "add_time" = "2015/2/3 16:26:20";
 "call_index" = "";
 "category_id" = 32;
 "channel_id" = 5;
 click = 111;
 content = "\U670d\U52a1\U9879\U76ee";
 "groupids_view" = "";
 id = 103;
 "img_url" = "";
 "is_hot" = 0;
 "is_msg" = 0;
 "is_red" = 0;
 "is_slide" = 0;
 "is_sys" = 1;
 "is_top" = 0;
 "link_url" = "";
 "seo_description" = "";
 "seo_keywords" = "";
 "seo_title" = "";
 "sort_id" = 99;
 status = 0;
 title = "\U670d\U52a1\U9879\U76ee";
 "update_time" = "";
 "user_name" = admin;
 "vote_id" = 0;
 zhaiyao = "\U670d\U52a1\U9879\U76ee";
 
 */



@property (nonatomic,copy) NSString *add_time;  // 添加时间

@property (nonatomic,copy) NSString *call_index;

@property (nonatomic,assign) NSString *category_id;

@property (nonatomic,assign) NSString *channel_id;

@property (nonatomic,assign) NSString *click;

@property (nonatomic,copy) NSString *content;   // 内容

@property (nonatomic,copy) NSString *groupids_view;

@property (nonatomic,assign) NSString *id;

@property (nonatomic,copy) NSString *img_url;   //图片路径

@property (nonatomic,assign) NSString *is_hot;

@property (nonatomic,assign) NSString *is_msg;

@property (nonatomic,assign) NSString *is_red;

@property (nonatomic,assign) NSString *is_slide;

@property (nonatomic,assign) NSString *is_sys;

@property (nonatomic,assign) NSString *is_top;

@property (nonatomic,copy) NSString *link_url;

@property (nonatomic,copy) NSString *seo_description;

@property (nonatomic,copy) NSString *seo_keywords;

@property (nonatomic,copy) NSString *seo_title;

@property (nonatomic,assign) NSString *sort_id;

@property (nonatomic,assign) NSString *status;

@property (nonatomic,copy) NSString *title;     // 标题

@property (nonatomic,copy) NSString *update_time;

@property (nonatomic,copy) NSString *user_name;

@property (nonatomic,assign) NSString *vote_id;

@property (nonatomic,copy) NSString *zhaiyao;



+ (instancetype)newsModelWithDict:(NSDictionary *)dict;


@end
