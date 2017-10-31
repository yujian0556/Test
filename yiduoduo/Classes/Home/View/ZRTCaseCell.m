//
//  ZRTCaseCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCaseCell.h"

#import "UIImageView+WebCache.h"
#import "Interface.h"

@interface ZRTCaseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *playNumber;
@property (weak, nonatomic) IBOutlet UILabel *commentNumber;
@property (weak, nonatomic) IBOutlet UIView *numberView;
@property (weak, nonatomic) IBOutlet UIView *numberBGView;

@end

@implementation ZRTCaseCell
{
    NSArray *_placeHolderArray;
}
- (void)awakeFromNib {
    // Initialization code
    _placeHolderArray = @[[UIImage imageNamed:@"图片延迟加载"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCellWithModel:(ZRTCaseModel *)model {
    
    self.numberView.hidden = YES;
    self.numberBGView.hidden = YES;
    
  
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.OldCaseContent]] placeholderImage:_placeHolderArray[0]];
    self.titleLabel.text = model.YWTitle;
    self.contentLabel.text = @"";
    
//    NSLog(@"model %@",model);
    
    
    
//    self.playNumber.text = @"1万";
//    self.commentNumber.text = @"298";
}

@end
