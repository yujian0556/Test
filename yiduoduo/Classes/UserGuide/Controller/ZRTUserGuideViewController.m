//
//  ZRTUserGuideViewController.m
//  yiduoduo
//
//  Created by olivier on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTUserGuideViewController.h"
#import "ZRTUserGuideCollectionViewCell.h"


@interface ZRTUserGuideViewController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ZRTUserGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createArray];
    
    [self createCollectionView];
    
    
}

- (void)createArray {

    NSArray *imgArr = @[@"0-1",@"0-2",@"0-3"];
    
    self.dataSource = [NSMutableArray arrayWithArray:imgArr];
}

- (void)createCollectionView {
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.itemSize = CGSizeMake(KScreenWidth, KScreenHeight);
    fl.minimumLineSpacing = 0.f;
    fl.minimumInteritemSpacing = 0.f;
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *cv = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) collectionViewLayout:fl];
    
    cv.backgroundColor = [UIColor whiteColor];
    cv.pagingEnabled = YES;
    
    
    cv.delegate = self;
    cv.dataSource = self;
    
    [cv registerClass:[ZRTUserGuideCollectionViewCell class] forCellWithReuseIdentifier:@"ugCell"];
    
    self.view.backgroundColor = KMainColor;
    cv.backgroundColor = KMainColor;
    
    [self.view addSubview:cv];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTUserGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ugCell" forIndexPath:indexPath];
    
    
    if (indexPath.row == 2) {
        
        [cell fillButtonCellWithImg:self.dataSource[indexPath.row]];
        
        __weak typeof(self) weakSelf = self;
        
        cell.block = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    else {
        [cell fillCellWithImg:self.dataSource[indexPath.row]];
    }
    
    return cell;
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

@end
