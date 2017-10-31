//
//  ZRTReportTableViewCell.h
//  yiduoduo
//
//  Created by olivier on 15/8/6.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRTReportTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;
@property (nonatomic,assign) BOOL isSelected;

@end
