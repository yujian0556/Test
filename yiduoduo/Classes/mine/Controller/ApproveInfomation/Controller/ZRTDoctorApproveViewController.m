//
//  ZRTDoctorApproveViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/6/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDoctorApproveViewController.h"

#import "OZHPickerView.h"

#import "ZRTSelectModel.h"

#import "MBProgressHUD+MJ.h"

@interface ZRTDoctorApproveViewController () <UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>

@property (nonatomic,copy) NSString *year;

@end

@implementation ZRTDoctorApproveViewController
{
    NSMutableArray *_textFieldArr;
    UITextView *_tv;
    
    UIScrollView *_sv;
    CGPoint _oldPoint;
    
    UIButton *_cityChooseBtn;
    UIButton *_yearChooseBtn;
    UIButton *_degreeChooseBtn;
    UIButton *_officeChooseBtn;
    UIButton *_backGroundChooseBtn;
    
    UIView *_grayView;
    UIView *_yearBGView;
    UIView *_degreeBGView;
    UIView *_officeBGView;
    UIView *_BGView;
    
    OZHPickerView *_cityPickerView;
    UIPickerView *_officePickerView;
    NSMutableArray *_yearArray;
    NSArray *_degreeArray;
    NSMutableArray *_officeArray;
    NSArray *_backGroundArray;
    
    NSString *_currentYear;
    NSString *_currentDegree;
    NSString *_currentOffice;
    NSString *_currentBG;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createArray];
    
    [self getSectionOfficeData];
    
    [self setLeftNavigationBar];
    
    [self setKeyBoardNotificationCenter];
    
    [self createUI];
    
    [self createPickerView];
    
    
    
    
    
    
    
    
    
    
    
        
}

- (void)createArray {
    
    _officeArray = [[NSMutableArray alloc] init];
    _yearArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fillUserInfo {
    
    NSDictionary *userInfo = [DEFAULT objectForKey:@"UserDict"];
    /*
     AddTime = "2015/7/14 10:43:08";
     Address = sdfas;
     Area = "";
     City = "\U5317\U4eac";
     DBCoun = "";
     Email = asfasf;
     GraduationDate = "";
     IDCard = fasdf;
     Id = 30;
     ImgUrl = "";
     Major = Disbands;
     NickName = af;
     PassWord = 123456;
     PracticeCard = Futuristic;
     Professional = Things;                                                  职称
     Province = "";
     QDScore = "";
     R1 = "\U666e\U901a\U533b\U751f/\U62a4\U58eb/\U836f\U5e08/\U804c\U5458"; 工作背景
     R2 = "\U4e2d\U4e13";                                                    学历学位
     R3 = "";
     R4 = "";
     R5 = "";
     RMBCount = "";
     RealName = asfda;
     SectionOffice = 32;
     Sex = 1;
     Specialty = "";
     Status = 2;
     Tel = 18707177018;
     UnitName = Hdkdjdj;
     University = Jfhdjdudj;
     Workage = 2015;
     */
    
//    UITextField *realName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *unitName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *professional = (UITextField *)[self.view viewWithTag:8001];
    UITextField *practiceCard = (UITextField *)[self.view viewWithTag:8002];
    UITextField *university = (UITextField *)[self.view viewWithTag:8003];
    UITextField *major = (UITextField *)[self.view viewWithTag:8004];
    
//    realName.text = userInfo[@"RealName"];
    
    NSLog(@" %@ %@ %@ %@ %@",userInfo[@"UnitName"],userInfo[@"Professional"],userInfo[@"PracticeCard"],userInfo[@"University"],userInfo[@"Major"]);
    
    unitName.text = userInfo[@"UnitName"];
    professional.text = userInfo[@"Professional"];
    practiceCard.text = userInfo[@"PracticeCard"];
    university.text = userInfo[@"University"];
    major.text = userInfo[@"Major"];
    
    
//    realName.returnKeyType = UIReturnKeyDone;
    unitName.returnKeyType = UIReturnKeyDone;
    professional.returnKeyType = UIReturnKeyDone;
    practiceCard.returnKeyType = UIReturnKeyDone;
    university.returnKeyType = UIReturnKeyDone;
    major.returnKeyType = UIReturnKeyDone;

    
    
    
    
    
//    _cityName = userInfo[@"City"];
//    if (![_cityName isEqualToString:@""]) {
//        [_cityChooseBtn setTitle:_cityName forState:UIControlStateNormal];
//    }
    
    
//    NSLog(@"one %@",_officeArray);
//    [_officeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//       
//        ZRTSelectModel *model = (ZRTSelectModel *)obj;
//        
//        NSLog(@"two %@",userInfo[@"SectionOffice"]);
//        
//        if ([userInfo[@"SectionOffice"] isEqualToString:model.Id]) {
//            _currentOffice = model.Title;
//            
//            NSLog(@"three %@",_currentOffice);
//        }
//        
//    }];
    
    NSLog(@"two %@",userInfo[@"SectionOffice"]);
    
    _currentOffice = userInfo[@"SectionOffice"];
    
    if (![_currentOffice isEqualToString:@""]) {
        
        [_officeChooseBtn setTitle:userInfo[@"SectionOffice"] forState:UIControlStateNormal];
    }
    
    
    
//    if (![_currentOffice isEqualToString:@""]) {
//        [_officeChooseBtn setTitle:_currentOffice forState:UIControlStateNormal];
//    }
    
    
    
    _currentBG = userInfo[@"R1"];
    
    if (![_currentBG isEqualToString:@""]) {
        [_backGroundChooseBtn setTitle:_currentBG forState:UIControlStateNormal];
    }
    
    
    _currentYear = userInfo[@"Workage"];
    
    NSLog(@"第一个年 %@",_currentYear);
    
    if (![_currentYear isEqualToString:@"0"]) {
        
        if (![_currentYear isEqualToString:@""]) {
            
            NSString *year = [_currentYear substringWithRange:NSMakeRange(0, 4)];
            [_yearChooseBtn setTitle:year forState:UIControlStateNormal];
        }
        
    }
    
    
    
    
    _currentDegree = userInfo[@"R2"];
    
    NSLog(@"学历 %@",_currentDegree);
    
    if (![_currentDegree isEqualToString:@""]) {
        [_degreeChooseBtn setTitle:userInfo[@"R2"] forState:UIControlStateNormal];
    }
    
  
    

}
    

#pragma mark - UI

#define KInputViewHeight 50



- (void)createUI {
    
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *doctorApproveSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    _sv = doctorApproveSV;
    
    doctorApproveSV.delegate = self;
    
    NSArray *nameArr = @[/*@"*真实姓名",@"*所在城市",*/@"*所属医院",@"*所属科室",@"*医务职称",@"工作背景",@"从业年份",@"*执业证号",@"毕业院校",@"所学专业",@"学历学位"];
    NSArray *placeHoldArr = @[/*@"",@"",*/@"填写医院名称",@"",@"填写职称",@"",@"",@"填写执业证号",@"填写毕业院校名称",@"填写专业名称"];
    
    NSInteger tagLCount = 0;
    NSInteger tagTFCount = 0;
    
    _textFieldArr = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [nameArr count]; i++) {
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KInputViewHeight * i, 120, KInputViewHeight)];
        nameLabel.text = nameArr[i];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.tag = 7900 + (tagLCount++);
        
        
        // 分割线
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, KInputViewHeight * (i+1) -1, KScreenWidth, 1)];
        
        line.backgroundColor = KRGBColor(243,243,243);
        
        [doctorApproveSV addSubview:line];
        
        
        //NSLog(@"nameLabel.tag == %ld",nameLabel.tag);
        
        if (i == 0 || i== 2 || i == 5 || i == 6 || i == 7) {
            
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, KInputViewHeight * i, KScreenWidth - 120 - 20, KInputViewHeight-1)];
            
            inputTextField.borderStyle = UITextBorderStyleNone;
            inputTextField.backgroundColor = [UIColor whiteColor];
            inputTextField.placeholder = placeHoldArr[i];
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.tag = 8000 + (tagTFCount++);
            inputTextField.delegate = self;
            
            //NSLog(@"inputTextField.tag == %ld",inputTextField.tag);

//            if (i == 0) {
//                inputTextField.text = self.realName;
//            }
            
            [_textFieldArr addObject:inputTextField];
            
            [doctorApproveSV addSubview:inputTextField];
        }
//        else if (i == 1) {//选择城市
//            _cityChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            
//            _cityChooseBtn.frame = CGRectMake(120 , i * 40, KScreenWidth - 120 - 20 , 40);
//            
//          
//            _cityChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//            
//            [_cityChooseBtn setTitle:_cityName forState:UIControlStateNormal];
//            
//            [_cityChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//            [_cityChooseBtn addTarget:self action:@selector(chooseCitylist) forControlEvents:UIControlEventTouchUpInside];
//            
//            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityChooseBtn.frame) , i * 40 + 14, 12, 12)];
//            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
//            
//            [doctorApproveSV addSubview:arrowIV];
//            [doctorApproveSV addSubview:_cityChooseBtn];
//        }
        else if (i == 1) {//选择科室
            _officeChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _officeChooseBtn.frame = CGRectMake(120 , i * KInputViewHeight, KScreenWidth - 120 - 20 , KInputViewHeight);
            
//            if (KScreenWidth == 320) {
//                [_officeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//            }
//            else if (KScreenWidth == 375) {
//                [_officeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
//            }
//            else {
//                [_officeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 175, 0, 0)];
//            }
            
            _officeChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            [_officeChooseBtn setTitle:@"选择科室" forState:UIControlStateNormal];
            
            [_officeChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_officeChooseBtn addTarget:self action:@selector(chooseOffice) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_officeChooseBtn.frame), i * KInputViewHeight + 19, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [doctorApproveSV addSubview:arrowIV];
            [doctorApproveSV addSubview:_officeChooseBtn];
        }
        else if (i == 3) {//选择工作背景
            _backGroundChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _backGroundChooseBtn.frame = CGRectMake(120, i * KInputViewHeight, KScreenWidth - 120 - 20, KInputViewHeight);
            
//            if (KScreenWidth == 320) {
//                [_backGroundChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//            }
//            else if (KScreenWidth == 375) {
//                [_backGroundChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
//            }
//            else {
//                [_backGroundChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 180, 0, 0)];
//            }
            
            _backGroundChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

            [_backGroundChooseBtn setTitle:@"选择背景" forState:UIControlStateNormal];
            
            [_backGroundChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_backGroundChooseBtn addTarget:self action:@selector(chooseJobBackGround) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_officeChooseBtn.frame), i * KInputViewHeight + 19, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [doctorApproveSV addSubview:arrowIV];
            [doctorApproveSV addSubview:_backGroundChooseBtn];
        }
        else if (i == 4) {//选择年份
            _yearChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _yearChooseBtn.frame = CGRectMake(120, i * KInputViewHeight, KScreenWidth - 120 - 20, KInputViewHeight);
            
//            if (KScreenWidth == 320) {
//                [_yearChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//            }
//            else if (KScreenWidth == 375) {
//                [_yearChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
//            }
//            else {
//                [_yearChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 180, 0, 0)];
//            }
            
            _yearChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

            
            [_yearChooseBtn setTitle:@"2015年" forState:UIControlStateNormal];
            
            [_yearChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_yearChooseBtn addTarget:self action:@selector(chooseYear) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_officeChooseBtn.frame), i * KInputViewHeight + 19, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [doctorApproveSV addSubview:arrowIV];
            [doctorApproveSV addSubview:_yearChooseBtn];
        }
        else if (i == 8) {//选择学历
            _degreeChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _degreeChooseBtn.frame = CGRectMake(120 , i * KInputViewHeight, KScreenWidth - 120 - 20 , KInputViewHeight);
            
//            if (KScreenWidth == 320) {
//                [_degreeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//            }
//            else if (KScreenWidth == 375) {
//                [_degreeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
//            }
//            else {
//                [_degreeChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 140, 0, 0)];
//            }
            
            _degreeChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

            
            [_degreeChooseBtn setTitle:@"选择学历学位" forState:UIControlStateNormal];
            
            [_degreeChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_degreeChooseBtn addTarget:self action:@selector(chooseDegree) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_degreeChooseBtn.frame) , i * KInputViewHeight + 19, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [doctorApproveSV addSubview:arrowIV];
            [doctorApproveSV addSubview:_degreeChooseBtn];
        }
//        else if (i == 9) {
        

            
//            UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            sureButton.frame = CGRectMake(20, CGRectGetMaxY(nameLabel.frame) + 10, KScreenWidth - 40, 40);
//            [sureButton setTitle:@"完成认证" forState:UIControlStateNormal];
//            [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [sureButton setBackgroundColor:KMainColor];
//            [sureButton addTarget:self action:@selector(finishDoctorApprove) forControlEvents:UIControlEventTouchUpInside];
//            
//            [doctorApproveSV addSubview:sureButton];
        
        
            doctorApproveSV.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(_degreeChooseBtn.frame) + 20);
//        }
        
        [doctorApproveSV addSubview:nameLabel];
        
    }
    
    [self.view addSubview:doctorApproveSV];
    
    [self fillUserInfo];
}

#pragma mark - pickerView

#define kPickOrignY 200 //pickView变化高度
#define kPickHeight 260 //pickView实际高度
#define kGrayViewHeight self.view.frame.size.height - kPickHeight //grayView高度

- (void)createPickerView {

    //城市
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _grayView.backgroundColor =[UIColor blackColor];
    _grayView.alpha = 0.5;
    [self.view addSubview:_grayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(clickForSure)];
    [_grayView addGestureRecognizer:tap];
    
    _cityPickerView = [[OZHPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kPickHeight)];
    [_cityPickerView.sureBtn addTarget:self action:@selector(clickForSure) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_cityPickerView];
    
    //工作背景
    _backGroundArray = @[@"院长",@"副院长",@"科室/部门主任",@"科室/部门副主任",@"普通医生/护士/药师/职员",];
    _BGView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _BGView.backgroundColor = [UIColor clearColor];
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kPickHeight)];
    backGroundView.backgroundColor =[UIColor blackColor];
    backGroundView.alpha = 0.5;
    
    UITapGestureRecognizer *backGroundTap = [[UITapGestureRecognizer alloc] init];
    [backGroundTap addTarget:self action:@selector(clickBGForSure)];
    
    UIPickerView *backGroundPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backGroundView.frame), KScreenWidth, kPickHeight)];
    backGroundPickerView.backgroundColor = [UIColor whiteColor];
    backGroundPickerView.delegate = self;
    backGroundPickerView.dataSource = self;
    backGroundPickerView.tag = 3003;
    
    UIButton *BGBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    BGBtn.frame = CGRectMake(KScreenWidth - 50, CGRectGetMaxY(backGroundView.frame), 50, 30);
    BGBtn.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
    [BGBtn setTitle:@"确定" forState:UIControlStateNormal];
    [BGBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [BGBtn addTarget:self action:@selector(clickBGForSure) forControlEvents:UIControlEventTouchUpInside];
    
    [_BGView addSubview:backGroundView];
    [backGroundView addGestureRecognizer:backGroundTap];
    [_BGView addSubview:backGroundPickerView];
    [_BGView addSubview:BGBtn];
    
    [self.view addSubview:_BGView];
    
    //年份
    _yearBGView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _yearBGView.backgroundColor = [UIColor clearColor];
    
    UIView *yearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kPickHeight)];
    yearView.backgroundColor =[UIColor blackColor];
    yearView.alpha = 0.5;
   
    UITapGestureRecognizer *yearTap = [[UITapGestureRecognizer alloc] init];
    [yearTap addTarget:self action:@selector(clickYearForSure)];
    

    
    for (NSInteger i = 2015; i > 1949; i--) {
        [_yearArray addObject:[NSString stringWithFormat:@"%ld年",i]];
    }
    
    UIPickerView *yearPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(yearView.frame), KScreenWidth, kPickHeight)];
    yearPickerView.backgroundColor = [UIColor whiteColor];
    yearPickerView.delegate = self;
    yearPickerView.dataSource = self;
    yearPickerView.tag = 3000;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sureBtn.frame = CGRectMake(KScreenWidth - 50, CGRectGetMaxY(yearView.frame), 50, 30);
    sureBtn.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(clickYearForSure) forControlEvents:UIControlEventTouchUpInside];
    
    [_yearBGView addSubview:yearView];
    [yearView addGestureRecognizer:yearTap];
    [_yearBGView addSubview:yearPickerView];
    [_yearBGView addSubview:sureBtn];
    
    [self.view addSubview:_yearBGView];
    
    
    //学历
    _degreeArray = @[@"中专",@"高中",@"大专",@"本科",@"硕士",@"博士",@"其他"];
    
    _degreeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _degreeBGView.backgroundColor = [UIColor clearColor];
    
    UIView *degreeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kPickHeight)];
    degreeView.backgroundColor =[UIColor blackColor];
    degreeView.alpha = 0.5;
    
    UITapGestureRecognizer *degreeTap = [[UITapGestureRecognizer alloc] init];
    [degreeTap addTarget:self action:@selector(clickDegreeForSure)];
    
    UIPickerView *degreePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(degreeView.frame), KScreenWidth, kPickHeight)];
    degreePickerView.backgroundColor = [UIColor whiteColor];
    degreePickerView.delegate = self;
    degreePickerView.dataSource = self;
    degreePickerView.tag = 3001;
    
    UIButton *degreeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    degreeBtn.frame = CGRectMake(KScreenWidth - 50, CGRectGetMaxY(yearView.frame), 50, 30);
    degreeBtn.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
    [degreeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [degreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [degreeBtn addTarget:self action:@selector(clickDegreeForSure) forControlEvents:UIControlEventTouchUpInside];
    
    [degreeView addGestureRecognizer:degreeTap];
    [_degreeBGView addSubview:degreeView];
    [_degreeBGView addSubview:degreePickerView];
    [_degreeBGView addSubview:degreeBtn];
    [self.view addSubview:_degreeBGView];
    
    //科室
    _officeBGView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _officeBGView.backgroundColor = [UIColor clearColor];
    
    UIView *officeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - kPickHeight)];
    officeView.backgroundColor =[UIColor blackColor];
    officeView.alpha = 0.5;
    
    UITapGestureRecognizer *officeTap = [[UITapGestureRecognizer alloc] init];
    [officeTap addTarget:self action:@selector(clickOfficeForSure)];
    
    _officePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(officeView.frame), KScreenWidth, kPickHeight)];
    _officePickerView.backgroundColor = [UIColor whiteColor];
    _officePickerView.delegate = self;
    _officePickerView.dataSource = self;
    _officePickerView.tag = 3002;
    
    UIButton *officeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    officeBtn.frame = CGRectMake(KScreenWidth - 50, CGRectGetMaxY(officeView.frame), 50, 30);
    officeBtn.backgroundColor = [UIColor colorWithRed:66.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1];
    [officeBtn setTitle:@"确定" forState:UIControlStateNormal];
    [officeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [officeBtn addTarget:self action:@selector(clickOfficeForSure) forControlEvents:UIControlEventTouchUpInside];
    
    [officeView addGestureRecognizer:officeTap];
    [_officeBGView addSubview:officeView];
    [_officeBGView addSubview:_officePickerView];
    [_officeBGView addSubview:officeBtn];
    [self.view addSubview:_officeBGView];
}

//#pragma mark - 选择城市
//- (void)clickForSure {
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        _grayView.frame = CGRectMake(0, -(KScreenHeight - kPickHeight), KScreenWidth, kGrayViewHeight);
//        
//        _cityPickerView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, kPickHeight);
//        
//        if ([_cityPickerView.cityStr isEqualToString:_cityPickerView.provinceStr]) {
//            [_cityChooseBtn setTitle:[NSString stringWithFormat:@"%@市",_cityPickerView.cityStr] forState:UIControlStateNormal];
//        }
//        else if ([_cityPickerView.cityStr isEqualToString:@"北京"]) {
//            [_cityChooseBtn setTitle:@"北京市" forState:UIControlStateNormal];
//        }
//        else {
//            [_cityChooseBtn setTitle:[NSString stringWithFormat:@"%@省%@市",_cityPickerView.provinceStr,_cityPickerView.cityStr] forState:UIControlStateNormal];
//        }
//        
//        _cityName = _cityChooseBtn.currentTitle;
//    }];
//    
//}
//
///**
// 选择城市
// */
//- (void)chooseCitylist {
//    
//    //NSLog(@"选择城市");
//    
//    [self resignTextField];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        _grayView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
//        _cityPickerView.frame  = CGRectMake(0, KScreenHeight - kPickHeight, KScreenWidth, kPickHeight);
//        
//    }];
//    
//    
//}

#pragma mark - 选择工作背景
- (void)chooseJobBackGround {
    
    [self resignTextField];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _BGView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }];
}

- (void)clickBGForSure {
    [UIView animateWithDuration:0.3 animations:^{
        
        _BGView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);

        if (!_currentBG) {
            _currentBG = @"院长";
        }

        [_backGroundChooseBtn setTitle:_currentBG forState:UIControlStateNormal];
        
    }];
}

#pragma mark - 选择年份
/**
 选择年份
 */
- (void)chooseYear {
    
    [self resignTextField];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _yearBGView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }];
    
}

/**
 确定年份
 */
- (void)clickYearForSure {
    [UIView animateWithDuration:0.3 animations:^{
        
        _yearBGView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);

        if (!_currentYear) {
            _currentYear = @"2015";
        }
        
        [_yearChooseBtn setTitle:_currentYear forState:UIControlStateNormal];
    }];
}

#pragma mark - 选择学历
- (void)chooseDegree {
 
    [self resignTextField];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _degreeBGView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }];
}

- (void)clickDegreeForSure {
    [UIView animateWithDuration:0.3 animations:^{
        
        _degreeBGView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);
        
        if (!_currentDegree) {
            _currentDegree = @"中专";
        }

        [_degreeChooseBtn setTitle:_currentDegree forState:UIControlStateNormal];
        
    }];
}

#pragma mark - 选择科室
- (void)chooseOffice {
    
    [self resignTextField];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _officeBGView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        
    }];
}

- (void)clickOfficeForSure {
    [UIView animateWithDuration:0.3 animations:^{
        
        _officeBGView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight);

        if (!_currentOffice) {
            _currentOffice = @"精神卫生科";
        }

        [_officeChooseBtn setTitle:_currentOffice forState:UIControlStateNormal];
        
    }];
}

#pragma mark - pickerView代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView.tag == 3000) {
        return _yearArray.count;
    }
    else if (pickerView.tag == 3001) {
        return _degreeArray.count;
    }
    else if (pickerView.tag == 3003) {
        return _backGroundArray.count;
    }
    return _officeArray.count;
    
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag == 3000) {
        return _yearArray[row];
    }
    else if (pickerView.tag == 3001) {
        return _degreeArray[row];
    }
    else if (pickerView.tag == 3003) {
        return _backGroundArray[row];
    }
    return [_officeArray[row] Title];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 3000) {
        _currentYear = _yearArray[row];
    }
    else if (pickerView.tag == 3001) {
        _currentDegree = _degreeArray[row];
    }
    else if (pickerView.tag == 3003) {
        _currentBG = _backGroundArray[row];
    }
    else {
        _currentOffice = [_officeArray[row] Title];
    }
}


/**
 完成医师认证
 */
- (void)finishDoctorApprove {
    
    
//    [self.navigationController popViewControllerAnimated:YES];
    
//    NSString *city;
//    if ([_cityPickerView.cityStr isEqualToString:@"北京"]) {
//        city = _cityPickerView.cityStr;
//    }
//    else if ([_cityPickerView.cityStr isEqualToString:_cityPickerView.provinceStr]) {
//        city = _cityPickerView.cityStr;
//    }
//    else {
//        city = [NSString stringWithFormat:@"%@,%@",_cityPickerView.provinceStr,_cityPickerView.cityStr];
//    }
    
//    UITextField *realName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *unitName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *professional = (UITextField *)[self.view viewWithTag:8001];
    UITextField *practiceCard = (UITextField *)[self.view viewWithTag:8002];
    UITextField *university = (UITextField *)[self.view viewWithTag:8003];
    UITextField *major = (UITextField *)[self.view viewWithTag:8004];
    
    
    
    NSLog(@"科室 %@",_currentOffice);
    
    
    if (!_currentOffice) {
        
        _currentOffice = @"请选择科室";
    }
    
    
//    NSString *classid;
//    if (!_currentOffice) {
//        classid = @"";
//    }
//    else {
//        for (NSInteger i = 0; i < _officeArray.count; i++) {
//            
//            if ([_currentOffice isEqualToString:[_officeArray[i] Title]]) {
//                classid = [_officeArray[i] Id];
//            }
//            
//        }
//
//    }
    
    
    if (![_currentYear isEqualToString:@"0"]) {
        
        
        if (![_currentYear isEqualToString:@""]) {
            
            NSLog(@"第二个年份 %@",_currentYear);
            
            self.year = [_currentYear substringWithRange:NSMakeRange(0, 4)];
            
        }
        
    }else{
        
        self.year = @"2015";
        
        
    }
    
    
    if (!_currentBG) {
        _currentBG = @"";
    }
    
    if (!_currentDegree) {
        _currentDegree = @"";
    }
    
    
    
    NSLog(@"职称 %@",professional.text);
    
    //不为空
    if (_currentOffice) {
        if (/*[realName.text isEqualToString:@""] || [city isEqualToString:@""] ||*/ [unitName.text isEqualToString:@""] || [_currentOffice isEqualToString:@""] || [practiceCard.text isEqualToString:@""] || [professional.text isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"必填项不能为空"];
            
            return;
            
        }
        else {
            //NSLog(@"Id == %@,city == %@,unitName == %@,classid == %@,professional == %@,_currentBG == %@,year == %@,practiceCard == %@,university == %@,major == %@,_currentDegree == %@,",[DEFAULT objectForKey:@"UserDict"][@"Id"],city,unitName.text,classid,professional.text,_currentBG,year,practiceCard.text,university.text,major.text,_currentDegree);
            
            
            NSLog(@"year %@",self.year);
            
            NSDictionary *dic = @{
                                  @"userId":[DEFAULT objectForKey:@"UserDict"][@"Id"],
                                  @"unitName":unitName.text,
                                  @"sectionOffice":_currentOffice,
                                  @"professional":professional.text,
                                  @"workBg":_currentBG,
                                  @"workAge":self.year,
                                  @"practiceCard":practiceCard.text,
                                  @"university":university.text,
                                  @"major":major.text,
                                  @"graduce":_currentDegree
                                  };
            
            NSLog(@"发送前 %@",dic);
            
            [self approveDoctorWithDictionary:dic];
        }
    }
    else {
        [MBProgressHUD showError:@"必填项不能为空"];
    }
    

}

#pragma mark - 导航控制器
- (void)setLeftNavigationBar
{
    
    self.title = @"医生认证";
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:[UIImage imageNamed:nil] target:self action:@selector(didClickLeft)];
    
    
    
    // 右边
    UIButton *composeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeBtn setTitle:@"提交" forState:UIControlStateNormal];
    [composeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [composeBtn addTarget:self action:@selector(finishDoctorApprove) forControlEvents:UIControlEventTouchUpInside];
    
    
    [composeBtn sizeToFit];
    UIBarButtonItem *compose = [[UIBarButtonItem alloc] initWithCustomView:composeBtn];
    
    self.navigationItem.rightBarButtonItem = compose;

    
    
}
/**
 *  首页导航栏左按钮:返回
 */
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark - KeyBoard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        
        
        return NO;
    }
    
    return YES;
}

- (void)setKeyBoardNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    //NSLog(@"键盘将要弹出");
    //UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    //UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";

    _oldPoint = _sv.contentOffset;
    
    for (UITextField *tf in _textFieldArr) {
        
        if ([tf isFirstResponder]) {

            [UIView animateWithDuration:0.3 animations:^{
                _sv.contentOffset = CGPointMake(0, CGRectGetMinY(tf.frame));
            }];
        }
    }
    
    if ([_tv isFirstResponder]) {

        [UIView animateWithDuration:0.3 animations:^{
            _sv.contentOffset = CGPointMake(0, CGRectGetMinY(_tv.frame));
        }];
            
    }
    
}

- (void)keyBoardWillHidden:(NSNotification *)notification {
    //NSLog(@"键盘将要隐藏");
    
    [UIView animateWithDuration:0.3 animations:^{
//        _sv.contentOffset = _oldPoint;
        
         _sv.contentOffset = CGPointMake(0, 0);
    }];
}

#pragma mark - 网络请求
- (void)approveDoctorWithDictionary:(NSDictionary *)dict {
    
//    __weak typeof(self) weakSelf = self;
    
//    NSLog(@" %@",dict);
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[OZHNetWork sharedNetworkTools] ValidateDoctorWithDictionary:dict andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
//     [weakSelf.navigationController popViewControllerAnimated:NO];
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
     
            [MBProgressHUD showSuccess:@"认证成功"];
            
            
//            if ([weakSelf.delegate respondsToSelector:@selector(backFromZRTDoctorApproveViewController)]) {
//                [weakSelf.delegate backFromZRTDoctorApproveViewController];
//            }
            
            [self reloadUserData];
            
        }
        else {
            
          
            
            [MBProgressHUD showError:@"认证失败"];
            
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"医师认证 error == %@",error);
        
    }];
    
}

#pragma mark - 科室网络请求
- (void)getSectionOfficeData {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getSectionOfficeDataType:@"0" Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [_officeArray removeAllObjects];
        
        [weakSelf dealModelWithDict:jsonDict];
        
        [self fillUserInfo];
        
       
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        
        
    }];
    
}

- (void)dealModelWithDict:(NSDictionary *)jsonDict {
    
    for (NSDictionary *obj in jsonDict[@"ds"]) {
        
        ZRTSelectModel *model = [ZRTSelectModel ModelWithDict:obj];
        
        [_officeArray addObject:model];
    }
    
   
    
    [_officePickerView reloadAllComponents];
}

#pragma mark - 其他
- (void)resignTextField {
    
//    UITextField *realName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *unitName = (UITextField *)[self.view viewWithTag:8000];
    UITextField *professional = (UITextField *)[self.view viewWithTag:8001];
    UITextField *practiceCard = (UITextField *)[self.view viewWithTag:8002];
    UITextField *university = (UITextField *)[self.view viewWithTag:8003];
    UITextField *major = (UITextField *)[self.view viewWithTag:8004];

//    [realName resignFirstResponder];
    [unitName resignFirstResponder];
    [professional resignFirstResponder];
    [practiceCard resignFirstResponder];
    [university resignFirstResponder];
    [major resignFirstResponder];
    
}


//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//    
//    [self resignTextField];
//
//}


// 刷新用户信息
-(void)reloadUserData
{
    
    OZHNetWork *user = [[OZHNetWork alloc] init];
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    [user getUserInfomationWithId:userDict[@"Id"] Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        
        NSDictionary *dict = [[NSDictionary alloc] init];
        for (NSDictionary *dic in jsonDict) {
            
            dict = dic;
            
        }
        
        for (NSDictionary *infoDict in dict[@"ds"]) {
            
            
            [DEFAULT setObject:infoDict forKey:@"UserDict"];
            
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"重新刷新用户信息失败 %@",error);
        
    }];
    
    
}





#pragma mark 懒加载

-(NSString *)year
{

    if (!_year) {
        
        _year = [[NSString alloc] init];
    }

    return _year;

}






@end

