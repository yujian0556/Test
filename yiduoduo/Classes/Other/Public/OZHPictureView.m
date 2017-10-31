//
//  OZHPictureView.m
//  yiduoduo
//
//  Created by Olivier on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "OZHPictureView.h"
#import "UIImageView+WebCache.h"


@implementation OZHPictureView

+ (UIView *)createPictureViewWithCGRect:(CGRect)rect AndModel:(ZRTConsultationModel *)model {
    
    UIView *pictureView = [[UIView alloc] init];
    
    NSInteger number = [model.ImgList count];
    
    NSInteger countNumber = 0;
    
    if (number) {
        
        pictureView.frame = rect;
        
        NSUInteger cols;
        NSUInteger rows;
        
        //根据图片数量进行判断
        if (number == 3 || number == 4 || number == 6 || number == 9) {
            cols = number == 4 ? 2 : 3;
            rows = (number - 1) / cols + 1;
            
            for (NSInteger i = 0; i <= rows - 1; i++) {
                
                for (NSInteger j = 0; j <= cols - 1; j++) {
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                    [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][countNumber++][@"imgurl"]]]];
                    
                    [pictureView addSubview:iv];
                    
                }
                
            }
        }
        else if (number == 1 || number == 2) {
            cols = number % 3;
            rows = number / 3;
            
            for (NSInteger i = 0; i <= cols - 1; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * KPictureOrignX, 0, KPictureSize, KPictureSize)];
                
                [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][countNumber++][@"imgurl"]]]];
                
                [pictureView addSubview:iv];
            }
            
        }
        else if (number == 5 || number == 7 || number == 8) {
            cols = number % 3;
            rows = number / 3;
            
            //当一行3个的数量为2
            if (rows / 2) {
                
                for (NSInteger i = 0; i <= rows; i++) {
                    
                    //前两行
                    if (i < 2) {
                        for (NSInteger j = 0; j < 3; j++) {
                            
                            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                            
                            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][countNumber++][@"imgurl"]]]];
                            [pictureView addSubview:iv];
                        }
                    }
                    //后一行
                    else {
                        for (NSInteger j = 0; j < cols; j++) {
                            
                            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                            
                            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][countNumber++][@"imgurl"]]]];
                            [pictureView addSubview:iv];
                        }
                    }
                    
                }
                
            }
            else {
                
                for (NSInteger i = 0; i <= rows; i++) {
                    for (NSInteger j = 0; j < 3 - i; j++) {
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                        
                        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,model.ImgList[@"ds"][countNumber++][@"imgurl"]]]];
                        [pictureView addSubview:iv];
                    }
                }
                
            }
            
        }
    }
    
    return pictureView;
}

+ (UIView *)createPictureViewWithCGRect:(CGRect)rect AndArray:(NSArray *)picArr {
    UIView *pictureView = [[UIView alloc] init];
    
    NSInteger number = [picArr count];
    NSInteger countNumber = 0;
    
    if (number) {
        
        pictureView.frame = rect;
        
        NSUInteger cols;
        NSUInteger rows;
        
        //根据图片数量进行判断
        if (number == 3 || number == 4 || number == 6 || number == 9) {
            cols = number == 4 ? 2 : 3;
            rows = (number - 1) / cols + 1;
            
            for (NSInteger i = 0; i <= rows - 1; i++) {
                
                for (NSInteger j = 0; j <= cols - 1; j++) {
                    
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                    [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,picArr[countNumber++][@"imgurl"]]]];
                    
                    [pictureView addSubview:iv];
                    
                }
                
            }
        }
        else if (number == 1 || number == 2) {
            cols = number % 3;
            rows = number / 3;
            
            for (NSInteger i = 0; i <= cols - 1; i++) {
                UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(i * KPictureOrignX, 0, KPictureSize, KPictureSize)];
                
                [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,picArr[countNumber++][@"imgurl"]]]];
                
                [pictureView addSubview:iv];
            }
            
        }
        else if (number == 5 || number == 7 || number == 8) {
            cols = number % 3;
            rows = number / 3;
            
            //当一行3个的数量为2
            if (rows / 2) {
                
                for (NSInteger i = 0; i <= rows; i++) {
                    
                    //前两行
                    if (i < 2) {
                        for (NSInteger j = 0; j < 3; j++) {
                            
                            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                            
                            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,picArr[countNumber++][@"imgurl"]]]];
                            
                            [pictureView addSubview:iv];
                        }
                    }
                    //后一行
                    else {
                        for (NSInteger j = 0; j < cols; j++) {
                            
                            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                            
                            iv.image = [UIImage imageNamed:@"1.jpg"];
                            [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,picArr[countNumber++][@"imgurl"]]]];
                            
                            [pictureView addSubview:iv];
                        }
                    }
                    
                }
                
            }
            else {
                
                for (NSInteger i = 0; i <= rows; i++) {
                    for (NSInteger j = 0; j < 3 - i; j++) {
                        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(j * KPictureOrignX, i * KpictureOrignY, KPictureSize, KPictureSize)];
                        
                        [iv sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KMainInterface,picArr[countNumber++][@"imgurl"]]]];
                        
                        [pictureView addSubview:iv];
                    }
                }
                
            }
            
        }
    }
    
    return pictureView;
}


@end
