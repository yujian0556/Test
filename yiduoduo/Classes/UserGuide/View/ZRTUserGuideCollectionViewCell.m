//
//  ZRTUserGuideCollectionViewCell.m
//  yiduoduo
//
//  Created by olivier on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTUserGuideCollectionViewCell.h"

@implementation ZRTUserGuideCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)fillCellWithImg:(NSString *)img {
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",img]];
    
    [self.contentView addSubview:iv];
    
}


#define BtnWidth KScreenWidth == 320 ? 225/2: 300/2
#define BtnHeight KScreenWidth == 320 ? 57/2: 80/2

- (void)fillButtonCellWithImg:(NSString *)img {
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",img]];
    [self.contentView addSubview:iv];
    
    
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
//    jumpBtn.backgroundColor = [UIColor redColor];
    

    jumpBtn.frame = CGRectMake(0, 0, BtnWidth+20, BtnHeight+20);
    
    if(KScreenHeight == 568){  // 5s
        
        
        jumpBtn.center = CGPointMake(KScreenWidth/2, KScreenHeight -180);
        
    }else if (KScreenHeight == 667){  // 6
        
        jumpBtn.center = CGPointMake(KScreenWidth/2, KScreenHeight -180);
        
    }else{  // 6p
        
        jumpBtn.center = CGPointMake(KScreenWidth/2, KScreenHeight -220);
        
    }
    
    
  //  [jumpBtn setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:jumpBtn];
}

- (void)jump {
    
    self.block();
    
}

@end
