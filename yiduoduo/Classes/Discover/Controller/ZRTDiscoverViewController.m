//
//  ZRTDiscoverViewController.m
//  yiwen
//
//  Created by moyifan on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDiscoverViewController.h"
#import "ZRTConsultationViewController.h"

#import "ZRTDiscoverTableViewCell.h"
#import "ZRTDiscovertowTableViewCell.h"

#import "ZRTNewsCollectionController.h"

#import "ZRTSubjectViewController.h"

#import "ZRTmodel.h"

#import "UIImageView+WebCache.h"

@interface ZRTDiscoverViewController ()
{
    NSMutableArray *data;
}
@end



@implementation ZRTDiscoverViewController


#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
//    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
//    but.frame = CGRectMake(0, 0, 20, 20);
//    [but setImage:[UIImage imageNamed:@"home_btn_search"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:but];
//    [but addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *contentArray = @[@[@"found_btn_consulation",@"医问医答",@""],@[@"found_btn_news",@"今日新闻",@""]];
    
    data = [NSMutableArray arrayWithArray:contentArray];
    

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.backgroundColor = [UIColor colorWithRed:232/256.0 green:232/256.0 blue:232/256.0 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZRTDiscoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZRTDiscovertowTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = clearView;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"qweqrq");

}



#pragma 导航条的页面切换处理
-(void)push
{

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0;
    }

    return 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return data.count;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if( indexPath.section == 0)
    {
        ZRTDiscoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
//        [cell.userImage sd_setImageWithURL:[NSURL URLWithString:@""]];
        
        return cell;
    }
    else
    {
        ZRTDiscovertowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        NSArray *k = data[indexPath.section];
        ZRTmodel *model = [[ZRTmodel alloc]init];
       
        model.image = k[0];
        model.title = k[1];
        model.detialTitle = k[2];
        
        [cell setCellView:model];
       
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        ZRTConsultationViewController *consultationVC = [[ZRTConsultationViewController alloc] init];
        consultationVC.RightBtnHidden = NO;
        
        [self.navigationController pushViewController:consultationVC animated:YES];
    }
    
    
    if (indexPath.section == 1 ) {
        
//        ZRTNewsViewController *news = [[ZRTNewsViewController alloc] init];
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"News" bundle:nil];
//        
//        news = [storyboard instantiateInitialViewController];
//
//        
//        
//        [self.navigationController pushViewController:news animated:YES];
        
        
        ZRTNewsCollectionController *news = [[ZRTNewsCollectionController alloc] init];
        
        [self setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:news animated:YES];
        
        [self setHidesBottomBarWhenPushed:NO];
        
    }
    
    //专题
//    if (indexPath.section == 2) {
//        
//        ZRTSubjectViewController *subjectVC = [[ZRTSubjectViewController alloc] init];
//        
//        [self.navigationController pushViewController:subjectVC animated:YES];
//    }
    
    
    
    
}



@end
