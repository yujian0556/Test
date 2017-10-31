//
//  ZRTConsultationDetailContentTableViewCell.m
//  yiduoduo
//
//  Created by Olivier on 15/5/20.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationDetailContentTableViewCell.h"

#import "Helper.h"

#import "OZHPictureView.h"

#import "UIImageView+WebCache.h"

#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"

#import "UIImage+YFImge.h"

@interface ZRTConsultationDetailContentTableViewCell ()

@property (nonatomic,strong) UIImageView *headerImageView;//头像
@property (nonatomic,strong) UILabel *userNameLabel;//用户名
@property (nonatomic,strong) UIView *separateLineView;//分割线
@property (nonatomic,strong) UILabel *officeLabel;//科室
@property (nonatomic,strong) UILabel *doctorRankLabel;//医师等级
@property (nonatomic,strong) UIButton *chooseOfficeButton;//科室按钮

@property (nonatomic,strong) UILabel *contentLabel;//内容

@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,strong) UIView *buttonsView;

@end


@implementation ZRTConsultationDetailContentTableViewCell
{
    NSInteger _numberOfFavorite;
    NSInteger _numberOfComment;
    NSInteger _numberOfShare;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)fillCellWithDictionary:(NSDictionary *)dict
{

//************************ 内   容 **************************************************//
    //设置头像
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    
    NSString *path =[NSString stringWithFormat:@"%@%@",KImageInterface,dict[@"headerImageURLString"]];
    
//    NSLog(@"哪儿 %@",path);
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    //设置用户名
    NSString *name;
    if ([dict[@"userName"] isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"用户%@",dict[@"UserId"]];
    }
    else {
        name = dict[@"userName"];
    }
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, 15, [Helper widthOfString:name font:[UIFont systemFontOfSize:17] height:17], 17)];
    self.userNameLabel.text = name;
    self.userNameLabel.textColor = KMainColor;
    
    //设置分割线
    self.separateLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame) + 5, 15, 1, 17)];
    self.separateLineView.backgroundColor = [UIColor lightGrayColor];
    
    //设置科室
    self.officeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.separateLineView.frame) + 5, 15, [Helper widthOfString:dict[@"officeName"] font:[UIFont systemFontOfSize:17] height:17], 17)];
    self.officeLabel.text = dict[@"officeName"];
    self.officeLabel.textColor = [UIColor lightGrayColor];
    
    //设置医生等级
    self.doctorRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.officeLabel.frame) + 10, 15, [Helper widthOfString:dict[@"doctorRank"] font:[UIFont systemFontOfSize:17] height:17], 17)];
    self.doctorRankLabel.text = dict[@"doctorRank"];
    self.doctorRankLabel.textColor = [UIColor lightGrayColor];
    
    //科室按钮
    self.chooseOfficeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseOfficeButton.frame = CGRectMake(KScreenWidth - 30 - self.officeLabel.size.width, 15, self.officeLabel.size.width + 4, self.officeLabel.size.height);
    [self.chooseOfficeButton setTitle:dict[@"officeName"] forState:UIControlStateNormal];
    [self.chooseOfficeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.chooseOfficeButton.hidden = NO;
    
    //内容
    CGFloat heightOfContent = [Helper heightOfString:dict[@"Contents"] font:[UIFont systemFontOfSize:17] width:KScreenWidth - 10 - 40];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = dict[@"Contents"];
    self.contentLabel.numberOfLines = 0;
    
    self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:@"huiche" withString:@"\n"];
    self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:@"kongge" withString:@"\r"];
    
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.headerImageView.frame), CGRectGetMaxY(self.userNameLabel.frame) + 10, KScreenWidth - 10 - 40 , heightOfContent);
    
//************************ 图    片 **************************************************//
    NSInteger number = [dict[@"picturesArray"] count];
    
    if (number) {
        
//        self.pictureView = [OZHPictureView createPictureViewWithCGRect:CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + 20, KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 )) AndArray:dict[@"picturesArray"]];
        
        HZImagesGroupView *imageGroupView = [[HZImagesGroupView alloc] init];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        
        
        [dict[@"picturesArray"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,dict[@"picturesArray"][idx][@"imgurl"]];
            [temp addObject:item];
            
        }];
        
        imageGroupView.photoItemArray = [temp copy];
        
        self.pictureView.backgroundColor = [UIColor redColor];
        
        UIView *pictureBGV = [[UIView alloc] init];
        [pictureBGV addSubview:imageGroupView];
        self.pictureView = pictureBGV;
        
        self.pictureView.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + 20, KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 ));
    }
    else {
        self.pictureView = nil;
    }
    
//************************  3个按钮   **************************************************//
    
    if (self.pictureView) {
        self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pictureView.frame) + 15, KScreenWidth, 30)];
    }
    else {
        
        self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + 15, KScreenWidth, 30)];
    }    
    self.buttonsView.userInteractionEnabled = YES;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, [Helper widthOfString:dict[@"AddTime"] font:[UIFont systemFontOfSize:17] height:30] , 30)];
    timeLabel.text = dict[@"AddTime"];
    timeLabel.textColor = [UIColor lightGrayColor];
    
    
    self.favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favoriteBtn.frame = CGRectMake(KScreenWidth - 10 - 50 * 2, 0, 80, 30);
    
    [self.favoriteBtn setImage:[UIImage imageNamed:@"all_btn_collection"] forState:UIControlStateNormal];
    [self.favoriteBtn setImage:[UIImage imageNamed:@"all_btn_collection_selected"] forState:UIControlStateSelected];
    [self.favoriteBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"collectnum"]] forState:UIControlStateNormal];
    [self.favoriteBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    self.favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.favoriteBtn addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];

    if ([dict[@"havecollect"] isEqualToString:@"1"]) {
        self.favoriteBtn.selected = YES;
    }
    else {
        self.favoriteBtn.selected = NO;
    }
    
//    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    commentBtn.frame = CGRectMake(KScreenWidth - 10 - 50 * 2, 0, 50, 30);
//    [commentBtn setImage:[UIImage imageNamed:@"all_btn_comment"] forState:UIControlStateNormal];
//    [commentBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"commentNumber"]] forState:UIControlStateNormal];
//    [commentBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    [commentBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(KScreenWidth - 10 - 50 * 1, 0, 50, 30);
//    [shareBtn setImage:[UIImage imageNamed:@"all_btn_share"] forState:UIControlStateNormal];
//    [shareBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"shareNumber"]] forState:UIControlStateNormal];
//    [shareBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(addShare:) forControlEvents:UIControlEventTouchUpInside];
    
//    _numberOfFavorite = [dict[@"favoriteNumber"] integerValue];
//    _numberOfComment = [dict[@"commentNumber"] integerValue];
//    _numberOfShare = [dict[@"shareNumber"] integerValue];
//    
//    [self.buttonsView addSubview:timeLabel];
    [self.buttonsView addSubview:self.favoriteBtn];
//    [self.buttonsView addSubview:commentBtn];
//    [self.buttonsView addSubview:shareBtn];
    
//************************ 添加到contentView上面   **************************************************//
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.separateLineView];
    [self.contentView addSubview:self.doctorRankLabel];
    [self.contentView addSubview:self.officeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.pictureView];
    [self.contentView addSubview:self.buttonsView];
//    [self.contentView addSubview:self.chooseOfficeButton];
    
    self.contentView.backgroundColor = [UIColor colorWithRed:232/256.0 green:248/256.0 blue:245/256.0 alpha:1];
    
    return CGRectGetMaxY(self.buttonsView.frame);
}


#pragma mark - 点击事件
/**
 *  添加收藏
 */
- (void)addFavorite:(UIButton *)sender
{
    
    self.favoriteBlock();
}

/**
 *  评论
 */
- (void)addComment:(UIButton *)sender
{
    ////NSLog(@"评论");
    
    self.commentBlock();
}

/**
 *  分享
 */
- (void)addShare:(UIButton *)sender
{
    ////NSLog(@"分享");
}

- (void)commentBlock:(void (^)(void))block
{
    self.commentBlock = block;
}

@end
