//
//  ZRTAccountTaskController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/9/8.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTAccountTaskController.h"
#import "ZRTAccountCell.h"
#import "AFNetworking.h"
#import "ZRTTasksModel.h"



@interface ZRTAccountTaskController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIImageView *integral;

@property (nonatomic,strong) UILabel *count;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIView *ruleView;

@property (nonatomic,strong) ZRTTasksModel *model;

@end

@implementation ZRTAccountTaskController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getNetWork];
}


- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = KGrayColor;

    [self setUpNavBar];
    
    [self setUpIntegral];
    
    [self setUpRecord];
    
  //  [self setUpRules];

}


#pragma mark 设置导航栏内容
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"积分账户";
    
    
}



- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark 设置总分

#define marginInte 10
-(void)setUpIntegral
{

    self.integral = [[UIImageView alloc] init];
    
    self.integral.image = [UIImage imageNamed:@"circle"];

    [self.integral sizeToFit];
    
    self.integral.y = marginInte;
    self.integral.x = (self.view.width - self.integral.width)/2;
    
    [self.view addSubview:self.integral];
    
    
    
    
    UILabel *jifen = [[UILabel alloc] init];
    
    jifen.text = @"积分";
    
    jifen.textColor = [UIColor whiteColor];
    
    [self.view addSubview:jifen];
    
    [jifen sizeToFit];
    
    
    jifen.center = self.integral.center;
    
    jifen.y += 20;
    
    
    
    self.count = [[UILabel alloc] init];
    
    [self.view addSubview:self.count];
    
    self.count.text = [NSString stringWithFormat:@"%tu",self.model.score];
    
    // 位数
    NSLog(@" %ld ",self.count.text.length);
    
    if (self.count.text.length == 5) {
        
        self.count.font = [UIFont fontWithName:@"Verdana-Bold" size:20];
        
    }else if (self.count.text.length == 4){
    
        self.count.font = [UIFont fontWithName:@"Verdana-Bold" size:25];
    }else {
    
        self.count.font = [UIFont fontWithName:@"Verdana-Bold" size:30];
    }
    
    
    self.count.textColor = [UIColor whiteColor];
    
    
    [self.count sizeToFit];
    
    self.count.center = jifen.center;
    
    self.count.y -= 28;
    
   
    
    
}



#pragma mark 设置奖励列表

-(void)setUpRecord
{

    CGFloat imageH = CGRectGetMaxY(self.integral.frame);
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, imageH+marginInte, self.view.width, KScreenHeight - imageH-64-marginInte)];
 
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = NO;
    
    [self.view addSubview:self.tableView];


}



#pragma mark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.model.ds.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DsForTask *ds = [DsForTask ModelWithDic:(NSDictionary *)self.model.ds[indexPath.row]];

    ZRTAccountCell *cell = [ZRTAccountCell cellWithTableView:tableView];
  
    cell.model = ds;
    
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    [cell setAllView];
    
    return cell;

}




#pragma mark 设置积分规则

-(void)setUpRules
{

    self.ruleView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-150-64, KScreenWidth, 150)];
    
    self.ruleView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.ruleView];
    
    

    UIView *orange = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    
    orange.backgroundColor = KLineColor;
    
    [self.ruleView addSubview:orange];

    
    UILabel *ruleLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginInte, 0, 0, 0)];
    
    ruleLabel.text = @"积分规则:";
    
    ruleLabel.textColor = [UIColor whiteColor];
    
    [orange addSubview:ruleLabel];
    
    [ruleLabel sizeToFit];
    
    ruleLabel.y = (orange.height - ruleLabel.height)/2;
    
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(marginInte, CGRectGetMaxY(orange.frame)+marginInte*2, self.view.width, 0)];
    
    label1.text = @"1、积分可通过任务获得，不可兑换人民币；";
    
    label1.numberOfLines = 0;
    
    label1.font = [UIFont systemFontOfSize:15];
    
    [self.ruleView addSubview:label1];
    
    [label1 sizeToFit];
    
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(marginInte, CGRectGetMaxY(label1.frame)+marginInte, self.view.width, 0)];
    
    label2.text = @"2、积分可用来兑换商场物品（医多多稍后推出）";
    
    label2.numberOfLines = 0;
    
    label2.font = [UIFont systemFontOfSize:15];
    
    [self.ruleView addSubview:label2];
    
    [label2 sizeToFit];
    

}




#pragma mark 网络请求

-(void)getNetWork
{
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Task.asmx/GetScoreFlowList";
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:@{@"userID":[DEFAULT objectForKey:@"UserDict"][@"Id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@" %@",[DEFAULT objectForKey:@"UserDict"][@"Id"]);
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        self.model = [ZRTTasksModel ModelWithDic:jsonDict];
        
        [self.tableView reloadData];
        
        [self setUpIntegral];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error %@",error);
        
    }];
    
    
}




@end
