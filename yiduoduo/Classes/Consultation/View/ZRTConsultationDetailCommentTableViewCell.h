//
//  ZRTConsultationDetailCommentTableViewCell.h
//  yiduoduo
//
//  Created by Olivier on 15/5/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface ZRTConsultationDetailCommentTableViewCell : UITableViewCell


- (CGFloat)fillCellWithDictionary:(NSDictionary *)dict;


- (CGFloat)fillCaseCommentCellWithData:(NSDictionary *)dict;
- (CGFloat)fillVideoCommentCellWithData:(NSDictionary *)dict;

@end
