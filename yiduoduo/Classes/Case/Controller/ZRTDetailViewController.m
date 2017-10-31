//
//  ZRTDetailViewController.m
//  yiduoduo
//
//  Created by moyifan on 15/6/4.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTDetailViewController.h"
#import "ZRTCaseHeadView.h"
#import "ZRTDetailCell.h"
#import "Helper.h"
#import "ZRTGradeView.h"
#import "LGAlertView.h"
#import "ZRTGradeSuccess.h"
#import "ZRTCommentController.h"
#import "AFNetworking.h"

#import "ZRTConsultationDetailCommentTableViewCell.h"
#import "ZRTCaseCommentNumberTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"
#import "Interface.h"

@interface ZRTDetailViewController ()<ZRTCaseHeadViewDelegete,ZRTGradeViewDelegate,ZRTCommentControllerDelegate>



@property (nonatomic,strong) NSArray *sectionArray;

@property (nonatomic,strong) NSMutableDictionary *showDic;

@property (nonatomic,strong) NSMutableArray *selectedArr;

@property (nonatomic,strong) ZRTCaseHeadView *headView;

@property (nonatomic,strong) NSMutableArray *commentDataArray;
@property (nonatomic,strong) NSDictionary *commentNumberDict;

@property (nonatomic,weak) ZRTGradeSuccess *success;

@property (nonatomic,assign) CGFloat fen;

@property (nonatomic,strong) UIBarButtonItem *gradeItem;

@property (nonatomic,strong) UIBarButtonItem *collectItem;

@property (nonatomic,strong) NSMutableDictionary *saveDic;

@property (nonatomic,strong) UIView *imageGroup;

@end

@implementation ZRTDetailViewController


//隐藏状态栏
//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
   
    

}



//-(void)GetCaseScore
//{
//
//    
//    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/GetCaseScore";
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    
//    [manager GET:url parameters:@{@"CaseID":self.model.Id} success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//     
//        
//        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        
//        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];
//        
//        self.headFen = jsonDict[@"score"];
//       
//        NSLog(@"net %@",self.headFen);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//        
//        NSLog(@" error %@",error);
//        
//    }];
//
//
//
//
//
//
//
//}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavBar];
    
    
    [self createArray];
    //NSLog(@"%@",self.model);
    
    //NSLog(@"id -- %@",self.model.Id);
    [self getCaseCommentDataWithCaseId:self.model.Id];
    //[self getCaseCommentDataWithCaseId:@"1"];
   
  // ZRTCaseHeadView *headView = [[ZRTCaseHeadView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 340)];
    
    ZRTCaseHeadView *headView = [[ZRTCaseHeadView alloc] init];
    
    headView.delegete = self;
    
    
  //  NSLog(@"%@",NSStringFromCGRect(headView.frame));
    
    self.headView = headView;
    
    self.headView.model = self.model;
    
    
    self.tableView.tableHeaderView = self.headView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
    
    [self.tableView registerClass:[ZRTCaseCommentNumberTableViewCell class] forCellReuseIdentifier:@"CaseCommentNumberCell"];
    [self.tableView registerClass:[ZRTConsultationDetailCommentTableViewCell class] forCellReuseIdentifier:@"CommentCell"];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = clearView;
    
    [self setUpWenZhen];
    
    [self setUpTiGe];
    
    [self setUpChuZhen];
    
    [self setUpFuZhu];
    
    [self setUpZhenDuan];
    
    [self setUpGuoCheng];
    
    [self setUpTaoLun];
    
    [self setUpToolBar];
    
   // self.view.clipsToBounds = NO;
}


- (void)createArray {
    
    self.commentDataArray = [NSMutableArray array];
}

-(void)headViewHeight:(CGFloat)height
{

  //  NSLog(@"%f",height);
    
    self.headView.frame = CGRectMake(0, 0, self.view.width, height);
    
    
    self.tableView.tableHeaderView = self.headView;
    
    
    
}


#pragma mark 底部工具栏，后期

#define titleColor [UIColor colorWithRed:102/256.0 green:102/256.0 blue:102/256.0 alpha:1]
#define lineColor [UIColor colorWithRed:226/256.0 green:226/256.0 blue:226/256.0 alpha:1]
#define disabledColor [UIColor colorWithRed:157/256.0 green:157/256.0 blue:157/256.0 alpha:1]

-(void)setUpToolBar
{

    
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    
    
//    [self setToolbarItems:[NSArray arrayWithObjects:flexItem, back, flexItem, support, flexItem, collect, flexItem, message, flexItem, share , flexItem,nil]];
    
    CGFloat toolW = self.navigationController.toolbar.width;
    CGFloat toolH = self.navigationController.toolbar.height;
    
    CGFloat marginFen = 10;
    
    CGFloat fengeX = toolW/3 -25;
    CGFloat fengeH = toolH - 2*marginFen;
    
    
    
    UIButton *grade = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX , toolH)];
    
    
    
    [grade setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    
    [grade setTitle:@" 评分" forState:UIControlStateNormal];
    
    [grade setImage:[UIImage imageNamed:@"love_information_list_ful_"] forState:UIControlStateDisabled];
    
    [grade setTitle:@" 评分" forState:UIControlStateDisabled];
   
    [grade setTitleColor:titleColor forState:UIControlStateNormal];
    
    [grade setTitleColor:disabledColor forState:UIControlStateDisabled];
    
    [grade addTarget:self action:@selector(didClickGrade) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *gradeItem = [[UIBarButtonItem alloc] initWithCustomView:grade];
    
    self.gradeItem = gradeItem;
    
    if ([self.model.havescore isEqual:@"1"]) {
        
        self.gradeItem.enabled = NO;
    }
    
    
    
    
    UIButton *collect = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX, toolH)];
    
    
    
    [collect setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    
    [collect setTitle:@" 收藏" forState:UIControlStateNormal];
    
    [collect setImage:[UIImage imageNamed:@"gstar"] forState:UIControlStateDisabled];
    
    [collect setTitle:@" 收藏" forState:UIControlStateDisabled];
    
    [collect setTitleColor:titleColor forState:UIControlStateNormal];
    
    [collect setTitleColor:disabledColor forState:UIControlStateDisabled];

    [collect addTarget:self action:@selector(didClickcollect) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *collectItem = [[UIBarButtonItem alloc] initWithCustomView:collect];
    
    self.collectItem = collectItem;
    
    if ([self.model.havecollect isEqual:@"1"]) {
        
        self.collectItem.enabled = NO;
    }
    
    
    
    
    UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, fengeX, toolH)];
    
    
    
    [comment setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    
    [comment setTitle:@" 评论" forState:UIControlStateNormal];
    
    [comment setTitleColor:titleColor forState:UIControlStateNormal];

    [comment addTarget:self action:@selector(didClickcomment) forControlEvents:UIControlEventTouchUpInside];

    
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:comment];
    
    
    
    

    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, 1, fengeH)];
    
    line.backgroundColor = lineColor;
    
    
    UIButton *line1 = [[UIButton alloc] initWithFrame:CGRectMake(0, marginFen, 1, fengeH)];
    
    line1.backgroundColor = lineColor;
    
    
    
    UIBarButtonItem *lineItem = [[UIBarButtonItem alloc] initWithCustomView:line];
    
    UIBarButtonItem *lineItem1 = [[UIBarButtonItem alloc] initWithCustomView:line1];
    
    [self setToolbarItems:[NSArray arrayWithObjects:gradeItem,lineItem,collectItem,lineItem1,commentItem,nil]];
    
    
    
    
    
    

}



#pragma mark ToolBar点击事件

// 点击评分
-(void)didClickGrade
{
    
    ZRTGradeView *grade = [[ZRTGradeView alloc] init];

    grade.delegate = self;
    
    
    
    LGAlertView *alert = [LGAlertView alertViewWithViewStyleWithTitle:@"评分" message:nil view:grade buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" actionHandler:nil cancelHandler:nil destructiveHandler:^(LGAlertView *alertView) {
       
        
        [self sendGrade];
     
        
    }];
  
    
    [alert showAnimated:YES completionHandler:nil];
    
    
   
    
}


-(void)sendGrade
{

    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/AddCaseScore";
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *CaseID = self.model.Id;
    
    NSString *score = [NSString stringWithFormat:@"%f",self.fen];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    

    
    [manager POST:url parameters:@{@"UserID":UserID,@"CaseID":CaseID,@"score":score} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
//        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//        
//        NSDictionary *jsonDict = [self StringToJsonDictWithJsonString:[[NSString alloc] initWithData:responseObject encoding:encoding]];

        
        self.headView.caseID = CaseID;
        
        [self.tableView reloadData];
        
        
        [self performSelector:@selector(cover) withObject:nil afterDelay:0.6];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

       
        
        [self performSelector:@selector(cover1) withObject:nil afterDelay:0.6];
        
    }];
    
    
    

}




// 点击收藏
-(void)didClickcollect
{
    
    
    NSString *url = @"http://www.yddmi.com/WebServices/Ydd_Case.asmx/AddCaseCollect";
    
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserDict"];
    
    NSString *UserID = [dic objectForKey:@"Id"];
    
    NSString *CaseID = self.model.Id;
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    [manager POST:url parameters:@{@"UserID":UserID,@"CaseID":CaseID} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.collectItem.enabled = NO;
        
        NSLog(@"收藏成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"收藏失败");
        
    }];
    
  
    
}



// 点击评论
-(void)didClickcomment
{
    
    ZRTCommentController *comment = [[ZRTCommentController alloc] init];
    
    comment.delegate = self;
    
    
    comment.isCase = YES;
    
    comment.model = self.model;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:comment];
    
   
    
    [self presentViewController:nav animated:YES completion:nil];
    
}





// 蒙版隐藏
-(void)cover
{
    self.success = [ZRTGradeSuccess initWithSuccess:YES];
  
    
    self.gradeItem.enabled = NO;
}


-(void)cover1
{
    self.success =[ZRTGradeSuccess initWithSuccess:NO];

    self.gradeItem.enabled = YES;
}



#pragma mark gradeView代理方法


// 选择分数
-(void)chooseGrade:(CGFloat)grade
{

    self.fen = grade;

}


#pragma mark 发送评论代理方法（刷表）

-(void)commentReload
{

    [self.commentDataArray removeAllObjects];
    
    do {
        [self getCaseCommentDataWithCaseId:self.model.Id];
        
    } while (self.commentDataArray.count != 0);
    
    

}









#pragma mark 改变导航条返回按钮
-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
}

- (void)back
{
    [self.navigationController setToolbarHidden:YES animated:YES];
//    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(reloadDataAfterBack)]) {
        
        [self.delegate reloadDataAfterBack];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (self.isSearch) {
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"search_top_bg"] forBarMetrics:UIBarMetricsDefault];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        
    }
    
}


#pragma mark 设置分组
-(void)setUpWenZhen
{
    
    
    NSString *text1 = self.model.ZhuShu;
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"主诉",@"title",text1,@"text",nil];
    
    NSString *text2 = self.model.MedicalHistory;
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"现病史",@"title",text2,@"text",nil];
    
     NSString *text3 = self.model.OldMedicalHistory;
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"既往史",@"title",text3,@"text",nil];


    NSString *text4 = self.model.OperationHistory;
    NSMutableDictionary *nameAndStateDic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"手术、外伤史",@"title",text4,@"text",nil];
    
    NSString *text5 = self.model.TransfusionHistory;
    NSMutableDictionary *nameAndStateDic5 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"输血史",@"title",text5,@"text",nil];
    
    NSString *text6 = self.model.GMS;
    NSMutableDictionary *nameAndStateDic6 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"药物过敏史",@"title",text6,@"text",nil];
    
    
    
    NSString *text7 = self.model.GRS;
    NSMutableDictionary *nameAndStateDic7 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"个人史",@"title",text7,@"text",nil];
    
    NSString *text8 = self.model.HunYu;
    NSMutableDictionary *nameAndStateDic8 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"婚育史",@"title",text8,@"text",nil];
    
    NSString *text9 = self.model.YJS;
    NSMutableDictionary *nameAndStateDic9 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"月经史",@"title",text9,@"text",nil];
    
    
    NSString *text10 = self.model.JiaZu;
    NSMutableDictionary *nameAndStateDic10 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"家族史",@"title",text10,@"text",nil];
    
    
    
   NSMutableArray *grouparr0 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3,nameAndStateDic4,nameAndStateDic5,nameAndStateDic6,nameAndStateDic7,nameAndStateDic8,nameAndStateDic9,nameAndStateDic10, nil];
    
    
    [self.showDic setValue:grouparr0 forKey:@"0"];


}


-(void)setUpTiGe
{

    NSString *text1 = self.model.SMTZ;
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"生命体征",@"title",text1,@"text",nil];
    
    
   
    
    NSString *text2 = self.model.TGJC;

   
    NSArray *image = [self.model.TGJC_img componentsSeparatedByString:@","];

    
    
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"体格检查",@"title",text2,@"text",image,@"img",nil];


    NSMutableArray *grouparr1 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2, nil];
    
    
    [self.showDic setValue:grouparr1 forKey:@"1"];
    
    
    
    

}



-(void)setUpChuZhen
{

    NSString *text1 = self.model.ChuZhen;
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"初诊",@"title",text1,@"text",nil];
    
    
    NSMutableArray *grouparr2 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1, nil];
    
    
    [self.showDic setValue:grouparr2 forKey:@"2"];
    
    

}




-(void)setUpFuZhu
{

    NSString *text1 = self.model.ShiYan;
    NSArray *image = [self.model.ShiYan_img componentsSeparatedByString:@","];
    
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"实验室检查",@"title",text1,@"text",image,@"img",nil];
    
    NSString *text2 = self.model.YXX;
    NSArray *image2 = [self.model.YXX_img componentsSeparatedByString:@","];
    
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"影像学检查",@"title",text2,@"text",image2,@"img",nil];
    
    NSString *text3 = self.model.ZKJC;
    
    NSArray *image3 = [self.model.ZKJC_img componentsSeparatedByString:@","];
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"专科检查",@"title",text3,@"text",image3,@"img",nil];
    
    
    NSString *text4 = self.model.PDLB;
    NSMutableDictionary *nameAndStateDic4 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"评定量表",@"title",text4,@"text",nil];

    
    NSMutableArray *grouparr3 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3,nameAndStateDic4, nil];
    
    
    [self.showDic setValue:grouparr3 forKey:@"3"];


}




-(void)setUpZhenDuan
{

    NSString *text1 = self.model.ZhenDuan;
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"诊断",@"title",text1,@"text",nil];
    
    NSString *text2 = self.model.XZZD;
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"修正诊断",@"title",text2,@"text",nil];
    
    NSString *text3 = self.model.JBZD;
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"鉴别诊断",@"title",text3,@"text",nil];

    
    NSMutableArray *grouparr4 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3, nil];
    
    
    [self.showDic setValue:grouparr4 forKey:@"4"];


}



-(void)setUpGuoCheng
{

    NSString *text1 = self.model.ZLSL;
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"诊疗思维",@"title",text1,@"text",nil];
    
    NSString *text2 = self.model.ZLJS;

    
    NSArray *image = [self.model.ZLJS_img componentsSeparatedByString:@","];
    
    NSMutableDictionary *nameAndStateDic2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"治疗简述",@"title",text2,@"text",image,@"img",nil];
    
    NSString *text3 = self.model.BQZG;
    NSMutableDictionary *nameAndStateDic3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"病情转归",@"title",text3,@"text",nil];
    
    
    NSMutableArray *grouparr5 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1,nameAndStateDic2,nameAndStateDic3, nil];
    
    
    [self.showDic setValue:grouparr5 forKey:@"5"];



}


-(void)setUpTaoLun
{

    NSString *text1 = [NSString stringByReplacing:self.model.TLDP];
    
    NSArray *image = [self.model.TLDP_img componentsSeparatedByString:@","];
    
    NSMutableDictionary *nameAndStateDic1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"讨论与点评",@"title",text1,@"text",image,@"img",nil];

    NSMutableArray *grouparr6 = [[NSMutableArray alloc] initWithObjects:nameAndStateDic1, nil];
    
    
    [self.showDic setValue:grouparr6 forKey:@"6"];

}









#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSString *string = [NSString stringWithFormat:@"%ld",section];
    
        
        if ([self.selectedArr containsObject:string]) {
            
        
            if (section != 7) {
                UIImageView *imageV = (UIImageView *)[self.tableView viewWithTag:20000+section];
                imageV.image = [UIImage imageNamed:@"consulation_btn_downarrow"];
                
                NSArray *array1 = self.showDic[string];
                
                return array1.count;
            }
            else if (section == 7) {
                
                return self.commentDataArray.count + 1;
                
            }
        }

    
    
    return 0;
}


//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    static NSString *ID = @"detail";
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
//        
//       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        
//    }
//    
//    cell.textLabel.text = @"主述:";
//    
//    cell.textLabel.textColor = KdetailTitleColor;
//    
//    cell.textLabel.font = [UIFont systemFontOfSize:16];
//    
////    CGSize text = cell.textLabel.frame.size;
//    
//    cell.detailTextLabel.text = @"momomo";
//    
//    cell.detailTextLabel.numberOfLines = 0;
//    
//   // cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
//    
////    CGSize detail = cell.detailTextLabel.frame.size;
////    
////    CGRect rect = cell.frame;
////    
////    rect.size.height = text.height + detail.height + 5;
//    
////    cell.frame = rect;
//    
//    return cell;
//}

#define margin 10

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.section];
    
 //   NSLog(@"section %@",indexStr);
    
    
    if ([self.showDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]){
        
        static NSString *ID = @"detail";
        
        ZRTDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if (cell == nil) {
            
            cell = [[ZRTDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            
            for (UIView *obj in cell.contentView.subviews) {
                [obj removeFromSuperview];
            }
            
            [cell setAllView];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.selected = NO;
        }
        
        
        if ([self.selectedArr containsObject:indexStr]) {
       
            cell.title.text = self.showDic[indexStr][indexPath.row][@"title"];
            
            CGFloat height = [Helper heightOfString:self.showDic[indexStr][indexPath.row][@"text"] font:[UIFont systemFontOfSize:17] width:KScreenWidth - margin*2];
            
            
            
            cell.text.frame = CGRectMake(margin, margin + cell.title.height, KScreenWidth - margin*2, height +margin);
            
            cell.text.text = self.showDic[indexStr][indexPath.row][@"text"];
           
  
            
            NSArray *array = self.showDic[indexStr][indexPath.row][@"img"];
            
        //    NSLog(@" %@",cell.srcStringArray);
            
            
            // 设置图片

            [self setUpContentImage:array imageView:cell.motifImageView textMaxY:CGRectGetMaxY(cell.text.frame)];
            
            
            
            
            
            cell.height =  cell.title.height + cell.text.height +margin + cell.motifImageView.height +margin*2;
            
            CGRect cellF = CGRectMake(cell.x, cell.y, cell.width, cell.height);
            
            cell.frame = cellF;

 
//            NSLog(@"shanji %f",height);
//            
//            NSLog(@"cell %f",cell.height);
//            
//            NSLog(@"title %@",NSStringFromCGRect(cell.title.frame));
//            
//            NSLog(@"text %@",NSStringFromCGRect(cell.text.frame));
//            
//            NSLog(@"img %@",NSStringFromCGRect(cell.image.frame));
            
            
        }

        
        return cell;
        
        
    }
    else if (indexPath.section == 7) {
        

        if (indexPath.row == 0) {
            
            ZRTCaseCommentNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseCommentNumberCell"];
            
            //NSLog(@"%@",self.commentDataArray);
            
//            if (cell == nil) {
//                
//                cell = [[ZRTCaseCommentNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CaseCommentNumberCell"];
            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                
//            }
            
            for (UIView *obj in cell.contentView.subviews) {
                [obj removeFromSuperview];
            }
            
            cell.height = [cell fillCellWithData:self.commentNumberDict];
            
            
            
            return cell;
        }
        else {
            
            ZRTConsultationDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            

//            
//            if (cell == nil) {
//                
//                cell = [[ZRTConsultationDetailCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

//            }
            
            for (UIView *obj in cell.contentView.subviews) {
                [obj removeFromSuperview];
            }
            
            //NSLog(@"-->%@",self.commentDataArray);
            
            cell.height = [cell fillCaseCommentCellWithData:self.commentDataArray[indexPath.row - 1]] + 10;
            
            
            return cell;
        }
        
        
    }
    
    
    return nil;
    
}


#define kImagesMargin 10

#pragma mark 设置图片
-(void)setUpContentImage:(NSArray *)imageArray imageView:(UIView *)imageView textMaxY:(CGFloat)textY
{
    
    
    if (imageArray == nil) {
        
        for (id obj in imageView.subviews) {
   
            NSString *class = [NSString stringWithUTF8String:object_getClassName(obj)] ;
 
            
            if ([class isEqualToString:@"HZImagesGroupView"]) {
       
                
                [obj removeFromSuperview];
            }
            
            
        }
        
        
        return;
    }
    
    
    for (NSString *temp in imageArray) {
        
        if ([temp isEqualToString:@""]) {
            
            return;
        }
    }
    
    
    
    long imageCount = imageArray.count;
    int perRowImageCount = ((imageCount == 4) ? 2 : 3);
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF);
    
    CGFloat h = 80;
    
    CGFloat high =  totalRowCount * (kImagesMargin + h);
    
    
    HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] init];
    
    
    
    NSMutableArray *temp = [NSMutableArray array];
    
   
    
    [imageArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
   
       
        HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
     
        
        item.thumbnail_pic = [NSString stringWithFormat:@"%@%@",KMainInterface,src];
        
      //  item.thumbnail_pic = src;
        
      //   NSLog(@"有没有 %@",item.thumbnail_pic);
        [temp addObject:item];
    }];
    
    imagesGroupView.photoItemArray = [temp copy];
    
    [imageView addSubview:imagesGroupView];
    
    
    
    
    
    // 重新设置view的frame
    
    imageView.frame = CGRectMake(10, textY+kImagesMargin, self.view.width-margin, high+margin);
    
    
    
}








#pragma mark cell高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

//     NSString *indexStr = [NSString stringWithFormat:@"%ld",indexPath.section];
//    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//
//    
//    
//    if ([self.showDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]]) {
//        
//        
//        return cell.height;
//        
//    }
//
//    if ([self.showDic[indexStr][indexPath.row][@"cell"] isEqualToString:@"MainCell"]) {
//        return cell.height;
//    }
    
//    return 0;
    
    
    
    return cell.height;
}


//设置表头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 7) {
        return 45;
    }
    return 40;
}

//Section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    
    if (section != 7) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
      //  header.backgroundColor = KdetailSectionColor;
        
        header.backgroundColor = KRGBColor(200, 232, 236);

        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, self.view.width * 0.5, 30)];
        
        label.text = [NSString stringWithFormat:@"%@",self.sectionArray[section]];
        label.textColor = [UIColor blackColor];
        
        label.font = [UIFont systemFontOfSize:16];
        
        [header addSubview:label];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 30, 12, 15, 15)];
        imageView.tag = 20000+section;
        
        //判断是不是选中状态
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        
        if ([self.selectedArr containsObject:string]) {
            imageView.image = [UIImage imageNamed:@"consulation_btn_uparrow"];
            
          //  NSLog(@"打开");
            
   
            
        }
        else
        {
            imageView.image = [UIImage imageNamed:@"consulation_btn_downarrow"];
            

            
          //  NSLog(@"收起");
        }
        
        [header addSubview:imageView];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.view.width, 40);
        button.tag = 100+section;
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
        
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.width, 1)];
        lineImage.image = [UIImage imageNamed:@"line.png"];
        [header addSubview:lineImage];
        
        return header;
    }
    else {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
        header.backgroundColor = [UIColor whiteColor];
        
        UIImageView *lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
        lineImage1.image = [UIImage imageNamed:@"line.png"];
        [header addSubview:lineImage1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, [Helper widthOfString:self.sectionArray[section] font:[UIFont systemFontOfSize:17] height:30], 30)];
        label.center = CGPointMake(KScreenWidth / 2, 15);
        
        label.text = [NSString stringWithFormat:@"%@",self.sectionArray[section]];
        //label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        
        [header addSubview:label];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 13, 7)];
        imageView.center = CGPointMake(KScreenWidth/2, CGRectGetMaxY(label.frame));
        imageView.tag = 20000+section;
        
        //判断是不是选中状态
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        
        if ([self.selectedArr containsObject:string]) {
            imageView.image = [UIImage imageNamed:@"ARROW"];
            label.text = @"收起评论";
            label.textColor = KMainColor;
        }
        else
        {
            label.textColor = KMainColor;
            UIImage *image = [UIImage imageNamed:@"ARROW"];
            imageView.image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationDown];
            
        }
        [header addSubview:imageView];
        
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, self.view.width, 40);
        button.tag = 100+section;
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:button];
        
        
        UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, self.view.width, 1)];
        lineImage2.image = [UIImage imageNamed:@"line.png"];
        [header addSubview:lineImage2];
        
        return header;
    }
    

    
    
    
//    header.tag = section;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickSection:)];
//    
//    tap.numberOfTapsRequired = 1;
//    [tap setNumberOfTouchesRequired:1];
//    
//    [header addGestureRecognizer:tap];
    

    
}


-(void)doButton:(UIButton *)sender
{
    NSString *string = [NSString stringWithFormat:@"%ld",sender.tag-100];
    
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([self.selectedArr containsObject:string])
    {
        [self.selectedArr removeObject:string];
    }
    else
    {
        [self.selectedArr addObject:string];
    }
    
   // NSLog(@"%@",self.selectedArr);
    
    [self.tableView reloadData];
}




//-(void)didClickSection:(UITapGestureRecognizer *)tap
//{
//    NSInteger *didSection = tap.view.tag;
//
//    NSString *key = [NSString stringWithFormat:@"%ld",didSection];
//
//    if (![_showDic objectForKey:key]) {
//        
//        [_showDic setObject:@"1" forKey:key];
//    
//    }else{
//    
//    
//        [_showDic removeObjectForKey:key];
//    
//    }
//
//
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:didSection] withRowAnimation:UITableViewRowAnimationNone];
//
//}



#pragma mark 懒加载

-(NSArray *)sectionArray
{

    if (!_sectionArray) {
        
        _sectionArray = [NSArray arrayWithObjects:@"问诊",@"体格检查",@"初诊",@"辅助检查",@"诊断",@"治疗过程",@"讨论与点评", @"展开评论",nil];
        
        
    }

    return _sectionArray;

}


-(NSMutableDictionary *)showDic
{

    if (!_showDic) {
        
        _showDic = [[NSMutableDictionary alloc] init];
    }

    return _showDic;

}



-(NSMutableArray *)selectedArr
{

    if (!_selectedArr) {
        
        _selectedArr = [[NSMutableArray alloc] init];
    }

    return _selectedArr;

}



//-(void)setModel:(ZRTCaseModel *)model
//{
//    _model = model;
//
//    
//    NSLog(@"model %@",model.ZhuShu);
//
//}


-(void)setModel:(ZRTCaseModel *)model
{
    _model = model;

   
  //  NSLog(@"Dmodel %@",model.ZhuShu);

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



#pragma mark - 网络获取评论数据
- (void)getCaseCommentDataWithCaseId:(NSString *)caseid {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] getCaseCommentDataWithCaseId:caseid andPageIndex:@"1" andPageSize:@"1000" andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        [weakSelf dealWithJsonDict:jsonDict];
        
        
        [self.tableView reloadData];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
       
        NSLog(@"获取病例评论数据 error == %@",error);
        
    }];
    
}

- (void)dealWithJsonDict:(NSDictionary *)jsonDict {
    
    
     for (NSDictionary *commentData in jsonDict[@"ds1"]) {
        
        [self.commentDataArray addObject:commentData];
    }
    
    self.commentNumberDict = jsonDict[@"ds"][0];

}


#pragma mark 懒加载

-(NSMutableDictionary *)saveDic
{

    if (!_saveDic) {
        
        _saveDic = [[NSMutableDictionary alloc] init];
    }
    
    return _saveDic;

}



-(void)dealloc
{
    NSLog(@" 病例详情挂了 ");

}


@end
