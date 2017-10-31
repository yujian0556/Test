//
//  ZRTMissionController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/10.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTMissionController.h"
#import "ZRTMissionCell.h"
#import "AFNetworking.h"
#import "ZRTMissionModel.h"
#import "ZRTTabBar.h"
#import "ZRTConsultationViewController.h"
@class Detail,Ds;

@interface ZRTMissionController ()



@property (nonatomic,strong) ZRTMissionModel *model;

@property (nonatomic, strong) Ds *ds;


@end

@implementation ZRTMissionController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getNetWork];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView.separatorStyle = NO;
    
    [self setUpNavBar];
    
   
    
}



#pragma mark 设置导航栏内容
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"我的任务";
    
    
}



- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   
    return self.model.ds.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    Ds *ds = [Ds ModelWithDic:(NSDictionary *)self.model.ds[section]];
    
    return ds.detail.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Ds *ds = [Ds ModelWithDic:(NSDictionary *)self.model.ds[indexPath.section]];
    
    Detail *detail = [Detail ModelWithDic:(NSDictionary *)ds.detail[indexPath.row]];
    
    
    ZRTMissionCell *cell = [ZRTMissionCell cellWithTableView:tableView];
   
//    NSLog(@" %ld",detail.score);
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    [cell setAllView];
    
    cell.name = detail.taskname;
    
    cell.progress = detail.datapercent;
    
    cell.score = detail.score;
 
    
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (KScreenHeight == 736) {  // 6p
       
        return 80;
    
    }else{
    
        return 70;
    }
    
    
}




//设置表头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}






#define headBG [UIColor colorWithRed:236/256.0 green:237/256.0 blue:238/256.0 alpha:1]
#define textCR [UIColor colorWithRed:145/256.0 green:146/256.0 blue:147/256.0 alpha:1]


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    header.backgroundColor = headBG;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.width * 0.5, 30)];
    
    Ds *ds = [Ds ModelWithDic:(NSDictionary *)self.model.ds[section]];
    
    label.text = ds.tasktype;
    
    label.textColor = textCR;
    
    [header addSubview:label];
    
    
        return header;

    
}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ZRTTabBar *tabar = [[ZRTTabBar alloc] init];
    for (ZRTTabBar *tab in self.tabBarController.tabBar.subviews) {
        
        if ([tab isKindOfClass:NSClassFromString(@"ZRTTabBar")]) {
            
            tabar = tab;
            
            [array addObjectsFromArray:tab.subviews];
            
        }
        
    }
    
    
    
    
    
    Ds *ds = [Ds ModelWithDic:(NSDictionary *)self.model.ds[indexPath.section]];
    
    Detail *detail = [Detail ModelWithDic:(NSDictionary *)ds.detail[indexPath.row]];
    
//    NSLog(@" %ld",detail.taskid);
    
    ZRTConsultationViewController *vc = [[ZRTConsultationViewController alloc] init];
    NSInteger index = -1;
    switch (detail.taskid) {
        case 9:
            index = 4;
            break;
          
        case 11:
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
           
            break;
            
        case 10:
            index = 1;
            break;
            
        case 5:
            index = 0;
            break;
            
        case 12:
            
            self.hidesBottomBarWhenPushed = YES;

            [self.navigationController pushViewController:vc animated:YES];
            break;
            
        default:
            break;
    }
    
    if (index == -1) {
        return;
    }
    

    
    self.tabBarController.selectedIndex = index;

    [self.navigationController popViewControllerAnimated:YES];

    
    for (UIButton *btn in array) {
        
        btn.selected = NO;
    }
    
    UIButton *btn = array[index];
    btn.selected = YES;
    tabar.selectBtn = btn;
    
}




#pragma mark 懒加载




#pragma mark 网络请求

-(void)getNetWork
{
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Task.asmx/GetTaskList";
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:@{@"userID":[DEFAULT objectForKey:@"UserDict"][@"Id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];

        
//        NSLog(@"%@ %@",[DEFAULT objectForKey:@"UserDict"][@"Id"],jsonDict);
        
        self.model = [ZRTMissionModel ModelWithDic:jsonDict];
      
    
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",error);
        
    }];
    

}





@end
