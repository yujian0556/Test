//
//  ZRTCaseViewController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCaseViewController.h"

#import "SDCycleScrollView.h"

#import "ZRTDetailViewController.h"
#import "ZRTCaseTableViewCell.h"
#import "ZRTCaseHeadView.h"
#import "ZRTCaseModel.h"
#import "MJRefresh.h"

#import "Helper.h"

#import "ZRTLoginViewController.h"

#import "ZRTSelectModel.h"
#import "LGAlertView.h"
#import "ZRTBannerView.h"
#import "AFNetworking.h"
#import "ZRTRZViewController.h"


#define KImageScrollViewMaxY KScreenWidth/840*350
#define KTwoBtnViewMaxY KImageScrollViewMaxY


#define KNew @"addTime desc"
#define KHot @"click desc"


//静止的
static NSString *CaseCellReuseIdentifier = @"CaseCell";

@interface ZRTCaseViewController () <SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,ZRTLoginViewControllerDelegate,UIGestureRecognizerDelegate,ZRTDetailViewControllerDelegate>

//@property (nonatomic,strong) UIScrollView *caseScrollView;

//最新推荐数据来源
@property (nonatomic,strong) NSMutableArray *NewDataSource;
//今日热榜数据来源
@property (nonatomic,strong) NSMutableArray *HotDataSource;
//重新开始的数据来源
@property (nonatomic,strong) NSMutableArray *RecommendDataSource;
//病例里面的数据来源
@property (nonatomic,strong) NSMutableArray *sectionOfficeDataSource;

@property (nonatomic,strong) NSArray *oldDataArray;
//病例里面的tableView
@property (nonatomic,strong) UITableView *sectionOfficeTB;

@property (nonatomic,strong) UIView *twoBtnView;
@property (nonatomic,strong) UIButton *hotBtn;
@property (nonatomic,strong) UIButton *recommendBtn;
@property (nonatomic,strong) UIView *partView;
@property (nonatomic,strong) UIScrollView *backView;
@property (nonatomic,strong) UITableView *hotView;
@property (nonatomic,strong) UITableView *recommendView;
@property (nonatomic,strong) UITabBar *tabbar;



@property (nonatomic,assign) BOOL isHotRefresh;

@end




@implementation ZRTCaseViewController
{
    UIView *_selectionView;
    UIButton *_selectBtn;
    SDCycleScrollView *_pictureView;
    
    //最新推荐页
    NSInteger _newCurrentPage;
    //今日热榜页
    NSInteger _hotCurrentPage;
    
    //当前页 
    NSInteger _currentTag;
    
    
    CGFloat _scCenterX;
    
    BOOL _selectSectionOffice;
    NSInteger _sectionOfficeRow;
    
    
    BOOL _huadong;
    //横着的数据
    NSMutableArray *_bannerArray;
    
}

#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    
    return NO;
}

// 不隐藏状态栏
-(BOOL)prefersStatusBarHidden
{
    return NO;
}



-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    //返回横幅
    [self getBanner];
    
   
    if (_selectBtn.isSelected) {
        //图片轮播器  移动指定的子视图到它相邻视图的后面

        [self.view sendSubviewToBack:_pictureView];
        //病例下拉栏  把指定的子视图移动到顶端
        [self.view bringSubviewToFront:_selectionView];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteWithReload) name:@"deleteWithReload" object:nil];
    
    
    
}


-(void)deleteWithReload
{
    NSLog(@" 删除了 ");
    
        [self getCaseListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
        //   NSLog(@"44455");
        
        [self getHotListNewWithstartPage:1 andstrwhere: STRWHERE andBack:0];
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createArray];
    
    //最新推荐显示
 //   [self setTwoBtn];
  
    //显示两个Btn
    [self setTwoBtn];
    

    
    //今日热榜显示
    [self createSelectionView];
 
    //热门收藏,已取消
    [self setUpContentSize];
    
    //设置navgationBar<病例>
    [self setNavgationBar];
    
    
    if (!isAllUserLogin) {
        
        NSLog(@" load1");

        _huadong = YES;
        
        //网络请求的方法

        
        [self getCaseListNewWithstartPage:1 andstrwhere:NotLoginSTRWHERE andBack:0];
        [self getHotListNewWithstartPage:1 andstrwhere:NotLoginSTRWHERE andBack:0];
      

    }
    else {
        _huadong = YES;
         NSLog(@" load2");

        
        [self getCaseListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
     //   NSLog(@"44455");

        [self getHotListNewWithstartPage:1 andstrwhere: STRWHERE andBack:0];
 


        
    }
//    //更新header
    [self setHeaderRefresh];
//    //更新footer
    [self setFooterRefresh];
    
    
    //NSLog(@"   %ld   ",self.tabBarController.selectedIndex);
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_selectBtn.selected) {
        
        CGRect closeFrame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
        _selectionView.frame = closeFrame;
        _selectBtn.selected = NO;
        
    }
    

}




- (void)createArray {
    
    _newCurrentPage = 1;
    _hotCurrentPage = 1;
    
    _selectSectionOffice = NO;
    
    //创建数据来源
    self.NewDataSource = [[NSMutableArray alloc] init];
    self.HotDataSource = [[NSMutableArray alloc] init];
    self.RecommendDataSource = [[NSMutableArray alloc] init];
    self.sectionOfficeDataSource = [[NSMutableArray alloc] init];

}

#pragma mark - 图片轮播器
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
}

#pragma mark - 点击轮播图
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


#define marginBtn 20
- (void)setTwoBtn
{
    CGFloat btnH;
    if (IPHONE6P) {
        
        btnH = 50;
    }else{
        btnH = 30;
    }
    
    
    self.twoBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, KTwoBtnViewMaxY, KScreenWidth, btnH)];
    
    self.twoBtnView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.twoBtnView];
    
    
    CGFloat lineH = 20;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, (self.twoBtnView.height - lineH)/2, 1, lineH)];
    
    line.backgroundColor = KTimeColor;
    
    [self.twoBtnView addSubview:line];
    
    
    
    self.recommendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.y, 0, 0)];
    
    [self.recommendBtn setTitle:@"最新推荐" forState:UIControlStateNormal];
    //设置正常状态文字颜色
    [self.recommendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //设置选中状态颜色
    [self.recommendBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    self.recommendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [self.recommendBtn addTarget:self action:@selector(didClickRecommendBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.recommendBtn sizeToFit];
    
    self.recommendBtn.center = line.center;
    
    self.recommendBtn.x = line.x - self.recommendBtn.width - marginBtn;
    
    [self.twoBtnView addSubview:self.recommendBtn];
    
    self.recommendBtn.selected = YES;
    
    
    
    self.hotBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.y, 0, 0)];
    
    [self.hotBtn setTitle:@"今日最热" forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
    [self.hotBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    self.hotBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [self.hotBtn addTarget:self action:@selector(didClickHotBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.hotBtn sizeToFit];
    
    self.hotBtn.center = line.center;
    
    self.hotBtn.x = line.x + marginBtn;
    
    [self.twoBtnView addSubview:self.hotBtn];
    
    self.partView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.twoBtnView.frame), KScreenWidth, 10)];


    self.partView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.partView];
    
    
    
}


/**
 设置按钮,按钮添加点击事件
 */
#define KButtonConunt 2
//最新推荐和今日热榜
- (void)didClickRecommendBtn{
    
    self.backView.contentOffset = CGPointMake(0, 0);

//    NSLog(@"222");
}

- (void)didClickHotBtn{
    
    self.backView.contentOffset = CGPointMake(KScreenWidth, 0);

//    NSLog(@"11111");
    
}

#pragma mark 设置滚动的范围
-(void)setUpContentSize
{
    
    CGFloat btnMaxY = CGRectGetMaxY(self.partView.frame);
    
    
    self.backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, btnMaxY, KScreenWidth, KScreenHeight - btnMaxY-64-44)];
    
    
    
    self.backView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - btnMaxY - 64 - 44);
    self.backView.pagingEnabled = YES;
    
    self.backView.directionalLockEnabled = YES;
    
    self.backView.showsHorizontalScrollIndicator= NO;
    self.backView.showsVerticalScrollIndicator = NO;
    
    self.backView.delegate = self;
    
    [self.view addSubview:self.backView];
    
    
    
    
    self.recommendView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.backView.height)];
    
    self.recommendView.delegate = self;
    self.recommendView.dataSource = self;
    
    //cell之间的分割线
    self.recommendView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.backView addSubview:self.recommendView];
    
    
    
    self.hotView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, self.backView.height)];
    
    self.hotView.delegate = self;
    self.hotView.dataSource = self;
    self.hotView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.backView addSubview:self.hotView];
    
    
}

#pragma mark scrollView的代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 得到每页宽度
    
    CGFloat pageWidth = scrollView.width;
    
    
    // 根据当前的x坐标和页宽度计算出当前页数
    
    int page = floor((self.backView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    
    if (page == 0) {
        
        NSLog(@"新");
        
        self.recommendBtn.selected = YES;
        self.hotBtn.selected = NO;

        
       
        
    }else{
        
        NSLog(@"热");
        
        self.hotBtn.selected = YES;
        self.recommendBtn.selected = NO;
        


    }
    
    
 //   [self.searchBar resignFirstResponder];
    
    
}


#pragma mark tableview数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.sectionOfficeTB) {
        
        return self.sectionOfficeDataSource.count;
    
    }else if (tableView == self.recommendView) {
        
//        NSLog(@"xin %ld",self.NewDataSource.count);
        return self.NewDataSource.count;
        
        
    }else{
        
//        NSLog(@" jiu %ld",self.NewDataSource.count);
        
        
        return self.HotDataSource.count;
    }
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //当前页面为病例页面的时候,新建一个cell,返回病例的行数,否则返回书品的行数
    if (tableView == self.sectionOfficeTB) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionOfficeCell"];
        
        for (UIView *obj in cell.contentView.subviews) {
            [obj removeFromSuperview];
        }
        
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
    
    }else if (tableView == self.recommendView) {
        
        ZRTCaseTableViewCell *cell = [ZRTCaseTableViewCell cellWithTableView:tableView];
        
        cell.caseModel = self.NewDataSource[indexPath.row];
        
        [cell setAllView];
        
        return cell;
        
    }else{
        
        ZRTCaseTableViewCell *cell = [ZRTCaseTableViewCell cellWithTableView:tableView];
        
        
//        NSLog(@"hot %@",self.HotDataSource );
        
        cell.caseModel = self.HotDataSource[indexPath.row];
        
        [cell setAllView];
        
        return cell;

    }

}
    

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.sectionOfficeTB == tableView) {
        
        return 44.0;
    
    }else if (IPHONE6P) {
        
        return 100;
        
    }else{
        
        return 80;
        
    }
    
    
}



//点击cell的时候会提示
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == self.sectionOfficeTB) {
        
        [_selectBtn setTitle:[self.sectionOfficeDataSource[indexPath.row] Title] forState:UIControlStateNormal];
        _selectBtn.frame = CGRectMake(0, 0, [Helper widthOfString:_selectBtn.currentTitle font:[UIFont systemFontOfSize:14] height:44], 44);
        
        [self showOfficeSection];
        
        _sectionOfficeRow = indexPath.row;
        
        
        
        [self selectSectionOffice];
        
    }
    else {
        
        if (!isAllUserLogin) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录，现在就去登录吧~" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                ZRTLoginViewController *lVC = [[ZRTLoginViewController alloc] init];
                
                lVC.delegate = self;
                
                
                //跳转前隐藏tableBar
                self.hidesBottomBarWhenPushed = YES;
                
                [self.navigationController pushViewController:lVC animated:YES];
                
                //跳转后不隐藏tableBar(跳转回之前的界面)
                self.hidesBottomBarWhenPushed = NO;
                
            }];
            
            
            //提示
            [alert addAction:cancle];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            //偏好设置
            NSDictionary *dict = [DEFAULT objectForKey:@"UserDict"];
            
            NSString *status = dict[@"Status"];
            
            //            NSLog(@"status %@",status);
            
            if ([status isEqualToString:@"2"]) {
                
                ZRTDetailViewController *detail = [[ZRTDetailViewController alloc] init];
                
                detail.isSearch = NO;
                detail.delegate = self;
                
                [self setHidesBottomBarWhenPushed:YES];
                
                // [self.navigationController setNavigationBarHidden:YES animated:YES];
                
                if (self.hotBtn.isSelected) {
                    
                    detail.model = self.HotDataSource[indexPath.row];
                    // head.model = self.HotDataSource[indexPath.row];
                    
                }
                else if (self.recommendBtn.isSelected) {
                    
                    detail.model = self.NewDataSource[indexPath.row];
                    // head.model = self.NewDataSource[indexPath.row];
                }
                else {
                    
                }
                
                
                [self.navigationController pushViewController:detail animated:YES];
                
                
                [self setHidesBottomBarWhenPushed:NO];
                
                
            }else{
                
//                LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"请先进行医生认证" buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:@"认证" actionHandler:nil cancelHandler:nil destructiveHandler:nil];
                
                
                
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

#pragma mark  --上下拉刷新
- (void)loadMoreData {
    //NSLog(@"loadMoreData");
    
    if (self.recommendBtn.isSelected) {
      
        _newCurrentPage += 1;
        
        if (!isAllUserLogin) {
            
            NSLog(@" 加载最新1");
            
            [self getCaseListNewWithstartPage:_newCurrentPage andstrwhere:NotLoginSTRWHERE andBack:1];
        }
        else {
            
             NSLog(@" 加载最新2");
            
           [self getCaseListNewWithstartPage:_newCurrentPage andstrwhere:STRWHERE andBack:1];
        }
        
    }
    else if (self.hotBtn.isSelected) {
        
        _hotCurrentPage += 1;
        
        if (!isAllUserLogin) {
            
            NSLog(@" 加载最热1");
            
            [self getHotListNewWithstartPage:_hotCurrentPage andstrwhere:NotLoginSTRWHERE andBack:1];
        }
        else {
            
            NSLog(@" 加载最热2");
            
           [self getHotListNewWithstartPage:_hotCurrentPage andstrwhere:STRWHERE andBack:1];
        }

    }
    
}
/**
 下拉刷新
 */
- (void)loadNewDatawithNeworHot:(BOOL)isNew{
//    NSLog(@"loadNewData");

    if (isNew) {
        
        
        NSLog(@"最新最新");
        
        _newCurrentPage = 1;
        if (!isAllUserLogin) {
            
            NSLog(@" 下拉最新1");
            
            _huadong = YES;
            

            [self getCaseListNewWithstartPage:1 andstrwhere:NotLoginSTRWHERE andBack:1];
        
        }else {
            
            _huadong = YES;
            
            NSLog(@" 下拉最新2");
            
            [self getCaseListNewWithstartPage:1 andstrwhere:STRWHERE andBack:1];
        }
    
    }else {
        
        //NSLog(@"最热最热");
        
        _hotCurrentPage = 1;
        
        if (!isAllUserLogin) {
            
            NSLog(@" 下拉最热1");
            
            [self getHotListNewWithstartPage:1 andstrwhere:NotLoginSTRWHERE andBack:1];
        }
        else {
            
           NSLog(@" 下拉最热2");
            
            [self getHotListNewWithstartPage:1 andstrwhere:STRWHERE andBack:1];
        }
    }
    
}
#pragma mark - 选择科室按钮
/**
 显示科室选择View
 */
- (void)showOfficeSection
{
    
    //NSLog(@"%@",[(UIGestureRecognizer *)sender view]);
    
    [self getSectionOfficeDataFromNetWork];
    
    NSLog(@"213123");
    __weak typeof(self) weakSelf = self;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [weakSelf createSelectionView];
        
    });
    
    [self.view sendSubviewToBack:_pictureView];
   
    [self.view bringSubviewToFront:_selectionView];
    
    //NSLog(@"显示科室选择View");
    CGRect openFrame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    
    //当病例的下拉栏出现的时候,下拉栏其实是在一个与界面相同大小的view上
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
    
    //showOfficeSection使用动画
    UITapGestureRecognizer *hiddenView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOfficeSection)];
    
    hiddenView.delegate = self;
   
    [_selectionView addGestureRecognizer:hiddenView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
    UIView *bgIV = [[UIView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight)];
    bgIV.backgroundColor = KRGBColor(17, 125, 138);
    
    self.sectionOfficeTB = [[UITableView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight) style:UITableViewStylePlain];
    
    self.sectionOfficeTB.backgroundColor = KRGBColor(17, 125, 138);
    
    //加圆角
    self.sectionOfficeTB.layer.cornerRadius = 10;
    
    //修剪边界
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
    
    }else {
    
        return 30;
    }
}

- (void)getSectionOfficeDataFromNetWork {
    
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"444444");
    
    [[OZHNetWork sharedNetworkTools] getSectionOfficeDataType:@"1" Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf.sectionOfficeDataSource removeAllObjects];
        
        [weakSelf dealWithJsonDict:jsonDict];
        
      //   NSLog(@"  %@",jsonDict);
       
        NSLog(@" qwewq");
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        //NSLog(@"选择科室 error == %@",error);
        
    }];
    
}

- (void)dealWithJsonDict:(NSDictionary *)jsonDict {
    
    for (NSDictionary *obj in jsonDict[@"ds"]) {
        
        ZRTSelectModel *model = [ZRTSelectModel ModelWithDict:obj];
     
//        NSLog(@" new   %@",model);
        
        [self.sectionOfficeDataSource addObject:model];
        
        
    }
    
    [self.sectionOfficeTB reloadData];
    
    
}

//点击手势代理方法

//当点击了病例出现了下拉栏的时候,再点击屏幕中除去下拉栏的位置,下拉栏会收起
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
     //NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        
        return NO;

    }else {
       
        return YES;

    }

    
}

//根据科室进行网络请求
- (void)selectSectionOffice {
    
    
    
    // 所有数据加载完毕，没有更多的数据了
    [self.recommendView.legendFooter resetNoMoreData];
    [self.hotView.legendFooter resetNoMoreData];
    
    _selectSectionOffice = YES;

    
    if (_sectionOfficeRow == 0)
    {
        _selectSectionOffice = NO;
    }

    [self getCaseListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
    
    [self getHotListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
  
}

#pragma mark - 网络请求

-(void)getCaseListNewWithstartPage:(NSInteger)start andstrwhere:(NSString *)strwhere andBack:(BOOL)back
{
    __weak typeof(self) weakSelf = self;
    
                      //网络请求控制器
        [[OZHNetWork sharedNetworkTools] getCaseDataWithOrderBy:KNew andStartCount:start andStrWhere:strwhere andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
    
            NSLog(@"back_New  %ld,%@",(long)start,strwhere);
    
            if (back) {
                
                [weakSelf makeModelWithDictionary:jsonDict];
            
            }else {
                
                [weakSelf dealModelWithDict:jsonDict withNewOrHot:1];
            }
    
    
    
        } andFailure:^(OZHNetWork *manager, NSError *error) {
    
            //NSLog(@"获取病例列表 error == %@",error);
    
    
            //创建提示框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接错误" preferredStyle:UIAlertControllerStyleAlert];
    
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                     
                [weakSelf showNetWorkingWarning];
                
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    
                [weakSelf getCaseListNewWithstartPage:start andstrwhere:strwhere andBack:1];
    
            }];
    
            [alert addAction:cancle];
            
            [alert addAction:sure];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
        }];


}

-(void)getHotListNewWithstartPage:(NSInteger)reverse andstrwhere:(NSString *)strwhere andBack:(BOOL)back
{
    
    __weak typeof(self) weakSelf = self;
    
    //网络请求控制器
    [[OZHNetWork sharedNetworkTools] getCaseDataWithOrderBy:KHot andStartCount:reverse andStrWhere:strwhere andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        
        if (back) {
            
            [weakSelf makeModelWithDictionary:jsonDict];
       
        }else {
            
            [weakSelf dealModelWithDict:jsonDict withNewOrHot:0];
        
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        //NSLog(@"获取病例列表 error == %@",error);
        
        
        //创建提示框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"网络连接错误" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancle    = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {


            [weakSelf showNetWorkingWarning];

        }];
        UIAlertAction *sure      = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            [weakSelf getHotListNewWithstartPage:reverse andstrwhere:strwhere andBack:1];

        }];

        [alert addAction:cancle];

        [alert addAction:sure];

        [weakSelf presentViewController:alert animated:YES completion:nil];

    }];
    
    
}


- (void)makeModelWithDictionary:(NSDictionary *)jsonDict
{
    if (self.recommendView.header.isRefreshing) {
        
        //正在刷新中的状态
        if ([self.recommendView.header isRefreshing])
        
        {
            //移除所有数据
            [self.NewDataSource removeAllObjects];
          
            [self.recommendView.header endRefreshing];
        }
    
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
            //            NSLog(@"一 %@",caseModel.YWTitle);
            [self.NewDataSource addObject:caseModel];
        }
        

        if (self.NewDataSource.count == 0) {
            
            [self.recommendView.legendFooter noticeNoMoreData];
            
        }else {
            
            //普通闲置状态
            [self.recommendView.legendFooter endRefreshing];
 
        }
        
        [self.recommendView reloadData];
        
        //NSLog(@"new -->");
    }else if (self.hotView.header.isRefreshing) {
        
        if ([self.hotView.header isRefreshing])
     
        {
            
            [self.HotDataSource removeAllObjects];
            
            [self.hotView.header endRefreshing];
      
        }
        
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
                     //   NSLog(@"一热 %@",caseModel.YWTitle);
            
            [self.HotDataSource addObject:caseModel];
      
        }

        if (self.HotDataSource.count == 0) {
            
            [self.hotView.legendFooter noticeNoMoreData];
            
        }else {
           
            [self.hotView.legendFooter endRefreshing];
            
        }
       
        [self.hotView reloadData];
        
//        self.hotBtn.selected = YES;
//        self.recommendBtn.selected = NO;
        
        //NSLog(@"hot -->");
    }
    
    
    //上拉加载更多
    if (self.recommendView.legendFooter.isRefreshing) {
        
        self.oldDataArray = [self.NewDataSource copy];
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
            [self.NewDataSource addObject:caseModel];
        }
        
        
        
        
        if (self.oldDataArray.count == self.NewDataSource.count) {
            
            [self.recommendView.legendFooter noticeNoMoreData];
            
        }else {
            
            [self.recommendView.legendFooter endRefreshing];
            
            [self.recommendView reloadData];
        }
        
        //NSLog(@"new footer");
    }else if (self.hotView.legendFooter.isRefreshing) {
        
        self.oldDataArray = [self.HotDataSource copy];
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
            [self.HotDataSource addObject:caseModel];
        }
        
        if (self.oldDataArray.count == self.HotDataSource.count) {
            
            [self.hotView.legendFooter noticeNoMoreData];
            
        }
        else {
            [self.hotView.legendFooter endRefreshing];
            
            [self.hotView reloadData];
        }
        
        //NSLog(@"hot footer");
    }
    
    
    //选择科室刷新

    
}

- (void)dealModelWithDict:(NSDictionary *)dict withNewOrHot:(BOOL)isNew
{
    
    if (isNew) {
        //NSLog(@"new");
        [self.NewDataSource removeAllObjects];
        
        for (NSDictionary *dsDict in dict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
            if (_huadong) {
                
                [self.NewDataSource addObject:caseModel];
                
            }
            
            //            NSLog(@"二 %@",caseModel.YWTitle);
        }
        
        [self.recommendView reloadData];
    
    }else {
        //NSLog(@"hot");
        [self.HotDataSource removeAllObjects];
        
        for (NSDictionary *dsDict in dict[@"ds"]) {
            
            ZRTCaseModel *caseModel = [ZRTCaseModel caseModelWithDict:dsDict];
            
            //             NSLog(@"二 热 %@",caseModel.YWTitle);
            
            [self.HotDataSource addObject:caseModel];
        }
        
        [self.hotView reloadData];
    }

}

- (void)showNetWorkingWarning {
    
    [self performSelector:@selector(stopMJRefresh) withObject:nil afterDelay:2.0];
    
}

- (void)stopMJRefresh {
    
    if (self.recommendBtn.isSelected) {
  
        [self.recommendView.header endRefreshing];
  
    }else {
        
        [self.hotView.header endRefreshing];
    }
    
}

#pragma mark - MJRefresh
- (void)setHeaderRefresh
{

    __weak typeof(self) weakSelf = self;


        [self.recommendView addLegendHeaderWithRefreshingBlock:^{

            //NSLog(@" 开始刷");

            [weakSelf loadNewDatawithNeworHot:1];
        }];

    [self.hotView addLegendHeaderWithRefreshingBlock:^{

            NSLog(@" 开始刷热榜");

            [weakSelf loadNewDatawithNeworHot:0];
        }];

}

- (void)setFooterRefresh
{

    __weak typeof(self) weakSelf = self;
    
    
    [self.recommendView addLegendFooterWithRefreshingBlock:^{
        
        NSLog(@"上拉刷新最新");
        
        [weakSelf loadMoreData];
    }];
    
    
    [self.hotView addLegendFooterWithRefreshingBlock:^{
        
        
        NSLog(@"上拉刷新最热");
        
        [weakSelf loadMoreData];
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

//返回刷表
- (void)reloadDataAfterBack {
    
    if (self.recommendBtn.isSelected) {
     
        _newCurrentPage = 1;
     
        [self getCaseListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
     
     }else {
     
         _hotCurrentPage = 1;
     
         [self getHotListNewWithstartPage:1 andstrwhere:STRWHERE andBack:0];
     
     }
    
}


@end
