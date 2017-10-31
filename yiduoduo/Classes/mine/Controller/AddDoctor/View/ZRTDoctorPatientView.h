//
//  ZRTDoctorPatientView.h
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRTDoctorPatientView : UIView

typedef void (^addConcernBlock)(void);

@property (nonatomic,copy) addConcernBlock block;

@property (nonatomic,assign) BOOL isDoctor;
@property (nonatomic,assign) BOOL isConcerned;


@property (nonatomic,strong) UIImageView *headerImageView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *doctorRankLabel;
@property (nonatomic,strong) UILabel *doctorInfomationLabel;
@property (nonatomic,strong) UIButton *addButton;

- (UIView *)createAddDoctorViewWithModel:(id)model;


@end
