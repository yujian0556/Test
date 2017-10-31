//
//  ZRTConsultationDetailViewController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/5/14.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTConsultationDetailViewController.h"

#import "Helper.h"

#import "ZRTConsultationDetailContentTableViewCell.h"
#import "ZRTConsultationDetailCommentTableViewCell.h"

#import "ZRTConsultationDetailModel.h"

#import "ZRTReportViewController.h"

#import "MBProgressHUD+MJ.h"

static NSString *contentCellReuseID = @"ContentCell";
static NSString *commentCellReuseID = @"CommentCell";

@interface ZRTConsultationDetailViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIScrollView *detailSV;

@property (nonatomic,strong) UIImageView *headerImageView;//头像
@property (nonatomic,strong) UILabel *userNameLabel;//用户名
@property (nonatomic,strong) UIView *separateLineView;//分割线
@property (nonatomic,strong) UILabel *officeLabel;//科室
@property (nonatomic,strong) UILabel *doctorRankLabel;//医师等级
@property (nonatomic,strong) UIButton *chooseOfficeButton;//科室按钮

@property (nonatomic,strong) UILabel *contentLabel;//内容

@property (nonatomic,strong) UIView *pictureView;
@property (nonatomic,strong) UIView *buttonsView;

@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) UIView *inputView;
@property (nonatomic,strong) UITextField *inputTextField;

@property (nonatomic,strong) UIButton *sendBtn;

@end

@implementation ZRTConsultationDetailViewController
{
    CGFloat _heightOfCommentLabel;
    UILabel *_previousLabel;
    NSInteger _commentLabelCount;
    UIButton *_selectBtn;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self createDetailTableView];
    
    [self changeModelToDataSource];
    
    [self setRightNavgationBar];
    
    [self createInputView];
    
    [self setKeyBoardNotificationCenter];
    
    
}

- (void)createDetailTableView
{
    self.commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 49)];
    
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    [self.commentTableView registerClass:[ZRTConsultationDetailCommentTableViewCell class] forCellReuseIdentifier:commentCellReuseID];
    [self.commentTableView registerClass:[ZRTConsultationDetailContentTableViewCell class] forCellReuseIdentifier:contentCellReuseID];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    self.commentTableView.tableFooterView = clearView;
    
    [self.view addSubview:self.commentTableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count) {
        return [self.dataSource[1] count] + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        ZRTConsultationDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contentCellReuseID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *subArray = cell.contentView.subviews;
        for (id obj in subArray) {
            [obj removeFromSuperview];
        }
        
        CGFloat rowHeight = [cell fillCellWithDictionary:self.dataSource[indexPath.row]];
        
        tableView.rowHeight = rowHeight + 10;
        
        [cell commentBlock:^{
            [self.inputTextField becomeFirstResponder];
        }];
        
        __weak UIButton *favoriteBtn = cell.favoriteBtn;
        __weak typeof(self) weakSelf = self;
        
        cell.favoriteBlock = ^{
            
                favoriteBtn.selected = !favoriteBtn.isSelected;
                
                NSInteger favoriteNumber = [[weakSelf.model collectnum] integerValue];
                
                if (favoriteBtn.isSelected) {
                    [favoriteBtn setTitle:[NSString stringWithFormat:@"%ld",(long)++favoriteNumber] forState:UIControlStateSelected];
                }
                else {
                    [favoriteBtn setTitle:[NSString stringWithFormat:@"%ld",(long)--favoriteNumber] forState:UIControlStateNormal];
                }
                
                [weakSelf collectConsultation];
                
            
  
        };
        
        return cell;
        
    }
    else {
        
        ZRTConsultationDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellReuseID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *subArray = cell.contentView.subviews;
        for (id obj in subArray) {
            [obj removeFromSuperview];
        }
        
        CGFloat rowHeight = [cell fillCellWithDictionary:self.dataSource[1][indexPath.row - 1]];
        
        tableView.rowHeight = rowHeight + 10;
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row) {
        //点击TabelViewCell的时候,输入框处理
        self.inputTextField.text = @"";
        NSString *userName;
        if ([self.dataSource[1][indexPath.row - 1][@"NickName"] isEqualToString:@""]) {
            userName = [NSString stringWithFormat:@"用户%@",self.dataSource[1][indexPath.row - 1][@"UserId"]];
        }
        else {
            userName = self.dataSource[1][indexPath.row - 1][@"NickName"];
        }
        
        self.inputTextField.text = [NSString stringWithFormat:@"回复%@:",userName];
        [self.inputTextField becomeFirstResponder];
    }
}

#pragma mark - 输入栏
- (void)createInputView
{
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64 - 49, KScreenWidth, 49)];
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
    [self.sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.sendBtn setBackgroundColor:[UIColor whiteColor]];
    [self.sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    
    [self.inputView addSubview:self.sendBtn];
    [self.inputView addSubview:self.inputTextField];
    
    [self.view addSubview:self.inputView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)sendComment
{
    ////NSLog(@"发送评论 : %@",self.inputTextField.text);
    
    __weak typeof(self) weakSelf = self;
    
    //发送评论
    [[OZHNetWork sharedNetworkTools] publishCommentWithContents:self.inputTextField.text andTopicId:self.model.Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        if ([jsonDict[@"Success"] isEqualToString:@"0"]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"评论失败~" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:cancle];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"评论成功~" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [weakSelf reloadCommentData];
            }];
            
            [alert addAction:cancle];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }

        
        
        
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        //NSLog(@"publish error == %@",error);
        
    }];
    
    self.inputTextField.text = @"";
    [self.inputTextField resignFirstResponder];
    
    
}

- (void)changeState:(NSNotification *)sender {
    
    
    if (self.inputTextField.text.length != 0) {
        
        [self.sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
    }
    else {
        [self.sendBtn setTitleColor:KGrayColor forState:UIControlStateNormal];
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
    //    CGRect oldFrame = self.inputView.frame;
    //
    //    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    oldFrame.origin.y = oldFrame.origin.y - keyboardFrame.size.height;
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.inputView.frame = oldFrame;
    //    }];
    
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
    
    //    CGRect oldFrame = self.inputView.frame;
    //
    //    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    oldFrame.origin.y = oldFrame.origin.y + keyboardFrame.size.height;
    //
    //    [UIView animateWithDuration:0.3 animations:^{
    //        self.inputView.frame = oldFrame;
    //    }];
    
    CGRect oldFrame = self.inputView.frame;
    
    //{{0, 296}, {375, 49}}
    //    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    oldFrame = CGRectMake(0, KScreenHeigh
    oldFrame.origin.y = KScreenHeight - 64 - 49;
    
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

#pragma mark - 导航控制器
/**
 *  左右NavigationBar
 */
-(void)setRightNavgationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"举报" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRight)];
}

/**
 *  首页导航栏左按钮:返回
 */
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  首页导航栏右按钮
 */
-(void)didClickRight
{
    //举报功能
    ZRTReportViewController *reportVC = [[ZRTReportViewController alloc] init];
    
    reportVC.consultationID = [NSString stringWithFormat:@"%ld",(long)self.ConsultationId];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:reportVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeModelToDataSource
{
    NSMutableDictionary *contentDict = [[NSMutableDictionary alloc] init];
    
    [contentDict setObject:self.model.UserId forKey:@"UserId"];
    
    [contentDict setObject:self.model.Contents forKey:@"Contents"];
    
    
    [contentDict setObject:self.model.NickName forKey:@"userName"];
    
    
    [contentDict setObject:self.model.SectionOffice forKey:@"officeName"];
    
    
    [contentDict setObject:self.model.Professional forKey:@"doctorRank"];
    
    
    [contentDict setObject:self.model.ImgUrl forKey:@"headerImageURLString"];
    
    [contentDict setObject:self.model.ReplayCount forKey:@"commentNumber"];
    
    
    [contentDict setObject:self.model.AddTime forKey:@"AddTime"];
    
    [contentDict setObject:self.model.collectnum forKey:@"collectnum"];
    
    [contentDict setObject:self.model.havecollect forKey:@"havecollect"];
    
    
    if (self.model.ImgList[@"ds"]) {
        [contentDict setObject:self.model.ImgList[@"ds"] forKey:@"picturesArray"];
    }
    else {
        [contentDict setObject:@[] forKey:@"picturesArray"];
    }
    
    [self.dataSource addObject:contentDict];
    
    if (self.model.ConsultationReplay[@"ds"]) {
        [self.dataSource addObject:self.model.ConsultationReplay[@"ds"]];
    }
    else {
        NSMutableArray *zeroArray = [NSMutableArray array];
        
        [self.dataSource addObject:zeroArray];
    }
    
}

#pragma mark - 网络请求
- (void)reloadCommentData {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getConsultationListWithIndexPage:1 andStrwhere:[NSString stringWithFormat:@"a.id=%@",self.model.Id] Success:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [self.dataSource removeAllObjects];
        
        for (NSDictionary *dsDict in jsonDict[@"ds"]) {
            
            ZRTConsultationModel *model = [ZRTConsultationModel consultationModelWithDict:dsDict];
            
            weakSelf.model = model;
            
            [weakSelf changeModelToDataSource];
        }
        
        [self.commentTableView reloadData];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        //NSLog(@"reload data error == %@",error);
    }];
}

/**
 收藏网络请求
 */
- (void)collectConsultation {
    
    ZRTConsultationModel *modle = self.model;
    
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
- (void)collectConsultationNetworking {
    
    [[OZHNetWork sharedNetworkTools] collectConsultationWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andConsultationId:[self.model Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
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
    
    [[OZHNetWork sharedNetworkTools] cancleCollectConsultationWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andConsultationId:[self.model Id] andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
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
@end
