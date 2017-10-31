//
//  ZRTCommentController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/8/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCommentController.h"
#import "ZRTTextView.h"
#import "AFNetworking.h"
#import "ZRTCaseModel.h"
#import "MBProgressHUD+MJ.h"
#import "ZRTVideoModel.h"

@interface ZRTCommentController ()<UITextViewDelegate>


@property (nonatomic, strong) UIBarButtonItem *compose;

@property (nonatomic, weak) ZRTTextView *textView;

@end

@implementation ZRTCommentController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_textView becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_textView resignFirstResponder];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_textView resignFirstResponder];
    
}





- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpNavgationBar];
    
    // 添加textView
    [self setUpTextView];
    
    
}



#pragma mark - 添加textView
- (void)setUpTextView
{
    
    ZRTTextView *textView = [[ZRTTextView alloc] initWithFrame:self.view.bounds];
    
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    
    textView.placeHolder = @"写评论……";
    
    _textView = textView;
    [self.view addSubview:textView];
}


#pragma mark textview代理方法

- (void)textViewDidChange:(UITextView *)textView
{
    // 控制器发送按钮允许点击
    _compose.enabled = textView.text.length;
    
    ZRTTextView *textV = (ZRTTextView *)textView;
    
    textV.isHidePlaceHolder =  textView.text.length;
    
}






#define dismissColor [UIColor colorWithRed:255/256.0 green:81/256.0 blue:81/256.0 alpha:1]
#define disabledColor [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1]
- (void)setUpNavgationBar
{
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    
    // 左边:取消
    
    UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:dismissColor forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    
    [dismissBtn sizeToFit];
    UIBarButtonItem *dismiss = [[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
    
    
    self.navigationItem.leftBarButtonItem = dismiss;
    
    
    
    
    
    // 右边
    UIButton *composeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeBtn setTitle:@"发送" forState:UIControlStateNormal];
    [composeBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    [composeBtn setTitleColor:disabledColor forState:UIControlStateDisabled];
    
    if (self.isCase) {
        
        [composeBtn addTarget:self action:@selector(composeStatus) forControlEvents:UIControlEventTouchUpInside];
    
    }else{
    
        [composeBtn addTarget:self action:@selector(composeStatusWithVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [composeBtn sizeToFit];
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithCustomView:composeBtn];
    
    _compose = compose;
    compose.enabled = NO;
    self.navigationItem.rightBarButtonItem = compose;
    // 标题
    self.title = @"发表评论";
}



// 点击取消的时候调用
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



// 点击发送的时候调用
- (void)composeStatus
{

    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/PubCaseReply";
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *CaseID = self.model.Id;
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:url parameters:@{@"UserID":UserID,@"CaseID":CaseID,@"Content":self.textView.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
      
        [self dismiss];
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        
        NSString *success = [jsonDict objectForKey:@"Success"];
        
        
      //  NSLog(@" %@",jsonDict);
        
        if ([self.delegate respondsToSelector:@selector(commentReload)]) {
            
            [self.delegate commentReload];
        }
        
        
        if ([success isEqualToString:@"1"]) {
            
            [MBProgressHUD showSuccess:@"发布成功"];
        }else{
            
            [MBProgressHUD showError:@"您已发布评论"];
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(commentReload)]) {
            
            [self.delegate commentReload];
        }
        
        [MBProgressHUD showError:@"发布失败"];
        
    }];
    
    
    
}




-(void)setModel:(ZRTCaseModel *)model
{
    _model = model;

    
}





// 点击视频发送的时候调用
- (void)composeStatusWithVideo
{
    
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Video.asmx/SendVideoEvaluation";
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *VideoID = self.videoModel.Id;
    
    
    NSLog(@" %@ %@ %@ ",VideoID,UserID,self.textView.text);
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:url parameters:@{@"VideoId":VideoID,@"UserId":UserID,@"Content":self.textView.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        [self dismiss];
 
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
   
        
        NSString *success = [jsonDict objectForKey:@"Success"];
        
        if ([self.delegate respondsToSelector:@selector(commentReload)]) {
            
            [self.delegate commentReload];
        }

        
        if ([success isEqualToString:@"1"]) {
            
            [MBProgressHUD showSuccess:@"发布成功"];
        }else{
        
            [MBProgressHUD showError:@"您已发布评论"];
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(commentReload)]) {
            
            [self.delegate commentReload];
        }
        
        
        [MBProgressHUD showError:@"发布失败"];
        
    }];
    
    
    
}






-(void)setVideoModel:(ZRTVideoModel *)videoModel
{


    _videoModel = videoModel;


}




- (NSDictionary *)StringToJsonDictWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
