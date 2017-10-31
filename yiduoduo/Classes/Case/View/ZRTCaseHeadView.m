//
//  ZRTCaseHeadController.m
//  yiduoduo
//
//  Created by moyifan on 15/6/4.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTCaseHeadView.h"
#import "AFNetworking.h"

#define maginX 10
#define maginY 10


@interface ZRTCaseHeadView ()

// 第一个介绍view
@property (nonatomic,weak) UIView *introduceView;
// 第二个信息view
@property (nonatomic,weak) UIView *infoView;
// 需要传进来的标签数组
@property (nonatomic,strong) NSArray *BtnArray;
// 最大时间的Y值
@property (nonatomic,assign) CGFloat lableTimeY;




// 标签view 的高度
@property (nonatomic,assign) CGFloat BtnViewH;





@property (nonatomic,strong) UILabel *labelTitle;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) CGFloat imageW;

@property (nonatomic,strong) UIImageView *image;

@property (nonatomic,strong) UIImageView *starImageView;


@property (nonatomic,strong) UILabel *count;

@end

@implementation ZRTCaseHeadView


-(void)layoutSubviews
{
    
    [self setUpIntroduce];

   
    // 隐藏发布者信息。后期添
   // [self setBasic];
    
    [self setDetail];
}


-(void)setUpIntroduce
{
    
    NSLog(@" %@ %@",self.model.havecollect,self.model.havescore);
    
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 140)];
    
    self.introduceView = view;
    
    view.backgroundColor = KMainColor;
    
    [self addSubview:view];

    // 标题
    self.labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(maginX, maginX, self.width - maginX, 30)];
    
   //  NSLog(@"model %@",model.Title);
    
     self.labelTitle.text = self.model.Title;
    
    self.labelTitle.numberOfLines = 0;

    self.labelTitle.textColor = [UIColor whiteColor];
    [self.labelTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];  //加粗
    
    [self.labelTitle sizeToFit];
    
    CGFloat labelTitleH = self.labelTitle.height;
    
    self.labelTitle.frame = CGRectMake(maginX, maginX, self.width - maginX, labelTitleH);
    
    
    
    [view addSubview:self.labelTitle];

    

    
    // 时间
    UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(maginX, CGRectGetMaxY(self.labelTitle.frame) + maginY , self.width - maginX, 20)];
    
    [view addSubview:labelTime];
    
    labelTime.textColor = [UIColor whiteColor];
    labelTime.font = [UIFont systemFontOfSize:13];
    labelTime.text = self.model.PublishTime;       //   数据
    
    
    [labelTime sizeToFit];
    
    CGFloat width = labelTime.width;
    
    labelTime.frame = CGRectMake(maginX, CGRectGetMaxY(self.labelTitle.frame) + maginY , width, 20);
    
    CGFloat lableTimeY = CGRectGetMaxY(labelTime.frame);
    
    self.lableTimeY = lableTimeY;
    
    
    
    // 添加评分
    
    UIView *gradeView = [[UIView alloc] init];
    
    [view addSubview:gradeView];
    
    
    
    
    self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love-half-up-white"]];
    
    [self.image sizeToFit];
    
    self.imageW = self.image.width ;
    CGFloat imageH = self.image.height ;
    
    gradeView.frame = CGRectMake(CGRectGetMaxX(labelTime.frame)+maginX, CGRectGetMaxY(self.labelTitle.frame) + maginY, self.imageW, imageH);
    
    
    self.image.frame = CGRectMake(0, 0, self.imageW, imageH);
    
    [gradeView addSubview:self.image];
    
    gradeView.center = labelTime.center;
    
    CGFloat gradeViewY = gradeView.y;
    
    gradeView.frame = CGRectMake(CGRectGetMaxX(labelTime.frame)+maginX, gradeViewY, self.imageW, imageH);
    

    
    //白色心形
    self.starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"love-ful-up-white"]];
    
    self.starImageView.frame = CGRectMake(0, 0, 0, imageH);
    self.starImageView.contentMode=UIViewContentModeLeft;
    self.starImageView.clipsToBounds=YES;
    
    [gradeView addSubview:self.starImageView];
    
  //  starImageView.frame = CGRectMake(CGRectGetMaxX(labelTime.frame)+maginX, imageY, 0, imageH);
    
    CGFloat halfWidth = self.imageW/10-3;
    
    CGFloat score = [self.model.score floatValue];
    
    CGFloat starWidth;
    
    CGFloat margin = 7;
    
    if (score == 0) {
        
        starWidth = 0;
        
    }else if (score == 0.5){
    
        starWidth = halfWidth;
    
    }else if (score == 1){
    
        starWidth = halfWidth*2;
    
    }else if (score == 1.5){
    
        starWidth = halfWidth*3 +margin;
    }else if (score == 2){
    
        starWidth = halfWidth*4 +margin;
    }else if (score == 2.5){
    
        starWidth = halfWidth*5 +margin*2;
    }else if (score == 3){
    
        starWidth = halfWidth*6 +margin*2;
    }else if (score == 3.5){
    
        starWidth = halfWidth*7 +margin*3;
    }else if (score == 4){
    
        starWidth = halfWidth*8 +margin*3;
    }else if (score == 4.5){
    
        starWidth = halfWidth*9 +margin*4;
    }else{
    
        starWidth = halfWidth*10 +margin*4 +1;
    }
    
    self.starImageView.frame = CGRectMake(0, 0, starWidth, self.image.height);

 //   NSLog(@"pingfen %f %@",score,self.model.Id);
    
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gradeView.frame)+margin/2, gradeView.y-2, 0, gradeView.height)];
    
    self.count = count;
    
    count.text = [NSString stringWithFormat:@"(%.1f)",score];

    count.textColor = [UIColor whiteColor];
    count.font = [UIFont systemFontOfSize:10];
    
    [count sizeToFit];
    
    
    [view addSubview:count];
    
    
    
    
    // 标签
  
    [self setUpBtn];

}


-(void)setUpScore
{






}







-(void)setUpBtn
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.lableTimeY +maginY, self.width, 30)];
    
    [self.introduceView addSubview:view];
    
    CGFloat x = maginX;
    
    CGFloat row = 0;
    
    CGFloat y = row *30;
    
    for (NSString *str in self.BtnArray) {
     
     //   NSLog(@" %@",str);
        
        NSString *str1 = [[NSString alloc] init];
        
        str1 = str;
        
        if ([str hasSuffix:@"。"]) {
           str1 = [str stringByReplacingOccurrencesOfString:@"。" withString:@""];
        }
        
        if ([str hasSuffix:@"."]) {
           str1 = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
        
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 0, 0)];

        [btn setTitle:str1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
     //   btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:btn];
        
        [btn sizeToFit];
    
        
        CGFloat btnW = btn.width;
        
     //   NSLog(@"多大 %f",x+btnW);
        
        if (x + btnW > KScreenWidth) {
            
            x = maginX;
            
            row += 1;
            
            y = row *30 + maginY;
        }
        
        
        btn.frame = CGRectMake(x, y , btnW, btn.height);
        


//        [[btn layer] setCornerRadius:16.0f]; // 设置圆角半径
//        
//        [[btn layer] setMasksToBounds:YES]; // 位于它之下的layer都遮盖住
//        
//        [[btn layer] setBorderWidth:1.0f];  // 显示出按钮的边框
//        

        
        x = CGRectGetMaxX(btn.frame) + maginX;
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)-6, btnW, 1)];
        
        line.backgroundColor = [UIColor whiteColor];
        
        [btn addSubview:line];
        
        
   //     NSLog(@" %@",NSStringFromCGRect(btn.frame));
        
        
    
    }
    
    
    
    self.BtnViewH = maginX + (row +1) *40;
    
    
    self.introduceView.frame = CGRectMake(0, 0, self.width, self.lableTimeY + self.BtnViewH);
    
    
}











-(void)setBasic
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introduceView.frame), self.width, 60)];
   
    self.infoView = view;
    
    [self addSubview:view];
    

    
    // 头像
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(maginX *2 , maginY, 40, 40)];
    
    image.image = [UIImage imageNamed:@"login_headimagebg_default"];
    
    [view addSubview:image];
    
    
    // 姓名
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + maginX, maginY, 100, 20)];
    
    name.font = [UIFont systemFontOfSize:16];
    
    name.text = @"王某某";
    
    [view addSubview:name];
    
    
    // 科室
    
    UILabel *keshi = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame) + maginX, CGRectGetMaxY(name.frame) + maginY, 100, 20)];
    
    keshi.textColor = [UIColor darkGrayColor];
    keshi.font = [UIFont systemFontOfSize:13];
    
    keshi.text = @"精神科 主任医师";
    
    [view addSubview:keshi];
    
    // 关注
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.center = CGPointMake(view.width - maginY*2 - 48, view.height *0.3);
    
    [btn setTitle:@"关注TA" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
   // btn.imageView.image = [UIImage imageNamed:<#(NSString *)#>]
    
    [btn sizeToFit];
    
  //  NSLog(@"btn %@",NSStringFromCGRect(btn.frame));
    
    [view addSubview:btn];
    
    
    // 分割线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame) , self.width, 1)];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    
    
    [self addSubview:line];
    

}




-(void)setDetail
{

    // 基本信息View
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.introduceView.frame), self.width, 200)];
    
  //  view.backgroundColor = [UIColor grayColor];
    
    [self addSubview:view];
    
    // 患者基本信息
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(maginX *2, maginY *2, self.width, 20)];
    
    info.text = @"患者基本信息";
    [info setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    info.textColor = KMainColor;
    
    
    [view addSubview:info];
    
    // 性别
    
    UILabel* sex = [[UILabel alloc] init];
    sex.frame = CGRectMake(maginX *2, CGRectGetMaxY(info.frame) + maginY, 200, 100);
    sex.textColor = KRGBColor(153, 154, 155);
    
    NSString *sexString = self.model.Sex;  //数据传入
    
    NSMutableAttributedString *sexStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"性别 : %@",sexString]];
    
    
    NSRange redRange = NSMakeRange(0, [[sexStr string] rangeOfString:@":"].location);
    
    
    [sexStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [sex setAttributedText:sexStr] ;
    [sex sizeToFit];
    
    
    
    [view addSubview:sex];
    
    
    
    // 民族
    
    UILabel *nation = [[UILabel alloc] init];
    nation.frame = CGRectMake(maginX *2, CGRectGetMaxY(sex.frame) + maginY, 200, 100);
    nation.textColor = KRGBColor(153, 154, 155);
    
    NSString *nationString = self.model.Nation;  //数据传入
    
    NSMutableAttributedString *nationStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"民族 : %@",nationString]];
    
    [nationStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [nation setAttributedText:nationStr] ;
    [nation sizeToFit];
    
    
    
    [view addSubview:nation];


    // 出生地
    
    UILabel *born = [[UILabel alloc] init];
    born.frame = CGRectMake(maginX *2, CGRectGetMaxY(nation.frame) + maginY, 200, 100);
    born.textColor = KRGBColor(153, 154, 155);
    
    NSString *bornString = self.model.BirthPlace;  //数据传入
    
    NSMutableAttributedString *bornStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"出生地 : %@",bornString]];
    
    [bornStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [born setAttributedText:bornStr] ;
    [born sizeToFit];
    
    
    
    [view addSubview:born];
    
    
    // 居住地
    
    UILabel *live = [[UILabel alloc] init];
    live.frame = CGRectMake(maginX *2, CGRectGetMaxY(born.frame) + maginY, 200, 100);
    live.textColor = KRGBColor(153, 154, 155);
    
    NSString *liveString = self.model.Address;  //数据传入
    
    NSMutableAttributedString *liveStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"居住地 : %@",liveString]];
    
    [liveStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [live setAttributedText:liveStr] ;
    [live sizeToFit];
    
    
    
    [view addSubview:live];
    
    
    // 就诊日期
    
    UILabel *date = [[UILabel alloc] init];
    date.frame = CGRectMake(maginX *2, CGRectGetMaxY(live.frame) + maginY, 200, 100);
    date.textColor = KRGBColor(153, 154, 155);
    
    
    NSArray *strarray = [self.model.VisitTime componentsSeparatedByString:@" "];
   
    NSString *dateString = strarray[0];  //数据传入
    
//    NSLog(@" %@",dateString);
 
    
    NSMutableAttributedString *dateStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"就诊日期 : %@",dateString]];
    
    NSRange dateRange = NSMakeRange(0, [[dateStr string] rangeOfString:@":"].location);
    
    [dateStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:dateRange];
    [date setAttributedText:dateStr] ;
    [date sizeToFit];
    
    
    
    [view addSubview:date];
    
    
    // 年龄
    
    UILabel *age = [[UILabel alloc] init];
    age.frame = CGRectMake(self.width *0.5, CGRectGetMaxY(info.frame) + maginY, 200, 100);
    age.textColor = KRGBColor(153, 154, 155);
    
    NSString *ageString = self.model.Birthday;  //数据传入
    
    NSString *visit = self.model.VisitTime;
    
//    NSLog(@"birth %@",ageString);
    NSLog(@"visit %@",visit);
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    NSDate *date1 = [fmt dateFromString:ageString];
    NSData *date2 = [fmt dateFromString:visit];
    
//    NSLog(@" %@ %@",ageString,visit);
    
    
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    
    ageString = [NSString stringWithFormat:@"%ld",iAge];
    
//    NSLog(@"age %ld",iAge);
    

    
    
    
    
    NSMutableAttributedString *ageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"年龄 : %@岁",ageString]];
    
    [ageStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [age setAttributedText:ageStr] ;
    [age sizeToFit];
    
    
    [view addSubview:age];
    
    
    // 职业
    
    UILabel *job = [[UILabel alloc] init];
    job.frame = CGRectMake(self.width *0.5, CGRectGetMaxY(age.frame) + maginY, 200, 100);
    job.textColor = KRGBColor(153, 154, 155);
    
    NSString *jobString = self.model.Profession;  //数据传入
    
    NSMutableAttributedString *jobStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"职业 : %@",jobString]];
    
    [jobStr addAttribute:NSForegroundColorAttributeName value:KRGBColor(153, 154, 155) range:redRange];
    [job setAttributedText:jobStr] ;
    [job sizeToFit];
    
   
    
    [view addSubview:job];
 
    
    
    
    if ([self.delegete respondsToSelector:@selector(headViewHeight:)]) {
        
        
        [self.delegete headViewHeight:CGRectGetMaxY(view.frame)];
        
    }
    
    
    
    
    
}








-(NSArray *)BtnArray
{

    if (!_BtnArray) {
        
     
      
//        NSRange range = [self.model.KeyWords rangeOfString:@";"];
//        
//        type = [type substringFromIndex:range.location + range.length];

        
       
        _BtnArray = [self.model.KeyWords componentsSeparatedByString:@"；"];
        
        if (_BtnArray.count == 1) {
            
            
             _BtnArray = [self.model.KeyWords componentsSeparatedByString:@";"];
            
        }
        
        
//        NSLog(@"count %ld",_BtnArray.count);
//        
//        
//        NSLog(@"keyword %@",self.model.KeyWords);
        
        
        
//        _BtnArray = [NSMutableArray arrayWithObjects:@"结节性硬化",@"遗传性疾病",@"精神障碍",@"神经病" ,nil];
//        
    }

    return _BtnArray;


}


#pragma mark 添加数据
-(void)setModel:(ZRTCaseModel *)model
{
    _model = model;

   
}


#pragma mark 评分成功

-(void)setCaseID:(NSString *)caseID
{

    _caseID = caseID;
    
  //  NSLog(@" %@",caseID);

    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/GetCaseScore";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:url parameters:@{@"caseId":caseID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
     
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
        
     //   NSLog(@" %@",jsonDict[@"score"]);
        
        CGFloat halfWidth = self.imageW/10-3;
        
        CGFloat score = [jsonDict[@"score"] floatValue];
        
        CGFloat starWidth;
        
        CGFloat margin = 7;
        
        if (score == 0) {
            
            starWidth = 0;
            
        }else if (score == 0.5){
            
            starWidth = halfWidth;
            
        }else if (score == 1){
            
            starWidth = halfWidth*2;
            
        }else if (score == 1.5){
            
            starWidth = halfWidth*3 +margin;
        }else if (score == 2){
            
            starWidth = halfWidth*4 +margin;
        }else if (score == 2.5){
            
            starWidth = halfWidth*5 +margin*2;
        }else if (score == 3){
            
            starWidth = halfWidth*6 +margin*2;
        }else if (score == 3.5){
            
            starWidth = halfWidth*7 +margin*3;
        }else if (score == 4){
            
            starWidth = halfWidth*8 +margin*3;
        }else if (score == 4.5){
            
            starWidth = halfWidth*9 +margin*4;
        }else{
            
            starWidth = halfWidth*10 +margin*4 +1;
        }
       
       
        self.starImageView.frame = CGRectMake(0, 0, starWidth, self.image.height);
        
//        NSLog(@"刷表");
        
    
        self.count.text = [NSString stringWithFormat:@"(%.1f)",score];
        
        [self.count sizeToFit];
   
        NSLog(@"connt %f  %@",score,self.count.text);
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
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
