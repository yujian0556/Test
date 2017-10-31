//
//  ZRTPatientCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTPatientModel.h"


@protocol ZRTPatientCellDelegete <NSObject>

-(void)linePatient:(ZRTPatientModel *)model;

@end


@interface ZRTPatientCell : UITableViewCell

@property (nonatomic,strong) ZRTPatientModel *model;


- (void)setAllView;
+(instancetype)cellWithTableView:(UITableView *)tableView;


@property (nonatomic,strong) id<ZRTPatientCellDelegete> delegete;

@end
