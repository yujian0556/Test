//
//  ZRTSystemSetsViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/7/1.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSystemSetsViewController.h"

#import "ZRTChangePassWordTableViewCell.h"

#import "ZRTChangePasswordViewController.h"
#import "ZRTLoginViewController.h"

static NSString *systemCellReuserIdentifiy = @"systemCell";

@interface ZRTSystemSetsViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *quitBtn;

@end

@implementation ZRTSystemSetsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.quitBtn.hidden = ![[DEFAULT valueForKey:@"isLogin"] boolValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KGrayColor;
    
    
    [self createTableView];
    
    [self createButton];
    
    [self setNavgationBar];
    

}

#pragma mark - TableView
- (void)createTableView {
    
    UITableView *systemTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44 + 10) style:UITableViewStyleGrouped];
    
    systemTB.delegate = self;
    systemTB.dataSource = self;
    
    systemTB.scrollEnabled = NO;
    
    systemTB.backgroundColor = KGrayColor;
    
    [systemTB registerNib:[UINib nibWithNibName:@"ZRTChangePassWordTableViewCell" bundle:nil] forCellReuseIdentifier:systemCellReuserIdentifiy];
    
    [self.view addSubview:systemTB];
    
    
    
    UIView *version = [[UIView alloc] initWithFrame:CGRectMake(0, 54, KScreenWidth, 44)];
    
    version.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:version];
    
    
    UILabel *versionLabel = [[UILabel alloc] init];
    
    [version addSubview:versionLabel];
    
    versionLabel.text = @"版本号";
    versionLabel.font = [UIFont systemFontOfSize:17];
    versionLabel.textColor = [UIColor blackColor];
    
    [versionLabel sizeToFit];
    
    versionLabel.x = 35;
    versionLabel.y = (version.height - versionLabel.height)/2;
    
    
    
    UILabel *versionCount = [[UILabel alloc] init];
    
    [version addSubview:versionCount];


    versionCount.text = @"1.3";
    versionCount.font = [UIFont systemFontOfSize:17];
    versionCount.textColor = [UIColor blackColor];
    
    [versionCount sizeToFit];
    
    versionCount.x = 300 - versionCount.width;
    versionCount.y = versionLabel.y;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTChangePassWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:systemCellReuserIdentifiy];
    
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue]) {
        ZRTChangePasswordViewController *cpVC = [[ZRTChangePasswordViewController alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:cpVC animated:YES];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"当前未登录,是否跳转登录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            //跳转登录界面
            ZRTLoginViewController *loginVC = [[ZRTLoginViewController alloc] init];
            
            self.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
    }

    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
#pragma mark - Button
- (void)createButton {
    
    
    //退出按钮
    self.quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.quitBtn.frame = CGRectMake((KScreenWidth - 300) / 2, KScreenHeight - 64 - 60, 300, 41);
    
    [self.quitBtn setBackgroundImage:[UIImage imageNamed:@"ok"] forState:UIControlStateNormal];
    [self.quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    //点击方法
    [self.quitBtn addTarget:self action:@selector(userQuite) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.quitBtn];
    
    if ([[DEFAULT objectForKey:@"isLogin"] boolValue] == YES) {
        self.quitBtn.hidden = NO;
    }
    else {
        self.quitBtn.hidden = YES;
    }
}

- (void)userQuite {
    
   // 退出前将用户信息的字典清空
    
    [DEFAULT setObject:nil forKey:@"UserDict"];

    
    [DEFAULT setObject:[NSNumber numberWithBool:NO] forKey:@"isLogin"];
    
    [DEFAULT synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserIsLogined" object:nil];
    
    self.quitBtn.hidden = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 导航控制器
/**
 *  左右两侧的navgationbar
 */
-(void)setNavgationBar
{
    self.title = @"系统设置";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];

}

/**
 *  导航栏左右按钮
 */
-(void)didClickLeft
{
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
