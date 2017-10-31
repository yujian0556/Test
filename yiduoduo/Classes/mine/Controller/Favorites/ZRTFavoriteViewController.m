//
//  ZRTFavoriteViewController.m
//  yiduoduo
//
//  Created by olivier on 15/8/10.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTFavoriteViewController.h"

#import "ZRTCaseModel.h"
#import "ZRTVideoModel.h"
#import "ZRTConsultationModel.h"


#import "ZRTFavoriteTableViewCell.h"


#import "ZRTDetailViewController.h"
#import "ZRTConsultationDetailViewController.h"

#import "Interface.h"
#import "KxMovieViewController.h"
#define KBGColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]

@interface ZRTFavoriteViewController () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,KxMovieViewControllerDelegate>

@property (nonatomic,assign) BOOL isCase;

@property (nonatomic,assign) BOOL isConsultation;

@property (nonatomic,assign) BOOL isVideo;


@property (nonatomic,strong) UIButton *caseBtn;

@property (nonatomic,strong) UIButton *consultationBtn;

@property (nonatomic,strong) UIButton *videoBtn;


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


@end

@implementation ZRTFavoriteViewController
{
    NSInteger _firstTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self createArray];
    
    self.view.backgroundColor = KBGColor;
    
    [self OSD];
    [self setUpNavBar];
    
    
    [self setUpBtns];
    
    
    [self didClickCase];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    
    if (self.redView1.hidden == NO) {
        
        if (_firstTime++ != 1) {
            [self.dataSource1 removeAllObjects];
            //写下网络请求
            [self getCaseCollection];
        }
        
    }
    else if (self.redView2.hidden == NO) {
        [self.dataSource2 removeAllObjects];
        
        //写下网络请求
        [self getConsultationCollection];
    }
    else {
        [self.dataSource3 removeAllObjects];
        //写下网络请求
        [self getVideoCollection];
    }
    
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
    
    self.navigationItem.title = @"我的收藏";
    
    
    self.isCase = YES;
    
    
}



- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 添加三个模块
-(void)setUpBtns
{
    
    CGFloat btnW = self.view.width/3;
    
    CGFloat redH = 6;
    
    CGFloat viewH = btnW *0.6;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, viewH)];
    
    view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:view];
    
    
    
    
    //  病例
    
    self.caseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, view.height)];
    
    [self.caseBtn setTitle:@"病 例" forState:UIControlStateNormal];
    
    [self.caseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.caseBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.caseBtn addTarget:self action:@selector(didClickCase) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.caseBtn];
    
    
    self.redView1 = [[UIView alloc] initWithFrame:CGRectMake(0, view.height -redH, btnW, redH)];
    
    self.redView1.backgroundColor = KLineColor;
    
    [self.caseBtn addSubview:self.redView1];
    
    
    
    
    
    
    // 会诊
    
    self.consultationBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, view.height)];
    
    [self.consultationBtn setTitle:@"医问医答" forState:UIControlStateNormal];
    
    [self.consultationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.consultationBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.consultationBtn addTarget:self action:@selector(didClickConsultation) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.consultationBtn];
    
    self.redView2 = [[UIView alloc] initWithFrame:CGRectMake(btnW, view.height -redH, btnW, redH)];
    
    self.redView2.backgroundColor = KLineColor;
    
    [self.caseBtn addSubview:self.redView2];
    
    self.redView2.hidden = YES;
    
    
    
    // 视频
    
    self.videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW *2, 0, btnW, view.height)];
    
    [self.videoBtn setTitle:@"视 频" forState:UIControlStateNormal];
    
    [self.videoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.videoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.videoBtn addTarget:self action:@selector(didClickVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:self.videoBtn];
    
    self.redView3 = [[UIView alloc] initWithFrame:CGRectMake(btnW*2, view.height -redH, btnW, redH)];
    
    self.redView3.backgroundColor = KLineColor;
    
    [self.caseBtn addSubview:self.redView3];
    
    self.redView3.hidden = YES;
    
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
-(void)didClickCase
{
    
    [self.dataSource1 removeAllObjects];
    
    //  切换下标
    self.redView2.hidden = YES;
    self.redView3.hidden = YES;
    self.redView1.hidden = NO;
    
    
    // 设置表
    [self.tableView2 removeFromSuperview];
    [self.tableView3 removeFromSuperview];
    
    
    if (self.tableView) {
        
        return;
    }
    
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.caseBtn.frame)+20, self.view.width, KScreenHeight - CGRectGetMaxY(self.caseBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[ZRTFavoriteTableViewCell class] forCellReuseIdentifier:@"FavoriteCell"];
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCase)];
//    
//    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [tableView addGestureRecognizer:swipe];
    
    
    //  [self setUpAnimation];
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    //写下网络请求
    [self getCaseCollection];
    
    ++_firstTime;
}



- (void)swipeCase
{
    [self didClickConsultation];
    
    
}



-(void)didClickConsultation
{
    [self.dataSource2 removeAllObjects];
    
    //  切换下标
    self.redView1.hidden = YES;
    self.redView3.hidden = YES;
    self.redView2.hidden = NO;
    
    // 设置添加按钮
    
    
    // 设置表
    [self.tableView removeFromSuperview];
    [self.tableView3 removeFromSuperview];
    
    if (self.tableView2) {
        
        return;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.caseBtn.frame)+20, self.view.width,  KScreenHeight - CGRectGetMaxY(self.caseBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[ZRTFavoriteTableViewCell class] forCellReuseIdentifier:@"FavoriteCell"];
    
//    
//    UISwipeGestureRecognizer *swipe1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeConsultationRight)];
//    
//    swipe1.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [tableView addGestureRecognizer:swipe1];
    


//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeConsultationLeft)];
//    
//    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
//    [tableView addGestureRecognizer:swipe];
    
    //  [self setUpAnimation];
    
    
    [self.view addSubview:tableView];
    self.tableView2= tableView;
    
    //写下网络请求
    [self getConsultationCollection];
}


-(void)swipeConsultationLeft
{
    
    [self didClickVideo];
    
    
}


-(void)swipeConsultationRight
{
    
    [self didClickCase];
    
    
}




-(void)didClickVideo
{
    [self.dataSource3 removeAllObjects];
    
    //    NSLog(@"patient");
    self.redView1.hidden = YES;
    self.redView2.hidden = YES;
    self.redView3.hidden = NO;
    
    
    
    // 设置表
    
    [self.tableView removeFromSuperview];
    [self.tableView2 removeFromSuperview];
    
    if (self.tableView3) {
        
        return;
    }
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.caseBtn.frame)+20, self.view.width,  KScreenHeight - CGRectGetMaxY(self.caseBtn.frame)-20-64)];
    
    tableView.backgroundColor = KBGColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView registerClass:[ZRTFavoriteTableViewCell class] forCellReuseIdentifier:@"FavoriteCell"];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    CGPoint translatedPoint = [tableView.panGestureRecognizer translationInView:tableView];
    
    self.pointPatient = translatedPoint;
    
    
    
//    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeVideo)];
//    
//    swipe.direction = UISwipeGestureRecognizerDirectionRight;
//    [tableView addGestureRecognizer:swipe];
    
    
    // [self setUpAnimation];
    
    
    
    [self.view addSubview:tableView];
    self.tableView3= tableView;
    
    //写下网络请求
    [self getVideoCollection];
    
}

-(void)swipeVideo
{
    
    [self didClickConsultation];
    
    
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
    ZRTFavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteCell"];
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }

    
    cell.editing = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.tableView){
        
        
        [cell fillCellWithCaseModel:self.dataSource1[indexPath.row]];
        cell.index.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        
    }else if(tableView == self.tableView2){
        
        [cell fillCellWithConsultationModel:self.dataSource2[indexPath.row]];
        cell.index.text = [NSString stringWithFormat:@"%ld.",indexPath.row+1];
        
        
        
    }else{
        
        
        
        [cell fillCellWithVideoModel:self.dataSource3[indexPath.row]];
        cell.index.text = [NSString stringWithFormat:@"%d.",indexPath.row+1];
    }
    
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        
        ZRTDetailViewController *dVC = [[ZRTDetailViewController alloc] init];
        
        dVC.model = self.dataSource1[indexPath.row];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:dVC animated:YES];
        
        
    }else if(tableView == self.tableView2){
        
        ZRTConsultationDetailViewController *cdVC = [[ZRTConsultationDetailViewController alloc] init];
        
        cdVC.model = self.dataSource2[indexPath.row];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:cdVC animated:YES];
        
        
        
        
    }else{
        
        NSString *urlString;
        ZRTVideoModel *model = [[ZRTVideoModel alloc] init];
        
        urlString = [self.dataSource3[indexPath.row] VideoPath];
        
        model = self.dataSource3[indexPath.row];
        urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,urlString];
        
    
        [self playWithUrl:urlString WithModel:model];
        
    }
    
    
    
    
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    if (KScreenHeight == 480) {  // 4s
        
        return 40;
        
    }else if (KScreenHeight == 568){  // 5s
        return 50;
        
    }else if (KScreenHeight == 667){  // 6
        
        return 60;
        
    }else{  // 6p
        
        return 70;
    }
        

    
    
    
}


//  滑动删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteCollectionWithRow:indexPath.row];
        
        if (tableView == self.tableView) {
            [self.dataSource1 removeObjectAtIndex:indexPath.row];
        }
        else if (tableView == self.tableView2) {
            [self.dataSource2 removeObjectAtIndex:indexPath.row];
        }
        else {
            [self.dataSource3 removeObjectAtIndex:indexPath.row];
        }
        
        [tableView reloadData];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteWithReload" object:nil];
        
       
        
    }
    
    

}



#pragma mark - 网络请求

#define pageIndex @"1"
#define pageSize @"100000"

- (void)getCaseCollection {
    
    NSLog(@"case");
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getCaseCollectionWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andPageIndex:pageIndex andPageSize:pageSize andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        //NSLog(@"jsonDict == %@",jsonDict);
        
        [weakSelf.dataSource1 removeAllObjects];
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        NSLog(@"获取病例收藏 error == %@",error);
        
    }];
    
}

- (void)getVideoCollection {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getVideoCollectionWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andPageIndex:pageIndex andPageSize:pageSize andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf.dataSource3 removeAllObjects];
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"获取视频收藏 error == %@",error);
        
    }];
    
}


- (void)getConsultationCollection {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getConsultationCollectionWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andPageIndex:pageIndex andPageSize:pageSize andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf.dataSource2 removeAllObjects];
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"获取会诊收藏 error == %@",error);
        
    }];
}


- (void)dealModelWithJsonDict:(NSDictionary *)dict {
    
    
    if (self.redView1.hidden == NO) {
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTCaseModel *model = [ZRTCaseModel caseModelWithDict:dic];
            
            [self.dataSource1 addObject:model];
            
            NSLog(@"%@",model.Id);

        }
        
        
        [self.tableView reloadData];
        
    }
    else if (self.redView2.hidden == NO) {
        
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTConsultationModel *model = [ZRTConsultationModel consultationModelWithDict:dic];
            
            [self.dataSource2 addObject:model];
            
        }
        
        [self.tableView2 reloadData];
    }
    else {
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTVideoModel *model = [ZRTVideoModel videoModelWithDict:dic];
            
            [self.dataSource3 addObject:model];
            
        }
        
        [self.tableView3 reloadData];
    }
    
}


//删除收藏
- (void)deleteCollectionWithRow:(NSInteger)row {
    
    if (self.redView1.hidden == NO) {
        
        
        [[OZHNetWork sharedNetworkTools] cancleCollectCaseWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andCaseId:[self.dataSource1[row] Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            NSLog(@"取消病例收藏 error == %@",error);
        }];
        
    }
    else if (self.redView2.hidden == NO) {
        
        [[OZHNetWork sharedNetworkTools] cancleCollectConsultationWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andConsultationId:[self.dataSource2[row] Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            NSLog(@"取消会诊收藏 error == %@",error);
        }];

    }
    else {
        
        [[OZHNetWork sharedNetworkTools] cancleCollectVideoWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andVideoId:[self.dataSource3[row] Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            NSLog(@"取消视频收藏 error == %@",error);
        }];
        
    }
    
}

#pragma mark - 代理方法
-(void)playWithUrl:(NSString *)urlString WithModel:(ZRTVideoModel *)model
{
    // NSString *path;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if ([urlString.pathExtension isEqualToString:@"wmv"])
        parameters[KxMovieParameterMinBufferedDuration] = @(5.0);
    
    // disable deinterlacing for iPhone, because it's complex operation can cause stuttering
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        parameters[KxMovieParameterDisableDeinterlacing] = @(YES);
    
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:urlString
                                                                               parameters:parameters];
    
    vc.model = model;
    vc.delegate = self;
    
    
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
@end
