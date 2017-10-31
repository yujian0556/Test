//
//  ZRTVideoCollectionViewCell.m
//  yiduoduo
//
//  Created by 余健 on 15/5/7.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTVideoCollectionViewCell.h"

#import "UIImageView+WebCache.h"
#import "Interface.h"

@interface ZRTVideoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *VideoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *PlayAndCommentNumberLabel;

@end

@implementation ZRTVideoCollectionViewCell
{
    NSArray *_placeHolderArray;
}
- (void)awakeFromNib {
    // Initialization code
    _placeHolderArray = @[[UIImage imageNamed:@"图片延迟加载"]];
}

-(void)fillCellWithModel:(ZRTVideoModel *)model
{
   
    if (model.ImgUrl != nil) {
        
        [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgUrl]] placeholderImage:_placeHolderArray[0]];
    }

    
    self.VideoNameLabel.text = model.Title;
    self.PlayAndCommentNumberLabel.hidden = YES;
//    self.PlayAndCommentNumberLabel.text = [NSString stringWithFormat:@"播放:%@  评论:%@",model.PlayNumber,model.CommentNumber];
}

@end
