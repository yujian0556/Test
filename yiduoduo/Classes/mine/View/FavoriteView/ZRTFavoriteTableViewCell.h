//
//  ZRTFavoriteTableViewCell.h
//  yiduoduo
//
//  Created by olivier on 15/8/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZRTCaseModel.h"
#import "ZRTVideoModel.h"
#import "ZRTConsultationModel.h"

@interface ZRTFavoriteTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *index;

- (void)fillCellWithCaseModel:(ZRTCaseModel *)model;

- (void)fillCellWithConsultationModel:(ZRTConsultationModel *)model;

- (void)fillCellWithVideoModel:(ZRTVideoModel *)model;
@end
