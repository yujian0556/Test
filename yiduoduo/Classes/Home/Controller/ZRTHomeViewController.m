//
//  ZRTHomeViewController.m
//  yiwen
//
//  Created by moyifan on 15/4/21.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHomeViewController.h"

#import "SDCycleScrollView.h"

#import "ZRTHome.h"
#import "OZHNetWork.h"

#import "ZRTHomeCaseTableViewCell.h"
#import "ZRTVideoCollectionView.h"

#import "ZRTCaseModel.h"
#import "ZRTVideoModel.h"


#import "ZRTDetailViewController.h"


#import "Interface.h"
#import "MBProgressHUD+MJ.h"

#import "KxMovieViewController.h"

#import "MJRefresh.h"

#import "ZRTMineViewController.h"
#import "ZRTLoginViewController.h"
#import "ZRTMoreButton.h"
#import "ZRTSearchBar.h"
#import "ZRTSearchViewController.h"
#import "AFNetworking.h"
#import "ZRTTabBar.h"
#import "ZRTBannerView.h"

static NSString *CaseTableViewReuseIdentifier = @"CaseTableViewCell";
static NSString *VideoCollectionViewReuseIdentifier = @"VideoCollectionView";
static NSString *StudyCollectionViewReuseIdentifier = @"";

#define KImageScrollViewMaxY KScreenWidth/840*350

@interface ZRTHomeViewController ()<SDCycleScrollViewDelegate,ZRTLoginViewControllerDelegate,KxMovieViewControllerDelegate,ZRTDetailViewControllerDelegate,UITextFieldDelegate,ZRTTabBarDelegate>

//病例
@property (nonatomic,strong) UITableView *CaseTableView;

//数组中装各模块数据的数组
@property (nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,assign) int type;

@property (nonatomic,assign) BOOL isReplay;

@property (nonatomic,strong) ZRTSearchBar *searchBar;

@property (nonatomic,copy) NSString *searchText;

@property (nonatomic,strong) ZRTSearchViewController *searchVC;

@end

@implementation ZRTHomeViewController
{
    NSLock *_lock;
    
    NSMutableArray *_bannerArray;
}

#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    
    return YES;
}

//-(NSUInteger)supportedInterfaceOrientations
//{
//    
//    return UIInterfaceOrientationMaskPortrait;
//    
//}

#pragma mark 懒加载

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;

}






#warning 这个方法iOS9里暂时失效，疑为不通过这个方法创建所以没走
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        //这个type以后会有变化，决定科室类型，现在只有一个科室
        self.type = 1;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setHeaderRefresh];
//    [self getHomeData];
    
    [self getBanner];
    
//    [self setimage];
    
    [self registerCells];
    
    [self setNavgationBar];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnreadMessage) name:@"UnreadMessage" object:nil];
    
}



#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"logo"] highImage:[UIImage imageNamed:@""] target:self action:nil];
    
  
    self.searchBar = [[ZRTSearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth*0.8-10, 30) WithColorNumber:1];
 
    self.searchBar.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.searchBar resignFirstResponder];

}


#pragma mark 搜索框代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.searchBar resignFirstResponder];
    
    
//    NSLog(@" %@",textField.text);
    
    self.searchText = textField.text;
    
    
    [self getNetWork];
    
    
    ZRTSearchViewController *search = [[ZRTSearchViewController alloc] init];

    self.searchVC = search;
    
    search.searchTitle = textField.text;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:search animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
    return YES;
}






/**
 *  首页导航栏左右按钮
 */
-(void)didClickLeft
{

}


-(void)didClickRight
{

}

#pragma mark - 滚动广告条模块 SDCycleScrollViewDelegate
/**
 *  图片轮播器
 */
-(void)setimage
{
    
    NSArray *imagesURL = @[
                           [NSURL URLWithString:_bannerArray[0][@"imgurl"]],
                           [NSURL URLWithString:_bannerArray[1][@"imgurl"]],
                           [NSURL URLWithString:_bannerArray[2][@"imgurl"]]
                           ];
    
    
//    NSArray *images = @[[UIImage imageNamed:@"app_banner1.png"],
//                        [UIImage imageNamed:@"app_banner2.jpg"],
//                        [UIImage imageNamed:@"app_banner3.jpg"],
//                        
//                        ];
    
    
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KImageScrollViewMaxY) imageURLsGroup:imagesURL];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 5.0;
    
    
    
    
    
    // 情景三：图片配文字
    //    NSArray *titles = @[@"好看",
    //                        @"也好看",
    //                        @"都好看",
    //
    //                        ];
    
    
    //    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, KScreenWidth, KImageScrollViewMaxY) imageURLsGroup:nil];
    //    cycleScrollView2.autoScrollTimeInterval = 5.0;//时间间隔
    //    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    //    cycleScrollView2.delegate = self;
    //    cycleScrollView2.titlesGroup = titles;
    //    cycleScrollView2.dotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    //
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        cycleScrollView2.imageURLsGroup = imagesURL;
    //    });
    //
    //    [self.view addSubview:cycleScrollView2];
    
    self.tableView.tableHeaderView = cycleScrollView;
    
    NSLog(@" %@",NSStringFromCGRect(cycleScrollView.frame));
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSString *url = _bannerArray[index][@"weburl"];
    
    NSLog(@" %@",url);
    
    if ([url isEqualToString:@""]) {
        
        return;
    }
    
    
    ZRTBannerView *banner = [[ZRTBannerView alloc] init];
    
    banner.url = url;
    
    banner.title = _bannerArray[index][@"title"];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:banner animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 病例、视频、学习园地模块
/**
 注册模块Cell
 */
- (void)registerCells
{
    [self.tableView registerNib:[UINib nibWithNibName:@"ZRTHomeCaseTableViewCell" bundle:nil] forCellReuseIdentifier:CaseTableViewReuseIdentifier];
        
    [self.tableView registerNib:[UINib nibWithNibName:@"ZRTVideoCollectionView" bundle:nil] forCellReuseIdentifier:VideoCollectionViewReuseIdentifier];
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSLog(@"jige %ld",self.dataSource.count);
    return self.dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    
    
//    NSLog(@" 123");
    
    if (indexPath.section == 0) {
        
        
        ZRTHomeCaseTableViewCell *caseTableViewCell = [tableView dequeueReusableCellWithIdentifier:CaseTableViewReuseIdentifier];
        
        [caseTableViewCell PassDataArray:self.dataSource[indexPath.section]];
        
        
        caseTableViewCell.jumpBlock = ^(ZRTCaseModel *model){
            
            if (!isAllUserLogin) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录，现在去登录~" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    ZRTLoginViewController * lvc = [[ZRTLoginViewController alloc] init];
                    
                    lvc.delegate = weakSelf;
                    
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    
                    [weakSelf.navigationController pushViewController:lvc animated:YES];
                    
                    weakSelf.hidesBottomBarWhenPushed = NO;
                    
                }];
                
                [alert addAction:cancle];
                [alert addAction:sure];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }
            else {
                ZRTDetailViewController *detail = [[ZRTDetailViewController alloc] init];
                
                detail.model = model;
                detail.delegate = self;
                
                [weakSelf setHidesBottomBarWhenPushed:YES];
                
                [weakSelf.navigationController pushViewController:detail animated:YES];
                
                [weakSelf setHidesBottomBarWhenPushed:NO];
            }
            
            
            
        };
        
        
        return caseTableViewCell;
    }
    else {//if (indexPath.section == 1) {
        ZRTVideoCollectionView *videoCollectionView = [tableView
                                                       dequeueReusableCellWithIdentifier:VideoCollectionViewReuseIdentifier];
        
        [videoCollectionView PassDataArray:self.dataSource[indexPath.section]];
        
        
        
        //设置video的model
        videoCollectionView.jumpBlock = ^(ZRTVideoModel *videoModel) {
//            
//            NSString *urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,model.VideoPath];
//            
//            
//            [weakSelf playWithUrl:urlString WithModel:model];
            if (!isAllUserLogin) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录，现在去登录~" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    ZRTLoginViewController * lvc = [[ZRTLoginViewController alloc] init];
                    
                    lvc.delegate = weakSelf;
                    
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    
                    [weakSelf.navigationController pushViewController:lvc animated:YES];
                    
                    weakSelf.hidesBottomBarWhenPushed = NO;
                    
                }];
                
                [alert addAction:cancle];
                [alert addAction:sure];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }
            else {
              
                
                NSString *urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,videoModel.VideoPath];
                
                
                [weakSelf playWithUrl:urlString WithModel:videoModel];
            
            
            }
            


        };
        
        return videoCollectionView;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

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
    
    if (self.isReplay) {
        
        vc.isReplay = YES;
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}



#pragma mark - 屏幕适配方法
/**
 根据设备类型，设置不同的CollectionView的高度
 */
- (CGFloat)heightForDevice
{
    //iPhone 4,5
    if (KScreenWidth == 320) {
        return 280;
    }
    //iPhone 6
    else if (KScreenWidth == 375) {
        return 320;
    }
    //iPhone 6p
    else {
        return 360;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //病例cell的高度
        return 156;
    }
    else {
        //视频 和 学习园地 cell的高度
        return [self heightForDevice];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //240 × 50
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 35)];

    //病例的header
    if (section == 0) {
        
        
        UILabel *caseHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, headerView.height)];
        
        caseHeaderLabel.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
        
        UILabel *caseHeaderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(headerView.width-5, 0, 5, headerView.height)];
        
        caseHeaderLabel1.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
        
        
        
        UIImageView *caseHeaderImageView = [[UIImageView alloc] init];
        caseHeaderImageView.image = [UIImage imageNamed:@"首页病例"];
        
        [caseHeaderImageView sizeToFit];
        
        caseHeaderImageView.x = 10;
        caseHeaderImageView.y = (headerView.height - caseHeaderImageView.height)/2;
        
        [headerView addSubview:caseHeaderImageView];
        [headerView addSubview:caseHeaderLabel];
        [headerView addSubview:caseHeaderLabel1];
        
        
        
        ZRTMoreButton *more = [[ZRTMoreButton alloc] init];
        
        [more layoutSubviews];
        
        more.x = headerView.width - more.width-10;
        more.y = (headerView.height- more.height)/2;
        
        more.tag = 100;
        [more addTarget:self action:@selector(SeeMore:) forControlEvents:UIControlEventTouchUpInside];
        
        [headerView addSubview:more];
    
        headerView.backgroundColor = [UIColor whiteColor];
    }
    //视频的header
    else if (section == 1) {
        
        UILabel *caseHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, headerView.height)];
        
        caseHeaderLabel.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
        
        UILabel *caseHeaderLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(headerView.width-5, 0, 5, headerView.height)];
        
        caseHeaderLabel1.backgroundColor = [UIColor colorWithRed:238/256.0 green:238/256.0 blue:238/256.0 alpha:1];
       
        UIImageView *VideoHeaderImageView = [[UIImageView alloc] init];
        VideoHeaderImageView.image = [UIImage imageNamed:@"首页视频"];
        
        [VideoHeaderImageView sizeToFit];
        
        VideoHeaderImageView.x = 10;
        VideoHeaderImageView.y = (headerView.height - VideoHeaderImageView.height)/2;
        
        
        [headerView addSubview:VideoHeaderImageView];
        [headerView addSubview:caseHeaderLabel];
        [headerView addSubview:caseHeaderLabel1];
        
        
        ZRTMoreButton *more = [[ZRTMoreButton alloc] init];
        
        [more layoutSubviews];
        
        more.x = headerView.width - more.width-10;
        more.y = (headerView.height- more.height)/2;
        
        more.tag = 102;
        
        [more addTarget:self action:@selector(SeeMore:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        [headerView addSubview:more];
        
        
        headerView.backgroundColor = [UIColor whiteColor];
    }
    //学习园地的header
    else if (section == 2) {
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(10, 7, 4, 15)];
        blueView.backgroundColor = [UIColor colorWithRed:80/256.0 green:186/256.0 blue:171/256.0 alpha:1];
        
        UILabel *videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(blueView.frame) + 2, -15, 120, 60)];
        videoLabel.text = @"学习园地";
        
        //设置视频和PPT切换按钮
        UIButton *switchVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchVideoButton setTitle:@"视频" forState:UIControlStateNormal];
        [switchVideoButton setTitle:@"视频" forState:UIControlStateSelected];
        [switchVideoButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [switchVideoButton setTitleColor:KMainColor forState:UIControlStateNormal];
        [switchVideoButton setBackgroundImage:nil forState:UIControlStateNormal];
        [switchVideoButton setBackgroundImage:[UIImage imageNamed:@"home_study_selected_bg"] forState:UIControlStateSelected];
        switchVideoButton.frame = CGRectMake(KScreenWidth - 120, 8, 50, 22);
        switchVideoButton.tag = 200;
        switchVideoButton.selected = YES;
        [switchVideoButton addTarget:self action:@selector(changeBetweenVideoAndPPT:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *switchPPTButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [switchPPTButton setTitle:@"PPT" forState:UIControlStateNormal];
        [switchPPTButton setTitle:@"PPT" forState:UIControlStateSelected];
        [switchPPTButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [switchPPTButton setTitleColor:KMainColor forState:UIControlStateNormal];
        [switchPPTButton setBackgroundImage:nil forState:UIControlStateNormal];
        [switchPPTButton setBackgroundImage:[UIImage imageNamed:@"home_study_selected_bg"] forState:UIControlStateSelected];
        switchPPTButton.frame = CGRectMake(CGRectGetMaxX(switchVideoButton.frame), CGRectGetMinY(switchVideoButton.frame), 50, 22);
        switchPPTButton.tag = 201;
        [switchPPTButton addTarget:self action:@selector(changeBetweenVideoAndPPT:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [headerView addSubview:blueView];
        [headerView addSubview:videoLabel];
        [headerView addSubview:switchVideoButton];
        [headerView addSubview:switchPPTButton];
        
        headerView.backgroundColor = [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    //设置footer的高度
    switch (section) {
        case 0:
        case 2:
//            return 30;
        default:
            return 0;
    }
}


//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
//    
//    UIButton *seeMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    seeMoreButton.frame = CGRectMake(0, 0, KScreenWidth, 30);
//    
//    [seeMoreButton setTitle:@"查看更多" forState:UIControlStateNormal];
//    
//    [seeMoreButton addTarget:self action:@selector(SeeMore:) forControlEvents:UIControlEventTouchUpInside];
//    
//    if (section == 0) {
//        //病例查看更多tag 100
//        seeMoreButton.tag = 100;
//        [seeMoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [seeMoreButton setBackgroundColor:KMainColor];
//    }
//    if (section == 2) {
//        //学习园地查看更多tag 101
//        seeMoreButton.tag = 101;
//        [seeMoreButton setTitleColor:KMainColor forState:UIControlStateNormal];
//        [seeMoreButton setBackgroundColor:[UIColor whiteColor]];
//    }
//    
//    [footerView addSubview:seeMoreButton];
//    
//    return footerView;
//}

#pragma mark - 按钮点击事件
/**
 查看更多按钮的点击事件
 */
- (void)SeeMore:(UIButton *)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    ZRTTabBar *tabar = [[ZRTTabBar alloc] init];
    for (ZRTTabBar *tab in self.tabBarController.tabBar.subviews) {
    
        if ([tab isKindOfClass:NSClassFromString(@"ZRTTabBar")]) {
            
            tabar = tab;
            
            [array addObjectsFromArray:tab.subviews];
    
        }
        
    }
    
    if (sender.tag == 100) {
//        NSLog(@"病例查看更多");
        
        self.tabBarController.selectedIndex = 0;
  
        UIButton *btn = array[0];
        
        btn.selected = YES;
        
        tabar.selectBtn = btn;
       
        
        
    }
    else if (sender.tag == 101) {
        ////NSLog(@"学习园地查看更多");
    }
    else if (sender.tag == 102) {
//        NSLog(@"视频查看更多");
        
        self.tabBarController.selectedIndex = 1;
        UIButton *btn = array[1];
        
        btn.selected = YES;
        
        tabar.selectBtn = btn;
        
    }
    
}

/**
 PPT和视频切换按钮的点击事件
 */
- (void)changeBetweenVideoAndPPT:(UIButton *)sender
{
    UIButton *videoBtn = (UIButton *)[self.view viewWithTag:200];
    UIButton *studyBtn = (UIButton *)[self.view viewWithTag:201];
    
    videoBtn.selected = NO;
    studyBtn.selected = NO;
    
    sender.selected = !sender.isSelected;
    
    if (sender.tag == 200 && sender.isSelected) {
        ////NSLog(@"切换到视频");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToVideo" object:nil userInfo:@{@"studyType":@"0"}];
    }
    else if (sender.tag == 201 && sender.isSelected) {
        ////NSLog(@"切换到PPT");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeToPPT" object:nil userInfo:@{@"studyType":@"1"}];
    }
}

#pragma mark - 网络请求
- (void)getHomeData {
    
    __weak typeof(self) weakSelf = self;
    
    if (isAllUserLogin) {//用户登录了，接口传入用户id
        [[OZHNetWork sharedNetworkTools] getMainDataWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            if ([self.tableView.header isRefreshing]) {
                
                [self.dataSource removeAllObjects];
                
                [self.tableView.header endRefreshing];
            }
            
            NSMutableArray *caseArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dsDict in jsonDict[@"case"][@"ds"]) {
                
//                NSLog(@" %@",dsDict);
                
                ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
                
//                NSLog(@" %@",caseModel);
                
                [caseArray addObject:caseModel];
                
//                NSLog(@"哪儿 %@",caseArray);
            }
            
//            NSLog(@"哪儿没有 %@",caseArray);
            
            [self.dataSource addObject:caseArray];
            
//            NSLog(@"几个 %ld",self.dataSource.count);
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dsDict in jsonDict[@"video"][@"ds"]) {
                
                ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
                [videoArray addObject:videoModel];
            }
            
            [self.dataSource addObject:videoArray];
            
            [self.tableView reloadData];
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
//            NSLog(@"获取首页数据 error == %@",error);
            
            [weakSelf showNetWorkingWarning];
            
        }];

    }
    else {
        
        [[OZHNetWork sharedNetworkTools] getMainDataWithUserId:@"" Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            if ([self.tableView.header isRefreshing]) {
                
                [self.dataSource removeAllObjects];
                
                [self.tableView.header endRefreshing];
            }
            
            NSMutableArray *caseArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dsDict in jsonDict[@"case"][@"ds"]) {
                
                ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
                [caseArray addObject:caseModel];
            }
            
            [self.dataSource addObject:caseArray];
            
            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dsDict in jsonDict[@"video"][@"ds"]) {
                
                ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
                [videoArray addObject:videoModel];
            }
            
            [self.dataSource addObject:videoArray];
            
            [self.tableView reloadData];
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
//                    NSLog(@"没登录获取首页数据 error == %@",error);
            
            [weakSelf showNetWorkingWarning];
            
        }];

    }
    
    
}



- (void)showNetWorkingWarning {
    
    [self performSelector:@selector(stopMJRefresh) withObject:nil afterDelay:2.0];
    
    [MBProgressHUD showError:@"网络请求失败"];

}

- (void)stopMJRefresh {
    [self.tableView.header endRefreshing];
}

#pragma mark - MJRefresh
- (void)setHeaderRefresh
{
    
    __weak typeof(self) weakSelf = self;
    

    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
    }];
    
    [self.tableView.legendHeader beginRefreshing];
}

/**
 下拉刷新
 */
- (void)loadNewData {

    [self getHomeData];

}

//- (void)getHomeData
//{
//    __weak typeof(self) weakSelf = self;
//    
//    // 实例化调度组
//    dispatch_group_t group = dispatch_group_create();
//    // 队列
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    
//    // 添加任务
//    dispatch_group_async(group, queue, ^{
//        [NSThread sleepForTimeInterval:1.0];
//        //获取病例
//        [[OZHNetWork sharedNetworkTools] getMainDataWithCasePageSize:3 andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
//            NSLog(@"1-->获取病例");
//            if ([self.tableView.header isRefreshing]) {
//                
//                [self.dataSource removeAllObjects];
//                
//            }
//            
//            
//            NSMutableArray *caseArray = [[NSMutableArray alloc] init];
//            
//            for (NSDictionary *dsDict in jsonDict[@"ds"]) {
//                
//                ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
//                [caseArray addObject:caseModel];
//            }
//            
//            
//            [self.dataSource addObject:caseArray];
//            
//            
//            
//        } andFailure:^(OZHNetWork *manager, NSError *error) {
//            NSLog(@"首页病例 error == %@",error);
//            
//            [weakSelf showNetWorkingWarning];
//        }];
//
//    });
//    
//    dispatch_group_async(group, queue, ^{
//        [NSThread sleepForTimeInterval:2.0];
//        //获取视频
//        [[OZHNetWork sharedNetworkTools] getMainDataWithVideoPageSize:4 andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
//            NSLog(@"2-->获取视频");
//            NSMutableArray *videoArray = [[NSMutableArray alloc] init];
//            
//            for (NSDictionary *dsDict in jsonDict[@"ds"]) {
//                
//                ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
//                [videoArray addObject:videoModel];
//            }
//            
//            
//            
//            [self.dataSource addObject:videoArray];
//            
//            
//            
//            
//        } andFailure:^(OZHNetWork *manager, NSError *error) {
//            NSLog(@"首页视频 error == %@",error);
//            [weakSelf showNetWorkingWarning];
//        }];
//    });
//
//    // dispatch_group_notify 可以监听调度组中所有的异步任务，在执行完毕后，获得通知！
//    // 监听工作是异步的！
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        
//        if ([self.tableView.header isRefreshing]) {
//            [self.tableView.header endRefreshing];
//            NSLog(@"3-->处理UI");
//            [self.tableView reloadData];
//        }
//    });
//
//}

#pragma mark - 接受未读消息的通知
- (void)UnreadMessage {
    ZRTMineViewController *mine = [self.tabBarController.viewControllers[4] viewControllers][0];
    
    
    mine.receiveMessage = YES;
}



#pragma mark - 代理方法

- (void)doNetWorking {
    
    [self getHomeData];
    
}

- (void)reloadDataAfterBack {
    
    [self.dataSource removeAllObjects];
    [self getHomeData];
    
}


-(void)rePlayVideoPath:(NSString *)path AndModel:(ZRTVideoModel *)model isReplay:(BOOL)isreplay
{
    
    
    NSLog(@"怎么回事 %@ %@",path,model);
    
    
    self.isReplay = isreplay;
    
    [self playWithUrl:path WithModel:model];
    
    
    
}



#pragma mark 搜索框网络请求

-(void)getNetWork
{

    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/SearchCaseOrVideo";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];


    [manager POST:url parameters:@{@"title":self.searchText} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
//        NSLog(@"搜索 %@ 返回 %@",self.searchText,responseObject);
        
        NSMutableArray *caseArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            [caseArray addObject:caseModel];
        }
        
    
        NSMutableArray *videoArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dsDict in jsonDict[@"ds1"]) {
            
            ZRTVideoModel *caseModel = [ZRTVideoModel videoModelWithDict:dsDict];
            [videoArray addObject:caseModel];
        }

        
        self.searchVC.caseModel = caseArray;
        self.searchVC.videoModel = videoArray;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"搜索error %@",error);
        
    }];
 
}




#pragma mark 获取banner

-(void)getBanner
{
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Misc.asmx/GetBanner";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        _bannerArray = [NSMutableArray array];
        for (NSDictionary *dic in jsonDict[@"ds"]) {
            
            [_bannerArray addObject:dic];
        }
        
        [self setimage]; //获取完数据才创建轮播图
        
        //            NSLog(@"banner %@",_bannerArray);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"轮播图 error %@",error);
        
    }];
    
    
}








@end
