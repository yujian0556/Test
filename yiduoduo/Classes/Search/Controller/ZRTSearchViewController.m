//
//  ZRTSearchViewController.m
//  yiduoduo
//
//  Created by 余健 15/9/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSearchViewController.h"
#import "ZRTSearchBar.h"
#import "ZRTSearchCell.h"
#import "ZRTCaseModel.h"
#import "ZRTVideoModel.h"
#import "ZRTLoginViewController.h"
#import "ZRTDetailViewController.h"
#import "Interface.h"
#import "KxMovieViewController.h"
#import "AFNetworking.h"

@interface ZRTSearchViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ZRTLoginViewControllerDelegate,KxMovieViewControllerDelegate>



//搜索框
@property (nonatomic,strong) ZRTSearchBar *searchBar;

//两个btn所在的view
@property (nonatomic,strong) UIView *btnView;

//病例btn
@property (nonatomic,strong) UIButton *caseBtn;

//视频btn
@property (nonatomic,strong) UIButton *videoBtn;

//scrollView
@property (nonatomic,strong) UIScrollView *backGroundView;

//分隔条
@property (nonatomic,strong) UIView *fengeBtn;
//病例view
@property (nonatomic,strong) UITableView *caseView;
//视频view
@property (nonatomic,strong) UITableView *videoView;
//播放
@property (nonatomic,assign) BOOL isReplay;
//搜索文字
@property (nonatomic,copy) NSString *searchText;


@end


#warning reloaddata没搞定，视频放不出来,病例颜色没调

@implementation ZRTSearchViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self setNavgationBar];
    
    [self setUpHeadBtn];
    
    [self setUpContentSize];
    
}



//第二个界面的navgationBar
-(void)setNavgationBar
{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"search_top_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    
    
    //自定义的搜索框
    self.searchBar = [[ZRTSearchBar alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth*0.7, 30) WithColorNumber:2];
    
    self.searchBar.delegate = self;
    
    self.searchBar.text = self.searchTitle;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    
    // 左边:取消
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:KLineColor forState:UIControlStateNormal];
    //点击取消键执行back方法,    触摸的抬起事件
    [dismissBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    [dismissBtn sizeToFit];
    
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
    
    self.navigationItem.rightBarButtonItem = dismiss;

}


//返回的方法
- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_top_bg"] forBarMetrics:UIBarMetricsDefault];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];

}




#pragma mark 搜索框代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.searchBar resignFirstResponder];
    
    
    //    NSLog(@" %@",textField.text);
    
    self.searchText = textField.text;
    
    
    [self getNetWork];
    

    
    
    return YES;
}








#pragma mark 设置头部按钮

#define marginBtn 20
#define backColor KRGBColor(238,238,238)

-(void)setUpHeadBtn
{
    CGFloat btnH;
    if (IPHONE6P) {
        
        btnH = 60;
    }else{
        btnH = 50;
    }
    
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, btnH)];
    
    self.btnView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.btnView];

    
    CGFloat lineH = 20;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2, (self.btnView.height - lineH)/2, 1, lineH)];
    
    line.backgroundColor = KTimeColor;
    
    [self.btnView addSubview:line];
    
    
    
    self.caseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.y, 0, 0)];
    
    [self.caseBtn setTitle:@"病例" forState:UIControlStateNormal];
    [self.caseBtn setTitleColor:KTimeColor forState:UIControlStateNormal];
    [self.caseBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    self.caseBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [self.caseBtn addTarget:self action:@selector(didClickCaseBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.caseBtn sizeToFit];
    
    self.caseBtn.center = line.center;
    
    self.caseBtn.x = line.x - self.caseBtn.width - marginBtn;
    
    [self.btnView addSubview:self.caseBtn];
    
    self.caseBtn.selected = YES;
    
    
    
    self.videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, line.y, 0, 0)];
    
    [self.videoBtn setTitle:@"视频" forState:UIControlStateNormal];
    [self.videoBtn setTitleColor:KTimeColor forState:UIControlStateNormal];
    [self.videoBtn setTitleColor:KMainColor forState:UIControlStateSelected];
    self.videoBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [self.videoBtn addTarget:self action:@selector(didClickVideoBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.videoBtn sizeToFit];
    
    self.videoBtn.center = line.center;
    
    self.videoBtn.x = line.x + marginBtn;
    
    [self.btnView addSubview:self.videoBtn];
    
    
    
    self.fengeBtn = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btnView.frame), KScreenWidth, 10)];
    
    self.fengeBtn.backgroundColor = backColor;
    
    [self.view addSubview:self.fengeBtn];
    
    

}


#pragma mark 按钮点击事件

-(void)didClickCaseBtn
{

    self.backGroundView.contentOffset = CGPointMake(0, 0);

}


-(void)didClickVideoBtn
{


    self.backGroundView.contentOffset = CGPointMake(KScreenWidth, 0);

}




#pragma mark 设置滚动范围及列表

-(void)setUpContentSize
{

    CGFloat btnMaxY = CGRectGetMaxY(self.fengeBtn.frame);
    
    
    self.backGroundView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, btnMaxY, KScreenWidth, KScreenHeight - btnMaxY-64)];
    
    
    
    self.backGroundView.contentSize = CGSizeMake(KScreenWidth * 2, KScreenHeight - btnMaxY - 64);
    self.backGroundView.pagingEnabled = YES;

    self.backGroundView.directionalLockEnabled = YES;
    
    self.backGroundView.showsHorizontalScrollIndicator= NO;
    self.backGroundView.showsVerticalScrollIndicator = NO;
    
    self.backGroundView.delegate = self;
    
    [self.view addSubview:self.backGroundView];
    
    
    
    
    self.caseView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, self.backGroundView.height)];
    
    self.caseView.delegate = self;
    self.caseView.dataSource = self;
    
    //cell之间的分割线
    self.caseView.separatorStyle = NO;
    
    [self.backGroundView addSubview:self.caseView];
    
    
    
    self.videoView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth, 0, KScreenWidth, self.backGroundView.height)];
    
    self.videoView.delegate = self;
    self.videoView.dataSource = self;
    self.videoView.separatorStyle = NO;

    
    [self.backGroundView addSubview:self.videoView];
    

}

#pragma mark scrollview代理方法


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 得到每页宽度
    
    CGFloat pageWidth = scrollView.width;

    
    // 根据当前的x坐标和页宽度计算出当前页数

    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    
    if (page == 0) {
        
        self.caseBtn.selected = YES;
        self.videoBtn.selected = NO;
        
    }else{
    
        self.videoBtn.selected = YES;
        self.caseBtn.selected = NO;
    }

    
    [self.searchBar resignFirstResponder];
    

}







#pragma mark tableview数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.caseView) {
        
        return self.caseModel.count;
    }else{
    
        return self.videoModel.count;
    }

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (tableView == self.caseView) {
        
        ZRTSearchCell *cell = [ZRTSearchCell cellWithTableView:tableView];
        
        cell.caseModel = self.caseModel[indexPath.row];
        
        [cell setAllView];
        
        return cell;
        
    }else{
    
        ZRTSearchCell *cell = [ZRTSearchCell cellWithTableView:tableView];
        
        cell.videoModel = self.videoModel[indexPath.row];

        [cell setAllView];

        
        return cell;
    
    }



    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (IPHONE6P) {
        
        return 115;
        
    }else{
    
        return 95;
    
    }
    

}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!isAllUserLogin) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录，现在去登录~" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            ZRTLoginViewController * lvc = [[ZRTLoginViewController alloc] init];
            
            lvc.delegate = self;
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:lvc animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
        }];
        
        [alert addAction:cancle];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{ // 已登录
    
        
        if (tableView == self.caseView) {
            
            
            ZRTCaseModel *caseModel = self.caseModel[indexPath.row];
            
            ZRTDetailViewController *detail = [[ZRTDetailViewController alloc] init];
            
            detail.isSearch = YES;
            detail.model = caseModel;
            
            [self setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"home_top_bg"] forBarMetrics:UIBarMetricsDefault];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
            
          
            
            [self.navigationController pushViewController:detail animated:YES];

            
            [self setHidesBottomBarWhenPushed:NO];
            
           
            
        }else{
            
            
            ZRTVideoModel *videoModel = self.videoModel[indexPath.row];
            
         
            
            NSString *urlString = [NSString stringWithFormat:@"%@upload/%@",KMainInterface,videoModel.VideoPath];
            
            NSLog( @"VideoUrl %@",urlString);
            
            
            [self playWithUrl:urlString WithModel:videoModel];

        
        
    
        }

    
    }


}






#pragma mark 传递模型


-(void)setCaseModel:(NSMutableArray *)caseModel
{
    _caseModel = caseModel;

    [self.caseView reloadData];
    
//    NSLog(@" %@",caseModel);

}



-(void)setVideoModel:(NSMutableArray *)videoModel
{
    _videoModel = videoModel;

    [self.videoView reloadData];
    
//    NSLog(@" %@",videoModel);
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
        
    }
   
    
    [self presentViewController:vc animated:YES completion:nil];
    
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
        
        
        self.caseModel = caseArray;
        self.videoModel = videoArray;
        
        [self.caseView reloadData];
        [self.videoView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"搜索error %@",error);
        
    }];
    
}



@end
