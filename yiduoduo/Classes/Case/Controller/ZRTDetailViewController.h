//
//  ZRTDetailViewController.h
//  yiduoduo
//
//  Created by moyifan on 15/6/4.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZRTCaseModel.h"


@protocol ZRTDetailViewControllerDelegate <NSObject>

- (void)reloadDataAfterBack;


@end

@interface ZRTDetailViewController : UITableViewController


@property (nonatomic,weak) id <ZRTDetailViewControllerDelegate> delegate;

@property (nonatomic,strong) ZRTCaseModel *model;

@property (nonatomic,assign) BOOL isSearch; // 如果是从搜索进入的就YES
@end
