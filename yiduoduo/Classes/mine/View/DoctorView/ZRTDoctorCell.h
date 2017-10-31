//
//  ZRTDoctorCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTDoctorModel.h"

@protocol ZRTDoctorCellDelegete <NSObject>

-(void)lineDoctor:(ZRTDoctorModel *)model;

@end

@interface ZRTDoctorCell : UITableViewCell

@property (nonatomic,strong) ZRTDoctorModel *model;


+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setAllView;

@property (nonatomic,strong) id<ZRTDoctorCellDelegete> delegete;

@end
