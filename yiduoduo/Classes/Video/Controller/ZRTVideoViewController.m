//
//  ZRTVideoViewController.m
//  yiduoduo
//
//  Created by 余健 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTVideoViewController.h"

#import "SDCycleScrollView.h"

#import "ZRTVideoModel.h"
#import "ZRTVideoCollectionViewCell.h"



#import "Helper.h"

#import "OZHNetWork.h"

#import "MJRefresh.h"

#import "Interface.h"

#import "MBProgressHUD+MJ.h"

#import "KxMovieViewController.h"


#import "ZRTSelectModel.h"

#import "ZRTLoginViewController.h"
#import "LGAlertView.h"
#import "AFNetworking.h"
#import "ZRTBannerView.h"
#import "ZRTRZViewController.h"
//#import "ZRTVideoModel.h"

#define KImageScrollViewMaxY KScreenWidth/840*350
#define KThreeBtnViewMaxY KImageScrollViewMaxY

#define KNew @"addTime desc"
#define KHot @"click desc"

static NSString *VideoCellReuseIdentifier = @"VideoCell";

@interface ZRTVideoViewController () <SDCycleScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,ZRTLoginViewControllerDelegate,KxMovieViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *videoScrollView;

@property (nonatomic,strong) NSMutableArray *NewDataSource;
@property (nonatomic,strong) NSMutableArray *HotDataSource;
@property (nonatomic,strong) NSMutableArray *RecommendDataSource;

@property (nonatomic,strong) NSArray *oldDataArray;
@property (nonatomic,strong) NSMutableArray *sectionOfficeDataSource;

@property (nonatomic,strong) UITableView *sectionOfficeTB;

@property (nonatomic,assign) BOOL isReplay;


@property (nonatomic,strong) UIButton *latestBtn;
@property (nonatomic,strong) UIButton *todayBtn;
//滑动View
@property (nonatomic,strong) UICollectionView *latestView;
@property (nonatomic,strong) UICollectionView *todayView;
@property (nonatomic,strong) UIView *twoButtonView;

@end


@implementation ZRTVideoViewController
{
    UIView *_selectionView;
    UIButton *_selectBtn;
    SDCycleScrollView *_pictureView;
    
    NSInteger _currentTag;
    
    NSInteger _newCurrentPage;
    NSInteger _hotCurrentPage;
    
    CGFloat _scCenterX;
    
    BOOL _selectSectionOffice;
    NSInteger _sectionOfficeRow;
    
    NSMutableArray *_bannerArray;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //  [self setimage];
    
    [self getBanner];
    
    if (_selectBtn.isSelected) {
        [self.view sendSubviewToBack:_pictureView];
        [self.view bringSubviewToFront:_selectionView];
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteWithReloadData) name:@"deleteWithReload" object:nil];
    
    
}


- (void)deleteWithReloadData
{
    [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:STRWHERE andBack:0];
    [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:STRWHERE andBack:0];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    if (_selectBtn.isSelected) {
        
        CGRect closeFrame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
        _selectionView.frame = closeFrame;
        _selectBtn.selected = NO;
        
    }
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    //NSLog(@" %f",self.view.height);
    
    [self createArray];
    
    [self setTwoButton];
    
    [self createSVandCV];
    
//    [self createNotifierCenter];
    
    [self setNavgationBar];
    
    [self createSelectionView];
    
    
    //如果登录账户了,返回的网络
    if (!isAllUserLogin) {
        [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:NotLoginSTRWHERE andBack:0];
        [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:NotLoginSTRWHERE andBack:0];
    }
    else {
        [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:STRWHERE andBack:0];
        [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:STRWHERE andBack:0];
    }
    
    //上下刷新
    [self setHeaderRefresh];
    
    [self setFooterRefresh];
    
}



- (void)createArray {
    
    _newCurrentPage = 1;
    _hotCurrentPage = 1;
    
    //病例栏
    _selectSectionOffice = NO;
    
    self.NewDataSource = [[NSMutableArray alloc] init];
    self.HotDataSource = [[NSMutableArray alloc] init];
    self.RecommendDataSource = [[NSMutableArray alloc] init];
    self.sectionOfficeDataSource = [[NSMutableArray alloc] init];
}

#pragma mark 图片轮播器
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
    
    
    //图片轮播器遮挡了选择科室的View,但是在这里将图片轮播器放在最底层会有问题,所以在点击NavigationBar出现view的时候进行处理
    
    _pictureView = cycleScrollView;
    
}


#define marginBtn 20
- (void)setTwoButton
{
    CGFloat btnH;
    if (IPHONE6P) {
        btnH = 50;
    }else{
        btnH = 30;
    }
    
    self.twoButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, KThreeBtnViewMaxY, KScreenWidth, btnH)];
    self.twoButtonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.twoButtonView];
    
    
    CGFloat lineH = 20;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2, (self.twoButtonView.height - lineH)/2, 1, lineH)];
    
    line.backgroundColor = KTimeColor;
    
    [self.twoButtonView addSubview:line];
    
    self.latestBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, line.y, 0, 0)];

    [self.latestBtn setTitle:@"最新推荐" forState:UIControlStateNormal];
    
    [self.latestBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.latestBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    
    self.latestBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    //点击触发方法
    [self.latestBtn addTarget:self action:@selector(didClickLatestBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.latestBtn sizeToFit];
    
    self.latestBtn.center = line.center;
    
    self.latestBtn.x = line.x - self.latestBtn.width - marginBtn;
    
    [self.twoButtonView addSubview:self.latestBtn];
    
    self.latestBtn.selected = YES;
    
    
    
    self.todayBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, line.y, 0, 0)];
    
    [self.todayBtn setTitle:@"今日最热" forState:UIControlStateNormal];
    
    [self.todayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.todayBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    
    self.todayBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    

    [self.todayBtn addTarget:self action:@selector(didClickTodayBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.todayBtn sizeToFit];
    
    self.todayBtn.center = line.center;
    
    self.todayBtn.x = line.x + marginBtn;
    
    [self.twoButtonView addSubview: self.todayBtn];
    
    
}


#pragma mark --创建tableView以及scrollView滚动的范围
- (void)createSVandCV
{
    CGFloat btnMaxY =  CGRectGetMaxY(self.twoButtonView.frame);
    
    NSLog(@"max %f",btnMaxY);
    
    self.videoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnMaxY, KScreenWidth, KScreenHeight - btnMaxY - 64)];
    
    self.videoScrollView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - btnMaxY - 64 - 1);
    self.videoScrollView.pagingEnabled = YES;
    self.videoScrollView.directionalLockEnabled = YES;
    self.videoScrollView.showsVerticalScrollIndicator = NO;
    self.videoScrollView.showsHorizontalScrollIndicator = NO;
    // self.videoScrollView.backgroundColor = [UIColor redColor];
    
    self.videoScrollView.delegate = self;
    [self.view addSubview:self.videoScrollView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.itemSize = [self getCurrentDeviceType];
    flowLayout.minimumLineSpacing = 6;
    //定义一个在scrollView被拽出一个contentOffset的时候控件
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout2.itemSize = [self getCurrentDeviceType];
    flowLayout2.minimumLineSpacing = 6;
    //定义一个在scrollView被拽出一个contentOffset的时候控件
    flowLayout2.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    
    
    self.latestView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.videoScrollView.height) collectionViewLayout:flowLayout];
    self.latestView.delegate = self;
    self.latestView.dataSource = self;
    self.latestView.backgroundColor = [UIColor whiteColor];
    [self.videoScrollView addSubview: self.latestView];
    
    
    self.todayView = [[UICollectionView alloc]initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, self.latestView.height) collectionViewLayout:flowLayout2];
    self.todayView.delegate = self;
    self.todayView.dataSource = self;
    self.todayView.backgroundColor = [UIColor whiteColor];
    [self.videoScrollView addSubview: self.todayView];
    
    [self.latestView registerNib:[UINib nibWithNibName:@"ZRTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:VideoCellReuseIdentifier];
    [self.todayView registerNib:[UINib nibWithNibName:@"ZRTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:VideoCellReuseIdentifier];
    
}


//点击后走的方法
- (void)didClickLatestBtn
{
    self.videoScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)didClickTodayBtn
{
    self.videoScrollView.contentOffset = CGPointMake(KScreenWidth, 0);
}


#pragma mark scrollViewde的代理方法


/**
 根据设备类型，设置CollectionViewCell的Size
 */
- (CGSize)getCurrentDeviceType
{
    
    if (IPHONE6P) {
        
        return CGSizeMake(191, 165);
    }else{
    
        return CGSizeMake(140, 127);
    }
    
    
}


#pragma mark - SDCycleScrollViewDelegate
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

#pragma mark 滚动视图执行此方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    {
        // 得到每页宽度
        
        CGFloat pageWidth = scrollView.width;
        
        // 根据当前的x坐标和页宽度计算出当前页数
        
        int page = floor((self.videoScrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        
        
        if (page == 0) {
            
//            NSLog(@"新");
            
            self.latestBtn.selected = YES;
            self.todayBtn.selected = NO;
            
//            [self.latestView reloadData];
            
        }else{
            
//            NSLog(@"热");
            
            self.todayBtn.selected = YES;
            self.latestBtn.selected = NO;
            
//            [self.todayView reloadData];
            
        }
        
        
    }
    
}

#pragma mark - UICollectionViewDataSource(数据源方法)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.latestView) {
        
//        NSLog(@"xin %ld",self.NewDataSource.count);
        
        return self.NewDataSource.count;
    }else{
        
//        NSLog(@"hot %ld",self.HotDataSource.count);
        
        return self.HotDataSource.count;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    UICollectionView *cv = (UICollectionView *)[self.view viewWithTag:_currentTag];
    
    ZRTVideoCollectionViewCell *videoCell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellReuseIdentifier forIndexPath:indexPath];
    
    if (collectionView == self.latestView) {
        
//        NSLog(@"New %@",self.NewDataSource );
        
        [videoCell fillCellWithModel:self.NewDataSource[indexPath.row]];
//        videoCell.backgroundColor = [UIColor whiteColor];
        
//        NSLog(@" %@",NSStringFromCGSize(videoCell.size));
        
        return videoCell;
        
    }
    else {
        
//        NSLog(@"Hot %@",self.HotDataSource );
        
        [videoCell fillCellWithModel:self.HotDataSource[indexPath.row]];
        
//        videoCell.backgroundColor = [UIColor darkGrayColor];
        
        return videoCell;
    }
    
}


#pragma mark 选中跳转视频/视频播放器(点击跳转)

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!isAllUserLogin) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录，现在就去登录吧~" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            ZRTLoginViewController *lVC = [[ZRTLoginViewController alloc] init];
            
            lVC.delegate = self;
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:lVC animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
        }];
        
        [alert addAction:cancle];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    else {
        
        //        UIButton *NewBtn = (UIButton *)[self.view viewWithTag:100];
        //        UIButton *HotBtn = (UIButton *)[self.view viewWithTag:101];
        
        NSString *urlString;
        ZRTVideoModel *model = [[ZRTVideoModel alloc] init];
        
        if (self.latestBtn.isSelected) {
            urlString = [self.NewDataSource[indexPath.row] VideoPath];
            
            model = self.NewDataSource[indexPath.row];
        }
        else if (self.todayBtn.isSelected) {
            urlString = [self.HotDataSource[indexPath.row] VideoPath];
            
            model = self.HotDataSource[indexPath.row];
        }
        //        else {
        //            urlString = [self.RecommendDataSource[indexPath.row] VideoPath];
        //
        //            model = self.RecommendDataSource[indexPath.row];
        //        }
        
        //  urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,urlString];
        
        urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,urlString];
        
        NSLog(@"视频路径 %@",urlString);
        
        
        //  NSLog(@"评分 %@ 收藏%@",model.havescore,model.havecollect);
        
        
        NSDictionary *dict = [DEFAULT objectForKey:@"UserDict"];
        
        NSString *status = dict[@"Status"];
        
        if ([status isEqualToString:@"2"]) {
            
            [self playWithUrl:urlString WithModel:model];
            
        }else{
            
            LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"请先进行医生认证" buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:@"认证" actionHandler:nil cancelHandler:^(LGAlertView *alertView, BOOL onButton) {
                
            } destructiveHandler:^(LGAlertView *alertView) {
                
                ZRTRZViewController *rzvc = [[ZRTRZViewController alloc] init];
                
                //                    rzvc.delegate = self;
                
                
                self.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:rzvc animated:YES];
                
                self.hidesBottomBarWhenPushed = NO;
                
                
            }];
            

            [alert showAnimated:YES completionHandler:nil];
            
        }
        
        
    }
    
    
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
    
    KxMovieViewController *vc = [KxMovieViewController movieViewControllerWithContentPath:urlString parameters:parameters];
    
    vc.model = model;
    
    vc.delegate = self;
    
    if (self.isReplay) {
        
        vc.isReplay = YES;
        
    }
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(0, 0, 50, 44);
    
    UIImage *img = [UIImage imageNamed:@"consulation_btn_downarrow_white"];
    
    [_selectBtn setImage:img forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageWithCGImage:img.CGImage scale:2.0 orientation:UIImageOrientationDown] forState:UIControlStateSelected];
    
    [_selectBtn setTitle:@" 全部科室" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_selectBtn addTarget:self action:@selector(showOfficeSection) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _selectBtn;
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
#pragma mark - 选择科室按钮
/**
 显示科室选择View
 */
- (void)showOfficeSection
{
    
    //NSLog(@"%@",[(UIGestureRecognizer *)sender view]);
    
    [self getSectionOfficeDataFromNetWork];
    
    __weak typeof(self) weakSelf = self;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [weakSelf createSelectionView];
        
    });
    
    [self.view sendSubviewToBack:_pictureView];
    [self.view bringSubviewToFront:_selectionView];
    
    //NSLog(@"显示科室选择View");
    CGRect openFrame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    CGRect closeFrame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
    
    _selectBtn.selected = !_selectBtn.isSelected;
    
    if (_selectBtn.isSelected) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _selectionView.frame = openFrame;
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            _selectionView.frame = closeFrame;
        }];
    }
    
}

#define bgViewHeight 115

#define SOTBWidth 205
#define SOTBX (KScreenWidth - SOTBWidth)/2
#define SOTBHeight 320

- (void)createSelectionView
{
    
    
    
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight)];
    _selectionView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *hiddenView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOfficeSection)];
    hiddenView.delegate = self;
    [_selectionView addGestureRecognizer:hiddenView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
    //    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight)];
    //    bgIV.image = [UIImage imageNamed:@"back"];
    UIView *bgIV = [[UIView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight)];
    bgIV.backgroundColor = KRGBColor(17, 125, 138);
    
    self.sectionOfficeTB = [[UITableView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight) style:UITableViewStylePlain];
    self.sectionOfficeTB.backgroundColor = KRGBColor(17, 125, 138);
    
    self.sectionOfficeTB.layer.cornerRadius = 10;
    self.sectionOfficeTB.clipsToBounds = YES;
    self.sectionOfficeTB.bounces = NO;
    self.sectionOfficeTB.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.sectionOfficeTB.delegate = self;
    self.sectionOfficeTB.dataSource = self;
    
    
    [bgView addSubview:bgIV];
    [bgView addSubview:self.sectionOfficeTB];
    [_selectionView addSubview:bgView];
    [self.view addSubview:_selectionView];
    [self.view bringSubviewToFront:_selectionView];
    
    
}


- (CGFloat)widthBetweenSelectionViewButtons
{
    //iPhone 4,4s,5,5s
    if (KScreenWidth == 320) {
        return 0;
    }
    //iPhone 6
    else if (KScreenWidth == 375){
        return 20;
    }
    else {
        return 30;
    }
}

- (void)getSectionOfficeDataFromNetWork {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getSectionOfficeDataType:@"2" Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf.sectionOfficeDataSource removeAllObjects];
        
        [weakSelf dealWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"选择科室 error == %@",error);
        
    }];
    
}

- (void)dealWithJsonDict:(NSDictionary *)jsonDict {
    
    for (NSDictionary *obj in jsonDict[@"ds"]) {
        
        ZRTSelectModel *model = [ZRTSelectModel ModelWithDict:obj];
        
        [self.sectionOfficeDataSource addObject:model];
        
    }
    
    [self.sectionOfficeTB reloadData];
    
    
}

//点击手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        
        return NO;
    }
    else {
        
        return YES;
    }
    
    
}

//根据科室进行网络请求
- (void)selectSectionOffice {
    
    [self.todayView.legendFooter resetNoMoreData];
    
    [self.latestView.legendFooter resetNoMoreData];
    
    
    _selectSectionOffice = YES;

    
    if (_sectionOfficeRow == 0) {
        _selectSectionOffice = NO;
    }
    
    
//    [self.latestView.legendHeader beginRefreshing];
//    [self.todayView.legendHeader beginRefreshing];
    
    [self getVideoListWithIndexPage:1 andStrWhere:STRWHERE andBack:0];
    
    [self getHotVideoListWithIndexPage:1 andStrWhere:STRWHERE andBack:0];
    
    
}
#pragma mark - UITableViewDateSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionOfficeDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionOfficeCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SectionOfficeCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.sectionOfficeDataSource[indexPath.row] Title];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = KRGBColor(17, 125, 138);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [_selectBtn setTitle:[self.sectionOfficeDataSource[indexPath.row] Title] forState:UIControlStateNormal];
    _selectBtn.frame = CGRectMake(0, 0, [Helper widthOfString:_selectBtn.currentTitle font:[UIFont systemFontOfSize:14] height:44], 44);
    
    [self showOfficeSection];
    
    _sectionOfficeRow = indexPath.row;
    
    
    [self selectSectionOffice];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

#pragma mark - 网络请求

- (void)getVideoListWithIndexPage:(NSInteger )page andStrWhere:(NSString *)strwhere andBack:(BOOL)back {
    
    __weak typeof(self) weakSelf = self;
    
//    NSLog(@"%ld %@ ",page,strwhere);
    
    
    [[OZHNetWork sharedNetworkTools] getVideoDataWithIndexPage:page andStrWhere:strwhere andOrderBy:KNew andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        if (back) {
            
            [self makeModelWithDictionary:jsonDict];
        }
        else {
            
//            NSLog(@" 走没走");
            
            [self dealModelWithDict:jsonDict withNewOrHot:1];
        }
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"视屏列表 error == %@",error);
        //创建提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接错误" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            
            [weakSelf showNetWorkingWarning];
            
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [weakSelf getVideoListWithIndexPage:_newCurrentPage andStrWhere:STRWHERE  andBack:0];
            
        }];
        
        [alert addAction:cancle];
        
        [alert addAction:sure];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
        
    }];
    
}

- (void)getHotVideoListWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strwhere andBack:(BOOL)back
{
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"re %ld %@",(long)page,strwhere);
    
    
    [[OZHNetWork sharedNetworkTools] getVideoDataWithIndexPage:page andStrWhere:strwhere andOrderBy:KHot andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
//        NSLog(@"re %@",jsonDict);
        
        
        if (back) {
            
            [self makeModelWithDictionary:jsonDict];
        }
        else {
            [self dealModelWithDict:jsonDict withNewOrHot:0];
        }
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"视屏列表 error == %@",error);
        
        //                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接错误" preferredStyle:UIAlertControllerStyleAlert];
        //
        //                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        //                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //
        ////                    [weakSelf getVideoListWithIndexPage:page andStrWhere:strwhere andOrderBy:order];
        //                    [weakSelf getVideoListWithIndexPage:page andStrWhere:STRWHERE andOrderBy:KNew andBack:0];
        //
        //
        //
        //
        //                }];
        //
        //                [alert addAction:cancle];
        //                [alert addAction:sure];
        
        //  [weakSelf presentViewController:alert animated:YES completion:nil];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接错误" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//            
//            
//            [weakSelf showNetWorkingWarning];
//            
//        }];
//        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//            
//            [weakSelf getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:STRWHERE andBack:1];
//            
//        }];
//        
//        [alert addAction:cancle];
//        
//        [alert addAction:sure];
//        
//        [weakSelf presentViewController:alert animated:YES completion:nil];
//        
        [weakSelf showError];
    }];


}

- (void)showError{
    [MBProgressHUD showError:@"网络请求失败"];
    
    [self showNetWorkingWarning];
}

#pragma mark -- makeModel
- (void)makeModelWithDictionary:(NSDictionary *)jsonDict {
    
    
    if (self.latestView.header.isRefreshing) {
        
        if ([self.latestView.header isRefreshing]) {
            
            [self.NewDataSource removeAllObjects];
            
            [self.latestView.header endRefreshing];
       
        }

        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            
            // NSLog(@" %@",videoModel.Id);
            
            
            [self.NewDataSource addObject:videoModel];
            
        }
        
        //[videoNewTableView.legendFooter beginRefreshing];
        if (self.NewDataSource.count == 0) {
            
            [self.latestView.legendFooter noticeNoMoreData];
            
        }
        else {
            [self.latestView.legendFooter endRefreshing];
            
        }
        
        [self.latestView reloadData];
        
    }
    else if (self.todayView.header.isRefreshing) {
       
        if ([self.todayView.header isRefreshing]) {
            
            [self.HotDataSource removeAllObjects];
            
            [self.todayView.header endRefreshing];

        }
        
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            
            [self.HotDataSource addObject:videoModel];
            
        }
        
        //[videoHotTableView.legendFooter beginRefreshing];
        if (self.HotDataSource.count == 0) {
            
            [self.todayView.legendFooter noticeNoMoreData];
            
        }
        else {
            [self.todayView.legendFooter endRefreshing];
            
        }
        
        
        [self.todayView reloadData];
    }
    
    //上拉加载更多
    if (self.latestView.legendFooter.isRefreshing) {
        
        self.oldDataArray = [self.NewDataSource copy];
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            
            [self.NewDataSource addObject:videoModel];
        }
        
        
        
        
        if (self.oldDataArray.count == self.NewDataSource.count) {
            
            [self.latestView.legendFooter noticeNoMoreData];
            
        }
        else {
            [self.latestView.legendFooter endRefreshing];
            
            [self.latestView reloadData];
        }
        
    }
    else if (self.todayView.legendFooter.isRefreshing) {
        
        self.oldDataArray = [self.HotDataSource copy];
        
        
        
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            
//             NSLog(@" %@",videoModel.Id);

            
            [self.HotDataSource addObject:videoModel];
            
            
//            NSLog(@" %@",self.HotDataSource);
        }
        

        if (self.oldDataArray.count == self.HotDataSource.count) {
            
            [self.todayView.legendFooter noticeNoMoreData];
            
        }
        else {
            [self.todayView.legendFooter endRefreshing];
            
            [self.todayView reloadData];
        }
    }
    
}

#pragma mark - 刷新

- (void)setHeaderRefresh
{
    
    __weak typeof(self) weakSelf = self;
    
    //    if (NewBtn.isSelected) {
    [self.latestView addLegendHeaderWithRefreshingBlock:^{
        
        NSLog(@" NEW刷新");
        
        [weakSelf loadLatestDataWithNewOrHot:1];
    }];
    
    //[caseNewTableView.legendHeader beginRefreshing];
    //    }
    //    else if (HotBtn.isSelected) {
    [self.todayView addLegendHeaderWithRefreshingBlock:^{
        
         NSLog(@" HOT刷新");
        
        [weakSelf loadLatestDataWithNewOrHot:0];
    }];
    
    
}

- (void)setFooterRefresh
{

    
    __weak typeof(self) weakSelf = self;
    
    [self.latestView addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
    
    [self.todayView addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
    
    
    
    
}

/**
 上拉加载更多
 */
- (void)loadMoreData {

    if (self.latestBtn.isSelected) {
        
        if (!isAllUserLogin) {
            [self getVideoListWithIndexPage:++_newCurrentPage andStrWhere:NotLoginSTRWHERE andBack:1];

        }
        else {
            [self getVideoListWithIndexPage:++_newCurrentPage andStrWhere:STRWHERE andBack:1];
        }
        
    }
    else {
        if (!isAllUserLogin) {

            [self getHotVideoListWithIndexPage:++_hotCurrentPage andStrWhere:NotLoginSTRWHERE andBack:1];
        }
        else {

            [self getHotVideoListWithIndexPage:++_hotCurrentPage andStrWhere:STRWHERE andBack:1];
            
        }
    }
    
}

/**
 下拉刷新
 */
- (void)loadLatestDataWithNewOrHot:(BOOL)isNew {

    if (isNew) {
        
        _newCurrentPage = 1;
        
        if (!isAllUserLogin) {
            
            [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:NotLoginSTRWHERE andBack:1];
        }
        else {
            [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:STRWHERE andBack:1];
        }
    }else  {
        _hotCurrentPage = 1;
        
        if (!isAllUserLogin) {
            [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:NotLoginSTRWHERE andBack:1];
        }
        else {
            [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:STRWHERE andBack:1];
        }
    }
}

#pragma mark - 登录代理方法
- (void)doNetWorking {
#warning 代理方法有误
    [self getVideoListWithIndexPage:1 andStrWhere:STRWHERE andBack:1];
}



-(void)reloadDataAfterBack {
    
//    NSLog(@" 凭什么");
    
//    UIButton *NewBtn = (UIButton *)[self.view viewWithTag:100];
    
    if (self.latestBtn.isSelected) {
        _newCurrentPage = 1;
        
        [self getVideoListWithIndexPage:_newCurrentPage andStrWhere:STRWHERE andBack:0];
    }
    else {
        _hotCurrentPage = 1;
        
        [self getHotVideoListWithIndexPage:_hotCurrentPage andStrWhere:STRWHERE andBack:0];
    }
}
#pragma mark --dealModel
- (void)dealModelWithDict:(NSDictionary *)dict withNewOrHot:(BOOL)isNew{

    if (isNew) {
        [self.NewDataSource removeAllObjects];
        
        for (NSDictionary *dsDict in dict[@"ds"]) {
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            [self.NewDataSource addObject:videoModel];
            
        }
        
         NSLog(@"来");
        
        [self.latestView reloadData];
    }
    else {
        
        NSLog(@"来不来");
        
        [self.HotDataSource removeAllObjects];
        
        for (NSDictionary *dsDict in dict[@"ds"]) {
            
            ZRTVideoModel *videoModel = [ZRTVideoModel videoModelWithDict:dsDict];
            [self.HotDataSource addObject:videoModel];
            
        }
        
        [self.todayView reloadData];
    }
    
}



-(void)rePlayVideoPath:(NSString *)path AndModel:(ZRTVideoModel *)model isReplay:(BOOL)isreplay
{
    
    
    NSLog(@"怎么回事 %@ %@",path,model);
    
    
    self.isReplay = isreplay;
    
    [self playWithUrl:path WithModel:model];
    
    
    
}



- (void)showNetWorkingWarning {
    
    [self performSelector:@selector(stopMJRefresh) withObject:nil afterDelay:2.0];
    
    
}

- (void)stopMJRefresh {
    
    if (self.latestBtn.isSelected) {
        [self.latestView.header endRefreshing];
    }
    else {
        [self.todayView.header endRefreshing];
    }
    
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
