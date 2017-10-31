//
//  ZRTNewsDetailController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/18.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTNewsDetailController.h"
#import "ZRTNewsDetailModel.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"

#define margin 10

@interface ZRTNewsDetailController ()


@property (nonatomic,strong) UIScrollView *newsView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *timeLable;

@property (nonatomic,strong) UIImageView *newsImage;

@property (nonatomic,strong) UILabel *newsText;


//@property (strong, nonatomic) UIWebView *webView;

//@property (nonatomic,strong) NSURL *url;

@end



@implementation ZRTNewsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    
//   
//    
//    self.webView.delegate = self;
    
    
   
    
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpScrollView];
    

    [self setUpNavBar];
    

    [self setUpTitle];
    
    [self setUpTime];
    
    [self setUpImage];
    
    
    [self setUpTextView];
    
//    
//     [self.view addSubview:self.webView];
//    
//   
//    NSURLRequest *reqest = [NSURLRequest requestWithURL:self.url];
//    [self.webView loadRequest:reqest];
//    
    

    
}


-(void)setUpScrollView
{

    self.newsView = [[UIScrollView alloc] initWithFrame:self.view.frame];

//    self.newsView.contentSize =
    
    self.newsView.showsVerticalScrollIndicator = NO;
    self.newsView.showsHorizontalScrollIndicator = NO;


    [self.view addSubview:self.newsView];

}





-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)setUpTitle
{

    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin *2, self.view.width - margin*2, 60)];

    [self.titleLable setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    
  //  self.titleLable.font = [UIFont systemFontOfSize:25];
    
    self.titleLable.numberOfLines = 0;

    

    [self.newsView addSubview:self.titleLable];
    
    
  //   self.titleLable.text = self.model.head[@"title"];

}




-(void)setUpTime
{

    self.timeLable = [[UILabel alloc] initWithFrame:CGRectMake(margin + 5, CGRectGetMaxY(self.titleLable.frame) +margin, self.view.width - margin*2, 20)];
    
    self.timeLable.textColor = [UIColor lightGrayColor];

    
    self.timeLable.numberOfLines = 0;
    
    self.timeLable.font = [UIFont systemFontOfSize:16];
    
    
    
    [self.newsView addSubview:self.timeLable];
    
    
  //   self.timeLable.text = self.model.head[@"time"];
}




-(void)setUpImage
{
    
    CGFloat height = (self.view.width - margin*2) /16 *9;
    

    self.newsImage = [[UIImageView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.timeLable.frame)+margin, self.view.width - margin*2, height)];


    


    [self.newsView addSubview:self.newsImage];
    
  //    self.newsImage.image = [UIImage imageNamed:@"pic_03"];


}


#warning frame需要重新设置
-(void)setUpTextView
{
 
    self.newsText = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.newsImage.frame)+margin, self.view.width - margin*2, 20)];
    
    self.newsText.font = [UIFont systemFontOfSize:20];
    
    
    self.newsText.userInteractionEnabled = NO;

    [self.newsView addSubview:self.newsText];
  
    
//    //NSLog(@"text %@",NSStringFromCGRect(self.newsText.frame));
//    
//    //NSLog(@"max %f",CGRectGetMaxY(self.newsText.frame));
    
    
    

}







-(void)setModel:(ZRTNewsCellModel *)model
{

    _model = model;
    

    
    [self getNewsDetailListWithId:model.Id];
    
    
//    NSString *url = @"http://www.baidu.com";
//   
//    self.url = [NSURL URLWithString:url];
    
    
    
}



#pragma mark web代理方法
//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//
//    ////NSLog(@"start");
//
//}
//
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
//{
//
//    //NSLog(@"%@",error);
//
//}



#pragma mark 处理新闻详情网络
- (void)getNewsDetailListWithId:(NSString *)Id
{
    [[OZHNetWork sharedNetworkTools] getNewsDataWithId:Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
    
      //  //NSLog(@"dict %@",jsonDict[@"ds"][0]);
        
        
        
      
        [self makeModelWithDictionary:jsonDict[@"ds"][0]];
        
        
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        
        [MBProgressHUD showSuccess:@"网络连接失败"];
        
    }];
    
    
    
}


-(void)makeModelWithDictionary:(NSDictionary *)Dict
{
    
    ZRTNewsDetailModel *model = [ZRTNewsDetailModel newsModelWithDict:Dict];

    self.titleLable.text = model.title;

    self.timeLable.text = model.add_time;
    
    NSString *path = [NSString stringWithFormat:@"http://www.yddmi.com%@",model.img_url];
    
  //  //NSLog(@"path %@",path);
    
    [self.newsImage sd_setImageWithURL:[NSURL URLWithString:path]];
    
   
    NSString *text = model.content;
    
    text = [text stringByReplacingOccurrencesOfString:@"huiche" withString:@"\n"];
    text = [text stringByReplacingOccurrencesOfString:@"kongge" withString:@"\r"];
    
    self.newsText.text = text;
    
    
//     self.newsText.text = @"“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的，一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的，一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的，一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的，一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的“一个烟雾缭绕的海岛，一个无人居住的荒村，一个绿野仙踪的梦境，谁来与我相遇”。近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的近日，网友“青简”拍摄的";
    self.newsText.numberOfLines = 0;
    
    
    [self.newsText sizeToFit];
    
    
    CGSize size = CGSizeMake(self.view.width, CGRectGetMaxY(self.newsText.frame) +44 +margin*2);
    
    self.newsView.contentSize = size;
    
    
    
    

}





@end
