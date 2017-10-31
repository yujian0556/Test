//
//  ZRTCompileController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCompileController.h"

#import "MLSelectPhotoPickerViewController.h"

#import "MLSelectPhotoAssets.h"

#import "ZRTUploadView.h"
#import "OZHNetWork.h"
#import "AFNetworking.h"

//#import "YFComposePara.h"
//#import "YFUploadParam.h"
#import "MJExtension.h"

#import "AFNetworking.h"

#import "ZRTHealthyModel.h"
#import "MBProgressHUD+MJ.h"

#import "Interface.h"

#import "UIImageView+WebCache.h"
#import "ZRTHealthyController.h"

#define margin 20
#define kImagesMargin 15

/**
 *
 
 // Use
 ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
 // 默认显示相册里面的内容SavePhotos
 pickerVc.status = PickerViewShowStatusCameraRoll;
 // 选择图片的最小数，默认是9张图片
 pickerVc.minCount = 4;
 // 设置代理回调
 pickerVc.delegate = self;
 // 展示控制器
 [pickerVc show];
 
 第一种回调方法：- (void)pickerViewControllerDoneAsstes:(NSArray *)assets
 第二种回调方法pickerVc.callBack = ^(NSArray *assets){
 // TODO 回调结果，可以不用实现代理
 };
 
 
 // alloc
 import "MLSelectPhotoPickerViewController.h"
 
 MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
 // Default Push CameraRoll
 pickerVc.status = PickerViewShowStatusCameraRoll;
 // Limit Count.
 pickerVc.minCount = 9;
 // Push
 [pickerVc show];
 __weak typeof(self) weakSelf = self;
 pickerVc.callBack = ^(NSArray *assets){
 // CallBack or Delegate
 [weakSelf.assets addObjectsFromArray:assets];
 [weakSelf.tableView reloadData];
 }
 
 
 */


#define KBGColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]

@interface ZRTCompileController ()<ZLPhotoPickerViewControllerDelegate,ZRTUploadViewDelegete,UIScrollViewDelegate>


@property (nonatomic,strong) MLSelectPhotoPickerViewController *pickerVc;

@property (nonatomic,strong) MLSelectPhotoAssets *asset;

@property (nonatomic,assign) CGFloat font;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *btn;  // 上传图片button

@property (nonatomic,strong) UILabel *titleLabel;  // 标题


@property (nonatomic,strong) UITextView *titleView;  // 标题的view

@property (nonatomic,strong) UITextView *motifView;  // 主述的view
@property (nonatomic,strong) UITextView *remarkView;  // 备注内容


@property (nonatomic, strong) NSMutableArray *photoItemArray;


@property (nonatomic,strong) ZRTUploadView *UploadView;

@property (nonatomic,strong) UIView *upload;



@property (nonatomic,strong) UILabel *remark;  // 备注

@property (nonatomic,strong) UIButton *submit;  // 提交

@property (nonatomic,assign) CGFloat submitH;


@property (nonatomic,strong) UIImage *postImage;

@property (nonatomic,strong) id rootViewController; //存放弹出照片选择器的控制器


@end

@implementation ZRTCompileController
{
    NSMutableArray *_imageArr;
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = KBGColor;
    
    [self OSD];
    
    [self createArray];
    
    [self setUpNavBar];
    
    
    [self setUpScrollView];
    
    
    [self setUpAllView];
    
    

}

- (void)createArray {
    
    _imageArr = [[NSMutableArray alloc] init];
    
    self.photoItemArray = [[NSMutableArray alloc] init];
    
}


#pragma mark 屏幕适配
-(void)OSD
{
    
    if (KScreenHeight == 480) {  // 4s
        
        _font = 16;
        _submitH = 30;
        
    }else if (KScreenHeight == 568){  // 5s
        _font = 16;
        _submitH = 40;
        
    }else if (KScreenHeight == 667){  // 6
        
        _font = 20;
        
        _submitH = 50;
        
    }else{  // 6p
        
        _font = 20;
        
        _submitH = 50;
    }
    
    
}




#pragma  mark 设置导航栏按钮
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"健康档案";
    
    
    self.navigationItem.rightBarButtonItem = nil;
  
    
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark 添加滚动区域

-(void)setUpScrollView
{

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    
    [self.view addSubview:self.scrollView];


}




#pragma mark 布局子控件
-(void)setUpAllView
{
    
    
    // 标题
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, 100, 100)];
    
    [self.scrollView addSubview:self.titleLabel];
    
    self.titleLabel.text = @"标题 ";
    
    self.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.titleLabel sizeToFit];
    
    CGFloat titleW = self.titleLabel.width;
    CGFloat titleH = self.titleLabel.height;
    
    self.titleLabel.frame = CGRectMake(margin, margin*2, titleW, titleH);
    
  //  NSLog(@"title %@",NSStringFromCGRect(title.frame));
    
    
    // 标题内容
    
    self.titleView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+margin*0.5, CGRectGetMinX(self.titleLabel.frame), 200, self.titleLabel.height*2)];
    
    self.titleView.center = self.titleLabel.center;
    
    self.titleView.backgroundColor = [UIColor whiteColor];
    
    self.titleView.layer.cornerRadius = 8;
    
    CGFloat titleViewW = self.view.width - CGRectGetMaxX(self.titleLabel.frame)+margin*0.5 - margin*2;
    
    
    self.titleView.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+margin*0.5, self.titleView.y, titleViewW, self.titleLabel.height*2);
    
    self.titleView.font = [UIFont systemFontOfSize:self.font-2];
    
    
    [self.scrollView addSubview:self.titleView];
    
  //  NSLog(@"%@",NSStringFromCGRect(titleView.frame));
    
    
    
    // 主述内容
    
    self.motifView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleView.frame), CGRectGetMaxY(self.titleView.frame)+margin,self.titleView.width, self.titleView.height*3)];
    
    self.motifView.backgroundColor = [UIColor whiteColor];
    
    self.motifView.layer.cornerRadius = 8;
    
    self.motifView.font = [UIFont systemFontOfSize:self.font-2];
    
    [self.scrollView addSubview:self.motifView];
    
    
   // 主述
    
    UILabel *motif = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMinY(self.motifView.frame)+margin*0.5, titleW+10, titleH)];
    
   
    
    motif.font = [UIFont systemFontOfSize:self.font];
    
    motif.textColor = KdeleteColor;
    
    
    
     NSString *title = @"*";
    
  // 星
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"主述 %@",title]];
    
    
    NSRange redRange = NSMakeRange(0, [[titleStr string] rangeOfString:@" "].location +1);
    
    
    [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor     ] range:redRange];
    [motif setAttributedText:titleStr] ;
    
    
    [self.scrollView addSubview:motif];
    
    
   // 上传图片
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(self.motifView.x, CGRectGetMaxY(self.motifView.frame)+margin, 150, 50)];
    
    [self.scrollView addSubview:self.btn];
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"pic"]  forState:UIControlStateNormal];
    
    [self.btn setTitle:@"上传图片" forState:UIControlStateNormal];
    
    self.btn.titleLabel.font = [UIFont systemFontOfSize:self.font-1];
    
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.btn sizeToFit];
    
    
    CGFloat btnW;
    CGFloat btnH;
    
    if (KScreenHeight == 480) {  // 4s
        
        btnW = self.btn.width *0.9;
        btnH = self.btn.height *0.9;
        
    }else if (KScreenHeight == 568){  // 5s
        
        btnW = self.btn.width ;
        btnH = self.btn.height ;
        
    }else if (KScreenHeight == 667){  // 6
        
        btnW = self.btn.width *1.1;
        btnH = self.btn.height *1.1;
        
    }else{  // 6p
        
       
        btnW = self.btn.width *1.2;
        btnH = self.btn.height *1.2;
        
    }
    
    
    
    
    
    [self.btn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn.frame = CGRectMake(self.motifView.x, CGRectGetMaxY(self.motifView.frame)+margin, btnW , btnH);
    
   
//    NSLog(@"%@",NSStringFromCGRect(btn.frame));
    
    
   // 图片
    
    UILabel *image = [[UILabel alloc] initWithFrame:CGRectMake(motif.x, 10, titleW, titleH)];
    
    [self.scrollView addSubview:image];
    
    image.center = self.btn.center;
    
    image.text = @"图片 ";
    
    image.font = [UIFont systemFontOfSize:self.font];
    
    CGFloat iamgeY = image.y;
    
    image.frame = CGRectMake(motif.x, iamgeY, titleW, titleH);
    
   
    
   // 图片View
    
    self.upload = [[UIView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.btn.frame)+margin, self.titleView.width, 0)];
    

    
    [self.scrollView addSubview:self.upload];
    
    
    self.UploadView = [[ZRTUploadView alloc] init];
    
    self.UploadView.delegete = self;
    
    [self.upload addSubview:self.UploadView];
   
    
    
  // 备注内容
    
    self.remarkView = [[UITextView alloc] initWithFrame:CGRectMake(self.btn.x, CGRectGetMaxY(self.upload.frame)+margin,self.titleView.width, self.titleView.height*2)];

    
    self.remarkView.backgroundColor = [UIColor whiteColor];
    
    self.remarkView.layer.cornerRadius = 8;
    
    self.remarkView.font = [UIFont systemFontOfSize:self.font-2];
    
    [self.scrollView addSubview:self.remarkView];
    
    
 // 备注

    self.remark = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.x, CGRectGetMinY(self.remarkView.frame)+margin*0.5, titleW, titleH)];
    
    self.remark.text = @"备注 ";
    
    self.remark.font = [UIFont systemFontOfSize:self.font];
    
    [self.scrollView addSubview:self.remark];
    
    
//    NSLog(@"remarkView %@",NSStringFromCGRect(self.remarkView.frame));
//    
//    NSLog(@"remark %@",NSStringFromCGRect(self.remark.frame));
    
    
    
    
  //  提交按钮
    
    
    self.submit = [[UIButton alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.remarkView.frame)+86, self.view.width - margin*2, self.submitH)];
    
    [self.scrollView addSubview:self.submit];
    
    
    [self.submit setBackgroundImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    
    [self.submit setTitle:@"提交" forState:UIControlStateNormal];
    
    self.submit.titleLabel.font = [UIFont systemFontOfSize:self.font+2];
    
    [self.submit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.submit sizeToFit];
    
    
    
    CGFloat submitH ;
    
    if (KScreenHeight == 480) {  // 4s
        
        
        submitH = self.submit.height *0.8;
        
    }else if (KScreenHeight == 568){  // 5s
        
        
        submitH = self.submit.height ;
        
    }else if (KScreenHeight == 667){  // 6
        
        
        submitH = self.submit.height ;
        
    }else{  // 6p
        
        
       
        submitH = self.submit.height *1.2;
        
    }
    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.remarkView.frame)+86, self.view.width - margin*2, submitH);
    
    
    [self.submit addTarget:self action:@selector(didSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    
    
  // 设置滚动区域
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128);
    
    
    const id root = [[[UIApplication sharedApplication].windows firstObject] rootViewController];
    
    
    self.rootViewController = root;
    
    

    [self changeHealthyDataView];
    
}

/**
 设置编辑
 */
- (void)changeHealthyDataView {
    if (self.isCompile) {
        
        //NSLog(@"%@",self.compileDict);
        
        
        self.titleView.text = self.compileDict[@"titleContent"];
        self.motifView.text = self.compileDict[@"motifTitle"];
        self.remarkView.text = self.compileDict[@"remarkLabel"];
        
        
        [self.compileDict[@"imgArray"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            
            UIImage *image = [self returnImageWithUrl:[NSString stringWithFormat:@"%@%@",KMainInterface,obj]];
            
            [self.photoItemArray addObject:image];
            
            [_imageArr addObject:image];
        }];
        
        
        self.UploadView.photoItemArray = self.photoItemArray;
        
        
    }
}

- (UIImage *)returnImageWithUrl:(NSString *)urlString {
    UIImageView *iv = [[UIImageView alloc] init];
    
    [iv sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
    
    return iv.image;
}


#pragma mark 点击上传图片
-(void)didClickBtn
{

 //   NSLog(@"click %ld ",self.UploadView.photoItemArray.count);
    
 //   NSLog(@"上传");
    
    self.pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    
    // 设置代理回调
    self.pickerVc.delegate = self;
    
    self.pickerVc.status = PickerViewShowStatusCameraRoll;
    
    self.pickerVc.minCount = 9 - self.UploadView.subviews.count;
    // 展示控制器
    [self.pickerVc showWithWindow:self.rootViewController];


}




#pragma mark 相册选择的代理方法
- (void) pickerViewControllerDoneAsstes : (NSArray *) assets
{

 //   NSLog(@"%@",assets);
    self.photoItemArray = nil;
    
 //   MLSelectPhotoAssets *asset = assets[0];
    
    
    
    for (MLSelectPhotoAssets *asset in assets) {
        
       
        
        [self.photoItemArray addObject:asset.thumbImage];
        
        [_imageArr addObject:asset.originImage];
    }
    
    // 赋值
    self.UploadView.photoItemArray = self.photoItemArray;
    
  
    long imageCount = self.UploadView.subviews.count;
    
   
    
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    CGFloat h = 80;
    
    CGFloat high =  totalRowCount * (kImagesMargin + h);
    
//    NSLog(@"iamgecount %ld",imageCount);
//    NSLog(@"high %f",high);
    
    
    self.upload.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(self.btn.frame)+margin, self.view.width, high);
    
   
    
 //   NSLog(@"upload %@",NSStringFromCGRect(self.upload.frame));
    
    self.remarkView.frame = CGRectMake(self.btn.x, CGRectGetMaxY(self.upload.frame)+margin,self.titleView.width, self.titleView.height*2);
    
    self.remark.frame = CGRectMake(self.titleLabel.x, CGRectGetMinY(self.remarkView.frame)+margin*0.5, self.titleLabel.width, self.titleLabel.height);
    
    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.remarkView.frame)+86, self.view.width - margin*2, self.submitH);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128);
    
    
    
    [self.view reloadInputViews];
    
    
//    NSLog(@"remarkView %@",NSStringFromCGRect(self.remarkView.frame));
//    
//    NSLog(@"remark %@",NSStringFromCGRect(self.remark.frame));
    
    
   //  NSLog(@"submit %@",NSStringFromCGRect(self.submit.frame));
    
   

}



#pragma mark 上传图片view的代理方法

-(void)changeFrame:(CGFloat)maxY
{

    
//    long imageCount = self.UploadView.subviews.count;
//    
//     NSLog(@" %ld",imageCount);
//    
//    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
//    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
//    int totalRowCount = ceil(imageCount / perRowImageCountF);
//    
//    CGFloat h = 80;
//    
//    CGFloat high =  totalRowCount * (kImagesMargin + h);
//    
//    NSLog(@"high %f",high);
    
    self.upload.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(self.btn.frame)+margin, self.view.width, maxY);
    
    
    
    self.remarkView.frame = CGRectMake(self.btn.x, CGRectGetMaxY(self.upload.frame)+margin,self.titleView.width, self.titleView.height*2);
    
    self.remark.frame = CGRectMake(self.titleLabel.x, CGRectGetMinY(self.remarkView.frame)+margin*0.5, self.titleLabel.width, self.titleLabel.height);
    
    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.remarkView.frame)+86, self.view.width - margin*2, self.submitH);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128);
    
    
    
    [self.view reloadInputViews];

}
#pragma mark - 删除图片数组项目的代理方法
- (void)deleteObjectInPhotoArray:(NSInteger)index {
    
    [_imageArr removeObjectAtIndex:index];
}

#pragma mark 点击提交按钮
-(void)didSubmit
{
   
    if (!self.isCompile) {
        
        
        if ([self.motifView.text isEqualToString:@""]) {
            
            [MBProgressHUD showMessage:@"您输入的内容为空"];
            
            [self performSelector:@selector(hide) withObject:nil afterDelay:1.0f];
            
            return;
            
        }
        
        
        if ([self.delegate respondsToSelector:@selector(Compose)]) {
            
            [self.delegate Compose];
        }
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
        [self performSelector:@selector(send) withObject:nil afterDelay:0.1f];
        
    }
    else {
        
        
        NSLog(@"进入编辑");
        
        if ([self.motifView.text isEqualToString:@""]) {
            
            [MBProgressHUD showMessage:@"您输入的内容为空"];
            
            [self performSelector:@selector(hide) withObject:nil afterDelay:1.0f];
            
            return;
            
        }
        
    
        if ([self.delegate respondsToSelector:@selector(Compose)]) {
            
            [self.delegate Compose];
        }
        
        
        
        
        [self.navigationController popViewControllerAnimated:NO];
        
        if ([self.delegate respondsToSelector:@selector(backFromChangeHealthyData)]) {
            
            [self.delegate backFromChangeHealthyData];
        }
        
        [self performSelector:@selector(changeHealthyData) withObject:nil afterDelay:0.1f];
        
        
    }
    
    
}

- (void)changeHealthyData {
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    [_imageArr enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
        
        NSData *imageData = UIImageJPEGRepresentation(obj, 0.01);
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions: 0];
        
        if (idx == _imageArr.count) {
            [mutableString appendString:encodedImageStr];
        }
        else {
            [mutableString appendFormat:@"%@,",encodedImageStr];
        }
        
    }];
    
    NSLog(@" %@",_imageArr);
    
    
    [[OZHNetWork sharedNetworkTools] changeHealthyDataWithHealthyID:self.compileDict[@"HealthyId"] andUserID:[DEFAULT objectForKey:@"UserDict"][@"Id"] andTitle:self.titleView.text andContent:self.motifView.text andImg:mutableString andRemark:self.remarkView.text andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
      //  NSLog(@"--> %@",jsonDict);
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
            
            NSLog(@"编辑成功");
            
            if ([self.delegate respondsToSelector:@selector(CompileReloadData)] ) {
                
                [self.delegate CompileReloadData];
                
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CompileReload" object:self];
            
            
        }
        
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        
        NSLog(@"修改健康档案 error == %@",error);
        
        if ([self.delegate respondsToSelector:@selector(CompileComposefailure)]) {
            
            [self.delegate CompileComposefailure];
        }
        
        
        
    }];
    
}


#pragma mark 发布的网络请求

-(void)send
{

    NSString *urlString = @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/AddCon";
    
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    [_imageArr enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL *stop) {
        
        //        UIImage *smallImg = [self reduceImage:obj percent:0.5f];
        //已经压缩过了,不用进行压缩
        NSData *imageData = UIImageJPEGRepresentation(obj, 0.01);
        NSString *encodedImageStr = [imageData base64EncodedStringWithOptions: 0];
        
        if (idx == _imageArr.count) {
            [mutableString appendString:encodedImageStr];
        }
        else {
            [mutableString appendFormat:@"%@,",encodedImageStr];
        }
        
    }];
    
    
 
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:@{@"UserID":[DEFAULT objectForKey:@"UserDict"][@"Id"],@"Title":self.titleView.text,@"Content":self.motifView.text,@"Img":mutableString,@"Remark":self.remarkView.text} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(ComposeSuccess)] ) {
            
            [self.delegate ComposeSuccess];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"失败");
        
        if ([self.delegate respondsToSelector:@selector(Composefailure)] ) {
            
            [self.delegate Composefailure];
            
        }
        

    }];


}






#pragma mark - 图片压缩
//压缩图片质量
- (UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}


#pragma mark 隐藏窗口
-(void)hide
{
    
    [MBProgressHUD hideHUD];
}



#pragma mark 懒加载


-(NSMutableArray *)photoItemArray
{

    if (!_photoItemArray) {
        
        _photoItemArray = [[NSMutableArray alloc] init];
        
    }


    return _photoItemArray;
}



#pragma mark 取消键盘响应

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    [self.titleView resignFirstResponder];
    [self.motifView resignFirstResponder];
    [self.remarkView resignFirstResponder];
}






@end
