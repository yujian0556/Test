//
//  ZRTHealthyController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/2.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHealthyController.h"
#import "ZRTHealthyCell.h"
#import "ZRTDoctorCell.h"
#import "ZRTPatientCell.h"
#import "ZRTCompileController.h"

#import "ZRTHealthyDetailController.h"

#import "ZRTSearchDoctorViewController.h"
#import "ZRTLineController.h"

#import "ZRTHealthyModel.h"
#import "ZRTPatientModel.h"
#import "ZRTDoctorModel.h"

#import "AppDelegate.h"

#import "MBProgressHUD+MJ.h"




#define KBGColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]


@interface ZRTHealthyController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,ZRTDoctorCellDelegete,ZRTCompileControllerDelegate,ZRTHealthyDetailControllerDelegate,ZRTPatientCellDelegete>

@property (nonatomic,assign) BOOL isHealthy;

@property (nonatomic,assign) BOOL isDoctor;

@property (nonatomic,assign) BOOL isPatient;


@property (nonatomic,strong) UIView *BtnView;

@property (nonatomic,strong) UIButton *healthyBtn;

@property (nonatomic,strong) UIButton *doctorBtn;

@property (nonatomic,strong) UIButton *patientBtn;


@property (nonatomic,strong) UIView *redView1;

@property (nonatomic,strong) UIView *redView2;

@property (nonatomic,strong) UIView *redView3;


@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) UITableView *tableView2;

@property (nonatomic, weak) UITableView *tableView3;


@property (nonatomic,assign) CGFloat font;


@property (nonatomic,assign) CGPoint pointPatient;

@property (nonatomic,strong) NSMutableArray *dataSource1;
@property (nonatomic,strong) NSMutableArray *dataSource2;
@property (nonatomic,strong) NSMutableArray *dataSource3;

@property (nonatomic,strong) UILabel *stateLabel;
@end

@implementation ZRTHealthyController
{
    NSInteger _firstTime;
}





- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
  
    
    if (self.redView1.hidden == NO) {
      
//        if (_firstTime++ != 1) {
//
//            [self.dataSource1 removeAllObjects];
//            [self getHealthyDataFromNetwork];
//        }
        
    }
    else if (self.redView2.hidden == NO) {
        [self.dataSource2 removeAllObjects];
        
        [self getDoctorOrPatientDataFromNetwork];
    }
    else {
        [self.dataSource3 removeAllObjects];
        [self getDoctorOrPatientDataFromNetwork];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createArray];
    
    self.view.backgroundColor = KBGColor;
    
    [self OSD];
    [self setUpNavBar];
    
    
    [self setUpBtns];
    
    
    [self didClickHealthy];
    
  //  [self line:nil];
    
   
    
}

- (void)createArray {
    _firstTime = 0;
    self.dataSource1 = [[NSMutableArray alloc] init];
    self.dataSource2 = [[NSMutableArray alloc] init];
    self.dataSource3 = [[NSMutableArray alloc] init];
}

#pragma mark 屏幕适配
-(void)OSD
{
    
    if (KScreenHeight == 480) {  // 4s
        
        _font = 16;
        
        
    }else if (KScreenHeight == 568){  // 5s
        _font = 17;
        
        
    }else if (KScreenHeight == 667){  // 6
        
        _font = 18;
        
        
    }else{  // 6p
        
        _font = 22;
    }
    
    
    
}



#pragma mark 设置导航栏内容
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"健康档案";
    
    
    self.isHealthy = YES;
    
    
    
    
    [self setRightItem:@selector(addHealthy)];
    
    
    NSLog(@" %f",self.font);
    
}



- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)setRightItem:(SEL)selector
{
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"add_03"] highImage:nil target:self action:selector];
    
}








#pragma mark 添加不同的按钮方法
-(void)addHealthy
{
   
    
    ZRTCompileController *compile = [[ZRTCompileController alloc] init];
    
    compile.delegate = self;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CompileReloadData) name:@"CompileReload" object:nil];
    
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:compile animated:YES];
    
    
}

-(void)addDoctor
{
    ZRTSearchDoctorViewController *searchVC = [[ZRTSearchDoctorViewController alloc] init];
    
    searchVC.myHealthyData = self.dataSource1;
    searchVC.getDoctorInfo = self.dataSource2;
    
    searchVC.addDoctor = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
   
    
}

-(void)addPatient
{
    ZRTSearchDoctorViewController *searchVC = [[ZRTSearchDoctorViewController alloc] init];
    
    searchVC.addDoctor = NO;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    
}


#pragma mark 编辑添加代理方法

-(void)ComposeSuccess
{
    
    
    
        NSLog(@"发送成功~");
    self.stateLabel.text = @"发送成功~";
    
    [self getHealthyDataFromNetwork];
    
    [UIView animateWithDuration:0.25 delay:3.0 options:0 animations:^{
        
        self.stateLabel.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [self.stateLabel removeFromSuperview];
        
    }];

}



-(void)Composefailure
{
    //[MBProgressHUD showError:@"添加失败~"];

    self.stateLabel.text = @"发送失败~";
    [UIView animateWithDuration:0.25 delay:3.0 options:0 animations:^{
        
        self.stateLabel.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [self.stateLabel removeFromSuperview];
        
    }];

}


-(void)Compose
{
     [self showPublishStateWithState:0];
    
    [self getHealthyDataFromNetwork];

}





#pragma mark 添加三个模块
-(void)setUpBtns
{
    
    CGFloat btnW = self.view.width/3;
    
    CGFloat redH = 6;
    
    CGFloat viewH = btnW *0.6;
    

    self.BtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, viewH)];
    
    self.BtnView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.BtnView];
    
    
   
    
    //  健康档案
    
    self.healthyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, self.BtnView.height)];
    
    [self.healthyBtn setTitle:@"健康档案" forState:UIControlStateNormal];
    
    [self.healthyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.healthyBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.healthyBtn addTarget:self action:@selector(didClickHealthy) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.healthyBtn];
    
    
    self.redView1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.BtnView.height -redH, btnW, redH)];
    
    self.redView1.backgroundColor = KLineColor;
    
    [self.healthyBtn addSubview:self.redView1];
    
    
    

    
    
    // 我的医生
    
    self.doctorBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, self.BtnView.height)];
    
    [self.doctorBtn setTitle:@"我的医生" forState:UIControlStateNormal];
    
    [self.doctorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.doctorBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.doctorBtn addTarget:self action:@selector(didClickDoctor) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.doctorBtn];
    
    self.redView2 = [[UIView alloc] initWithFrame:CGRectMake(btnW, self.BtnView.height -redH, btnW, redH)];
    
    self.redView2.backgroundColor = KLineColor;
    
    [self.healthyBtn addSubview:self.redView2];
    
    self.redView2.hidden = YES;
    
    
    
    // 我的患者
    
    self.patientBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW *2, 0, btnW, self.BtnView.height)];
    
    [self.patientBtn setTitle:@"我的患者" forState:UIControlStateNormal];
    
    [self.patientBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.patientBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.patientBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.patientBtn addTarget:self action:@selector(didClickPatient) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnView addSubview:self.patientBtn];
    
    self.redView3 = [[UIView alloc] initWithFrame:CGRectMake(btnW*2, self.BtnView.height -redH, btnW, redH)];
    
    self.redView3.backgroundColor = KLineColor;
    
    [self.healthyBtn addSubview:self.redView3];
    
    self.redView3.hidden = YES;
    
    
    
    
    if ([[DEFAULT objectForKey:@"UserDict"][@"Status"] isEqualToString:@"1"]) {
        
        [self.patientBtn removeFromSuperview];
        
        
        CGFloat btnW = self.view.width/2;
        
        self.healthyBtn.frame = CGRectMake(0, 0, btnW, self.BtnView.height);
        
        self.doctorBtn.frame = CGRectMake(btnW, 0, btnW, self.BtnView.height);
        
        self.redView1.frame = CGRectMake(0, self.BtnView.height -redH, btnW, redH);
        
        self.redView2.frame = CGRectMake(btnW, self.BtnView.height -redH, btnW, redH);
        
        
        return;
    }

}



#pragma mark 添加动画效果

-(void)setUpAnimation
{

    CATransition *anim = [CATransition animation];
    anim.duration = 1;
    anim.type = @"rippleEffect ";
    
    [self.view.layer addAnimation:anim forKey:nil];

}




#pragma mark 点击三个按钮
-(void)didClickHealthy
{
 
    [self.dataSource1 removeAllObjects];
    
//  切换下标
    self.redView2.hidden = YES;
    self.redView3.hidden = YES;
    self.redView1.hidden = NO;
    
  
 // 设置添加按钮
    [self setRightItem:@selector(addHealthy)];
    

    // 设置表
    [self.tableView2 removeFromSuperview];
    [self.tableView3 removeFromSuperview];
  
    
    if (self.tableView) {
        
        return;
    }
    
   
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.healthyBtn.frame)+20, self.view.width, KScreenHeight - CGRectGetMaxY(self.healthyBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHealthy)];
   
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [tableView addGestureRecognizer:swipe];
    

  //  [self setUpAnimation];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self getHealthyDataFromNetwork];

    ++_firstTime;
}



- (void)swipeHealthy
{
    [self didClickDoctor];
   
    
}



-(void)didClickDoctor
{
    [self.dataSource2 removeAllObjects];
    
//  切换下标
    self.redView1.hidden = YES;
    self.redView3.hidden = YES;
    self.redView2.hidden = NO;
    
  // 设置添加按钮
    [self setRightItem:@selector(addDoctor)];
    
    
   // 设置表
    [self.tableView removeFromSuperview];
    [self.tableView3 removeFromSuperview];
    
    if (self.tableView2) {
        
        return;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.healthyBtn.frame)+20, self.view.width,  KScreenHeight - CGRectGetMaxY(self.healthyBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    

    
    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDoctorRight)];
    
    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    
    [tableView addGestureRecognizer:swipe1];

    
    if (![[DEFAULT objectForKey:@"UserDict"][@"Status"] isEqualToString:@"1"]) {
        
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDoctorLeft)];
        
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [tableView addGestureRecognizer:swipe];
        
    }
    
  //  [self setUpAnimation];
    
    
    [self.view addSubview:tableView];
    self.tableView2= tableView;
    
    [self getDoctorOrPatientDataFromNetwork];
}


-(void)swipeDoctorLeft
{

    [self didClickPatient];
    

}


-(void)swipeDoctorRight
{

    [self didClickHealthy];


}




-(void)didClickPatient
{
   
    
    
    
    [self.dataSource3 removeAllObjects];
    
//    NSLog(@"patient");
    self.redView1.hidden = YES;
    self.redView2.hidden = YES;
    self.redView3.hidden = NO;
    
    
    // 设置添加按钮
    [self setRightItem:@selector(addPatient)];
    
    
    // 设置表
    
    [self.tableView removeFromSuperview];
    [self.tableView2 removeFromSuperview];
    
    if (self.tableView3) {
        
        return;
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.healthyBtn.frame)+20, self.view.width,  KScreenHeight - CGRectGetMaxY(self.healthyBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    CGPoint translatedPoint = [tableView.panGestureRecognizer translationInView:tableView];
    
    self.pointPatient = translatedPoint;
    
    
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePatient)];
    
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [tableView addGestureRecognizer:swipe];
    
    
  // [self setUpAnimation];
    
    
    
    [self.view addSubview:tableView];
    self.tableView3= tableView;
    
    [self getDoctorOrPatientDataFromNetwork];
}

-(void)swipePatient
{

    [self didClickDoctor];


}





#pragma mark 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        
        return self.dataSource1.count;
        
    }else if(tableView == self.tableView2){
    
        return self.dataSource2.count;
    
    }else{
    
        return self.dataSource3.count;
    
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView){
        
        ZRTHealthyCell *cell = [ZRTHealthyCell cellWithTableView:tableView];
        
        
        cell.model = self.dataSource1[indexPath.row];
        
        
        
        for (UIView *obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
        [cell setAllView];
        cell.index.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        
        return cell;
    
    }else if(tableView == self.tableView2){
    
        ZRTDoctorCell *cell = [ZRTDoctorCell cellWithTableView:tableView];
        
        cell.model = self.dataSource2[indexPath.row];
        
        cell.delegete = self;
        
        for (UIView *obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
        [cell setAllView];
        
        return cell;
        
    }else{
    
        ZRTPatientCell *cell = [ZRTPatientCell cellWithTableView:tableView];
        
        cell.delegete = self;
        
        cell.model = self.dataSource3[indexPath.row];
        for (UIView *obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
        [cell setAllView];
        return cell;
    
    }
    
  
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tableView) {
        
//         NSLog(@"healthy %ld",indexPath.row);
        
        ZRTHealthyDetailController *HealthyDetail = [[ZRTHealthyDetailController alloc] init];
        
        HealthyDetail.delegate = self;
        
        HealthyDetail.hmodel = self.dataSource1[indexPath.row];
        
        HealthyDetail.index = indexPath.row;
        
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:HealthyDetail animated:YES];
        
       
        
    }else if(tableView == self.tableView2){
        
        NSLog(@"doctor %ld",indexPath.row);
        
    }else{
        
        NSLog(@"patient %ld",indexPath.row);
        
    }
    
    
    
   

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tableView) {
        
        if (KScreenHeight == 480) {  // 4s
           
            return 40;
            
        }else if (KScreenHeight == 568){  // 5s
            return 50;
            
        }else if (KScreenHeight == 667){  // 6
     
            return 60;
          
        }else{  // 6p
 
            return 70;
        }

    }else{
    
        if (KScreenHeight == 480) {  // 4s
            
            return 60;
            
        }else if (KScreenHeight == 568){  // 5s
            return 70;
            
        }else if (KScreenHeight == 667){  // 6
            
            return 80;
            
        }else{  // 6p
            
            return 80;
        }

    }



}


#pragma mark 点击删除按钮
-(void)HealthyDelete:(NSInteger)index
{
    
    [self.dataSource1 removeObjectAtIndex:index];
    
    [self.tableView reloadData];
    
  //  [self getHealthyDataFromNetwork];


}

#pragma mark 编辑刷表


-(void)CompileReloadData
{
    NSLog(@" 成功刷表");
    
  // [self getHealthyDataFromNetwork];
    
    [self ComposeSuccess];
    
}


-(void)CompileCompose
{
    [self Compose];

}


-(void)Compilefailure
{

    [self Composefailure];
}



#pragma mark 发起聊天

-(void)lineDoctor:(ZRTDoctorModel *)model
{
    
    NSLog(@"当前ID %@",model.Id);
    
    NSString *ID = model.Id;
 
   //  NSString *ID = @"62";
    
   
    
    ZRTLineController *line = [[ZRTLineController alloc]initWithConversationType:ConversationType_PRIVATE targetId:ID];

    line.targetId = ID; // 接收者的 targetId，这里为举例。
    line.userName = line.userName; // 接受者的 username，这里为举例。
    line.title = line.userName; // 会话的 title。
    line.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    
    // 把单聊视图控制器添加到导航栈。
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:line animated:YES];
   

}



-(void)linePatient:(ZRTPatientModel *)model
{


    NSLog(@"当前ID %@",model.Id);
    
    NSString *ID = model.Id;
    
    
    ZRTLineController *line = [[ZRTLineController alloc]initWithConversationType:ConversationType_PRIVATE targetId:ID];
    
    line.targetId = ID; // 接收者的 targetId
    line.userName = line.userName; // 接受者的 username
    line.title = line.userName; // 会话的 title。
    line.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    
    // 把单聊视图控制器添加到导航栈。
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:line animated:YES];



}






#pragma mark - 网络请求
- (void)getHealthyDataFromNetwork {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getHealthyDataWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andStrWhere:@"" andOrderBy:@"" andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [self.dataSource1 removeAllObjects];
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"健康档案请求数据 error == %@",error);
    }];
    
}

- (void)getDoctorOrPatientDataFromNetwork {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *type;
    
    if (self.redView2.isHidden == NO) {
        type = @"2";
    }
    else {
        type = @"1";
    }
    
    [[OZHNetWork sharedNetworkTools] getDoctorOrPatientDataWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andDocOrPat:type andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"获取我的医生和患者 error == %@",error);
        
    }];
    
}


- (void)dealModelWithJsonDict:(NSDictionary *)dict {
    

    if (self.redView1.hidden == NO) {
        
     //   NSLog(@"----------->%@",dict);
        
        for (NSDictionary *dsDict in dict[@"ds"]) {
         
            
            ZRTHealthyModel *model = [ZRTHealthyModel HealthyWithDic:dsDict];
            
            
            
            [self.dataSource1 addObject:model];
            
        }
        
        
        [self.tableView reloadData];
        
    }
    else if (self.redView2.hidden == NO) {
        
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            
            
            
            ZRTDoctorModel *dmodel = [ZRTDoctorModel DoctorWithDic:dic];
            
            [self.dataSource2 addObject:dmodel];
        }
        
        [self passDoctorDataToAppdelegate];
        
        [self.tableView2 reloadData];
        
    }
    else {
        
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTPatientModel *pmodel = [ZRTPatientModel PatientWithDic:dic];
            
            [self.dataSource3 addObject:pmodel];
        }
        
        [self passPatientDataToAppdelegate];
        
        [self.tableView3 reloadData];
    }
    
    
}

- (void)passDoctorDataToAppdelegate {
    
    NSMutableArray *doctorArray = [[NSMutableArray alloc] init];
    
    [self.dataSource2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        ZRTDoctorModel *model = (ZRTDoctorModel *)obj;
        
        NSDictionary *dict = @{@"UserId":model.Id,@"ImgUrl":model.ImgUrl,@"NickName":model.NickName};
        
        [doctorArray addObject:dict];
        
    }];
    
    [DEFAULT setObject:doctorArray forKey:@"DoctorArray"];
    [DEFAULT synchronize];
    
}

- (void)passPatientDataToAppdelegate {
    
    NSMutableArray *patientArray = [[NSMutableArray alloc] init];
    
    [self.dataSource2 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        ZRTPatientModel *model = (ZRTPatientModel *)obj;
        
        NSDictionary *dict = @{@"UserId":model.Id,@"ImgUrl":model.ImgUrl,@"NickName":model.NickName};
        
        [patientArray addObject:dict];
        
    }];
    
    [DEFAULT setObject:patientArray forKey:@"PatientArray"];
    [DEFAULT synchronize];
}

#pragma mark - 发布成功提示

#define KHeigthOfSpace 36;

- (void)showPublishStateWithState:(NSInteger)state {
    
    CGFloat labelH = 17;
    CGFloat labelW = self.view.width;
    CGFloat labelX = 0;
    CGFloat labelY = CGRectGetMinY(self.redView1.frame) + labelH + KHeigthOfSpace;
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    
    self.stateLabel.text = @"正在发送中~";
    
    
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
    self.stateLabel.textColor = [UIColor darkGrayColor];
    [self.stateLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self.navigationController.view insertSubview:self.stateLabel belowSubview:self.navigationController.navigationBar];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.stateLabel.transform = CGAffineTransformMakeTranslation(0, labelH);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

@end
