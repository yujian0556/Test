//
//  ZRTVideoCollectionView.m
//  yiduoduo
//
//  Created by 余健 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTVideoCollectionView.h"

#import "ZRTMainViewCollectionViewCell.h"

static NSString * cellReuseIdentifier = @"MainViewCollectionViewCell";

@interface ZRTVideoCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ZRTVideoCollectionView
//{
//    NSInteger _type;
//}
- (void)awakeFromNib {
    // Initialization code
    
    //设置代理
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self setFlowLayoutWithCellSize:[self getCurrentDeviceType]];
    
    //注册
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZRTMainViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellReuseIdentifier];
    
//    _type = 0;
}

- (void)setFlowLayoutWithCellSize:(CGSize)CellSize
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CellSize;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView.collectionViewLayout = flowLayout;
}

/**
 根据设备类型，设置CollectionViewCell的Size
 */
- (CGSize)getCurrentDeviceType
{
    //iPhone 4,5
    if (KScreenWidth == 320) {
        return CGSizeMake(147, 127);
    }
    //iPhone 6
    else if (KScreenWidth == 375) {
        return CGSizeMake(171, 148);
    }
    //iPhone 6 plus
    else {
        return CGSizeMake(191, 165);
    }
}

- (void)PassDataArray:(NSArray *)dataArray
{
    self.DataArray = dataArray;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return [self.DataArray[_type] count];
    return self.DataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTMainViewCollectionViewCell *mainViewCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [mainViewCollectionViewCell fillCellWithModel:self.DataArray[indexPath.row]];
    
    return mainViewCollectionViewCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.jumpBlock(self.DataArray[indexPath.row]);
}

#pragma mark - 通知中心
//- (void)createNotificationCenter
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataSource:) name:@"ChangeToVideo" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDataSource:) name:@"ChangeToPPT" object:nil];
//}
//
//- (void)changeDataSource:(NSNotification *)sender
//{
//    NSString *studyType = sender.userInfo[@"studyType"];
//    
//    if ([studyType isEqualToString:@"0"]) {
//        _type = 0;
//    }
//    else if ([studyType isEqualToString:@"1"]) {
//        _type = 1;
//    }
//}

@end
