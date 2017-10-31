//
//  ZRTRZViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/6/12.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTRZViewController.h"

#import "ZRTDoctorApproveViewController.h"

#import "OZHPickerView.h"

#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


@interface ZRTRZViewController () <UITextFieldDelegate,ZRTDoctorApproveViewControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) OZHPickerView *cityPickView;
@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UIButton *cityChooseBtn;

@property (nonatomic,copy) NSString *currentCity;

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UIButton *headBtn;

@property (nonatomic,strong) UIButton *approveBtn;

@property (nonatomic,assign) BOOL isClickSure;


//@property (nonatomic,assign) BOOL isApproveDoctor;

@end

@implementation ZRTRZViewController
{
    NSMutableArray *_textFieldArr;

    UIButton *_maleButton;
    UIButton *_femaleButton;
    
    NSString *_realName;
    NSString *_cityName;
    
    UIScrollView *_sv;
    CGPoint _oldPoint;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        
//        self.hidesBottomBarWhenPushed = YES;
//        
//    }
//    return self;
//}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
    
    self.isClickSure = NO;
    
//    NSLog(@" %@",[DEFAULT objectForKey:@"isSelectCity"]);
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    
//    if ([DEFAULT objectForKey:@"isSelectCity"]) {
//        
//        [_cityChooseBtn setTitle:[DEFAULT objectForKey:@"city"] forState:UIControlStateNormal];
//    
//    }else{
    
//        NSLog(@"maybe %@",userDict[@"City"]);
//        
//        if (![userDict[@"City"] isEqualToString:@""]) {
//        
//            [_cityChooseBtn setTitle:userDict[@"City"] forState:UIControlStateNormal];
//        }
    
//    }
    
    
//    [DEFAULT setObject:NO forKey:@"isSelectCity"];
    

    
    NSString *status = userDict[@"Status"];
    
    if ([status isEqualToString:@"2"]) {  // 认证
        
        
        [_approveBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [_approveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
    }

    
    
//     NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    
    
    
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
      NSLog(@"viewDidLoad");
    
    self.view.backgroundColor = KGrayColor;
    
    
    
    [self setLeftNavigationBar];
    
    [self setKeyBoardNotificationCenter];
    
    [self createUI];
    
    [self createPickerView];
    
}


- (void)fillUserInfo {
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];

    //填充textField
    UITextField *nickNameTF = (UITextField *)[self.view viewWithTag:7700];
    UITextField *realNameTF = (UITextField *)[self.view viewWithTag:7701];
    UITextField *addressTF = (UITextField *)[self.view viewWithTag:7702];
    UITextField *IdNumberTF = (UITextField *)[self.view viewWithTag:7703];
    UITextField *emailAddressTF = (UITextField *)[self.view viewWithTag:7704];

    nickNameTF.text = userDict[@"NickName"];
    realNameTF.text = userDict[@"RealName"];
    addressTF.text = userDict[@"Address"];
    IdNumberTF.text = userDict[@"IDCard"];
    emailAddressTF.text = userDict[@"Email"];
    
    
    nickNameTF.returnKeyType = UIReturnKeyDone;
    realNameTF.returnKeyType = UIReturnKeyDone;
    addressTF.returnKeyType = UIReturnKeyDone;
    IdNumberTF.returnKeyType = UIReturnKeyDone;
    emailAddressTF.returnKeyType = UIReturnKeyDone;

    
    
    
    
    
    if ([userDict[@"Sex"] isEqualToString:@"1"]) {
        
        _maleButton.selected = YES;
        _femaleButton.selected = NO;
        
    }
    else {
        
        _maleButton.selected = NO;
        _femaleButton.selected = YES;
        
    }
    
    
//    NSLog(@"开始 %@",userDict[@"City"]);
    
//    self.currentCity = userDict[@"City"];
//    
//    if (![self.currentCity isEqualToString:@""]) {
//     
//         [_cityChooseBtn setTitle:userDict[@"City"] forState:UIControlStateNormal];
//        
//    }
    
   
//    self.cityPickView.cityStr = userDict[@"City"];
    
    NSLog(@"maybe %@ %@",userDict[@"City"],userDict[@"Id"]);
    
    NSString *city;
    
//    city = [NSString stringWithFormat:@"%@省%@市",userDict[@"Province"],userDict[@"City"]];
    
    if (![userDict[@"Province"] isEqualToString:@""]) {
        
        city = [NSString stringWithFormat:@"%@省%@市",userDict[@"Province"],userDict[@"City"]];
        
        NSString *City = userDict[@"City"];
        
        if ([userDict[@"Province"] isEqualToString:City]) {
            
            city = [NSString stringWithFormat:@"%@市",userDict[@"City"]];
            
        }
        

    }else{
    
        if (![userDict[@"City"] isEqualToString:@""]) {
            
            city = [NSString stringWithFormat:@"%@市",userDict[@"City"]];
        }
        
    }
    
    
   
    
    [_cityChooseBtn setTitle:city forState:UIControlStateNormal];

    
    
    NSString *status = userDict[@"Status"];
    
    if ([status isEqualToString:@"2"]) {  // 认证
        
        
        [_approveBtn setTitle:@"已认证" forState:UIControlStateNormal];
        [_approveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

#define KInputViewWidth KScreenWidth - 120 - 20
#define KInputViewOrignX 120
#define KInputViewHeight 50

#define KSaveApproveButtonHeight 40
#define KSaveButtonWidthCaseOne 150
#define KSaveButtonWidthCaseTwo 100
#define KSaveButtonWidthCaseThree 120
#define KApproveButtonOrignX CGRectGetMaxX(saveBtn.frame)+10
#define KApproveButtonWidth saveBtn.frame.size.width*2

- (void)createUI {
    
    // 基本资料头标题
    
    UIView *headView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headView.backgroundColor = KGrayColor;
    [self.view addSubview:headView];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.text = @"基本资料";
    [headLabel sizeToFit];
    headLabel.center = headView.center;
    headLabel.x = 15;
    headLabel.textColor = KTimeColor;
    [headView addSubview:headLabel];
    
  
    
    UIScrollView *RZSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), KScreenWidth, 0)];
    RZSV.backgroundColor = [UIColor whiteColor];
    _sv = RZSV;
    
    
    
    // 头像
    
    
    UIView *headImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    
    headImageView.backgroundColor = [UIColor whiteColor];
    
    [RZSV addSubview:headImageView];
    
    
    UIView *lineHead = [[UIView alloc] initWithFrame:CGRectMake(0, headImageView.height -1, KScreenWidth, 1)];
    lineHead.backgroundColor = KRGBColor(243,243,243);
    [headImageView addSubview:lineHead];
    
    
    UILabel *headImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0, 0)];
    
    headImageLabel.text = @"头像";
    headImageLabel.font = [UIFont systemFontOfSize:17];
    headImageLabel.textColor = [UIColor blackColor];
    [headImageLabel sizeToFit];
    
    headImageLabel.y = (headImageView.height - headImageLabel.height)/2;
    
    
    [headImageView addSubview:headImageLabel];
    
    // 头像view
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0 , 50, 50)];
    self.headImage.layer.cornerRadius = 25;
    self.headImage.clipsToBounds = YES;
    self.headImage.center = headImageView.center;
    self.headImage.y = (headImageView.height - self.headImage.height)/2;
    self.headImage.x = KScreenWidth - self.headImage.height- 20;
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImagePath,userDict[@"ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
    
    
    [headImageView addSubview:self.headImage];
    
    
    // 头像点击事件
    
    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.headBtn.frame = self.headImage.frame;
    
    [headImageView addSubview:self.headBtn];
    
    [self.headBtn addTarget:self action:@selector(takePictureClick:) forControlEvents:UIControlEventTouchUpInside];

    
    
    
    
    
    
    // 个人资料
    
    _textFieldArr = [[NSMutableArray alloc] init];

    NSArray *nameArr = @[@"昵称",@"姓名",@"性别",@"所在城市",@"通信地址",@"身份证号",@"邮箱",@"专业认证"];
    NSArray *placeHoldArr = @[@"请输入您的昵称",@"2-5个汉字",@"",@"选择城市",@"请输入您的地址",@"请输入您的身份证号",@"请输入您的邮箱"];
    
    NSInteger tagLabel = 0;
    NSInteger tagTextField = 0;
    
    for (NSInteger i = 0; i < [nameArr count]; i++) {
        
        // 名称
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, KInputViewHeight * i+headImageView.height, KInputViewOrignX, KInputViewHeight)];
        nameLabel.text = nameArr[i];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.tag = 7800 + (tagLabel++);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        
        
        
        
        
       // 分割线
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, KInputViewHeight * (i+1) +headImageView.height -1, KScreenWidth, 1)];
        
        line.backgroundColor = KRGBColor(243,243,243);
        
        [RZSV addSubview:line];
        
        
        //TextField
        if (i == 0 || i == 1 || i== 4) {
            
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(KInputViewOrignX, KInputViewHeight * i+headImageView.height, KInputViewWidth, KInputViewHeight)];
            inputTextField.placeholder = placeHoldArr[i];
            inputTextField.tag = 7700 + (tagTextField++);
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.delegate = self;
            
            [RZSV addSubview:inputTextField];
            
            [_textFieldArr addObject:inputTextField];
        }
        //gender button
        else if (i == 2) {
            UIButton *maleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIButton *femaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];

            
        
            [maleBtn setTitle:@"男" forState:UIControlStateNormal];
            [maleBtn setTitle:@"男" forState:UIControlStateSelected];
            [femaleBtn setTitle:@"女" forState:UIControlStateNormal];
            [femaleBtn setTitle:@"女" forState:UIControlStateSelected];
            
            [maleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [maleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [femaleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [femaleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            [maleBtn setImage:[UIImage imageNamed:@"user_sexmale_icon_default"] forState:UIControlStateNormal];
            [maleBtn setImage:[UIImage imageNamed:@"user_sexmale_icon_selected"] forState:UIControlStateSelected];
            [femaleBtn setImage:[UIImage imageNamed:@"user_sexfemale_icon_default"] forState:UIControlStateNormal];
            [femaleBtn setImage:[UIImage imageNamed:@"user_sexfemale_icon_selected"] forState:UIControlStateSelected];
            
            [maleBtn addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventTouchUpInside];
            [femaleBtn addTarget:self action:@selector(changeGender:) forControlEvents:UIControlEventTouchUpInside];
            
            maleBtn.selected = YES;
            
            
            
            //            maleBtn.frame = CGRectMake(120, 50 * i, (KScreenWidth - 120) / 2, 50);
            femaleBtn.frame = CGRectMake(0 , 50 * i+headImageView.height, 0, 0);
            [femaleBtn sizeToFit];
            
            femaleBtn.x = KScreenWidth - femaleBtn.width - 12;
            femaleBtn.height = 50;
            
            maleBtn.frame = CGRectMake(0, 50 * i +headImageView.height, 0, 0);
            [maleBtn sizeToFit];
            maleBtn.x = femaleBtn.x - maleBtn.width - 20;
            maleBtn.height = 50;
            
            
            
            [RZSV addSubview:maleBtn];
            [RZSV addSubview:femaleBtn];
            
            _maleButton = maleBtn;
            _femaleButton = femaleBtn;
            
        }
        //city button
        else if (i == 3) {
            
            _cityChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _cityChooseBtn.frame = CGRectMake(120 , i * 50 +headImageView.height, KScreenWidth - 120 - 20 , 50);
            
//            if (KScreenWidth == 320) {
//                [_cityChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
//            }
//            else if (KScreenWidth == 375) {
//                [_cityChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
//            }
//            else {
//                [_cityChooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 180, 0, 0)];
//            }
            
            _cityChooseBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            
            [_cityChooseBtn setTitle:@"" forState:UIControlStateNormal];
            [_cityChooseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_cityChooseBtn addTarget:self action:@selector(chooseCitylist) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cityChooseBtn.frame) , i * 50 + 19 +headImageView.height, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [RZSV addSubview:arrowIV];
            [RZSV addSubview:_cityChooseBtn];
            
        }
        else if (i == 5){
        
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(KInputViewOrignX, KInputViewHeight * i+headImageView.height, KInputViewWidth, KInputViewHeight)];
            inputTextField.placeholder = placeHoldArr[i];
            inputTextField.tag = 7700 + (tagTextField++);
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.delegate = self;
            
            inputTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [RZSV addSubview:inputTextField];
            
            [_textFieldArr addObject:inputTextField];

        
        
        }
        else if (i == 6) {
                                
            UITextField *inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(KInputViewOrignX, KInputViewHeight * i +headImageView.height, KInputViewWidth, KInputViewHeight)];
            inputTextField.placeholder = placeHoldArr[i];
            inputTextField.tag = 7700 + (tagTextField++);
            inputTextField.textAlignment = NSTextAlignmentRight;
            inputTextField.delegate = self;
            
            [RZSV addSubview:inputTextField];
            

            
//            [RZSV addSubview:inputTextField];
//            [RZSV addSubview:approveBtn];
//            [RZSV addSubview:saveBtn];
            
//            NSLog(@" %f",inputTextField.y);
            
            
            [_textFieldArr addObject:inputTextField];
            
        }else if (i==7){
        
        
            _approveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _approveBtn.frame = CGRectMake(120 , i * 50 +headImageView.height, KScreenWidth - 120 - 20 , 50);
        
            
            _approveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            
            
            [_approveBtn setTitle:@"未认证" forState:UIControlStateNormal];
            [_approveBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_approveBtn addTarget:self action:@selector(doctorApprove) forControlEvents:UIControlEventTouchUpInside];
            
            UIImageView *arrowIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_approveBtn.frame) , i * 50 + 19 +headImageView.height, 12, 12)];
            arrowIV.image = [UIImage imageNamed:@"user_Rarrow_icon_default"];
            
            [RZSV addSubview:arrowIV];
            [RZSV addSubview:_approveBtn];

        
            NSLog(@" %@,%f",NSStringFromCGRect(_approveBtn.frame),CGRectGetMaxY(_approveBtn.frame));
            
            RZSV.height = CGRectGetMaxY(_approveBtn.frame);
            
            RZSV.contentSize = CGSizeMake(KScreenWidth, RZSV.height +40);
        
        }
        
        [RZSV addSubview:nameLabel];
        
        
    }
    
    [self.view addSubview:RZSV];
    
    [self fillUserInfo];
}

#pragma mark - pickerView

#define kPickOrignY 200 //pickView变化高度
#define kPickHeight 260 //pickView实际高度
#define kGrayViewHeight self.view.frame.size.height - kPickHeight //grayView高度

- (void)createPickerView {
    
    _grayView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, KScreenHeight)];
    _grayView.backgroundColor =[UIColor blackColor];
    _grayView.alpha = 0.5;
    [self.view addSubview:_grayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(clickForSure)];
    [_grayView addGestureRecognizer:tap];
    
    _cityPickView = [[OZHPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, kPickHeight)];
    [_cityPickView.sureBtn addTarget:self action:@selector(clickForSure) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_cityPickView];
}


- (void)clickForSure {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _grayView.frame = CGRectMake(0, -(KScreenHeight - kPickHeight), KScreenWidth, kGrayViewHeight);
        
        _cityPickView.frame = CGRectMake(0, KScreenHeight, KScreenWidth, kPickHeight);
        
        
        NSLog(@" %@ %@",_cityPickView.cityStr,_cityPickView.provinceStr);
        
        
        if ([_cityPickView.cityStr isEqualToString:_cityPickView.provinceStr]) {
            [_cityChooseBtn setTitle:[NSString stringWithFormat:@"%@市",_cityPickView.cityStr] forState:UIControlStateNormal];
        }
        else if ([_cityPickView.cityStr isEqualToString:@"北京"]) {
            [_cityChooseBtn setTitle:@"北京市" forState:UIControlStateNormal];
        }
        else {
            [_cityChooseBtn setTitle:[NSString stringWithFormat:@"%@省%@市",_cityPickView.provinceStr,_cityPickView.cityStr] forState:UIControlStateNormal];
        }
        
    }];
    
}

/**
 医生认证
 */
- (void)doctorApprove {
    
    ZRTDoctorApproveViewController *davc = [[ZRTDoctorApproveViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:davc animated:YES];
    
   
}



/**
 选择城市
 */
- (void)chooseCitylist {
    
    NSLog(@"选择城市");
    
    self.isClickSure = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _grayView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
        _cityPickView.frame  = CGRectMake(0, KScreenHeight - kPickHeight, KScreenWidth, kPickHeight);
        
    }];

    
    
    [self resignTextField];
}

#pragma mark - 性别
/**
 改变性别
 */
- (void)changeGender:(UIButton *)sender {
    
    [self resignTextField];
    
    _femaleButton.selected = NO;
    _maleButton.selected = NO;
    sender.selected = !sender.isSelected;
    
}
#pragma mark - 保存

/**
 保存用户信息
 */
- (void)saveUserInfo {
    
//    self.isApproveDoctor = NO;
    
    
    UITextField *nickNameTF = (UITextField *)[self.view viewWithTag:7700];
    UITextField *realNameTF = (UITextField *)[self.view viewWithTag:7701];
    UITextField *addressTF = (UITextField *)[self.view viewWithTag:7702];
    UITextField *IdNumberTF = (UITextField *)[self.view viewWithTag:7703];
    UITextField *emailAddressTF = (UITextField *)[self.view viewWithTag:7704];
    
    NSString *nickName = nickNameTF.text;
    NSString *realName = realNameTF.text;
    
    NSString *gender;
    if (_maleButton.isSelected) {
        gender = @"男";
    }
    else {
        gender = @"女";
    }
    
//    NSLog(@"城市 %@,%@",self.cityPickView.provinceStr,self.currentCity);
    
    
     NSString *city;
    
    city = self.cityChooseBtn.titleLabel.text;
    
//    NSRange range = [city rangeOfString:@"省"];
//    
//    city = [city substringFromIndex:range.location];
//    
//    NSLog(@"123 %@",city);

//    if (![city isEqualToString:@""]) {
    
       
        
//        NSLog(@"2 %@",self.cityPickView.cityStr);
        
//        if ([self.cityPickView.cityStr isEqualToString:@"北京市"]) {
//            city = self.cityPickView.cityStr;
//        }
//        else
//    if ([self.cityPickView.cityStr isEqualToString:self.cityPickView.provinceStr]) {
//            city = [NSString stringWithFormat:@"%@,%@市",self.cityPickView.provinceStr,self.cityPickView.cityStr];
//        
//        }
//        else {
    
    
//            city = [NSString stringWithFormat:@"%@,%@",self.cityPickView.provinceStr,self.cityPickView.cityStr];
//        }
    
        
//    }else{
//    
//    
//        city = self.currentCity;
//    
//    }
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    if (self.isClickSure) {
        
        if ([self.cityPickView.cityStr isEqualToString:@"北京"]) {
            
            self.cityPickView.provinceStr = @"北京";
            
        }
     
        city = [NSString stringWithFormat:@"%@,%@",self.cityPickView.provinceStr,self.cityPickView.cityStr];
    
    }else{
    
        if (![userDict[@"Province"] isEqualToString:@""]) {
            
            city = [NSString stringWithFormat:@"%@,%@",userDict[@"Province"],userDict[@"City"]];
        
            NSString *City = userDict[@"City"];
            
            if ([userDict[@"Province"] isEqualToString:City]) {
                
                city = [NSString stringWithFormat:@"%@",userDict[@"City"]];
                
            }
            
        }else{
            
            if (![userDict[@"City"] isEqualToString:@""]) {
                
                city = [NSString stringWithFormat:@"%@",userDict[@"City"]];
            }
            
        }
 
        
    }
   
    
     NSLog(@"1 %@",city);

    
    if (![self validateIdentityCard:IdNumberTF.text]) {
  
    
        [MBProgressHUD showError:@"请输入正确的个人信息"];
    
        return;
    }
  
    
    NSString *address = addressTF.text;
    NSString *IdNumber = IdNumberTF.text;
    NSString *emailAddress = emailAddressTF.text;
    
    //NSLog(@"%@,%@,%@,%@,%@,%@,%@,%@",[DEFAULT objectForKey:@"UserDict"][@"Id"],nickName,realName,city,address,IdNumber,emailAddress,gender);
    
    if (![realNameTF.text isEqualToString:@""] && ![nickNameTF.text isEqualToString:@""] && ![addressTF.text isEqualToString:@""] && ![IdNumberTF.text isEqualToString:@""] && ![emailAddressTF.text isEqualToString:@""] && ![city isEqualToString:@""]) {
        
        NSDictionary *userInfoDict = @{@"userId":[DEFAULT objectForKey:@"UserDict"][@"Id"],@"nickName":nickName,@"realName":realName,@"city":city,@"address":address,@"idCard":IdNumber,@"mail":emailAddress,@"sex":gender};
        
        [self postUserInfo:userInfoDict];
        
    }
    else {
        
        [MBProgressHUD showError:@"资料不能为空"];
        
    }
    

}




/**
 医生认证
 */
//- (void)approveDoctorInfo {
//
//    
////    self.isApproveDoctor = YES;
//    
////    [self saveUserInfo1];
//    
//    
////    UITextField *realNameTF = (UITextField *)[self.view viewWithTag:7701];
////    _realName = realNameTF.text;
////    _cityName = _cityChooseBtn.currentTitle;
//    
//    ZRTDoctorApproveViewController *daVC = [[ZRTDoctorApproveViewController alloc] init];
//    daVC.delegate = self;
//    
////    daVC.realName = _realName;
////    daVC.cityName = _cityName;
//    
//    self.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:daVC animated:YES];
//    
//    
//}

#pragma mark - 导航控制器
- (void)setLeftNavigationBar
{
    
    self.title = @"个人资料";
    
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:[UIImage imageNamed:nil] target:self action:@selector(didClickLeft)];
    
    
    // 右边
    UIButton *composeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [composeBtn setTitle:@"保存" forState:UIControlStateNormal];
    [composeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   
        
    [composeBtn addTarget:self action:@selector(saveUserInfo) forControlEvents:UIControlEventTouchUpInside];
    
    
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
}

#pragma mark - KeyBoard
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)setKeyBoardNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notification {
//    NSLog(@"键盘将要弹出");
//    UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
//    UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
    
    NSLog(@" %@",NSStringFromCGPoint(_sv.contentOffset));
    
    
    for (UITextField *tf in _textFieldArr) {

        if ([tf isFirstResponder]) {
    
            
            
        
            [UIView animateWithDuration:0.3 animations:^{
                _sv.contentOffset = CGPointMake(0, CGRectGetMinY(tf.frame));
                
                _oldPoint = _sv.contentOffset;
                
                
                NSLog(@"2 %@",NSStringFromCGPoint(_sv.contentOffset));
                
            }];
    
        }
    }
}

- (void)keyBoardWillHidden:(NSNotification *)notification {
//    NSLog(@"键盘将要隐藏");
   
//    NSLog(@" %@",NSStringFromCGPoint(_oldPoint));
    
//    _oldPoint = CGPointMake(0, -_oldPoint.y);
    
    [UIView animateWithDuration:0.3 animations:^{
//        _sv.contentOffset = _oldPoint;
        
        _sv.contentOffset = CGPointMake(0, 0);
        
        
    }];
}

#pragma mark - 上传用户信息
- (void)postUserInfo:(NSDictionary *)userInfoDict {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    [[OZHNetWork sharedNetworkTools] postUserInfoWithDictionary:userInfoDict andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        
//        NSLog(@" %@",userInfoDict[@"city"]);
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
            
            //NSLog(@"保存用户信息成功");
            
            [MBProgressHUD showSuccess:@"保存成功"];
            
            
            [self reloadUserData];
            
            
           
            
            
            
            if ([self.delegate respondsToSelector:@selector(refreshNickName:)]) {
                
                [self.delegate refreshNickName:userInfoDict[@"nickName"]];
                
            }
            
            
            
        }
        else {
            
            //NSLog(@"保存用户信息失败");
            
            [MBProgressHUD showError:@"保存失败"];
            
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        NSLog(@" 上传用户信息 error == %@",error);
        
    }];
    
}
#pragma mark - 代理方法
- (void)backFromZRTDoctorApproveViewController {
    [self.navigationController popViewControllerAnimated:NO];
    
    if ([self.delegate respondsToSelector:@selector(backFromZRTRZViewController)]) {
        [self.delegate backFromZRTRZViewController];
    }
}



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




// 取消键盘
- (void)resignTextField
{
    
    UITextField *nickNameTF = (UITextField *)[self.view viewWithTag:7700];
    UITextField *realNameTF = (UITextField *)[self.view viewWithTag:7701];
    UITextField *addressTF = (UITextField *)[self.view viewWithTag:7702];
    UITextField *IdNumberTF = (UITextField *)[self.view viewWithTag:7703];
    UITextField *emailAddressTF = (UITextField *)[self.view viewWithTag:7704];

    
    [nickNameTF resignFirstResponder];
    [realNameTF resignFirstResponder];
    [addressTF resignFirstResponder];
    [IdNumberTF resignFirstResponder];
    [emailAddressTF resignFirstResponder];
//    [major resignFirstResponder];
    
}



#pragma mark 头像点击事件

-(void)takePictureClick:(UIButton *)sender
{
   
        UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:@"请选择文件来源"
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"照相机",@"本地相簿",nil];
        [actionSheet showInView:self.view];
 
    
}


#pragma mark UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    NSLog(@"buttonIndex = [%ld]",(long)buttonIndex);
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            
            break;
            
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}



#pragma mark  UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    //    }
    //    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
    //        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
    //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    //    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image
{
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    
    //    NSLog(@"imageFile->>%@",imageFilePath);
    
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    
    [self sendHeadImage:selfPhoto];
    
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


// 图片上传服务器

-(void)sendHeadImage:(UIImage *)image
{
    
    
    NSString *urlString = @"http://www.yddmi.com/WebServices/Ydd_User.asmx/UploadImg";
    
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *mutableString = [imageData base64EncodedStringWithOptions: 0];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    //    NSLog(@" %@",[DEFAULT objectForKey:@"UserDict"][@"Id"]);
    
    [manager POST:urlString parameters:@{@"userId":[DEFAULT objectForKey:@"UserDict"][@"Id"],@"img":mutableString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.headImage.image = image; // 改变头像
        
        [MBProgressHUD showSuccess:@"头像上传成功"];
        
        
        [self reloadUserData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@" %@",error);
        
        [MBProgressHUD showError:@"头像上传失败"];
        
//        [self sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
        
    }];
    
    
}




//身份证号
-(BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    BOOL isMatch = [identityCardPredicate evaluateWithObject:identityCard];
    
//    NSLog(@"isMatch %d",isMatch);
    
    return isMatch;
}

@end
