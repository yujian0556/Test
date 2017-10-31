//
//  ZRTHealthyDetailController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/3.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHealthyDetailController.h"
#import "ZRTCompileController.h"
#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"

#import "Interface.h"

#import "LGAlertView.h"

#define KfengeColor [UIColor colorWithRed:221/256.0 green:221/256.0 blue:221/256.0 alpha:1]
#define KTitleColor [UIColor colorWithRed:118/256.0 green:118/256.0 blue:118/256.0 alpha:1]


#define navigatorH 64
#define margin 20

#define kImagesMargin 15

@interface ZRTHealthyDetailController () <ZRTCompileControllerDelegate>


@property (nonatomic,assign) CGFloat font;

@property (nonatomic,strong) UIScrollView *filesView;  // 滑动view

@property (nonatomic,strong) UIView *toolView;    //  底部工具栏view

@property (nonatomic,strong) UIButton *compiled;  // 编辑按钮

@property (nonatomic,strong) UIButton *delete;  // 删除按钮

@property (nonatomic,strong) UIView *titleView;  // 标题view

@property (nonatomic,strong) UILabel *titleContent; // 标题内容

@property (nonatomic,strong) UIView *motifView;    // 主述view

@property (nonatomic,strong) UILabel *motifTitle;   // 主述内容

@property (nonatomic,strong) UIView *motifImageView;  // 主述图片view

@property (nonatomic,assign) CGFloat imageViewHigh;  // 图片view的高度

@property (nonatomic, strong) NSArray *srcStringArray; // 图片数组

//@property (nonatomic,strong) UIImageView *motifImage;  // 主述图片

@property (nonatomic,strong) UIView *remarkView;   // 备注view

@property (nonatomic,strong) UILabel *remarkLabel;  // 备注内容


@end

@implementation ZRTHealthyDetailController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self OSD];
    
    [self setUpNavBar];
    
    
    [self setUpCompileView];
    
    
    [self setUpScrollView];
    
    
    [self setUpTitle];

    [self setUpContent];
    
    [self setUpContentImage];
    
    [self setUpRemark];
    
}



#pragma mark 屏幕适配
-(void)OSD
{
    
    if (KScreenHeight == 480) {  // 4s
        
        _font = 16;
       
        
    }else if (KScreenHeight == 568){  // 5s
        _font = 16;
       
        
    }else if (KScreenHeight == 667){  // 6
        
        _font = 20;
        
       
        
    }else{  // 6p
        
        _font = 22;
        
        
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





#pragma mark 设置编辑和删除按钮的view
-(void) setUpCompileView
{
    
    CGFloat viewH ;
    
    if (KScreenHeight == 480) {  // 4s
        
        viewH = 60;
        
        
    }else if (KScreenHeight == 568){  // 5s
       
        
        viewH = 60;
        
    }else if (KScreenHeight == 667){  // 6
        
        
        viewH = 70;
        
        
    }else{  // 6p
        
       
        viewH = 80;
        
    }
    
   

    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-viewH - navigatorH, self.view.width, viewH)];

  //  view.backgroundColor = [UIColor blueColor];
    
    [self.view addSubview:self.toolView];

    
    
    //  分割线
    
    
    UIView *ge = [[UIView alloc] initWithFrame:CGRectMake(margin, 1, KScreenWidth-margin*2, 1)];
    
    ge.backgroundColor = KfengeColor;
    
    
    [self.toolView addSubview:ge];
    
    
    
   // 编辑按钮
    
    
    self.compiled = [[UIButton alloc] init];
    
//    [self.compiled setImage:[UIImage imageNamed:@"frame-green"] forState:UIControlStateNormal];

    [self.compiled setBackgroundImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    
   // [self.compiled setTitle:@"编辑" forState:UIControlStateNormal];
    
    [self.compiled setTitleColor: KcompiledColor forState:UIControlStateNormal];
    
    self.compiled.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.compiled sizeToFit];
    
    
    CGFloat compiledW ;
    CGFloat compiledH ;
    
    if (KScreenHeight == 480) {  // 4s
        
        compiledW = self.compiled.width *0.9;
        compiledH = self.compiled.height *0.9;
        
        
    }else if (KScreenHeight == 568){  // 5s
        
        
        compiledW = self.compiled.width ;
        compiledH = self.compiled.height ;
        
    }else if (KScreenHeight == 667){  // 6
        
        
        compiledW = self.compiled.width *1.2;
        compiledH = self.compiled.height *1.2;
        
        
    }else{  // 6p
        
        
        compiledW = self.compiled.width*1.5 ;
        compiledH = self.compiled.height*1.5 ;
        
    }
    
    
    self.compiled.frame = CGRectMake(margin, (self.toolView.height - compiledH)*0.5, compiledW, compiledH);
    
    
    [self.compiled addTarget:self action:@selector(didClickCompiled) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolView addSubview:self.compiled];
    
    
    
    //  删除按钮
    
    
    self.delete = [[UIButton alloc] init];

    
    [self.delete setBackgroundImage:[UIImage imageNamed:@"del"] forState:UIControlStateNormal];
    
//    [self.delete setTitle:@"删除" forState:UIControlStateNormal];
    
    [self.delete setTitleColor:KdeleteColor forState:UIControlStateNormal];
    
    self.delete.titleLabel.font = [UIFont systemFontOfSize:self.font];
    
    [self.delete sizeToFit];
    
    
//    CGFloat deleteW = self.delete.width *0.7;
//    CGFloat deleteH = self.delete.height *0.7;
    
    
    self.delete.frame = CGRectMake(self.toolView.width - margin - compiledW, (self.toolView.height - compiledH)*0.5, compiledW, compiledH);
    
    [self.delete addTarget:self action:@selector(didClickDelete) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolView addSubview:self.delete];
    
    
  //  NSLog(@" %@",NSStringFromCGRect(ge.frame));

  //  NSLog(@" %@",NSStringFromCGRect(view.frame));

}



#pragma mark 点击编辑和删除按钮事件

-(void)didClickCompiled
{
    
    ZRTCompileController *compile = [[ZRTCompileController alloc] init];
    
    compile.delegate = self;
    
    NSDictionary *compileDict = @{@"titleContent":self.titleContent.text,@"motifTitle":self.motifTitle.text,@"remarkLabel":self.remarkLabel.text,@"imgArray":self.srcStringArray,@"HealthyId":self.hmodel.ID};
    
    compile.compile = YES;
    compile.compileDict = compileDict;
        
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:compile animated:YES];
    
  


}



-(void)didClickDelete
{

    LGAlertView *alert = [LGAlertView alertViewWithTitle:@"删除" message:@"是否确认删除" buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
       
       
        [[OZHNetWork sharedNetworkTools] deleteHealthyDataWithID:self.hmodel.ID andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
        }];
        
        
        if ([self.delegate respondsToSelector:@selector(HealthyDelete:)]) {
            
            [self.delegate HealthyDelete:self.index];
            
        }
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    [alert showAnimated:YES completionHandler:nil];
    
 
    
}



#pragma mark 设置滚动范围
-(void)setUpScrollView
{
    
    CGFloat filesH = self.view.height - navigatorH - self.toolView.height;
    
    self.filesView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, filesH)];
    
    self.filesView.contentSize = CGSizeMake(self.view.width, filesH*2);
    
    self.filesView.showsVerticalScrollIndicator = NO;
    self.filesView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.filesView];
    
}



#pragma mark 设置标题
-(void)setUpTitle
{

    self.titleView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.width, 60)];
    
    [self.filesView addSubview:self.titleView];
    
    
    // 标题
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"标题 : ";
    
    label.font = [UIFont systemFontOfSize:self.font];
    
    [label sizeToFit];
    
    CGFloat labelH = label.height;
    CGFloat lablew = label.width;
    
    label.frame = CGRectMake(margin, (self.titleView.height - labelH)*0.5 , lablew, labelH);
    
    [self.titleView addSubview:label];
    
    
    
    // 标题内容
    
    self.titleContent = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), label.y, self.titleView.width - CGRectGetMaxX(label.frame), label.height)];
    
    
    self.titleContent.text = self.hmodel.Topic;
    
    self.titleContent.font = [UIFont systemFontOfSize:self.font];
    
    
    [self.titleView addSubview:self.titleContent];
    
    
    // 分割线
    
    UIView *ge = [[UIView alloc] initWithFrame:CGRectMake(margin, self.titleView.height-1, KScreenWidth-margin*2, 1)];
    
    ge.backgroundColor = KfengeColor;
    
    
    [self.titleView addSubview:ge];
    

}


#pragma mark 设置主述
-(void) setUpContent
{

    // 主述view
    
    self.motifView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.width, 300)];
    
    [self.filesView addSubview:self.motifView];
    
    
    
    // 主述
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"主述 : ";
    
    label.font = [UIFont systemFontOfSize:self.font];
    
    [label sizeToFit];
    
    CGFloat labelH = label.height;
    CGFloat lablew = label.width;
    
    label.frame = CGRectMake(margin, margin , lablew, labelH);
    
    [self.motifView addSubview:label];
    
    

    // 主述内容
    
    CGFloat marginW = 30;
    CGFloat marginH = 10;
    
    self.motifTitle = [[UILabel alloc] initWithFrame:CGRectMake(marginW, CGRectGetMaxY(label.frame)+marginH, self.view.width -marginW*2, 200)];
    
    self.motifTitle.font = [UIFont systemFontOfSize:self.font];
    self.motifTitle.textColor = KTitleColor;
    self.motifTitle.numberOfLines = 0;
    
    self.motifTitle.text = self.hmodel.HContent;
    
    
    
    [self.motifTitle sizeToFit];
    
    
    CGFloat titleH = self.motifTitle.height;
    
    self.motifTitle.frame = CGRectMake(marginW, CGRectGetMaxY(label.frame)+marginH, self.view.width -marginW*2, titleH);
    
    [self.motifView addSubview:self.motifTitle];
    
    
    
    // 主述图片
    
//    CGFloat marginImageW = 40;
//    CGFloat marginImageH = marginH;
//    CGFloat imageW = self.view.width - marginImageW*2;
//    
//    self.motifImage = [[UIImageView alloc] initWithFrame:CGRectMake(marginImageW, CGRectGetMaxY(self.motifTitle.frame)+marginImageH, imageW, imageW/16*9)];
//    
//    
//    self.motifImage.image = [UIImage imageNamed:@"pic_07"];
//    
//    
//    [self.motifView addSubview:self.motifImage];
 
    
    
    
    // 重新设置主述view的frame
    
    CGFloat motifViewH = CGRectGetMaxY(self.motifTitle.frame) + marginH;
    
     self.motifView.frame = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.view.width, motifViewH);
    

//    NSLog(@"image %@",NSStringFromCGRect(self.motifImage.frame));
//    
//    NSLog(@"view %@",NSStringFromCGRect(self.motifView.frame));
    
}






#pragma mark 设置主述图片
-(void)setUpContentImage
{
    
    
    self.motifImageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.motifView.frame), self.view.width, 100)];
    
    [self.filesView addSubview:self.motifImageView];

    
    long imageCount = self.srcStringArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    CGFloat h = 80;
    
    CGFloat high =  totalRowCount * (kImagesMargin + h);
    

    HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] init];
    
    imagesGroupView.isHealthy = YES;
    
    NSMutableArray *temp = [NSMutableArray array];
    [self.srcStringArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
        
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,src];
//        NSLog(@"%@",item.thumbnail_pic);
        [temp addObject:item];
    }];
    
    imagesGroupView.photoItemArray = [temp copy];
  
    [self.motifImageView addSubview:imagesGroupView];
    
    
    // 重新设置view的frame
    
    self.motifImageView.frame = CGRectMake(0, CGRectGetMaxY(self.motifView.frame), self.view.width, high);
    
    
  //  NSLog(@"image %@",NSStringFromCGRect(self.motifImageView.frame));
    
}




#pragma mark 设置备注

-(void) setUpRemark
{
    
    // 备注view
    self.remarkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.motifImageView.frame), self.view.width, 300)];
    
    
    [self.filesView addSubview:self.remarkView];
    
  
    
    // 备注
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"备注 : ";
    
    label.font = [UIFont systemFontOfSize:self.font];
    
    [label sizeToFit];
    
    CGFloat labelH = label.height;
    CGFloat lablew = label.width;
    
    label.frame = CGRectMake(margin, margin , lablew, labelH);
    
    [self.remarkView addSubview:label];
    
    
    
    // 备注内容
    
    CGFloat marginW = 30;
    CGFloat marginH = 10;
    
    self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(marginW, CGRectGetMaxY(label.frame)+marginH, self.view.width -marginW*2, 200)];
    
    self.remarkLabel.font = [UIFont systemFontOfSize:self.font];
    self.remarkLabel.textColor = KTitleColor;
    self.remarkLabel.numberOfLines = 0;
    
    
    NSString *remark = [NSString stringByReplacing:self.hmodel.Remark];
    
    self.remarkLabel.text = remark;
    
    
    
    [self.remarkLabel sizeToFit];
    
    
    CGFloat titleH = self.remarkLabel.height;
    
    self.remarkLabel.frame = CGRectMake(marginW, CGRectGetMaxY(label.frame)+marginH, self.view.width -marginW*2, titleH);
    
    [self.remarkView addSubview:self.remarkLabel];
    
    
    
    // 重置备注view的frame
    
    CGFloat remarkviewH = CGRectGetMaxY(self.remarkLabel.frame) + marginH;
    
    self.remarkView.frame = CGRectMake(0, CGRectGetMaxY(self.motifImageView.frame), self.view.width, remarkviewH);
    
    
    
    
    // 设置滚动区域和大小
    
    CGSize size = CGSizeMake(self.view.width, CGRectGetMaxY(self.remarkView.frame));
    
    
    self.filesView.contentSize = size;
    
    
}




#pragma mark 懒加载

-(NSArray *)srcStringArray
{
    if (!_srcStringArray) {
        
        
        _srcStringArray  = [[NSArray alloc] init];
        

        
        
//        _srcStringArray = @[
//                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr3xvtlj20gy0obadv.jpg",
//                            @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
//                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
//                            @"http://ww4.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr4nndfj20gy0o9q6i.jpg",
//                            @"http://ww3.sinaimg.cn/thumbnail/8e88b0c1gw1e9lpr57tn9j20gy0obn0f.jpg",
//                            @"http://ww2.sinaimg.cn/thumbnail/677febf5gw1erma104rhyj20k03dz16y.jpg",
//                            @"http://ww4.sinaimg.cn/thumbnail/677febf5gw1erma1g5xd0j20k0esa7wj.jpg",
//                            
//                            ];
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in self.hmodel.PicList[@"ds"]) {
            
            [arr addObject:dict[@"ImageUrl"]];
            
        }
        
        _srcStringArray = arr;

        
    }

    
    return _srcStringArray;

}


#pragma mark - 代理方法

- (void)backFromChangeHealthyData {
    
    //NSLog(@"backFromChangeHealthyData~!~~~~~");
    [self.navigationController popViewControllerAnimated:NO];
    
}


-(void)CompileReloadData
{
    if ([self.delegate respondsToSelector:@selector(CompileReloadData)]) {
        
        [self.delegate CompileReloadData];
    }

}



-(void)Compose
{

    if ([self.delegate respondsToSelector:@selector(CompileCompose)]) {
        
        [self.delegate CompileCompose];
        
    }
    

}


-(void)CompileComposefailure
{

    if ([self.delegate respondsToSelector:@selector(Compilefailure)]) {
        
        [self.delegate Compilefailure];
        
    }

}



@end
