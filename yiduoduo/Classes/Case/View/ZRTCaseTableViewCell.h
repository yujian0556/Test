//
//  ZRTCase2TableViewCell.h
//  yiduoduo
//
//  Created by Chen on 15/10/24.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTCaseModel.h"

@interface ZRTCaseTableViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)setAllView;

@property (nonatomic,strong) ZRTCaseModel *caseModel;


@end
