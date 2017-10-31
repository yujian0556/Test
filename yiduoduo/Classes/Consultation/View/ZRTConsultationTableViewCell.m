//
//  ZRTConsultationTableViewCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationTableViewCell.h"

#import "OZHPictureView.h"

#import "UIImageView+WebCache.h"
#import "UIImage+YFImge.h"

#import "Helper.h"

#import "ZRTConsultationDetailViewController.h"

#import "HZImagesGroupView.h"

#import "HZPhotoItemModel.h"

#import "Interface.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"

@interface ZRTConsultationTableViewCell ()

#define KFontSize 16

@property (nonatomic,strong) UIImageView *headerImageView;//头像
@property (nonatomic,strong) UILabel *userNameLabel;//用户名
@property (nonatomic,strong) UILabel *officeLabel;//科室
@property (nonatomic,strong) UILabel *doctorRankLabel;//医师等级
@property (nonatomic,strong) UIButton *chooseOfficeButton;//科室按钮

@property (nonatomic,strong) UILabel *contentLabel;//内容
@property (nonatomic,strong) UIButton *allContentButton;//全文按钮

@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,strong) UIView *buttonsView;

@property (nonatomic,assign) NSInteger numberOfFavorite;
@property (nonatomic,strong) ZRTConsultationModel *model;



@end

@implementation ZRTConsultationTableViewCell
{
    CGFloat _heightOfCommentLabel;
    UILabel *_previousLabel;
    NSInteger _commentLabelCount;
    UIButton *_selectBtn;
}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)fillCellWithModel:(ZRTConsultationModel *)Model
{
    
    
    _heightOfCommentLabel = 0;
    _commentLabelCount = 0;
    self.model = Model;
    
    //设置头像
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    
    NSString *path =[NSString stringWithFormat:@"%@%@",ImagePath,Model.ImgUrl];
    
//    NSLog(@" %@",path);
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"mine_icon_face_default"]];
    
    //设置用户名
    
    NSString *name;
    if ([Model.NickName isEqualToString:@""]) {
        name = [NSString stringWithFormat:@"用户%@",Model.UserId];
    }
    else {
        name = Model.NickName;
    }
    
    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, 15, [Helper widthOfString:name font:[UIFont systemFontOfSize:15] height:15], 15)];
//    self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImageView.frame) + 10, 15, [OZHHelper widthOfString:[NSString stringWithFormat:@"id == %@",Model.Id] font:[UIFont systemFontOfSize:17] height:17], 17)];
    self.userNameLabel.font = [UIFont systemFontOfSize:15];
    self.userNameLabel.text = name;//[NSString stringWithFormat:@"id == %@",Model.Id];
    self.userNameLabel.textColor = KMainColor;
    
    //设置科室
    self.officeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userNameLabel.frame)+10, self.userNameLabel.y, [Helper widthOfString:Model.SectionOffice font:[UIFont systemFontOfSize:14] height:14], 14)];
    self.officeLabel.text = Model.SectionOffice;
//    NSLog(@" %@",self.officeLabel.text);
    
//    NSLog(@" %@",self.officeLabel.text);
    
    self.officeLabel.textColor = [UIColor lightGrayColor];
    self.officeLabel.font = [UIFont systemFontOfSize:14];
    
    
    // 设置分割线
    
    UIView *fenge = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.officeLabel.frame)-5, self.userNameLabel.y, 1, self.userNameLabel.height)];
    
    [self.contentView addSubview:fenge];
    
    fenge.backgroundColor = [UIColor lightGrayColor];
    
    
    //设置医生等级
    self.doctorRankLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.officeLabel.frame) + 5, CGRectGetMinY(self.officeLabel.frame), [Helper widthOfString:Model.Professional font:[UIFont systemFontOfSize:14] height:14], 14)];
    self.doctorRankLabel.text = Model.Professional;
    
//    NSLog(@"level %@",self.doctorRankLabel.text);
    
    self.doctorRankLabel.textColor = [UIColor lightGrayColor];
    self.doctorRankLabel.font = self.officeLabel.font;
    
    //科室按钮
    CGFloat width = [Helper widthOfString:Model.Title2 font:[UIFont systemFontOfSize:17] height:20];
    self.chooseOfficeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseOfficeButton.frame = CGRectMake(KScreenWidth - 10 - 5 - width, 10, width + 5, 20);
    [self.chooseOfficeButton setTitle:Model.Title2 forState:UIControlStateNormal];
    [self.chooseOfficeButton setTitleColor:KLineColor forState:UIControlStateNormal];
    self.chooseOfficeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.chooseOfficeButton addTarget:self action:@selector(showOfficeSectionView) forControlEvents:UIControlEventTouchUpInside];
    self.chooseOfficeButton.hidden = NO;
    
    
    
    //全文按钮
    self.allContentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //内容
    CGFloat heightOfContent = [Helper heightOfString:Model.Contents font:[UIFont systemFontOfSize:17] width:KScreenWidth - 10 - 40];
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = Model.Contents;
    self.contentLabel.numberOfLines = 5;
    
    self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:@"huiche" withString:@"\n"];
    self.contentLabel.text = [self.contentLabel.text stringByReplacingOccurrencesOfString:@"kongge" withString:@"\r"];
    //如果内容小于5行
    if (heightOfContent <= 5 * 17) {
        self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.userNameLabel.frame), CGRectGetMaxY(self.officeLabel.frame) + 10, KScreenWidth - 10 - 40 -10 , heightOfContent);
        
        self.allContentButton.userInteractionEnabled = NO;
        self.allContentButton.hidden = YES;
    }
    //如果内容大于5行
    else {
        self.contentLabel.frame = CGRectMake(CGRectGetMinX(self.userNameLabel.frame), CGRectGetMaxY(self.officeLabel.frame) + 10, KScreenWidth - 10 - 40 -10 , 6 * 17);
        
        self.allContentButton.userInteractionEnabled = YES;
        self.allContentButton.hidden = NO;
    }
    
    //设置全文按钮
    self.allContentButton.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + 10, 3 * 17, 20);
    [self.allContentButton setTitle:@"全文" forState:UIControlStateNormal];
    self.allContentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.allContentButton setTitleColor:KMainColor forState:UIControlStateNormal];
    [self.allContentButton addTarget:self action:@selector(JumpToDetail:) forControlEvents:UIControlEventTouchUpInside];
    self.allContentButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft; //设置文字居左
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.officeLabel];
    [self.contentView addSubview:self.doctorRankLabel];
    [self.contentView addSubview:self.chooseOfficeButton];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.allContentButton];
    
    [self setPicturesViewWithPictureNumber:[Model.ImgList[@"ds"] count] AndModel:Model];
    [self setButtonsViewWithModel:Model];
    [self setCommentViewWithModel:Model];
    
}

- (void)setPicturesViewWithPictureNumber:(NSInteger)number AndModel:(ZRTConsultationModel *)model
{
    
//    if (number) {
//        
//        if (self.allContentButton.isHidden) {
//            
//            HZImagesGroupView *imageGroupView = [[HZImagesGroupView alloc] init];
//            NSMutableArray *temp = [[NSMutableArray alloc] init];
//
//            [model.ImgList[@"ds"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                
//                HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
//                item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][idx][@"imgurl"]];
//                [temp addObject:item];
//                
//            }];
//            
//            imageGroupView.photoItemArray = [temp copy];
//            
//            UIView *pictureBGV = [[UIView alloc] init];
//            self.pictureView = pictureBGV;
//            [pictureBGV addSubview:imageGroupView];
//            
//            self.pictureView.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame), KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 ));
//        }
//        else {
//            HZImagesGroupView *imageGroupView = [[HZImagesGroupView alloc] init];
//            NSMutableArray *temp = [[NSMutableArray alloc] init];
//             
//            [model.ImgList[@"ds"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                
//                HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
//                item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][idx][@"imgurl"]];
//                [temp addObject:item];
//                
//            }];
//            
//            imageGroupView.photoItemArray = [temp copy];
//            
//            UIView *pictureBGV = [[UIView alloc] init];
//            self.pictureView = pictureBGV;
//            [pictureBGV addSubview:imageGroupView];
//            
//            self.pictureView.frame = CGRectMake(CGRectGetMinX(self.allContentButton.frame), CGRectGetMaxY(self.allContentButton.frame) + 20, KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 ));
//        }
//
//        
//    }
//    else {
//        self.pictureView = nil;
//    }
//    
//    [self.contentView addSubview:self.pictureView];
    

    if (number) {
        
        HZImagesGroupView *imageGroupView = [[HZImagesGroupView alloc] init];
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        
        [model.ImgList[@"ds"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
            item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][idx][@"imgurl"]];
            [temp addObject:item];
            
        }];
        
        imageGroupView.photoItemArray = [temp copy];
        
        self.pictureView.backgroundColor = [UIColor redColor];
        
        UIView *pictureBGV = [[UIView alloc] init];
        [pictureBGV addSubview:imageGroupView];
        self.pictureView = pictureBGV;
        
        if (self.allContentButton.isHidden) {
            self.pictureView.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.contentLabel.frame) + 20, KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 ));
        }
        else {
            self.pictureView.frame = CGRectMake(CGRectGetMinX(self.contentLabel.frame), CGRectGetMaxY(self.allContentButton.frame) + 20, KScreenWidth - 40, KpictureOrignY * (((number - 1) / 3 ) + 1 ));
        }
    }
    else {
        self.pictureView = nil;
    }
    [self.contentView addSubview:self.pictureView];
}


#define marginX 30


- (void)setButtonsViewWithModel:(ZRTConsultationModel *)model
{
    
    if (self.pictureView) {
        self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pictureView.frame) + 10, KScreenWidth, 30)];
    }
    else {
        
        if (self.allContentButton.isHidden) {
            self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), KScreenWidth, 30)];
        }
        else {
            self.buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.allContentButton.frame), KScreenWidth, 30)];
        }
    }
        
    //发布时间
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.contentLabel.frame), 0, [Helper widthOfString:model.AddTime font:[UIFont systemFontOfSize:14] height:30] , 30)];
    timeLabel.text = model.AddTime;
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = [UIFont systemFontOfSize:14];
    
    
    
    // 删除按钮
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    
    delete.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [delete setTitleColor:KMainColor forState:UIControlStateNormal];
    
    
    [delete sizeToFit];
    
    CGFloat deleteW = delete.width;
    CGFloat deleteH = delete.height;
    
    
    delete.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 10, 0, deleteW, deleteH);
    
    delete.hidden = YES;
    
    
    NSDictionary *UserDict = [DEFAULT objectForKey:@"UserDict"];
    
    NSString *ID = [UserDict objectForKey:@"Id"];
    
    
//    NSLog(@"自己的 %@",ID);

    
//    NSLog(@"发布的 %@",model.UserId);
    

    
    BOOL islogin = [[DEFAULT objectForKey:@"isLogin"] boolValue];
   
    
    
    if (islogin) {
        
        
        if ([model.UserId isEqualToString: ID]) {
            
            
            delete.hidden = NO;
            
        }else{
            
            delete.hidden = YES;
        }
        
        
    }
    
    
    
    [delete addTarget:self action:@selector(deleteConsult:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [delete setTag:[model.Id intValue]];
    
    
    
    [self.buttonsView addSubview:delete];
    
    
    
    self.numberOfFavorite = [model.collectnum integerValue];
    
    
    // 添加收藏按钮
    
    self.favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favoriteBtn.frame = CGRectMake(KScreenWidth - marginX*2, 0, 0, 0);
    [self.favoriteBtn setImage:[UIImage imageNamed:@"all_btn_collection"] forState:UIControlStateNormal];
    [self.favoriteBtn setImage:[UIImage imageNamed:@"all_btn_collection_selected"] forState:UIControlStateSelected];
//    [self.favoriteBtn setTitle:[NSString stringWithFormat:@"%@",model.collectnum] forState:UIControlStateNormal];
//    [self.favoriteBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    self.favoriteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self.favoriteBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    
    [self.favoriteBtn sizeToFit];
    
    [self.favoriteBtn addTarget:self action:@selector(addFavorite) forControlEvents:UIControlEventTouchUpInside];
    
    if ([model.havecollect isEqualToString:@"1"]) {
        self.favoriteBtn.selected = YES;
    }
    else {
        self.favoriteBtn.selected = NO;
    }
    
    
    // 添加评论按钮
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    commentBtn.frame = CGRectMake(KScreenWidth - 10 - 50 * 2, 0, 50, 30);
    commentBtn.frame = CGRectMake(KScreenWidth - marginX, 0, 0, 0);
    [commentBtn setImage:[UIImage imageNamed:@"all_btn_comment"] forState:UIControlStateNormal];
//    [commentBtn setTitle:[NSString stringWithFormat:@"%ld",[model.ConsultationReplay count]] forState:UIControlStateNormal];
//    [commentBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    commentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [commentBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [commentBtn sizeToFit];
    
    [commentBtn addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    shareBtn.frame = CGRectMake(KScreenWidth - 10 - 50 * 1, 0, 50, 30);
//    [shareBtn setImage:[UIImage imageNamed:@"all_btn_share"] forState:UIControlStateNormal];
//    [shareBtn setTitle:[NSString stringWithFormat:@"%@",model.shareNumber] forState:UIControlStateNormal];
//    [shareBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    [shareBtn addTarget:self action:@selector(addShare:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.buttonsView addSubview:self.favoriteBtn];
    [self.buttonsView addSubview:commentBtn];
//    [self.buttonsView addSubview:shareBtn];
    [self.buttonsView addSubview:timeLabel];
    [self.contentView addSubview:self.buttonsView];
    
}

- (void)setCommentViewWithModel:(ZRTConsultationModel *)model
{
    if ([model.ConsultationReplay[@"ds"] count]) {
        
        UIView *commentView = [[UIView alloc] init];
        
        CGFloat backX = CGRectGetMinX(self.allContentButton.frame);
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(backX, 0, KScreenWidth - 20-backX, 30)];
//        backgroundImageView.image = [UIImage imageNamed:@"consulation_comment_bg"];
        
        backgroundImageView.backgroundColor = KRGBColor(230, 244, 245);
        
        //设置评论Label
        
        if ([model.ConsultationReplay[@"ds"] count] <= 4) {
            
            NSInteger i;
            
            for (i = 0; i < [model.ConsultationReplay[@"ds"] count]; i++) {
                
                NSString *name;
                if ([model.ConsultationReplay[@"ds"][i][@"NickName"] isEqualToString:@""]) {
                    name = [NSString stringWithFormat:@"用户%@",model.ConsultationReplay[@"ds"][i][@"UserId"]];
                }
                else {
                    name = model.ConsultationReplay[@"ds"][i][@"NickName"];
                }
                
                NSString *str = [NSString stringWithFormat:@"%@ : %@",name,model.ConsultationReplay[@"ds"][i][@"Contents"]];
//                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
//                NSRange range = [str rangeOfString:@":回复"];
//                
//                if (range.length == 0) {
//                    NSInteger length = [model.ConsultationReplay[i][@"NickName"] length];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(0, length)];
//                }
//                else {
//                    NSInteger length = [model.ConsultationReplay[i][@"NickName"] length];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(0, length)];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(range.location + 2, length - range.location - 2)];
//                }
                
                CGFloat heightOfLabel = [Helper heightOfString:str font:[UIFont systemFontOfSize:KFontSize] width:backgroundImageView.frame.size.width - 30];
                _heightOfCommentLabel += (heightOfLabel + 10);
                
                UILabel *label;
                ++_commentLabelCount;
                
                if (i == 0) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, backgroundImageView.frame.size.width - 30, heightOfLabel)];
                }
                else {
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(_previousLabel.frame) + 10, backgroundImageView.frame.size.width - 30, [Helper heightOfString:str font:[UIFont systemFontOfSize:KFontSize] width:backgroundImageView.frame.size.width - 30])];
                }
//                label.attributedText = string;
                
                NSMutableAttributedString *sexStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                NSRange redRange = NSMakeRange(0, [[sexStr string] rangeOfString:@":"].location);
                
                
                [sexStr addAttribute:NSForegroundColorAttributeName value:KMainColor range:redRange];
                [label setAttributedText:sexStr] ;

//                label.text = str;
                
                label.numberOfLines = 0;
                [backgroundImageView addSubview:label];
                
                _previousLabel = label;
                
            }
        }
        else {
            
            NSInteger i;
            
            for (i = 0; i < 4; i++) {
                
                NSString *name;
                if ([model.ConsultationReplay[@"ds"][i][@"NickName"] isEqualToString:@""]) {
                    name = [NSString stringWithFormat:@"用户%@",model.ConsultationReplay[@"ds"][i][@"UserId"]];
                }
                else {
                    name = model.ConsultationReplay[@"ds"][i][@"NickName"];
                }

                
                NSString *str = [NSString stringWithFormat:@"%@ : %@",name,model.ConsultationReplay[@"ds"][i][@"Contents"]];
//                NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
//                NSRange range = [str rangeOfString:@"回复"];
//                
//                if (range.length == 0) {
//                    NSInteger length = [model.ConsultationReplay[i][@"Contents"] length];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(0, length)];
//                }
//                else {
//                    NSInteger length = [model.ConsultationReplay[i][@"Contents"] length];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(0, range.location)];
//                    [string addAttribute:NSForegroundColorAttributeName value:KMainColor range:NSMakeRange(range.location + 2, length - range.location - 2)];
//                }
                
                CGFloat heightOfLabel = [Helper heightOfString:str font:[UIFont systemFontOfSize:KFontSize] width:backgroundImageView.frame.size.width - 30];
                _heightOfCommentLabel += (heightOfLabel + 10);
                
                UILabel *label;
                ++_commentLabelCount;
                
                if (i == 0) {
                    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, backgroundImageView.frame.size.width - 30, heightOfLabel)];
                }
                else {
                    
                    label = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(_previousLabel.frame) + 10, backgroundImageView.frame.size.width - 30, [Helper heightOfString:str font:[UIFont systemFontOfSize:KFontSize] width:backgroundImageView.frame.size.width - 30])];
                }
//                label.attributedText = string;
                
                NSMutableAttributedString *sexStr = [[NSMutableAttributedString alloc] initWithString:str];
                
                NSRange redRange = NSMakeRange(0, [[sexStr string] rangeOfString:@":"].location);
                
                
                [sexStr addAttribute:NSForegroundColorAttributeName value:KMainColor range:redRange];
                [label setAttributedText:sexStr] ;
                
//                label.text = str;
                label.numberOfLines = 0;
                [backgroundImageView addSubview:label];
                
                _previousLabel = label;
                
            }
            
        }
        
        //拉伸背景图片
//        UIImage *image = [UIImage imageWithStretchableImageName:@"consulation_comment_bg"];
//        backgroundImageView.image = image;
        
        NSInteger commentNumebr = [model.ConsultationReplay[@"ds"] count];
        NSString *buttonTitle = [NSString stringWithFormat:@"查看全部%ld条评论",commentNumebr];
        
        UIButton *seeMoreComment = [UIButton buttonWithType:UIButtonTypeCustom];
        
        seeMoreComment.frame = CGRectMake(backX+10, CGRectGetMaxY(_previousLabel.frame) + 10, [Helper widthOfString:buttonTitle font:[UIFont systemFontOfSize:17] height:30] + 10, 30);
        
        [seeMoreComment setTitle:buttonTitle forState:UIControlStateNormal];
        [seeMoreComment setTitleColor:KMainColor forState:UIControlStateNormal];
        [seeMoreComment addTarget:self action:@selector(JumpToDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //评论展示4条,多的用按钮查看更多
        if (_commentLabelCount >= 4) {
            
            //设置拉伸背景图的尺寸
            backgroundImageView.frame = CGRectMake(backgroundImageView.x, backgroundImageView.y, KScreenWidth - 20 - backX, CGRectGetMaxY(seeMoreComment.frame) + 15);
            
            commentView.frame = CGRectMake(0, CGRectGetMaxY(self.buttonsView.frame), KScreenWidth,  CGRectGetMaxY(seeMoreComment.frame) + 15);
        }
        else
        {
            seeMoreComment.userInteractionEnabled = NO;
            seeMoreComment.hidden = YES;
            
            //设置拉伸背景图的尺寸
            backgroundImageView.frame = CGRectMake(backgroundImageView.x, backgroundImageView.y, KScreenWidth - 20 - backX, CGRectGetMaxY(_previousLabel.frame) + 15);
            
            commentView.frame = CGRectMake(0, CGRectGetMaxY(self.buttonsView.frame), KScreenWidth,  CGRectGetMaxY(_previousLabel.frame) + 15);
        }
        
        [commentView addSubview:backgroundImageView];
        [self.contentView addSubview:commentView];
        [commentView addSubview:seeMoreComment];
        
        self.cellHeight = CGRectGetMinY(commentView.frame) + backgroundImageView.frame.size.height + 10;
    }
    else {
        self.cellHeight = CGRectGetMaxY(self.buttonsView.frame);
    }
}

#pragma mark - 点击事件
/**
 *  添加收藏
 */
- (void)addFavorite
{
    ////NSLog(@"添加收藏");
    
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

/**
 *  跳转到详情页
 */
- (void)JumpToDetail:(UIButton *)sender
{
    ////NSLog(@"跳转详情页");
    
    
    self.jumpBlock(self.model);
}

-(void)jumpToDetailWithBlock:(void (^)(ZRTConsultationModel *))block
{
    self.jumpBlock = block;
}

- (void)commentBlock:(void (^)(void))block
{
    self.commentBlock = block;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


// 删除会诊
-(void)deleteConsult:(id)sender
{
    
    NSString *ID = [NSString stringWithFormat:@"%d",(int )[sender tag]];
    
//    NSLog(@" %@",ID); 
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:KDeleteConsultation parameters:@{@"Id":ID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [MBProgressHUD showSuccess:@"删除成功"];
        
        if ([self.delegate respondsToSelector:@selector(reloadData)]) {
            
            [self.delegate reloadData];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [MBProgressHUD showError:@"删除失败"];
        
        
    }];

    
    
    

}


- (void)showOfficeSectionView {
    
    self.sectionOfficeBtnBlock();
    
}

@end
