//
//  ZRTProvisionViewController.m
//  yiduoduo
//
//  Created by olivier on 15/8/6.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTProvisionViewController.h"


@interface ZRTProvisionViewController ()

@end

#define imageHeight self.isReport? KScreenHeight : 3361/2

@implementation ZRTProvisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self setNavigationBar];

}

- (void)createUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 69)];
    sc.contentSize = CGSizeMake(KScreenWidth, imageHeight);
    
    UIImage *source;
    if (self.isReport) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"举报须知" ofType:@"jpg"];
        source = [UIImage imageWithContentsOfFile:filePath];
    }
    else {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"条款" ofType:@"jpg"];
        source = [UIImage imageWithContentsOfFile:filePath];
    }
    
    UIImageView *provisionIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, imageHeight)];
    provisionIV.image = source;
    
    [self.view addSubview:sc];
    [sc addSubview:provisionIV];
}

- (void)setNavigationBar {
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
    
}

- (void)didClickLeft {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
