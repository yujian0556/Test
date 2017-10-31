//
//  ZRTNewsCollectionCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/6/16.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//


#import "ZRTNewsCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+MJ.h"



#define margin 10



@interface ZRTNewsCollectionCell ()<UIGestureRecognizerDelegate>




// 时间
@property(nonatomic ,strong)UIButton *time;


// 大图视图
@property (nonatomic,strong) UIImageView *headView;

// 大图标签
@property (nonatomic,strong) UILabel *headLabel;

// 大图下分割线
@property (nonatomic,strong) UIView *divide;


// 第一个cell
@property (nonatomic,strong) UILabel *label1;

@property (nonatomic,strong) UIImageView *image1;

@property (nonatomic,strong) UIView *divideCell1;


// 第二个cell
@property (nonatomic,strong) UILabel *label2;

@property (nonatomic,strong) UIImageView *image2;

@property (nonatomic,strong) UIView *divideCell2;


// 第三个cell
@property (nonatomic,strong) UILabel *label3;

@property (nonatomic,strong) UIImageView *image3;





@property (nonatomic,strong) ZRTNewsCellModel *cellModel0;

@property (nonatomic,strong) ZRTNewsCellModel *cellModel1;

@property (nonatomic,strong) ZRTNewsCellModel *cellModel2;

@property (nonatomic,strong) ZRTNewsCellModel *cellModel3;




@end





@implementation ZRTNewsCollectionCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        self.backgroundColor = KGrayColor;
        
        self.contentView.userInteractionEnabled = YES;
        
        
        
        //
        //        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, CGRectGetWidth(self.frame)-10, CGRectGetWidth(self.frame)-10)];
        //        self.imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        //        [self addSubview:self.imgView];
        //
        //        self.text = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.imgView.frame), CGRectGetWidth(self.frame)-10, 20)];
        //        self.text.backgroundColor = [UIColor brownColor];
        //        self.text.textAlignment = NSTextAlignmentCenter;
        //        [self addSubview:self.text];
        //
        //        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        self.btn.frame = CGRectMake(5, CGRectGetMaxY(self.text.frame), CGRectGetWidth(self.frame)-10,30);
        //        [self.btn setTitle:@"按钮" forState:UIControlStateNormal];
        //        self.btn.backgroundColor = [UIColor orangeColor];
        //        [self addSubview:self.btn];
        
        
        
        // 添加时间
        
        self.time = [[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth - 80) * 0.5, 17, 80, 25)];
        
        //  NSString *timeTitle = @"上午9:00";
        
        //  [self.time setTitle:timeTitle forState:UIControlStateNormal];
        
        self.time.titleLabel.font = [UIFont systemFontOfSize:13];
        
        
        [self.time setBackgroundImage:[UIImage imageWithStretchableImageName:@"时间背景_03"] forState:UIControlStateNormal];
        
        //        [self.time sizeToFit];
        
        [self.contentView addSubview:self.time];
        
        
        
        
        // 添加背景图
        
        
        self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.time.frame) + 8, CGRectGetWidth(self.frame)-margin * 2, 500)];
        
        self.backView.userInteractionEnabled = YES;
        
        self.backView.image = [UIImage imageNamed:@"内容背景_07"];
        
        [self.contentView addSubview:self.backView];
        
        
        // 添加
        [self setUpHeadView];
        
        
        // 第一个cell
        [self setUpCell1];
        
        // 第一个cell
        [self setUpCell2];
        
        // 第一个cell
        [self setUpCell3];
        
        
        
    }
    
    return self;
    
}



-(void)setUpHeadView
{
    
    // 添加图片
    self.headView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, CGRectGetWidth(self.backView.frame) - margin *2, 200)];
    
    self.headView.userInteractionEnabled = YES;
    
    //    UIImage *headImage = [UIImage imageNamed:@"新闻图片_03"];
    //
    //    self.headView.image = headImage;
    
    [self.backView addSubview:self.headView];
    
    
    // 添加标题
    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.headView.frame) - 40, CGRectGetWidth(self.headView.frame), 40)];
    
    self.headLabel.userInteractionEnabled = YES;
    
    
    self.headLabel.backgroundColor = [UIColor blackColor];
    self.headLabel.alpha = 0.8;
    
    //    NSString *headText = @"医疗垃圾在国内是怎么处理的";
    //
    //    self.headLabel.text = headText;
    
    [self.headLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]]; // 加粗
    
    self.headLabel.textAlignment = NSTextAlignmentCenter;
    
    self.headLabel.textColor = [UIColor whiteColor];
    
    
    [self.headView addSubview:self.headLabel];
    
    
    // 分割线
    self.divide = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame) + margin, CGRectGetWidth(self.backView.frame), 1)];
    
    self.divide.backgroundColor = Kdivide;
    
    [self.backView addSubview:self.divide];
    
    
    
    // 添加透明点击View
    
    UIView *meng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.headView.width, self.headView.height)];
    
    //    self.meng.userInteractionEnabled = YES;
    
    [self.headView addSubview:meng];
    
    meng.alpha = 0.1;
    
    
    
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap)];
    
    tap.delegate = self;
    
    
    [meng addGestureRecognizer:tap];
    
    
    
}

// 当触发点按手势的时候调用
- (void)headTap
{
    
    
    if ([self.delegate respondsToSelector:@selector(didClickHeadView:)]) {
        
        
        [self.delegate didClickHeadView:self.cellModel0];
    }
    
    
    
}




-(void)setUpCell1
{
    // 标题
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(margin *2, CGRectGetMaxY(self.divide.frame) +margin , self.backView.width * 0.7, 60)];
    
    [self.backView addSubview:self.label1];
    
    self.label1.textColor = [UIColor blackColor];
    
    [self.label1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    self.label1.numberOfLines = 0;
    
    
    
    //  //NSLog(@"divil %@",NSStringFromCGRect(self.divide.frame));
    //
    //    //NSLog(@"lable1 %@",NSStringFromCGRect(self.label1.frame));
    
    
  //  //NSLog(@" %f",self.backView.width);
    
    
    // 图片
    self.image1 = [[UIImageView alloc] initWithFrame:CGRectMake( self.backView.width - self.label1.height - margin, CGRectGetMaxY(self.divide.frame) +margin, self.label1.height , self.label1.height)];
    
    
    [self.backView addSubview:self.image1];
    
    
    // 分割线
    self.divideCell1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.image1.frame) + margin, CGRectGetWidth(self.backView.frame), 1)];
    
    self.divideCell1.backgroundColor = Kdivide;
    
    [self.backView addSubview:self.divideCell1];
    
    //    //NSLog(@"iamge %@",NSStringFromCGRect(self.image1.frame));
    //
    //   //NSLog(@"dividecell %@",NSStringFromCGRect(self.divideCell1.frame));
    
    
    
    // 添加透明点击View
    
    UIView *meng = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.divide.frame), self.backView.width, 86)];
    
    //    self.meng.userInteractionEnabled = YES;
    
    [self.backView addSubview:meng];
    
    meng.alpha = 0.1;
    
    
    
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapCell1)];
    
    tap.delegate = self;
    
    
    [meng addGestureRecognizer:tap];
    
    
    
}

#pragma mark 点击Cell1
// 当触发点按手势的时候调用
- (void)TapCell1
{
    
  
    
    if ([self.delegate respondsToSelector:@selector(didClickCell1:)]) {
        
        
        [self.delegate didClickCell1:self.cellModel1];
    }
    
    
    
}




-(void)setUpCell2
{
    // 标题
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(margin *2, CGRectGetMaxY(self.divideCell1.frame) +margin , self.backView.width * 0.7, 60)];
    
    [self.backView addSubview:self.label2];
    
    self.label2.textColor = [UIColor blackColor];
    
    [self.label2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    self.label2.numberOfLines = 0;
    
    
    
    // 图片
    self.image2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width - self.label2.height - margin, CGRectGetMaxY(self.divideCell1.frame) +margin, self.label2.height , self.label2.height)];
    
    
    [self.backView addSubview:self.image2];
    
    
    // 分割线
    self.divideCell2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.image2.frame) + margin, CGRectGetWidth(self.backView.frame), 1)];
    
    self.divideCell2.backgroundColor = Kdivide;
    
    [self.backView addSubview:self.divideCell2];
    
    
    
    
    // 添加透明点击View
    
    UIView *meng = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.divideCell1.frame), self.backView.width, 86)];
    
    //    self.meng.userInteractionEnabled = YES;
    
    [self.backView addSubview:meng];
    
    meng.alpha = 0.1;
    
    
    
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapCell2)];
    
    tap.delegate = self;
    
    
    [meng addGestureRecognizer:tap];
    
    
    
}


#pragma mark 点击Cell2
- (void)TapCell2
{
    
    
  
    
    if ([self.delegate respondsToSelector:@selector(didClickCell2:)]) {
        
        
        [self.delegate didClickCell2:self.cellModel2];
    }
    
    
    
}




-(void)setUpCell3
{
    // 标题
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(margin *2, CGRectGetMaxY(self.divideCell2.frame) +margin , self.backView.width * 0.7, 60)];
    
    [self.backView addSubview:self.label3];
    
    self.label3.textColor = [UIColor blackColor];
    
    [self.label3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    self.label3.numberOfLines = 0;
    
    
    
    // 图片
    self.image3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.backView.width - self.label1.height - margin, CGRectGetMaxY(self.divideCell2.frame) +margin, self.label3.height , self.label3.height)];
    
    
    [self.backView addSubview:self.image3];
    
    
    //    // 分割线
    //    self.divideCell3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.image3.frame) + margin, CGRectGetWidth(self.backView.frame), 1)];
    //
    //    self.divideCell3.backgroundColor = Kdivide;
    //
    //    [self.backView addSubview:self.divideCell3];
    
    //  //NSLog(@"dividecell %@",NSStringFromCGRect(self.divideCell2.frame));
    
    
    // 添加透明点击View
    
    UIView *meng = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.divideCell2.frame), self.backView.width, 98)];
    
    //    self.meng.userInteractionEnabled = YES;
    
    [self.backView addSubview:meng];
    
    meng.alpha = 0.1;
    
    
    
    
    // 添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapCell3)];
    
    tap.delegate = self;
    
    
    [meng addGestureRecognizer:tap];
    
    
}


#pragma mark 点击Cell1
- (void)TapCell3
{
    
    
   
    
    if ([self.delegate respondsToSelector:@selector(didClickCell3:)]) {
        
        
        [self.delegate didClickCell3:self.cellModel3];
    }
    
    
    
}





// 在这里给控件赋值
-(void)setModel:(ZRTNewsModel *)model
{
    _model = model;
    
   // //NSLog(@"123 %ld",model.ds.count);
    
    
    if (model.ds.count > 0) {
        
        self.cellModel0 = [ZRTNewsCellModel newsModelWithDict:model.ds[0]];
        
    }
    
    if (model.ds.count > 1) {
        
        self.cellModel1 = [ZRTNewsCellModel newsModelWithDict:model.ds[1]];
    }
    
    if (model.ds.count >2 ) {
        
        self.cellModel2 = [ZRTNewsCellModel newsModelWithDict:model.ds[2]];
    }
   
    if (model.ds.count > 3) {
        
        self.cellModel3 = [ZRTNewsCellModel newsModelWithDict:model.ds[3]];
    }
    
   
    
  //  //NSLog(@"cell %@",self.cellModel1.Id);
    
    
    
    // 时间
    

    
    [self.time setTitle:[self setUptime:model] forState:UIControlStateNormal];
    
    [self.time sizeToFit];
    
  //  //NSLog(@"time %@",NSStringFromCGRect(self.time.frame));
    
    CGFloat timeW = self.time.width *0.7;
    CGFloat timeH = self.time.height *0.7;
    
    self.time.frame = CGRectMake((KScreenWidth - timeW) * 0.5, 17, timeW, timeH);
    
    
    
    // 大图
    
    NSString *path = [NSString stringWithFormat:@"http://www.yddmi.com%@",self.cellModel0.img_url];
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:path]];
    
    self.headLabel.text = self.cellModel0.title;

    

    // cell1
    
    self.label1.text = self.cellModel1.title;
    
    NSString *path1 = [NSString stringWithFormat:@"http://www.yddmi.com%@",self.cellModel1.img_url];
    
    [self.image1 sd_setImageWithURL:[NSURL URLWithString:path1]];
    
    
    // cell2

    self.label2.text = self.cellModel2.title;
    
    NSString *path2 = [NSString stringWithFormat:@"http://www.yddmi.com%@",self.cellModel2.img_url];
    
    [self.image2 sd_setImageWithURL:[NSURL URLWithString:path2]];

    
    //
    
    self.label3.text = self.cellModel3.title;
    
    NSString *path3 = [NSString stringWithFormat:@"http://www.yddmi.com%@",self.cellModel3.img_url];

    [self.image3 sd_setImageWithURL:[NSURL URLWithString:path3]];
    
    
//    self.headView.image = [UIImage imageNamed:@"新闻图片_03"];
//    
//    self.image1.image = [UIImage imageNamed:@"图片展示_03"];
//    
//    self.image2.image = [UIImage imageNamed:@"图片展示_03"];
//    
//    self.image3.image = [UIImage imageNamed:@"图片展示_03"];
    

    
    
    
    self.backView.frame = CGRectMake(margin, CGRectGetMaxY(self.time.frame) + 8, CGRectGetWidth(self.frame)-margin * 2, CGRectGetMaxY(self.image3.frame) + margin);
    
    
//    //NSLog(@"path %@",path);
//    //NSLog(@"path1 %@",path1);
//    //NSLog(@"path2 %@",path2);
//    //NSLog(@"path3 %@",path3);

    
}



-(NSString *)setUptime:(ZRTNewsModel *)model
{

    NSString *time = self.cellModel0.add_time;
    

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"YYYY/MM/dd HH:mm:ss";

//    format.locale = [NSLocale localeWithLocaleIdentifier:@"en_us"];
    
    NSDate *creat = [format dateFromString:time];
    
    ////NSLog(@"%@",creat);
    
   // //NSLog(@"%ld",creat.isTime);
    
    
    if ([creat isThisYear]) {
        
        if ([creat isToday]) {
            
            
            if (creat.isTime == 1) {
                
                format.dateFormat = @"早上 HH:mm";
                
                return [format stringFromDate:creat];

                
            }else if (creat.isTime == 2){
                
                format.dateFormat = @"下午 HH:mm";
                
                return [format stringFromDate:creat];
                
            }else{
                
                format.dateFormat = @"晚上 HH:mm";
                
                return [format stringFromDate:creat];
                
            }
            
            
        }else if([creat isYesterday]){
            
            format.dateFormat = @"昨天 HH:mm";
            
            return [format stringFromDate:creat];
       
        }else{
            
            format.dateFormat = @"MM-dd HH:mm";
            
            return [format stringFromDate:creat];
            
        }
        
        
    }else{
        
        format.dateFormat = @"yyyy-MM-dd";
        
        return [format stringFromDate:creat];
    }
    

}







@end
