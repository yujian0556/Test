//
//  ZRTBannerView.m
//  yiduoduo
//
//  Created by moyifan on 15/9/28.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTBannerView.h"

@interface ZRTBannerView ()<UIWebViewDelegate>

@end


@implementation ZRTBannerView
{

    UIWebView *_myWebView;
    UIProgressView *_prograss;

}

-(void)viewDidLoad
{

    [super viewDidLoad];

   
    
    
    
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _prograss = [[UIProgressView alloc] initWithFrame:barFrame];
    
    _prograss.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
//    [_prograss setProgress:0 animated:YES];
    

    
    _prograss.progressTintColor = [UIColor whiteColor];
    
   

    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    
    _myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0,self.view.width,KScreenHeight-64)];
    
    _myWebView.delegate = self;
    
    
    [self setUpNavBar];  // 设置导航条
    
  
    [_myWebView loadRequest:req];
    
    [self.view addSubview:_myWebView];
    [self.navigationController.navigationBar addSubview:_prograss];

    
}


#pragma mark 改变导航条返回按钮
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationController.title = self.title;
    
}

- (void)back
{
  
    
    [self.navigationController popViewControllerAnimated:YES];
    
  
}




#pragma mark webview代理方法


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
   
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{

    [_prograss setProgress:0 animated:NO];

}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"hello");
    
    [_prograss setProgress:100 animated:NO];
    
    [_prograss removeFromSuperview];

}



@end
