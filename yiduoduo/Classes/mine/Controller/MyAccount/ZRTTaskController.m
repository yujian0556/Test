//
//  ZRTTaskController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/8.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTTaskController.h"
#import "ZRTTaskCell.h"
#import "ZRTAccountTaskController.h"

@interface ZRTTaskController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation ZRTTaskController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = KGrayColor;
   
    [self setUpNavBar];
    
    
  
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight-20)];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = NO;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
}



#pragma mark 设置导航栏内容
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"我的账户";


}



- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}




#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // return 2;
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        
   ZRTTaskCell *cell = [ZRTTaskCell cellWithTableView:tableView];

    cell.label.text = self.dataArray[indexPath.row];
    
    [cell.label sizeToFit];
    
    cell.label.y = (cell.height - cell.label.height)/2;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    if (indexPath.row == 0) {
//        
//        NSLog(@"123");
//        
//        
//    }else{
//    
//    
//        NSLog(@"456");
//    
//    }

    
    ZRTAccountTaskController *account = [[ZRTAccountTaskController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:account animated:YES];
    
   
    

}




#pragma mark 懒加载


-(NSArray *)dataArray
{
    
    if (!_dataArray) {
        
       // _dataArray = [NSArray arrayWithObjects:@"现金账户",@"积分账户",nil];
        
        _dataArray = [NSArray arrayWithObjects:@"积分账户",nil];
    }
    
    
    return _dataArray;
    
}


@end
