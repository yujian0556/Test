 //
//  ZRTMineViewController.m
//  yiwen
//
//  Created by moyifan on 15/4/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTMineViewController.h"

#import "ZRTRegistViewController.h"
#import "ZRTLoginViewController.h"

#import "UIImageView+WebCache.h"

#import "Helper.h"

#import "ZRTRZViewController.h"

#import "ZRTMineTableViewCell.h"

#import "ZRTSystemSetsViewController.h"
#import "ZRTLineListController.h"

#import "ZRTHealthyController.h"
#import "Interface.h"

#import "ZRTFavoriteViewController.h"

#import "ZRTDoctorApproveViewController.h"
#import "ZRTRZViewController.h"

#import "ZRTTaskController.h"
#import "ZRTMissionController.h"
#import "LGAlertView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "OZHNetWork.h"

static NSString *mineCellReuseIdentifiy = @"mineCell";

@interface ZRTMineViewController () <UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,ZRTRZViewControllerDelegate>

@property (nonatomic,getter=isLogin) BOOL Login;

@property (nonatomic,strong) UITableView *mineTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *imageArray;

@property (nonatomic,assign) CGFloat titlefont;

@property (nonatomic,strong) UIButton *finishInfoBtn;
@property (nonatomic,strong) UIButton *docApproveBtn;

//@property (nonatomic,strong) UIButton *headBtn;

@property (nonatomic,strong) UIButton *signBtn;

@property (nonatomic,assign) BOOL isSign;

@property (nonatomic,strong) UIView *personalInfomationView;


@end

@implementation ZRTMineViewController
{
    UIImageView *_headerImageView;
    UILabel *_userNameLabel;
    UILabel *_userRank;
    UIButton *_RegistBtn;
    
    UIButton *_detailToLogin;
    UIButton *_detailToMine;
    CGFloat _nameW;
    
    UIImageView *_successImage; // 已完成认证图标
    UIImageView *_failImage;  // 未完成认证
    
}
#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    //r如果登录了.获取签到状态
    if (self.isLogin) {
        
        [self GetSignStatus];
    }
    
    
    // 刷新头像
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];

    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImagePath,userDict[@"ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
  
    
    if (self.isLogin) {
        
        _userRank.y = CGRectGetMaxY(_userNameLabel.frame);
        _userRank.text = userDict[@"Professional"];
        [_userRank sizeToFit];
 
        [self setSuccessImage];
        
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.Login = [self isUserLogin];
    
    [self OSD];
   
    [self setNavgationBar];
    
    [self setPersonalInfomationView];
    
    [self setSignIn];
    
    if (self.Login) {
        
//        NSLog(@" 已登录 ");
        
        [self GetSignStatus];
    }

    
//    [self setNineButton];
    [self createTableView];
    
    self.view.backgroundColor = KRGBColor(239, 239, 244);
    
    [self addNotificationCenter];
    
    
//    [self.personalInfomationView layoutSubviews];
    
}




#pragma mark - 判断是否登录
- (BOOL)isUserLogin
{
    return [[DEFAULT objectForKey:@"isLogin"] boolValue];
}


#pragma mark 屏幕适配
-(void)OSD
{
    
    if (KScreenHeight == 480) {  // 4s
        
        
        _titlefont = 16;
        
    }else if (KScreenHeight == 568){  // 5s
        
        _titlefont = 18;
        
    }else if (KScreenHeight == 667){  // 6
        
       
        _titlefont = 20;
        
    }else{  // 6p
        
        _titlefont = 24;
        
    }
    
    
    
}


#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    
 
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine_icon_setup_default"] highImage:nil target:self action:@selector(didClickRight)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];

}



/**
 *  导航栏左右按钮
 */
-(void)didClickRight
{
//    [DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
//    
//    [DEFAULT synchronize];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
    
    
    ZRTSystemSetsViewController *systemVC = [[ZRTSystemSetsViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:systemVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
//    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
//    NSLog(@" %@",userDict[@"NickName"]);
    
    
}

#pragma mark - 用户信息栏

#define btnW 83
#define btnH 20

#define docApproveBtnTitle @"医生认证"
#define finishInfoBtnTitle @"完善个人资料"


- (void)setPersonalInfomationView
{
    UIView *personalInfomationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 120)];
    personalInfomationView.backgroundColor = KMainColor;
    personalInfomationView.tag = 9999;
    
    self.personalInfomationView = personalInfomationView;
    
    //头像
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0 , 50, 50)];
    _headerImageView.layer.cornerRadius = 25;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.center = personalInfomationView.center;
    _headerImageView.x = 20;
    _headerImageView.image = [UIImage imageNamed:@"login_headimagebg_default"];
    
    
    
    //用户名
    
    CGFloat nameW = KScreenWidth - _headerImageView.frame.size.width - 36;
    _nameW = nameW;
    
    
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 11, CGRectGetMinY(_headerImageView.frame)-5, nameW/3*2, 0)];
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.text = @"登录分享学习资源,管理我的医疗诊所";
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    
    _userNameLabel.numberOfLines = 0;
   
    
    
    
    //进入登录界面
    _detailToLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailToLogin.frame = CGRectMake(0, 0, KScreenWidth+100, 36);
    _detailToLogin.center = CGPointMake(KScreenWidth - 36, 60);
    [_detailToLogin setImage:[UIImage imageNamed:@"mine_icon_bigarrow_default"] forState:UIControlStateNormal];
    [_detailToLogin addTarget:self action:@selector(ShowDetailInfomation) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    //进入个人资料
    
    _detailToMine = [UIButton buttonWithType:UIButtonTypeCustom];
    _detailToMine.frame = _detailToLogin.frame;
    [_detailToMine setImage:[UIImage imageNamed:@"mine_icon_bigarrow_default"] forState:UIControlStateNormal];
    [_detailToMine addTarget:self action:@selector(finishInformation) forControlEvents:UIControlEventTouchUpInside];
//    [_detailToMine addTarget:self action:@selector(doctorApprove) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //医师级别
    _userRank = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_userNameLabel.frame), CGRectGetMaxY(_userNameLabel.frame), KScreenWidth - _headerImageView.frame.size.width - 36, 24)];
    _userRank.textColor = [UIColor whiteColor];
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
//    NSDictionary *UserDetailInfo = [DEFAULT objectForKey:@"UserDetailInfo"];
    
    
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",ImagePath,userDict[@"ImgUrl"]];
    
//    NSLog(@" %@",imgUrl);
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
    
    if ([userDict[@"NickName"] isEqualToString:@""]) {
        _userNameLabel.text = userDict[@"Tel"];
    }
    else {
        _userNameLabel.text = userDict[@"NickName"];
    }
    _userRank.text = userDict[@"Professional"];
    
//    NSLog(@"级别 %@",_userRank.text);
    
    _userNameLabel.font = [UIFont systemFontOfSize:18];
    _userRank.font = [UIFont systemFontOfSize:15];
    
    [personalInfomationView addSubview:_userRank];
    
    
//    _detailInformationButton.hidden = YES;

    
    // 进入注册按钮
    
//    _RegistBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _RegistBtn.frame = CGRectMake(CGRectGetMinX(_userNameLabel.frame), CGRectGetMaxY(_userNameLabel.frame), [Helper widthOfString:@"新用户注册享特惠" font:[UIFont systemFontOfSize:17] height:24] + 10, 24);
//    [_RegistBtn setTitle:@"新用户注册享特惠" forState:UIControlStateNormal];
//    [_RegistBtn setBackgroundImage:[UIImage imageNamed:@"mine_btn_register_default"] forState:UIControlStateNormal];
//    _RegistBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_RegistBtn addTarget:self action:@selector(UserRegist) forControlEvents:UIControlEventTouchUpInside];
    
   
    
   
    
//    [personalInfomationView addSubview:_RegistBtn];
    
//    _detailInformationButton.hidden = NO;
    
//    self.finishInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.finishInfoBtn.frame = CGRectMake(CGRectGetMinX(_userRank.frame), personalInfomationView.frame.size.height - 11 -24, 83, 20);
//    [self.finishInfoBtn setTitle:finishInfoBtnTitle forState:UIControlStateNormal];
//    [self.finishInfoBtn addTarget:self action:@selector(finishInformation) forControlEvents:UIControlEventTouchUpInside];
//    [self.finishInfoBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
//    self.finishInfoBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    
//    self.docApproveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.docApproveBtn.frame = CGRectMake(CGRectGetMaxX(self.finishInfoBtn.frame) + 10, CGRectGetMinY(self.finishInfoBtn.frame), 83, 20);
//    [self.docApproveBtn setTitle:docApproveBtnTitle forState:UIControlStateNormal];
//    [self.docApproveBtn addTarget:self action:@selector(doctorApprove) forControlEvents:UIControlEventTouchUpInside];
//    [self.docApproveBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
//    self.docApproveBtn.titleLabel.font = [UIFont systemFontOfSize:11];

    
    [personalInfomationView addSubview:_headerImageView];
    [personalInfomationView addSubview:_userNameLabel];
    [personalInfomationView addSubview:_detailToLogin];
    [personalInfomationView addSubview:_detailToMine];
    
    
//    [personalInfomationView addSubview:self.finishInfoBtn];
//    [personalInfomationView addSubview:self.docApproveBtn];
    
    
    // 认证图标
    
    _successImage = [[UIImageView alloc] init];

    _successImage.image = [UIImage imageNamed:@"finish"];
    
    [_successImage sizeToFit];

    
    _failImage = [[UIImageView alloc] init];
    _failImage.image = [UIImage imageNamed:@"fail"];
    
    
    [self.personalInfomationView addSubview:_successImage];
    [self.personalInfomationView addSubview:_failImage];
    
  
    [self.view addSubview:personalInfomationView];
    
    [self changeLoginState];
    
    
    
    // 头像点击事件
    
//    self.headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    self.headBtn.frame = _headerImageView.frame;
//    
//    [personalInfomationView addSubview:self.headBtn];
//    
//    [self.headBtn addTarget:self action:@selector(takePictureClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 按钮点击事件

/**
 完善个人信息
 */
- (void)finishInformation {
    
    ZRTRZViewController *rzvc = [[ZRTRZViewController alloc] init];
    
    rzvc.delegate = self;
    
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:rzvc animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}


#pragma mark 刷新昵称

-(void)refreshNickName:(NSString *)nickName
{

    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    if ([nickName isEqualToString:@""]) {
        _userNameLabel.text = userDict[@"Tel"];
    }
    else {
        _userNameLabel.text = nickName;
    }
    
    // 刷新头像
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImagePath,userDict[@"ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
   
}




/**
 医生认证
 */
- (void)doctorApprove {
    
    ZRTDoctorApproveViewController *davc = [[ZRTDoctorApproveViewController alloc] init];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:davc animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

/**
 未登录状态,登录点击按钮
 */
//- (void)UserRegist
//{
//    //NSLog(@"跳转注册界面");
//    
//    ZRTRegistViewController *registVC = [[ZRTRegistViewController alloc] init];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:registVC animated:YES];
//    
//    self.hidesBottomBarWhenPushed = NO;
//}

/**
 详情按钮点击事件
 */
- (void)ShowDetailInfomation
{
    //NSLog(@"点击查看详细");
    if ([self isUserLogin]) {
        
    }
    else {
        ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:loginVC animated:YES];
        
        self.hidesBottomBarWhenPushed = NO;
    }
}


// 头像点击事件

//-(void)takePictureClick:(UIButton *)sender
//{
//    
////    NSLog(@" 点击头像");
//    
//    //    /*注：使用，需要实现以下协议：UIImagePickerControllerDelegate,
//    //     UINavigationControllerDelegate
//    //     */
//    //    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//    //    //设置图片源(相簿)
//    //    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    //    //设置代理
//    //    picker.delegate = self;
//    //    //设置可以编辑
//    //    picker.allowsEditing = YES;
//    //    //打开拾取器界面
//    //    [self presentViewController:picker animated:YES completion:nil];
//    
//    
//    if ([self isUserLogin]) {
//        
//        
//        UIActionSheet* actionSheet = [[UIActionSheet alloc]
//                                      initWithTitle:@"请选择文件来源"
//                                      delegate:self
//                                      cancelButtonTitle:@"取消"
//                                      destructiveButtonTitle:nil
//                                      otherButtonTitles:@"照相机",@"本地相簿",nil];
//        [actionSheet showInView:self.view];
//        
//    }else{
//    
//        LGAlertView *alert = [LGAlertView alertViewWithTitle:@"提示" message:@"当前未登录,现在跳转去登录~" buttonTitles:nil cancelButtonTitle:@"稍后" destructiveButtonTitle:@"确定" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
//            
//            ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
//            
//            self.hidesBottomBarWhenPushed = YES;
//            
//            [self.navigationController pushViewController:loginVC animated:YES];
//            
//            self.hidesBottomBarWhenPushed = NO;
//            
//        }];
//        
//        
//        [alert showAnimated:YES completionHandler:nil];
//    
//    }
//    
//    
//    
//}
//
//
//#pragma mark UIActionSheet Delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
////    NSLog(@"buttonIndex = [%ld]",(long)buttonIndex);
//    switch (buttonIndex) {
//        case 0://照相机
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            //            [self presentModalViewController:imagePicker animated:YES];
//            [self presentViewController:imagePicker animated:YES completion:nil];
//        }
//       
//            break;
//            
//        case 1://本地相簿
//        {
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            //            [self presentModalViewController:imagePicker animated:YES];
//            [self presentViewController:imagePicker animated:YES completion:nil];
//        }
//            break;
//     
//        default:
//            break;
//    }
//}
//
//
//
//#pragma mark  UIImagePickerController Delegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
////    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
//        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
//        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
////    }
////    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
////        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
////        self.fileData = [NSData dataWithContentsOfFile:videoPath];
////    }
//    //    [picker dismissModalViewControllerAnimated:YES];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    //    [picker dismissModalViewControllerAnimated:YES];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)saveImage:(UIImage *)image
//{
//    //    NSLog(@"保存头像！");
//    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error;
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
//    
////    NSLog(@"imageFile->>%@",imageFilePath);
//    
//    success = [fileManager fileExistsAtPath:imageFilePath];
//    if(success) {
//        success = [fileManager removeItemAtPath:imageFilePath error:&error];
//    }
//    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
//    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
//    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
//    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
//    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
//    
//    [self sendHeadImage:selfPhoto];
//    
//}
//
//// 改变图像的尺寸，方便上传服务器
//- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
//{
//    UIGraphicsBeginImageContext(size);
//    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//
//// 保持原来的长宽比，生成一个缩略图
//- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
//{
//    UIImage *newimage;
//    if (nil == image) {
//        newimage = nil;
//    }
//    else{
//        CGSize oldsize = image.size;
//        CGRect rect;
//        if (asize.width/asize.height > oldsize.width/oldsize.height) {
//            rect.size.width = asize.height*oldsize.width/oldsize.height;
//            rect.size.height = asize.height;
//            rect.origin.x = (asize.width - rect.size.width)/2;
//            rect.origin.y = 0;
//        }
//        else{
//            rect.size.width = asize.width;
//            rect.size.height = asize.width*oldsize.height/oldsize.width;
//            rect.origin.x = 0;
//            rect.origin.y = (asize.height - rect.size.height)/2;
//        }
//        UIGraphicsBeginImageContext(asize);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
//        [image drawInRect:rect];
//        newimage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//    return newimage;
//}


// 图片上传服务器

//-(void)sendHeadImage:(UIImage *)image
//{
//    
//    
//    NSString *urlString = @"http://www.yddmi.com/WebServices/Ydd_User.asmx/UploadImg";
//    
//    
//    NSData *imageData = UIImagePNGRepresentation(image);
//    NSString *mutableString = [imageData base64EncodedStringWithOptions: 0];
//    
//
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
////    NSLog(@" %@",[DEFAULT objectForKey:@"UserDict"][@"Id"]);
//    
//    [manager POST:urlString parameters:@{@"userId":[DEFAULT objectForKey:@"UserDict"][@"Id"],@"img":mutableString} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//         _headerImageView.image = image; // 改变头像
//        
//        [MBProgressHUD showSuccess:@"头像上传成功"];
//        
//        
//        [self reloadUserData];
//       
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@" %@",error);
//        
//        [MBProgressHUD showError:@"头像上传失败"];
//        
//        [_headerImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
//        
//    }];
//
//
//}





#pragma mark - 列表

- (void)createTableView {
    
    
    self.dataSource = [[NSMutableArray alloc] init];

    NSArray *dataArr = @[@[@"健康中心"],@[@"消息中心"],@[@"我的收藏"],@[@"我的任务"],@[@"我的账户"]];
    [self.dataSource addObjectsFromArray:dataArr];
    
    self.imageArray = @[@[@"hel_03"],@[@"mine_icon_message_default"],@[@"mine_icon_collection_default"],@[@"path"],@[@"account"]];
    
    UIView *userView = [self.view viewWithTag:9999];
    
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userView.frame)+10, KScreenWidth, KScreenHeight - CGRectGetMaxY(userView.frame) - 49 - 64) style:UITableViewStyleGrouped];
    
    self.mineTableView.delegate = self;
    self.mineTableView.dataSource = self;
    
    [self.mineTableView registerNib:[UINib nibWithNibName:@"ZRTMineTableViewCell" bundle:nil] forCellReuseIdentifier:mineCellReuseIdentifiy];
    
    [self.view addSubview:self.mineTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellReuseIdentifiy];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.title.text = self.dataSource[indexPath.section][indexPath.row];
    cell.image.image = [UIImage imageNamed:self.imageArray[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0) {
        cell.redPoint.hidden = YES;
    }
    else if (indexPath.section == 2) {
        cell.redPoint.hidden = YES;
    }
    else if (indexPath.section == 3) {
        cell.redPoint.hidden = YES;
    
    }else if (indexPath.section == 4) {
        cell.redPoint.hidden = YES;
    }

    else {

        cell.redPoint.hidden = !_receiveMessage;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
  //  NSLog(@"%d",[[DEFAULT objectForKey:@"isLogin"] boolValue]);
    
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        //健康中心
        if (indexPath.section == 0) {
            
            ZRTHealthyController *healthy = [[ZRTHealthyController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:healthy animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
            
            
            
        }
        //消息中心
        else if (indexPath.section == 1) {
                    ZRTLineListController *mcVC = [[ZRTLineListController alloc] initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE)] collectionConversationType:nil];
            
                    _receiveMessage = NO;
                    
                    [self.mineTableView reloadData];
            
                    self.hidesBottomBarWhenPushed = YES;
            
                    [self.navigationController pushViewController:mcVC animated:YES];
            
                    self.hidesBottomBarWhenPushed = NO;
            
         //   RCConversationListViewController *chat = [[RCConversationListViewController alloc] initWithDisplayConversationTypes:nil collectionConversationType:nil];
            
            // [self.navigationController pushViewController:ZRTMessageCenterViewController animated:YES];
            

        }
        //我的任务
        else if (indexPath.section == 3) {
            
            ZRTMissionController *mission = [[ZRTMissionController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:mission animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
          
        }
        else if (indexPath.section == 2) { // 我的收藏
            ZRTFavoriteViewController *favorite = [[ZRTFavoriteViewController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:favorite animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
        }else if (indexPath.section == 4){ // 我的账户
        
            ZRTTaskController *task = [[ZRTTaskController alloc] init];
        
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:task animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
            
        }

    }
    else {
        

//        
//            UIAlertController *jumpToLogin = [UIAlertController alertControllerWithTitle:@"" message:@"当前未登录,现在跳转去登录~" preferredStyle:UIAlertControllerStyleAlert];
//            
//            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
//            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//               
//                ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
//                
//                self.hidesBottomBarWhenPushed = YES;
//                
//                [self.navigationController pushViewController:loginVC animated:YES];
//                
//                self.hidesBottomBarWhenPushed = NO;
//                
//            }];
//            
//            [jumpToLogin addAction:cancle];
//            [jumpToLogin addAction:sure];
//            
//            [self presentViewController:jumpToLogin animated:YES completion:nil];
        
        
        
        LGAlertView *alert = [LGAlertView alertViewWithTitle:@"提示" message:@"当前未登录,现在跳转去登录~" buttonTitles:nil cancelButtonTitle:@"稍后" destructiveButtonTitle:@"登录" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
            
            ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
        }];
        
        
        [alert showAnimated:YES completionHandler:nil];
        
        
        
        
        
        }

    
}







- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

/*
 ZRTRZViewController *rzVC = [[ZRTRZViewController alloc] init];
 
 self.hidesBottomBarWhenPushed = YES;
 
 [self.navigationController pushViewController:rzVC animated:YES];
 
 self.hidesBottomBarWhenPushed = NO;
 
 
 
 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录,现在就去登录" preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
 UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
 //NSLog(@"跳转登录界面");
 
 ZRTLoginViewController *registVC = [[ZRTLoginViewController alloc] init];
 
 [self.navigationController pushViewController:registVC animated:YES];
 }];
 
 [alert addAction:cancle];
 [alert addAction:sure];
 
 [self presentViewController:alert animated:YES completion:nil];
 */

#pragma mark - 通知中心
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginState) name:@"UserIsLogined" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UnreadMessage) name:@"UnreadMessage" object:nil];
    
}

- (void)changeLoginState {
    
    self.Login = [[DEFAULT objectForKey:@"isLogin"] boolValue];
    
//    NSLog(@" 改变登录状态 ");
    if (self.isLogin) {
        
        [self GetSignStatus];
    }
    
    _headerImageView.image = nil;
    _userNameLabel.text = @"";
    _userRank.text = @"";
    
    _headerImageView.image = [UIImage imageNamed:@"login_headimagebg_default"];
    
    // 未登录时显示的用户名
    _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 11, CGRectGetMinY(_headerImageView.frame)-5, _nameW/3*2, 0);
    _userNameLabel.text = @"登录查看医学资源,管理我的健康档案";
    _userNameLabel.font = [UIFont systemFontOfSize:14];
    [_userNameLabel sizeToFit];
    _userNameLabel.center = _headerImageView.center;
    _userNameLabel.x = CGRectGetMaxX(_headerImageView.frame) + 20;
    
    
   
    _RegistBtn.hidden = NO;
    _detailToLogin.hidden = NO;
    _detailToMine.hidden = YES;
    _userRank.hidden = YES;
    _successImage.hidden = YES;
    
#pragma mark   ---- 修改用户为认证退出时出现未认证图片
    // 隐藏完成认证图标
    _failImage.hidden = YES;
    
    
    self.finishInfoBtn.hidden = YES;
    self.docApproveBtn.hidden = YES;
    
    self.signBtn.hidden = YES;
    
    if (self.isLogin) {
        
        NSLog(@"login");
        
        //添加签到按钮
        
        self.signBtn.hidden = NO;
        
        _RegistBtn.hidden = YES;
        _userRank.hidden = NO;
        _detailToLogin.hidden = YES;
        _detailToMine.hidden = NO;
        
        //完善个人资料
        self.finishInfoBtn.hidden = NO;
        //医生认证
        self.docApproveBtn.hidden = NO;
        
        NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
//        NSDictionary *UserDetailInfo = [DEFAULT objectForKey:@"UserDetailInfo"];
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImagePath,userDict[@"ImgUrl"]]] placeholderImage:[UIImage imageNamed:@"login_headimagebg_default"]];
        
        // 用户名frame重设
        
        _userNameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + 11, CGRectGetMinY(_headerImageView.frame), _nameW, 30);
        
        if ([userDict[@"NickName"] isEqualToString:@""]) {
            _userNameLabel.text = userDict[@"Tel"];
        }
        else {
            _userNameLabel.text = userDict[@"NickName"];
        }
        _userNameLabel.font = [UIFont systemFontOfSize:17];
        
        
        _userRank.y = CGRectGetMaxY(_userNameLabel.frame);
        _userRank.text = userDict[@"Professional"];
        [_userRank sizeToFit];
        
//        if (![UserDetailInfo[@"Professional"] isEqualToString:@""]) {
//            
//            _userRank.text = UserDetailInfo[@"Professional"];
//            
//            [self changeFrameWithBool:1];
//            
//        }
//        else {
//            
//            [self changeFrameWithBool:0];
//            
//        }
        
        
        [self setSuccessImage];
        
        
    }
    
}


-(void)setSuccessImage
{

 
    if (![_userRank.text isEqualToString:@""]) {
        
        _successImage.center = _userRank.center;
        _successImage.x = CGRectGetMaxX(_userRank.frame)+10;
    
    }else{
    
        _successImage.x = _userNameLabel.x;
        _successImage.y = CGRectGetMaxY(_userNameLabel.frame);
    }
    
   
    
    
    _failImage.frame = _successImage.frame;
    
    NSDictionary *userDict = [DEFAULT objectForKey:@"UserDict"];
    
    NSString *status = userDict[@"Status"];
    
    NSLog(@"认证状态 %@ %@",status,_successImage);
    
    if ([status isEqualToString:@"2"]) { // 完成认证
        
        
        _successImage.hidden = NO;
        _failImage.hidden = YES;
        
        
    }else{
        
        _successImage.hidden = YES;
        _failImage.hidden = NO;
        
    }




}


//- (void)changeFrameWithBool:(BOOL)isNil {
//
//    if (isNil) {
//        CGRect frame1 = self.docApproveBtn.frame;
//        CGRect frame2 = self.finishInfoBtn.frame;
//
//        frame1.origin.y = CGRectGetMaxY(_userRank.frame);
//        frame2.origin.y = CGRectGetMinY(frame1);
//
//        self.docApproveBtn.frame = frame1;
//        self.finishInfoBtn.frame = frame2;
//    }
//    else {
//        CGRect frame1 = self.docApproveBtn.frame;
//        CGRect frame2 = self.finishInfoBtn.frame;
//        
//        frame1.origin.y = CGRectGetMaxY(_userNameLabel.frame);
//        frame2.origin.y = CGRectGetMinY(frame1);
//        
//        self.docApproveBtn.frame = frame1;
//        self.finishInfoBtn.frame = frame2;
//    }
//}


#pragma mark 显示未读消息

-(void)UnreadMessage
{

    
    _receiveMessage = YES;
    
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.mineTableView reloadData];
    });
    
    

}



#pragma mark 重新刷新用户信息


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




#pragma mark 签到

-(void)setSignIn
{

    UIView *view = [self.view viewWithTag:9999];
    
    self.signBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];

    [self.signBtn setBackgroundImage:[UIImage imageNamed:@"sign_normal_"] forState:UIControlStateNormal];
    
    [self.signBtn setBackgroundImage:[UIImage imageNamed:@"sign_click_"] forState:UIControlStateSelected];
    
    
    
    [self.signBtn sizeToFit];
    
//    self.signBtn.center = _userNameLabel.center;
    
    self.signBtn.x = KScreenWidth - self.signBtn.width - 10;
    
    
    [view addSubview:self.signBtn];
    
    if (self.isLogin) {
        
        self.signBtn.hidden = NO;
    }else{
    
        self.signBtn.hidden = YES;
    }
    
//    self.signBtn.selected = self.isSign;
//    self.signBtn.userInteractionEnabled = !self.isSign;
  
    
    [self.signBtn addTarget:self action:@selector(didClickSign) forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)didClickSign
{


    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Task.asmx/Sign";
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:@{@"userID":[DEFAULT objectForKey:@"UserDict"][@"Id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
//        NSLog(@" %@",jsonDict[@"Success"]);
        
        
        if ([jsonDict[@"Success"] isEqualToNumber:@1]) {
            
            self.signBtn.selected = YES;
            
            self.signBtn.userInteractionEnabled = NO;
        
        }else{
        
            [MBProgressHUD showError:@"签到失败"];
        
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"签到error %@",error);
        
    }];
   

}



#pragma mark 获取签到状态

-(void)GetSignStatus
{

    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Task.asmx/GetSignStatus";
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:url parameters:@{@"userID":[DEFAULT objectForKey:@"UserDict"][@"Id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        NSDictionary *jsonDict = [NSDictionary StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
        
//        NSLog(@" %@",jsonDict[@"status"]);
        
        
        if ([jsonDict[@"status"] isEqualToNumber:@1]) {
            
            self.isSign = YES;
            
            
        }else{
            
            self.isSign = NO;

        }
        
        
        self.signBtn.selected = self.isSign;
        self.signBtn.userInteractionEnabled = !self.isSign;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"签到状态error %@",error);
        
    }];



}


@end
