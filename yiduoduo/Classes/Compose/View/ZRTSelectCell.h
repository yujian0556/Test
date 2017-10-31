//
//  ZRTSelectCell.h
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZRTSelectCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NSString *ID;

+(instancetype)cellWithTableView:(UITableView *)tableView;




@end
