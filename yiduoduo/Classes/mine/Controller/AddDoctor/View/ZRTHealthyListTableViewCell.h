//
//  ZRTHealthyListTableViewCell.h
//  yiduoduo
//
//  Created by Olivier on 15/7/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZRTHealthyListTableViewCell : UITableViewCell

@property (nonatomic,strong) UIButton *selectBtn;

- (void)fillCellWithModel:(id)model AndCount:(NSInteger)count;

@end
