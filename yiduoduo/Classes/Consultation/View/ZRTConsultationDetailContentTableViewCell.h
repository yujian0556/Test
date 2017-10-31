//
//  ZRTConsultationDetailContentTableViewCell.h
//  yiduoduo
//
//  Created by Olivier on 15/5/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZRTConsultationDetailContentTableViewCell : UITableViewCell

@property (nonatomic,copy) void (^commentBlock)(void);
@property (nonatomic,copy) void (^favoriteBlock)(void);
- (void)commentBlock:(void (^)(void))block;

@property (nonatomic,strong) UIButton *favoriteBtn;

- (CGFloat)fillCellWithDictionary:(NSDictionary *)dict;

@end
