//
//  ZRTComposeController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/22.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTComposeController.h"

#import "ZRTUploadView.h"

#import "MLSelectPhotoPickerViewController.h"

#import "MLSelectPhotoAssets.h"

#import "AFNetworking.h"

#import "ZRTSelectorController.h"

#import "ZRTSelectModel.h"

#import "MBProgressHUD+MJ.h"



#define KBGColor [UIColor colorWithRed:237/256.0 green:237/256.0 blue:237/256.0 alpha:1]

#define margin 16

#define kImagesMargin 15

@interface ZRTComposeController ()<UIScrollViewDelegate,ZRTUploadViewDelegete,ZLPhotoPickerViewControllerDelegate,ZRTSelectorControllerDelegate>


@property (nonatomic,assign) CGFloat submitH;

@property (nonatomic,assign) CGFloat font;

@property (nonatomic,strong) UILabel *officeTitle;

@property (nonatomic,strong) UIButton *officeBtn;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UITextView *contentView;

@property (nonatomic,strong) UILabel *contentLabel;

@property (nonatomic,strong) UIButton *btn;  // 上传图片button

@property (nonatomic,strong) UIView *upload;

@property (nonatomic,strong) ZRTUploadView *UploadView;

@property (nonatomic,strong) MLSelectPhotoPickerViewController *pickerVc;

@property (nonatomic,strong) MLSelectPhotoAssets *asset;

@property (nonatomic,strong) UIButton *submit;  // 提交

@property (nonatomic, strong) NSMutableArray *photoItemArray;

@property (nonatomic,strong) NSMutableArray *arr;

@property (nonatomic,strong) NSString *selectTitle;

@property (nonatomic,strong) NSString *ClassId;

@property (nonatomic,strong) id rootViewController;  ////存放弹出照片选择器的控制器


@end

@implementation ZRTComposeController

{
    NSMutableArray *_imageArr;
}




- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor = KBGColor;
    
    
    [self OSD];
    
    
    [self setUpNavBar];
    
    [self setUpScrollView];
    
    
    [self setUpSubviews];

    [self keshi];
    
    _imageArr = [[NSMutableArray alloc] init];

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
        
        _font = 22;
        
        _submitH = 50;
    }
    
    
}

#pragma  mark 设置导航栏按钮
-(void)setUpNavBar
{
    
    
   
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    
    self.navigationItem.title = @"发布问题";
    
    
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

-(void)setUpSubviews
{

    [self setoffice];
    
    [self setContent];
    
    [self setImage];
    
    [self setIssue];


}




#pragma mark 设置科室

-(void)setoffice
{

    // 科室
    
    self.officeTitle = [[UILabel alloc] initWithFrame:CGRectMake(margin, margin, 100, 100)];
    
    [self.scrollView addSubview:self.officeTitle];
    
    self.officeTitle.text = @"科室 ";
    
    self.officeTitle.font = [UIFont systemFontOfSize:self.font];
    
    [self.officeTitle sizeToFit];
    
    CGFloat titleW = self.officeTitle.width;
    CGFloat titleH = self.officeTitle.height;
    
    self.officeTitle.frame = CGRectMake(margin, margin*2, titleW, titleH);
    
    //  //NSLog(@"title %@",NSStringFromCGRect(title.frame));
    
    
    // 内容
    
    self.officeBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.officeTitle.frame)+margin*0.5, CGRectGetMinX(self.officeTitle.frame), 200, self.officeTitle.height*2)];
    
    self.officeBtn.center = self.officeTitle.center;
 
    
    self.officeBtn.backgroundColor = [UIColor whiteColor];
    
    self.officeBtn.layer.cornerRadius = 8;
    
    CGFloat titleViewW = self.view.width - CGRectGetMaxX(self.officeTitle.frame)+margin*0.5 - margin*2;
    
    
    self.officeBtn.frame = CGRectMake(CGRectGetMaxX(self.officeTitle.frame)+margin*0.5, self.officeBtn.y, titleViewW, self.officeTitle.height*2);
    
    [self.officeBtn setTitle:@"    选择分类" forState:UIControlStateNormal];
    
    [self.officeBtn setTitleColor:[UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    self.officeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
     self.officeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;    // 文字左对齐
    
    [self.officeBtn addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.scrollView addSubview:self.officeBtn];

    
    
    //NSLog(@"btn %@",self.officeBtn.titleLabel.text);

    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Showconsultation_return_icon_default"]];
    
    [image sizeToFit];
    
    CGFloat imageW = image.width *0.8;
    CGFloat imageH = image.height *0.8;
    
    
    CGFloat imageY = (self.officeBtn.height - imageH) *0.5;
    
    image.frame = CGRectMake(self.officeBtn.width - 22, imageY, imageW, imageH);
    
    [image setTransform:CGAffineTransformMakeRotation(M_PI)];
    
    
    
    [self.officeBtn addSubview:image];


}


#pragma mark 选择科室

-(void)didClickBtn
{

    ZRTSelectorController *select = [[ZRTSelectorController alloc] init];

    select.modelArray = self.arr;
    
    select.delegate = self;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:select animated:YES];

}


#pragma mark 改变科室内容
-(void)changeContent:(ZRTSelectModel *)model
{

    NSString *title = [NSString stringWithFormat:@"    %@",model.Title];
    
    self.ClassId = model.Id;
    
    
    [self.officeBtn setTitle:title forState:UIControlStateNormal];
    



}





#pragma mark 设置内容

-(void)setContent
{

    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(self.officeBtn.x, CGRectGetMaxY(self.officeBtn.frame)+margin, CGRectGetWidth(self.officeBtn.frame), self.officeBtn.height * 7)];

    
    self.contentView.backgroundColor = [UIColor whiteColor];

    
    self.contentView.font = [UIFont systemFontOfSize:self.font-2];
    
    self.contentView.layer.cornerRadius = 8;
    
    
    
     [self.scrollView addSubview:self.contentView];



    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.officeTitle.x, self.contentView.y, CGRectGetWidth(self.officeTitle.frame), CGRectGetHeight(self.officeTitle.frame))];
    
    
    self.contentLabel.text = @"内容 ";
    
    self.contentLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.scrollView addSubview:self.contentLabel];
    
    
    
    
    
    


}


#pragma mark 设置图片

-(void)setImage
{


    // 上传图片
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.x, CGRectGetMaxY(self.contentView.frame)+margin, 150, 50)];
    
    [self.scrollView addSubview:self.btn];
    
    [self.btn setBackgroundImage:[UIImage imageNamed:@"pic"]  forState:UIControlStateNormal];
    
    [self.btn setTitle:@"上传图片" forState:UIControlStateNormal];
    
    self.btn.titleLabel.font = [UIFont systemFontOfSize:self.font-2];
    
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
    
    
    [self.btn addTarget:self action:@selector(didClickUploadBtn) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn.frame = CGRectMake(self.contentView.x, CGRectGetMaxY(self.contentView.frame)+margin, btnW , btnH);
    
    
    //    //NSLog(@"%@",NSStringFromCGRect(btn.frame));
    
    
    // 图片
    
    UILabel *image = [[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.x, 10, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame))];
    
    [self.scrollView addSubview:image];
    
    image.center = self.btn.center;
    
    image.text = @"图片 ";
    
    image.font = [UIFont systemFontOfSize:self.font];
    
    CGFloat iamgeY = image.y;
    
    image.frame = CGRectMake(self.contentLabel.x, iamgeY, CGRectGetWidth(self.contentLabel.frame), CGRectGetHeight(self.contentLabel.frame));
    
    
    
    // 图片View
    
    self.upload = [[UIView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.btn.frame)+margin, self.contentView.width, 0)];
    
    
    
    [self.scrollView addSubview:self.upload];
    
    
    self.UploadView = [[ZRTUploadView alloc] init];
    
    self.UploadView.delegete = self;
    
    [self.upload addSubview:self.UploadView];


}



#pragma mark 设置提交

-(void)setIssue
{

    //  提交按钮
    
    
    self.submit = [[UIButton alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.btn.frame)+66, self.view.width - margin*2, self.submitH)];
    
    [self.scrollView addSubview:self.submit];
    
    
    [self.submit setBackgroundImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    
    [self.submit setTitle:@"发布" forState:UIControlStateNormal];
    
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
    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.btn.frame) + margin +26, self.view.width - margin*2, submitH);
    
    
    [self.submit addTarget:self action:@selector(didSubmit) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 设置滚动区域
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128);

   
    const id root = [[[UIApplication sharedApplication].windows firstObject] rootViewController];

    
    self.rootViewController = root;
    

 //   NSLog(@"root %@",self.rootViewController);
    
}



#pragma mark 点击上传图片按钮

-(void)didClickUploadBtn
{

     //NSLog(@"发布");
    
    //   //NSLog(@"click %ld ",self.UploadView.photoItemArray.count);
    
//    NSLog(@" 1%@",self.rootViewController);
    
   
    self.pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    
    // 设置代理回调
    self.pickerVc.delegate = self;
    
    self.pickerVc.status = PickerViewShowStatusCameraRoll;
    
    self.pickerVc.minCount = 9 - self.UploadView.subviews.count;
    
    
    // 展示控制器
    [self.pickerVc showWithWindow:self.rootViewController];
    
//     NSLog(@" 2%@",self.rootViewController);

}



#pragma mark 相册选择的代理方法
- (void) pickerViewControllerDoneAsstes : (NSArray *) assets
{
    
    for (MLSelectPhotoAssets *asset in assets) {
        
        
        
        [self.photoItemArray addObject:asset.thumbImage];
        
        [_imageArr addObject:asset.originImage];
        
        
    }
 
    
    
    // 赋值
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        self.UploadView.photoItemArray = self.photoItemArray;
        
  
        NSLog(@" %@",[NSThread currentThread]);

    
    
    long imageCount = self.UploadView.subviews.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    CGFloat h = 80;
    
    CGFloat high =  totalRowCount * (kImagesMargin + h);
    
    //    //NSLog(@"iamgecount %ld",imageCount);
    //    //NSLog(@"high %f",high);
    
    
    self.upload.frame = CGRectMake(CGRectGetMaxX(self.officeTitle.frame), CGRectGetMaxY(self.btn.frame)+margin, self.view.width, high);
    
    
    
    //   //NSLog(@"upload %@",NSStringFromCGRect(self.upload.frame));
    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.btn.frame)+26, self.view.width - margin*2, self.submitH);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128 );
    
    
    
    [self.view reloadInputViews];
    
    
    //    //NSLog(@"remarkView %@",NSStringFromCGRect(self.remarkView.frame));
    //
    //    //NSLog(@"remark %@",NSStringFromCGRect(self.remark.frame));
    
    
    //  //NSLog(@"submit %@",NSStringFromCGRect(self.submit.frame));
    
    self.photoItemArray = nil;
    
    });
    
}



#pragma mark 上传图片view的代理方法

-(void)changeFrame:(CGFloat)maxY
{
    
    
//    long imageCount = self.UploadView.subviews.count;
//    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
//    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
//    int totalRowCount = ceil(imageCount / perRowImageCountF);
//    
//    CGFloat h = 80;
//    
//    CGFloat high =  totalRowCount * (kImagesMargin + h);
    
    //    //NSLog(@"high %f",high);
    
    self.upload.frame = CGRectMake(CGRectGetMaxX(self.officeTitle.frame), CGRectGetMaxY(self.btn.frame)+margin, self.view.width, maxY);
    

    
    
    self.submit.frame = CGRectMake(margin, CGRectGetMaxY(self.upload.frame)+26, self.view.width - margin*2, self.submitH);
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, CGRectGetMaxY(self.submit.frame)+margin +128);
    
    
    
    [self.view reloadInputViews];
    
    
}

#pragma mark - 删除图片数组项目的代理方法
- (void)deleteObjectInPhotoArray:(NSInteger)index {
    
    [_imageArr removeObjectAtIndex:index];
}

#pragma mark 点击发布按钮
-(void)didSubmit
{
    
    
    
    if (self.ClassId == nil) {
        
        
        [MBProgressHUD showMessage:@"请选择科室"];
        
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.0f];
        
        return;
        
    }
    
//    
//    NSLog(@"content %@",self.contentView.text);
    
    if ([self.contentView.text isEqualToString:@""]) {
        
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

#pragma mark 发布的网络请求

-(void)send
{

    
    NSString *urlString = @"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/AddConsultation";
    
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
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:urlString parameters:@{@"UserId":[DEFAULT objectForKey:@"UserDict"][@"Id"],@"ClassId":self.ClassId,@"Content":self.contentView.text,@"Img":mutableString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@" 成功");
        
        
        if ([self.delegate respondsToSelector:@selector(ComposeSuccess)] ) {
            
            [self.delegate ComposeSuccess];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"error %@",error);
        
        if ([self.delegate respondsToSelector:@selector(Composefailure)] ) {
            
            [self.delegate Composefailure];
            
        }
        
    }];
    
    
    

    
    

}






#pragma mark 隐藏窗口
-(void)hide
{

    [MBProgressHUD hideHUD];
}


-(void)hideAndPop
{

    [MBProgressHUD hideHUD];
    
    [self.navigationController popViewControllerAnimated:YES];

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
    
    [self.contentView resignFirstResponder];

}




#pragma mark 科室网络处理


-(void)keshi
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:@"http://www.yddmi.com/WebServices/Ydd_Consultation.asmx/GetDepartment" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        self.arr = [NSMutableArray array];
    
        
        int i = 0;
        
        for (id obj in jsonDict[@"ds"]) {
            
          
            
            ZRTSelectModel *model = [ZRTSelectModel ModelWithDict:obj];
            
            
            [self.arr addObject:model];
            
            if (i == 0) {
                
                [self.arr removeLastObject];
                
            }
            
            
            i++;
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@" %@",error);
    
    }];
    

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
