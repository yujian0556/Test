//
//  ZRTNewsCollectionController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTNewsCollectionController.h"
#import "ZRTNewsCollectionCell.h"
#import "ZRTNewsModel.h"
#import "ZRTNewsDetailController.h"
#import "MJRefresh.h"
#import "OZHNetWork.h"
#import "MBProgressHUD+MJ.h"


#define KNews @"add_Time desc"

@interface ZRTNewsCollectionController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZRTNewsCollectionCellDelegate>


@property (nonatomic,strong) NSMutableArray *newsList;

@property(nonatomic ,strong)UIImageView *backView;

// 判断设备型号
@property (nonatomic,assign) CGSize size;

@property (nonatomic,assign) NSInteger page;





@end

@implementation ZRTNewsCollectionController




//隐藏状态栏
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

-(instancetype)init
{
    if (self = [super init]) {
        
        self.newsList = [[NSMutableArray alloc] init];
        
    }
    


    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self setUpNavBar];
    
    
    
   
}


-(void)setUpNavBar
{

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];

}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
        
    
    //设置视图的范围
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:flowLayout];
    
    if (KScreenHeight == 480) {  // 4s
        
        
        self.size = CGSizeMake(self.view.width, self.view.height + 150);
        
    }else if (KScreenHeight == 568){  // 5s
    
        self.size = CGSizeMake(self.view.width, self.view.height + 50);
    
    }else if (KScreenHeight == 667){  // 6
    
        self.size = self.view.bounds.size;
    
    }else{  // 6p
    
    
        self.size = CGSizeMake(self.view.width, self.view.height - 50);
        
    }
    
        
    flowLayout.itemSize = self.size ;
    //设置视图item之间的间隙
    flowLayout.minimumInteritemSpacing = 0.0;
    //设置长间距为0
    flowLayout.minimumLineSpacing = 0.0;
    //设置滚动方向为垂直滚动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
   // [self.collectionView setContentOffset:CGPointMake(0, 667) animated:YES];
    
    
    //设置分页
    self.collectionView.pagingEnabled = NO;
    //设置水平滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //设置垂直滚动条
    self.collectionView.showsVerticalScrollIndicator = NO;
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ZRTNewsCollectionCell class] forCellWithReuseIdentifier:@"news"];
    
    
    

    
    
    self.page = 1;
    
    

        
    [self getNewsListWithIndexPage:1 andStrWhere:@"" andOrderBy:KNews];
    

    
    
    [self setHeaderRefresh];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDataSource>

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete method implementation -- Return the number of items in the section
    
   
    
    return self.newsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify = @"news";
    
    
   // ZRTNewsModel *model = [ZRTNewsModel newsModelWithDict:self.newsList[indexPath.row]];
    
    
    //  //NSLog(@"%@ ",model);
    
    
    
    ZRTNewsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.model = self.newsList[indexPath.row];
    
    
    
    
    //    for (id obj in cell.subviews) {
    //
    //        if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
    //
    //        {
    //
    //            UIScrollView *scroll = (UIScrollView *) obj;
    //
    //            scroll.delaysContentTouches =NO;
    //
    //            break;
    //
    //        }
    //
    //    }
    
    
    
    
    [cell sizeToFit];
    
    if (!cell) {
        
        
        //NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
        
    }
    
    //    cell.imgView.image = [UIImage imageNamed:@"cat.png"];
    //    cell.text.text = [NSString stringWithFormat:@"Cell %ld",indexPath.row];
    
    return cell;
    
    
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor redColor];
    //NSLog(@"选择%ld",indexPath.row);
    
    //    UICollectionViewCell *cell = [self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    //
    //
    //    //NSLog(@"cell %@",cell.subviews);
    //
    //
    //    for (UIImageView *imageView in cell.subviews) {
    //
    //        //NSLog(@"iamge %@",imageView.subviews);
    //
    //    }
    
    
    
    
}

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

#pragma mark 点击详情的代理方法

-(void)didClickHeadView:(ZRTNewsCellModel *)model
{
    
    //   //NSLog(@"head %@",tap.view);
    
  //  //NSLog(@"array %@",model.head);
    
    ZRTNewsDetailController *detail = [[ZRTNewsDetailController alloc] init];

    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    
   
    detail.model = model;
    
    
    
    
   
    
    
}


-(void)didClickCell1:(ZRTNewsCellModel *)model
{
 

    
    ZRTNewsDetailController *detail = [[ZRTNewsDetailController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
    detail.model = model;
    
    
    
    
}


-(void)didClickCell2:(ZRTNewsCellModel *)model
{
    
   
    
    ZRTNewsDetailController *detail = [[ZRTNewsDetailController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
    detail.model = model;
    
    
}


-(void)didClickCell3:(ZRTNewsCellModel *)model
{
    
   
    
    ZRTNewsDetailController *detail = [[ZRTNewsDetailController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
    detail.model = model;
    
    
}



#pragma mark 处理新闻网络
- (void)getNewsListWithIndexPage:(NSInteger)page andStrWhere:(NSString *)strwhere andOrderBy:(NSString *)order {
   
    
    
   
        
        [[OZHNetWork sharedNetworkTools] getNewsDataWithIndexPage:page andStrWhere:strwhere andOrderBy:order andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            if (jsonDict == NULL) {
                
                return ;
            }
            
            
            
            [self makeModelWithDictionary:jsonDict];
            NSLog(@"%@",jsonDict);
            
            
            [self.collectionView.footer endRefreshing];
            
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
          //  //NSLog(@"news %@",error);
            
            [MBProgressHUD showError:@"网络连接失败"];
            
            
            [self.collectionView.footer endRefreshing];
    
            
        }];
  
    
    
}



- (void)makeModelWithDictionary:(NSDictionary *)jsonDict
{

    ZRTNewsModel *model = [ZRTNewsModel newsModelWithDict:jsonDict];
    
    
    [self.newsList addObject:model];

    //NSLog(@"123 %ld",self.newsList.count);
    
//    //NSLog(@" %@",model);
//    
//    //NSLog(@"123 %@",model.ds);
    
    
    [self.collectionView reloadData];

}





#pragma mark -  刷新
- (void)setHeaderRefresh
{
    
    __weak typeof(self) weakSelf = self;
    
    [self.collectionView addLegendFooterWithRefreshingBlock:^{
        
        [weakSelf loadMoreData];
    }];
    

}




-(void)loadMoreData
{

  //  //NSLog(@"%ld ",self.page);
    
  //  //NSLog(@"456");

    
    
        [self getNewsListWithIndexPage:++self.page andStrWhere:@"" andOrderBy:KNews];
    
    
    
    
   
}











@end