//
//  ZRTConsultationViewController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/13.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationViewController.h"

#import "ZRTConsultationTableViewCell.h"

#import "ZRTConsultationModel.h"

#import "Helper.h"

#import "ZRTComposeController.h"

#import "ZRTConsultationDetailViewController.h"

#import "ZRTLoginViewController.h"

#import "ZRTReportViewController.h"

#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "ZRTSelectModel.h"
#import "LGAlertView.h"


#import "OZHNetWork.h"



static NSString *ConsultationReuseIdentifier = @"ConsultationCell";

@interface ZRTConsultationViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZRTComposeControllerDelegate,UIActionSheetDelegate,ZRTConsultationTableViewCellDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UITableView *ConsultationTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSArray *oldDataSource;

@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextField *inputTextField;
@property (nonatomic,strong) UIButton *sendBtn;

@property (nonatomic,strong) MJRefreshFooter *footer;
@property (nonatomic,strong) MJRefreshHeader *header;

@property (nonatomic,strong) UILabel *stateLabel;

@property (nonatomic,assign) CGFloat titlefont;

@property (nonatomic,weak) id <UIActionSheetDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *sectionOfficeDataSource;
@property (nonatomic,strong) UITableView *sectionOfficeTB;

@end

@implementation ZRTConsultationViewController
{
    UIButton *_selectBtn;
    UIView *_selectionView;
    ZRTConsultationTableViewCell *_cell;
    NSInteger _currentPage;
    

    
    NSInteger _selectedRow;
    
    NSMutableArray *_cellArray;
    
    BOOL _selectSectionOffice;
    NSInteger _sectionOfficeRow;
}


#pragma mark 控制屏幕旋转
-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        _currentPage = 1;
        _selectSectionOffice = NO;
        self.dataSource = [[NSMutableArray alloc] init];
        self.sectionOfficeDataSource = [[NSMutableArray alloc] init];
        _cellArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    if (_selectBtn.isSelected){
        
        CGRect closeFrame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
        _selectionView.frame = closeFrame;
        _selectBtn.selected = NO;
        
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTableView];
    
    [self setRightNavgationBar];
    
    if (!self.isRightBtnHidden) {
      
        [self setLeftNavigationBar];
   
    }
    
    [self createSelectionView];
    
    [self setHeaderRefresh];
    [self setFooterRefresh];
    
    
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


#pragma mark - 设置TableView
/**
 设置会诊的TableView
 */
- (void)setTableView
{
    self.ConsultationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
    
    self.ConsultationTableView.delegate = self;
    
    self.ConsultationTableView.dataSource = self;
    
    [self.ConsultationTableView registerClass:[ZRTConsultationTableViewCell class] forCellReuseIdentifier:ConsultationReuseIdentifier];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    self.ConsultationTableView.tableFooterView = clearView;
    
    [self.view addSubview:self.ConsultationTableView];
    
}

#pragma mark - 导航控制器
/**
 *  中间和右侧  navgationbar
 */
-(void)setRightNavgationBar
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"consulation_btn_publish"] highImage:nil target:self action:@selector(didClickRight)];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:self.titlefont]}];
    
    
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectMake(0, 0, 50, 44);
    
    UIImage *img = [UIImage imageNamed:@"consulation_btn_downarrow_white"];
    
    [_selectBtn setImage:img forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageWithCGImage:img.CGImage scale:2.0 orientation:UIImageOrientationDown] forState:UIControlStateSelected];
    
    [_selectBtn setTitle:@" 全部科室" forState:UIControlStateNormal];
    _selectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_selectBtn addTarget:self action:@selector(showOfficeSection) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.titleView = _selectBtn;
}

- (void)setLeftNavigationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:[UIImage imageNamed:nil] target:self action:@selector(didClickLeft)];
}
/**
 *  首页导航栏左按钮:返回
 */
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
   

}

/**
 *  首页导航栏右按钮:发布新消息
 */
-(void)didClickRight
{
    
    ZRTComposeController *compose = [[ZRTComposeController alloc] init];
    
    compose.delegate = self;
    
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        
      
        NSDictionary *dict = [DEFAULT objectForKey:@"UserDict"];
        
        NSString *status = dict[@"Status"];
        
        if ([status isEqualToString:@"2"]) {
          
            ZRTComposeController *compose = [[ZRTComposeController alloc] init];
            
            compose.delegate = self;
            
            [self setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:compose animated:YES];
            
            [self setHidesBottomBarWhenPushed:NO];


        }else{
           
            LGAlertView *alert = [LGAlertView alertViewWithTitle:nil message:@"请先进行医生认证" buttonTitles:nil cancelButtonTitle:@"确定" destructiveButtonTitle:nil actionHandler:nil cancelHandler:nil destructiveHandler:nil];
            
            
            [alert showAnimated:YES completionHandler:nil];
        }

    }else{
        
        
        [MBProgressHUD showMessage:@"请先登录"];
        
        [self performSelector:@selector(hide) withObject:nil afterDelay:1.0f];
        
    }

}


#pragma mark 上传代理方法


-(void)Compose
{
    //    NSLog(@"发送~");
    [self showPublishStateWithState:0];
    
    
}



-(void)ComposeSuccess
{
    //    NSLog(@"发送成功~");
    self.stateLabel.text = @"发送成功~";
    [UIView animateWithDuration:0.25 delay:3.0 options:0 animations:^{
        
        self.stateLabel.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [self.stateLabel removeFromSuperview];
        
    }];
    [self.ConsultationTableView.header beginRefreshing];
    
    
}

-(void)Composefailure
{
    //    NSLog(@"发送失败~");
    self.stateLabel.text = @"发送失败~";
    [UIView animateWithDuration:0.25 delay:3.0 options:0 animations:^{
        
        self.stateLabel.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        
        [self.stateLabel removeFromSuperview];
        
    }];
}

#pragma mark 隐藏窗口
-(void)hide
{
    
    [MBProgressHUD hideHUD];
}


#pragma mark - 科室选择
/**
 显示科室选择View
 */
- (void)showOfficeSection
{
    [self getSectionOfficeDataFromNetWork];
    
    __weak typeof(self) weakSelf = self;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [weakSelf createSelectionView];
        
    });
    
    //[self.view sendSubviewToBack:_pictureView];
    //[self.view bringSubviewToFront:_selectionView];
    
    //NSLog(@"显示科室选择View");
    CGRect openFrame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    CGRect closeFrame = CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight);
    
    _selectBtn.selected = !_selectBtn.isSelected;
    
    if (_selectBtn.isSelected) {
        
        [UIView animateWithDuration:0.2 animations:^{
            _selectionView.frame = openFrame;
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.2 animations:^{
            _selectionView.frame = closeFrame;
        }];
    }

    
}
#define bgViewHeight 115

#define SOTBWidth 205
#define SOTBX (KScreenWidth - SOTBWidth)/2
#define SOTBHeight 320
- (void)createSelectionView
{
    _selectionView = [[UIView alloc] initWithFrame:CGRectMake(0, -KScreenHeight, KScreenWidth, KScreenHeight)];
    _selectionView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *hiddenView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOfficeSection)];
    hiddenView.delegate = self;
    [_selectionView addGestureRecognizer:hiddenView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
//    UIImageView *bgIV = [[UIImageView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight)];
//    bgIV.image = [UIImage imageNamed:@"back"];
    UIView *bgIV = [[UIView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight)];
    bgIV.backgroundColor = KRGBColor(17, 125, 138);
    
    self.sectionOfficeTB = [[UITableView alloc] initWithFrame:CGRectMake(SOTBX, 0, SOTBWidth, SOTBHeight) style:UITableViewStylePlain];
    self.sectionOfficeTB.backgroundColor = KRGBColor(17, 125, 138);
    self.sectionOfficeTB.layer.cornerRadius = 10;
    self.sectionOfficeTB.clipsToBounds = YES;
    self.sectionOfficeTB.bounces = NO;
    self.sectionOfficeTB.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.sectionOfficeTB.delegate = self;
    self.sectionOfficeTB.dataSource = self;
    
    
    [bgView addSubview:bgIV];
    [bgView addSubview:self.sectionOfficeTB];
    [_selectionView addSubview:bgView];
    [self.view addSubview:_selectionView];
    [self.view bringSubviewToFront:_selectionView];
}

- (CGFloat)widthBetweenSelectionViewButtons
{
    //iPhone 4,4s,5,5s
    if (KScreenWidth == 320) {
        return 0;
    }
    //iPhone 6
    else if (KScreenWidth == 375){
        return 20;
    }
    else {
        return 30;
    }
}


#pragma mark -- 选择科室网络请求
- (void)getSectionOfficeDataFromNetWork {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getSectionOfficeDataType:@"3" Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf.sectionOfficeDataSource removeAllObjects];
        
        [weakSelf dealWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"选择科室 error == %@",error);
        
    }];
    
}

- (void)dealWithJsonDict:(NSDictionary *)jsonDict {
    
    for (NSDictionary *obj in jsonDict[@"ds"]) {
        
        ZRTSelectModel *model = [ZRTSelectModel ModelWithDict:obj];
        
        [self.sectionOfficeDataSource addObject:model];
        
    }
    
    [self.sectionOfficeTB reloadData];
    
}

//点击手势代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    //NSLog(@"%@",NSStringFromClass([touch.view class]));
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        
        return NO;
   
    }
    else {
        
        return YES;
  
    }
    
}

- (void)selectSectionOffice {
    
    _selectSectionOffice = YES;
    
    if (_sectionOfficeRow == 0) {
      
        _selectSectionOffice = NO;
   
    }
    
    [self.ConsultationTableView.legendHeader beginRefreshing];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.sectionOfficeTB) {
        
        return self.sectionOfficeDataSource.count;
    }
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.sectionOfficeTB) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionOfficeCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SectionOfficeCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [self.sectionOfficeDataSource[indexPath.row] Title];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = KRGBColor(17, 125, 138);
        
        return cell;

    }
    else {
        ZRTConsultationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ConsultationReuseIdentifier];
        
        //ZRTConsultationModel *model = self.dataSource[indexPath.row];

        
        cell.delegate = self;
        
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.consultationId = [self.dataSource[indexPath.row] Id];
        
        [cell fillCellWithModel:self.dataSource[indexPath.row]];
        
        
        _cell = cell;
        
        [self tableView:self.ConsultationTableView heightForRowAtIndexPath:indexPath];
        
        __weak typeof(self) weakSelf = self;
        
        cell.sectionOfficeBtnBlock = ^{
        
            [weakSelf showOfficeSection];
        
        };
        
        [cell jumpToDetailWithBlock:^(ZRTConsultationModel *model) {
            
            
            if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
                
                ZRTConsultationDetailViewController *detailVC = [[ZRTConsultationDetailViewController alloc] init];
                
                detailVC.model = model;
                
                weakSelf.hidesBottomBarWhenPushed = YES;
                
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
                
                weakSelf.hidesBottomBarWhenPushed = NO;
                
                //获取到  点击某一个会诊的id
                detailVC.ConsultationId = [model.Id integerValue];
           
            }
            else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录,跳转去登录" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
                    weakSelf.hidesBottomBarWhenPushed = YES;
                    [weakSelf.navigationController pushViewController:loginVC animated:YES];
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }];
                
                [alert addAction:cancle];
                [alert addAction:sure];
                
                [weakSelf presentViewController:alert animated:YES completion:nil];
                
            }
            
            
        }];
        
        cell.commentBlock = ^{
            
            [weakSelf createInputView];
            [weakSelf tableView:weakSelf.ConsultationTableView didSelectRowAtIndexPath:indexPath];
            
        };
        
        __weak UIButton *favoriteBtn = cell.favoriteBtn;
        
        cell.favoriteBlock = ^{
            
            
            if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
                
                NSLog(@"已经登录");
                
                favoriteBtn.selected = !favoriteBtn.isSelected;
                
                NSInteger favoriteNumber = [[weakSelf.dataSource[indexPath.row] collectnum] integerValue];
                
                if (favoriteBtn.isSelected) {
                    [favoriteBtn setTitle:[NSString stringWithFormat:@"%ld",(long)++favoriteNumber] forState:UIControlStateSelected];
                }
                else {
                    [favoriteBtn setTitle:[NSString stringWithFormat:@"%ld",(long)--favoriteNumber] forState:UIControlStateNormal];
                }
                
                [weakSelf tableView:weakSelf.ConsultationTableView didSelectRowAtIndexPath:indexPath];
                
                [weakSelf collectConsultation];

                
            }else {
                
                NSLog(@"没有登录");
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录,跳转去登录" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
                    
                    self.hidesBottomBarWhenPushed = YES;
                    
                    [self.navigationController pushViewController:loginVC animated:YES];
                    
                    self.hidesBottomBarWhenPushed = NO;
               
                }];
                
                [alert addAction:cancle];
                [alert addAction:sure];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }

            
        };
        
        
        UILongPressGestureRecognizer *lpG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showReport:)];
        [cell addGestureRecognizer:lpG];
        
        [_cellArray addObject:cell];
        
        return cell;

    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.sectionOfficeTB) {
        [_selectBtn setTitle:[self.sectionOfficeDataSource[indexPath.row] Title] forState:UIControlStateNormal];
        _selectBtn.frame = CGRectMake(0, 0, [Helper widthOfString:_selectBtn.currentTitle font:[UIFont systemFontOfSize:14] height:44], 44);
        
        [self showOfficeSection];
        
        _sectionOfficeRow = indexPath.row;
        

        
        [self selectSectionOffice];
    }
    else {
        _selectedRow = indexPath.row;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != self.sectionOfficeTB) {
        return _cell.cellHeight;
    }
    return 44.0;
}

#pragma mark - 长按手势
- (void)showReport:(UILongPressGestureRecognizer *)sender {
    
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"长按手势");
        
        ZRTConsultationTableViewCell *cell = (ZRTConsultationTableViewCell *)sender.view;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            ZRTReportViewController *reportVC = [[ZRTReportViewController alloc] init];
            
            
            reportVC.consultationID = cell.consultationId;
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:reportVC animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
            
        }];
        
        UIAlertAction *comment = [UIAlertAction actionWithTitle:@"评论" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [self createInputView];
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:comment];
        [alert addAction:report];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }

}

- (void)didReceiveMemoryWarning {
  
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 输入栏
- (void)createInputView
{
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        
        if (self.inputView == nil) {
            
            self.inputView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth, KScreenHeight - 64 - 49 - 49, KScreenWidth, 49)];
            self.inputView.backgroundColor = KGrayColor;
            
            self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 10 - 5 - 50 - 10, 29)];
            self.inputTextField.backgroundColor = [UIColor whiteColor];
            self.inputTextField.borderStyle = UITextBorderStyleRoundedRect;
            self.inputTextField.delegate = self;
            
            self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.sendBtn.frame = CGRectMake(CGRectGetMaxX(self.inputTextField.frame) + 5, 10, 50, 29);
            self.sendBtn.layer.cornerRadius = 5;
            self.sendBtn.clipsToBounds = YES;
            [self.sendBtn setTitle:@"评论" forState:UIControlStateNormal];
            [self.sendBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
            [self.sendBtn setBackgroundColor:[UIColor whiteColor]];
            [self.sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
            
            [self.inputView addSubview:self.sendBtn];
            [self.inputView addSubview:self.inputTextField];
            
            [self.view addSubview:self.inputView];
            
            [self setKeyBoardNotificationCenter];
            
            CGRect frame = self.inputView.frame;
            frame.origin.x = 0;
            
            [UIView animateWithDuration:0.3 animations:^{
                self.inputView.frame = frame;
            }completion:^(BOOL finished) {
                [self.inputTextField becomeFirstResponder];
            }];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:UITextFieldTextDidChangeNotification object:nil];
            
        }
        else {
            
            //出现
            [self showSendCommentView];
            
        }
        
    }
    else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前未登录,跳转去登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
            self.hidesBottomBarWhenPushed = NO;
        }];
        
        [alert addAction:cancle];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}

- (void)changeState:(NSNotification *)sender {
    
    
    if (self.inputTextField.text.length != 0) {
        
        [self.sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }else {
    
        [self.sendBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
   
    }
    
}

- (void)showSendCommentView {
    
    NSLog(@"show");
    
    CGRect frame = CGRectMake(0, KScreenHeight - 64 - 49 - 49, KScreenWidth, 49);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.inputView.frame = frame;
        
        //  NSLog(@"%@",NSStringFromCGRect(self.inputView.frame));
        
    }];
}

- (void)dismissSendCommentView {
    
    NSLog(@"dismiss");
    
    CGRect frame = CGRectMake(-KScreenWidth, KScreenHeight - 64 - 49 - 49, KScreenWidth, 49);
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.inputView.frame = frame;
        
        
        
    }completion:^(BOOL finished) {
        
        [self.inputTextField resignFirstResponder];
        
    }];
    
}

- (void)sendComment
{
    NSString *commentContent = self.inputTextField.text;
    
    //消失
    CGRect frame = self.inputView.frame;
    
    frame.origin.x = -KScreenWidth;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.inputView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [self.inputTextField resignFirstResponder];
        
        [self.sendBtn removeFromSuperview];
        [self.inputTextField removeFromSuperview];
        [self.inputView removeFromSuperview];
        
        self.sendBtn = nil;
        self.inputTextField = nil;
        self.inputView = nil;
        
        if (![commentContent isEqualToString:@""]) {
            //不上传数据
            
            ZRTConsultationModel *selectedModel = self.dataSource[_selectedRow];
            //            NSLog(@"-->发送给%ld",[selectedModel.Id integerValue]);
            //发送评论

            [[OZHNetWork sharedNetworkTools] publishCommentWithContents:commentContent andTopicId:selectedModel.Id andSuccess:^(OZHNetWork *manager,NSDictionary *jsonDict) {
                if ([jsonDict[@"Success"] isEqualToString:@"0"]) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"评论失败~" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    
                    [alert addAction:cancle];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"评论成功~" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //评论完成以后要更新数据,刷表
                        //                        [self reloadTableViewWithTopicID:[cell.commentId integerValue]];
                        
                        [self.ConsultationTableView.legendHeader beginRefreshing];
                    }];
                    
                    [alert addAction:cancle];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                
            } andFailure:^(OZHNetWork *manager, NSError *error) {
                
                //NSLog(@"publish error == %@",error);
                
            }];
        }
    }];
}

- (void)reloadTableViewWithTopicID:(NSInteger)ID {
    
    if (isAllUserLogin) {
        [[OZHNetWork sharedNetworkTools] getConsultationListWithIndexPage:_currentPage andStrwhere:STRWHERE andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            [self dealModelWithDict:jsonDict];
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
            
            
        }];
    }
    else {
        [[OZHNetWork sharedNetworkTools] getConsultationListWithIndexPage:_currentPage andStrwhere:NotLoginSTRWHERE andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            [self dealModelWithDict:jsonDict];
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
            
            
        }];
    }
}

- (void)setKeyBoardNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyBoardWillShow:(NSNotification *)notification {
    ////NSLog(@"键盘将要弹出");
    //UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
    //UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
    CGRect oldFrame = self.inputView.frame;
    
    //{{0, 505}, {375, 49}}
    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    oldFrame = CGRectMake(0, KScreenHeight - keyboardFrame.size.height - 49 - 64 , KScreenWidth , 49);//oldFrame.origin.y - keyboardFrame.size.height + 49;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.frame = oldFrame;
        
    }];
}

- (void)keyBoardWillHidden:(NSNotification *)notification {
    ////NSLog(@"键盘将要隐藏");
    
    CGRect oldFrame = self.inputView.frame;
    
    //{{0, 296}, {375, 49}}
    //    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    oldFrame = CGRectMake(0, KScreenHeigh
    oldFrame.origin.y = KScreenHeight - 64 - 49 - 49;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.inputView.frame = oldFrame;
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 网络请求
- (void)getConsultationListWithIndexPage:(NSInteger)page andStrwhere:(NSString *)strwhere{
    
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"PAGE %ld",(long)page);

    
        [[OZHNetWork sharedNetworkTools] getConsultationListWithIndexPage:page andStrwhere:strwhere andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
            
            
            //        NSLog(@"json %@",jsonDict);
            
            [weakSelf makeModelWithDictionary:jsonDict];
            
        } andFailure:^(OZHNetWork *manager, NSError *error) {
            
            NSLog(@"会诊error == %@",error);
            
            [MBProgressHUD showError:@"网络情况不稳定!"];
            
        }];
        
    
}

/**
 收藏网络请求
 */
- (void)collectConsultation {
    
        ZRTConsultationModel *modle = self.dataSource[_selectedRow];
        
        BOOL isFavorite = [modle.havecollect integerValue];
        NSInteger favoriteNum = [modle.collectnum integerValue];
        
        modle.havecollect = [NSString stringWithFormat:@"%d",!isFavorite];
        
        //已经收藏，取消收藏
        if (isFavorite) {
            NSLog(@"取消收藏");
            modle.collectnum = [NSString stringWithFormat:@"%ld",(long)--favoriteNum];
            
            [self cancleCollectConsultationNetworking];
        }
        //没有收藏，进行收藏
        else {
            NSLog(@"进行收藏");
            modle.collectnum = [NSString stringWithFormat:@"%ld",(long)++favoriteNum];
            
            [self collectConsultationNetworking];
        }
        
    
    
    
}

- (void)makeModelWithDictionary:(NSDictionary *)jsonDict {
    
    if ([self.ConsultationTableView.header isRefreshing]) {
        
        [self.dataSource removeAllObjects];
        
        [self fillDataSourceWithArray:jsonDict[@"ds"]];
        
        [self.ConsultationTableView.header endRefreshing];
        
        
        
        
//        [self.ConsultationTableView.legendFooter beginRefreshing];
        
        if (self.dataSource.count == 0) {
          
            [self.ConsultationTableView.legendFooter noticeNoMoreData];
      
        }
        else {
           
            [self.ConsultationTableView.legendFooter endRefreshing];
            
        }
        
        
        
    }else if([self.ConsultationTableView.footer isRefreshing]) {
        
        self.oldDataSource = [self.dataSource copy];
        
        
//        NSLog(@"ds %@",jsonDict[@"ds"]);
//
        NSLog(@"lai");
        
        
        [self fillDataSourceWithArray:jsonDict[@"ds"]];

        
        if (self.oldDataSource.count == self.dataSource.count) {
            
            
            [self.ConsultationTableView.legendFooter noticeNoMoreData];
            
        }
        else {
           
            [self.ConsultationTableView.legendFooter endRefreshing];

        }
        
    }
    
    [self.ConsultationTableView reloadData];
    
//     NSLog(@"??? %ld",_currentPage);
   
//    NSLog(@"io %@",self.dataSource);
}

- (void)fillDataSourceWithArray:(NSArray *)Arr {
    
    for (NSDictionary *dsDict in Arr) {
        
        ZRTConsultationModel *model = [ZRTConsultationModel consultationModelWithDict:dsDict];
        
        //        NSLog(@"网络获取的id == %ld",[model.Id integerValue]);
//        NSLog(@"1111 %@",self.dataSource);
        
        
        [self.dataSource addObject:model];
        
        
//        NSLog(@"2222 %@",self.dataSource);
        
    }
}

- (void)dealModelWithDict:(NSDictionary *)dic {
    
    [self.dataSource removeObjectAtIndex:_selectedRow];
    
    ZRTConsultationModel *model;
    
    for (NSInteger i = 0; i < [dic[@"ds"] count]; i++) {
        
        if (i == _selectedRow) {
            
            model = [ZRTConsultationModel consultationModelWithDict:dic[@"ds"][i]];
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedRow inSection:0];
           
            [self.dataSource insertObject:model atIndex:_selectedRow];
            
            [self.ConsultationTableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        
    }
    
}


- (void)collectConsultationNetworking {
    
    [[OZHNetWork sharedNetworkTools] collectConsultationWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andConsultationId:[self.dataSource[_selectedRow] Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"收藏成功~"];
        }
        else {
            [MBProgressHUD showError:@"收藏失败~"];
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"收藏会诊error == %@",error);
    }];
    
}

- (void)cancleCollectConsultationNetworking {
    
    [[OZHNetWork sharedNetworkTools] cancleCollectConsultationWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andConsultationId:[self.dataSource[_selectedRow] Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
            [MBProgressHUD showSuccess:@"取消收藏成功~"];
        }
        else {
            [MBProgressHUD showError:@"取消收藏失败~"];
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"取消收藏会诊error == %@",error);
 
    }];
    
}

#pragma mark - MJRefresh
- (void)setHeaderRefresh
{
    
    __weak typeof(self) weakSelf = self;
    
    [self.ConsultationTableView addLegendHeaderWithRefreshingBlock:^{
        
        [weakSelf loadNewData];
        
    }];
    
    [self.ConsultationTableView.legendHeader beginRefreshing];
}

- (void)setFooterRefresh
{
    __weak typeof(self) weakSelf = self;
    
    [self.ConsultationTableView addLegendFooterWithRefreshingBlock:^{
        
        NSLog(@"设置foot");
        
        [weakSelf loadMoreData];

    }];
    
    
//    self.ConsultationTableView.legendFooter.appearencePercentTriggerAutoRefresh = 3.0;
    
    [self.ConsultationTableView.legendFooter setTitle:MJRefreshFooterStateNoMoreDataText forState:MJRefreshFooterStateNoMoreData];
}

/**
 上拉加载更多
 */
- (void)loadMoreData {
    
    
    
    if (isAllUserLogin) {
        
        [self getConsultationListWithIndexPage:++_currentPage andStrwhere:STRWHERE];

    }
    else {
        
        [self getConsultationListWithIndexPage:++_currentPage andStrwhere:NotLoginSTRWHERE];

    }
    

}

/**
 下拉刷新
 */
- (void)loadNewData {
    
    _currentPage = 1;
    if (isAllUserLogin) {
        
        
        NSLog(@"SHUASHUA");
      
        [self getConsultationListWithIndexPage:_currentPage andStrwhere:STRWHERE];
  
    }
    else {
        
        [self getConsultationListWithIndexPage:_currentPage andStrwhere:NotLoginSTRWHERE];
    
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.inputView.origin.x == 0 && self.inputView != nil) {
        [self dismissSendCommentView];
    }
}

#pragma mark - 发布成功提示
- (void)showPublishStateWithState:(NSInteger)state {
    
    CGFloat labelH = 35;
    CGFloat labelW = self.view.width;
    CGFloat labelX = 0;
    CGFloat labelY = CGRectGetMaxY( self.navigationController.navigationBar.frame) - labelH;
    
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    
    self.stateLabel.backgroundColor = [UIColor orangeColor];
    
    self.stateLabel.text = @"正在发送中~";
    
    
    self.stateLabel.textAlignment = NSTextAlignmentCenter;
  
    self.stateLabel.textColor = [UIColor whiteColor];
    
    [self.navigationController.view insertSubview:self.stateLabel belowSubview:self.navigationController.navigationBar];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.stateLabel.transform = CGAffineTransformMakeTranslation(0, labelH);
        
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark ZRTConsultationTableViewCell代理方法

-(void)reloadData
{
    
    [self.ConsultationTableView.legendHeader beginRefreshing];
    
}


@end
