//
//  ZRTConsultationTableViewCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTConsultationModel.h"

@protocol ZRTConsultationTableViewCellDelegate <NSObject>

-(void)reloadData;

@end


@interface ZRTConsultationTableViewCell : UITableViewCell

@property (nonatomic,assign) CGFloat cellHeight;

@property (nonatomic,copy) void (^jumpBlock)(ZRTConsultationModel *model);

@property (nonatomic,copy) void (^commentBlock)(void);

@property (nonatomic,copy) void (^favoriteBlock)(void);

@property (nonatomic,copy) void (^sectionOfficeBtnBlock)(void);

@property (nonatomic,strong) id<ZRTConsultationTableViewCellDelegate> delegate;

@property (nonatomic,strong) NSString *consultationId;

@property (nonatomic,strong) UIButton *favoriteBtn;

- (void)fillCellWithModel:(ZRTConsultationModel *)Model;

- (void)jumpToDetailWithBlock:(void (^)(ZRTConsultationModel *model))block;

- (void)commentBlock:(void (^)(void))block;

@end
