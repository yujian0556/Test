//
//  ZRTMainViewCollectionViewCell.m
//  yiduoduo
//
//  Created by Zhanghua on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTMainViewCollectionViewCell.h"

#import "UIImageView+WebCache.h"

#import "Interface.h"

@interface ZRTMainViewCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *playNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *numberBGView;

@end

@implementation ZRTMainViewCollectionViewCell
{
    NSArray *_placeHolderArray;
}
- (void)awakeFromNib {
    // Initialization code
    
    _placeHolderArray = @[[UIImage imageNamed:@"图片延迟加载"]];
}

- (void)fillCellWithModel:(ZRTVideoModel *)model {
    
    self.numberBGView.hidden = YES;
    self.numberView.hidden = YES;
    
    
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",KMainInterface,model.ImgUrl]] placeholderImage:_placeHolderArray[0]];
    self.titleLabel.text = model.Title;
    self.detailLabel.text = @"";
    
//    self.playNumber.text = @"4,1万";
//    self.commentNumber.text = @"256";
    
//    self.playNumber.font = [UIFont systemFontOfSize:[self getCurrentDeviceType]];
//    self.commentNumber.font = [UIFont systemFontOfSize:[self getCurrentDeviceType]];
}

- (CGFloat)getCurrentDeviceType
{
    //iPhone 4,5
    if (KScreenWidth == 320) {
        return 10;
    }
    //iPhone 6
    else if (KScreenWidth == 375) {
        return 10;
    }
    //iPhone 6 plus
    else {
        return 17;
    }
}

@end
