//
//  ZRTReportViewController.m
//  yiduoduo
//
//  Created by olivier on 15/8/6.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTReportViewController.h"

#import "ZRTReportTableViewCell.h"

#import "MBProgressHUD+MJ.h"

#import "Helper.h"

#import "ZRTProvisionViewController.h"

@interface ZRTReportViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *cellArray;
@property (nonatomic,strong) NSString *reasonString;

@end

@implementation ZRTReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setDataSourceArray];
    
    [self setNavgationBar];
    
    [self setUI];
    

}

- (void)setDataSourceArray {
    self.dataSource = [[NSMutableArray alloc] init];
    
    NSArray *reasonArray = @[@"色情低俗",@"广告骚扰",@"诱导分享",@"谣言",@"政治敏感",@"违法（暴力恐怖、违禁品等）",@"其他（收集隐私信息）"];
    
    [self.dataSource addObjectsFromArray:reasonArray];
    
    self.cellArray = [[NSMutableArray alloc] init];
    
}

#pragma mark - 导航控制器
/**
 *  左右NavigationBar
 */
-(void)setNavgationBar
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(didClickRight)];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
//    
//    self.title = @"请选择一个举报原因";
    
}

//返回
- (void)didClickLeft {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//发送
- (void)didClickRight {
    
    NSInteger count = 0;
    
    for (ZRTReportTableViewCell *cell in self.cellArray) {
        
        if (cell.isSelected) {
            count++;
        }
    }
    
    if (count) {
        [self sendReport];
    }
    else {
        [MBProgressHUD showError:@"请选择一个举报原因"];
    }
}

#pragma mark - 处理UI
- (void)setUI {
    
    self.view.backgroundColor = KGrayColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth, 17)];
    title.text = @"请选择一个举报原因";
    title.font = [UIFont systemFontOfSize:17];
    [title setTextColor:[UIColor darkGrayColor]];
    
    
    UITableView *reasonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, KScreenWidth, 44 * 7) style:UITableViewStylePlain];
    
    reasonTableView.delegate = self;
    reasonTableView.dataSource = self;
    
    reasonTableView.scrollEnabled = NO;
    
    [reasonTableView registerNib:[UINib nibWithNibName:@"ZRTReportTableViewCell" bundle:nil] forCellReuseIdentifier:@"reasonCell"];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    reasonTableView.tableFooterView = clearView;
    
    UIButton *showProvision = [UIButton buttonWithType:UIButtonTypeCustom];
    showProvision.frame = CGRectMake(KScreenWidth/2 - 35, KScreenHeight - 69 - 50, 70, 20);
    [showProvision setTitle:@"举报须知" forState:UIControlStateNormal];
    [showProvision addTarget:self action:@selector(showProvisionToUser) forControlEvents:UIControlEventTouchUpInside];
    showProvision.titleLabel.font = [UIFont systemFontOfSize:17];
    [showProvision setTitleColor:KMainColor forState:UIControlStateNormal];
    
    [self.view addSubview:showProvision];
    [self.view addSubview:title];
    [self.view addSubview:reasonTableView];
    
}

- (void)showProvisionToUser {
    
    //NSLog(@"弹出举报须知");
    
    ZRTProvisionViewController *pVC = [[ZRTProvisionViewController alloc] init];
    
    pVC.isReport = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:pVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - UITableViewDateSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reasonCell"];
    
    [self.cellArray addObject:cell];
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reasonLabel.text = self.dataSource[indexPath.row];
    cell.checkImageView.hidden = YES;
    cell.isSelected = NO;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.cellArray enumerateObjectsUsingBlock:^(ZRTReportTableViewCell *obj, NSUInteger idx, BOOL *stop) {
       
        obj.checkImageView.hidden = YES;
        obj.isSelected = NO;
        
        if (idx == indexPath.row) {
            
            obj.checkImageView.hidden = NO;
            obj.isSelected = YES;
            
        }
        
        [self.cellArray removeObjectAtIndex:idx];
        [self.cellArray insertObject:obj atIndex:idx];
    }];
    
    
    ZRTReportTableViewCell *cell = self.cellArray[indexPath.row];
    self.reasonString = cell.reasonLabel.text;
    
}

#pragma mark - 网络请求，发送举报信息
- (void)sendReport {

    NSString *userId;
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        userId = [DEFAULT objectForKey:@"UserDict"][@"Id"];
    }
    else {
        userId = @"0";
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] sendReportWithConsultationId:self.consultationID andUserId:userId andReason:self.reasonString andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        //NSLog(@"%@",jsonDict);
        
        [weakSelf showSuccess];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"发送举报信息 error == %@",error);
        
    }];
    
    [self performSelector:@selector(dismissView) withObject:nil afterDelay:0.3];
    
}

- (void)showSuccess {
    
    [MBProgressHUD showSuccess:@"举报成功"];
    
}

- (void)dismissView {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
