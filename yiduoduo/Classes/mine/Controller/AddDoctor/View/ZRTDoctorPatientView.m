//
//  ZRTDoctorPatientView.m
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTDoctorPatientView.h"
#import "UIImageView+WebCache.h"
#import "Helper.h"


#import "ZRTPatientModel.h"
#import "ZRTDoctorModel.h"

@implementation ZRTDoctorPatientView

- (UIView *)createAddDoctorViewWithModel:(id)model {
    
    if (self.isDoctor) {
        
        ZRTDoctorModel *dmodel = (ZRTDoctorModel *)model;
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 19, 50, 50)];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像_03"]];
        
        NSString *name = dmodel.RealName;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 5, 21, [Helper widthOfString:name font:[UIFont systemFontOfSize:20] height:20], 20)];
        self.nameLabel.text = name;
        self.nameLabel.font = [UIFont systemFontOfSize:20];
        
        NSString *doctorRank = [NSString stringWithFormat:@"%@%@%@",dmodel.UnitName,dmodel.SectionOffice,dmodel.Professional];
        self.doctorRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, KScreenWidth - CGRectGetMinX(self.nameLabel.frame) - 10, 20)];
        self.doctorRankLabel.text = doctorRank;
        self.doctorRankLabel.textColor = KLineColor;
        self.doctorRankLabel.font = [UIFont systemFontOfSize:14];
        
        NSString *doctorInfomation;
        if (![dmodel.Major isEqualToString:@""]) {
            doctorInfomation = [NSString stringWithFormat:@"擅长专业:%@",dmodel.Major];
        }
        else {
            doctorInfomation = @"";
        }
        
        self.doctorInfomationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.doctorRankLabel.frame), CGRectGetMaxY(self.doctorRankLabel.frame), [Helper widthOfString:doctorInfomation font:[UIFont systemFontOfSize:14] height:20], 20)];
        self.doctorInfomationLabel.text = doctorInfomation;
        self.doctorInfomationLabel.textColor = [UIColor lightGrayColor];
        self.doctorInfomationLabel.font = [UIFont systemFontOfSize:14];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = CGRectMake(KScreenWidth - 80 - 10, 18, 80, 25);
        [self.addButton setImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
//        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
        
       
        
        [self.addButton setImage:[UIImage imageNamed:@"orange"] forState:UIControlStateSelected];
        [self.addButton setTitle:@"已添加" forState:UIControlStateSelected];
        
        
//        [self.addButton setTitleColor:KMainColor forState:UIControlStateNormal];
        [self.addButton setTitleColor:KLineColor forState:UIControlStateSelected];
        self.addButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.addButton addTarget:self action:@selector(addConcern) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.doctorRankLabel];
        [self addSubview:self.doctorInfomationLabel];
        [self addSubview:self.addButton];
        
        return self;
    }
    else {
        ZRTPatientModel *pmodel = (ZRTPatientModel *)model;
        
        self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 19, 50, 50)];
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"头像_03"]];
        
        NSString *name = pmodel.RealName;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 5, 21, [Helper widthOfString:name font:[UIFont systemFontOfSize:20] height:20], 20)];
        self.nameLabel.text = name;
        self.nameLabel.font = [UIFont systemFontOfSize:20];
        
//        NSString *doctorRank = @"武汉协和医院骨科主任";
//        self.doctorRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 15, [OZHHelper widthOfString:doctorRank font:[UIFont systemFontOfSize:14] height:20], 20)];
//        self.doctorRankLabel.text = doctorRank;
//        self.doctorRankLabel.textColor = KMainColor;
//        self.doctorRankLabel.font = [UIFont systemFontOfSize:14];
//        
//        NSString *doctorInfomation = @"擅长专业：心血管科";
//        self.doctorInfomationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.doctorRankLabel.frame), CGRectGetMaxY(self.doctorRankLabel.frame), [OZHHelper widthOfString:doctorInfomation font:[UIFont systemFontOfSize:14] height:20], 20)];
//        self.doctorInfomationLabel.text = doctorInfomation;
//        self.doctorInfomationLabel.textColor = [UIColor lightGrayColor];
//        self.doctorInfomationLabel.font = [UIFont systemFontOfSize:14];
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addButton.frame = CGRectMake(KScreenWidth - 80 - 10, 18, 80, 25);
        [self.addButton setBackgroundImage:[UIImage imageNamed:@"add2"] forState:UIControlStateNormal];
//        [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
//        [self.addButton setTitleColor:KMainColor forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addConcern) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self addSubview:self.headerImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.doctorRankLabel];
        [self addSubview:self.doctorInfomationLabel];
        [self addSubview:self.addButton];
        
        return self;
    }

}

- (void)addConcern {
    NSLog(@"添加关注");
    self.block();
}

@end
