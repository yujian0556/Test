//
//  ZRTSelectorController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/23.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSelectorController.h"

#import "ZRTSelectCell.h"

#import "ZRTSelectModel.h"

#import "ZRTComposeController.h"

#define KBGColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]

@interface ZRTSelectorController ()



@end

@implementation ZRTSelectorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KBGColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self setUpNavBar];
    
    
    
}

#pragma  mark 设置导航栏按钮
-(void)setUpNavBar
{
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    
    self.navigationItem.title = @"选择科室类别";
    
    
    self.navigationItem.rightBarButtonItem = nil;
    
    
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.modelArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    
    ZRTSelectCell *cell = [ZRTSelectCell cellWithTableView:tableView];
  
    

    
    ZRTSelectModel *model = self.modelArray[indexPath.row];


    cell.titleLabel.text = model.Title;
    
    
    return cell;
}





#pragma mark 模型传入


-(void)setModelArray:(NSMutableArray *)modelArray
{

    _modelArray = modelArray;
    

}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    ZRTSelectModel *model = self.modelArray[indexPath.row];
    
    
  //  ZRTComposeController *compose = [[ZRTComposeController alloc] init];
    
   
    if ([self.delegate respondsToSelector:@selector(changeContent:)]) {
        
        [self.delegate changeContent:model];
    }
    
    

    
    [self.navigationController popViewControllerAnimated:YES];

}




@end
