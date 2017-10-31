//
//  ZRTSearchDoctorViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSearchDoctorViewController.h"

#import "ZRTSearchDoctorTableViewCell.h"

#import "ZRTAddDoctorViewController.h"

#import "OZHAlertView.h"

#import "ZRTDoctorModel.h"
#import "ZRTPatientModel.h"

@interface ZRTSearchDoctorViewController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,OZHAlertViewAction,ZRTAddDoctorViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UITableView *searchResultTableView;

@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ZRTSearchDoctorViewController
{
    NSDictionary *_dict;
    OZHAlertView *_alert;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpTableViewAndTextField];
    
    [self setNavigationBar];
    
    self.dataSource = [[NSMutableArray alloc] init];
}

- (void)setUpTableViewAndTextField {
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    self.searchResultTableView.tableFooterView = clearView;
    
    [self.searchResultTableView registerNib:[UINib nibWithNibName:@"ZRTSearchDoctorTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchCell"];
    
    self.inputTextField.delegate = self;
}

#pragma mark - 导航条
- (void)setNavigationBar {
    
    if (self.isAddDoctor) {
       self.title = @"添加医生";
    }
    else {
        self.title = @"添加患者";
    }
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(didClickLeft)];
}

- (void)didClickLeft {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 开始搜索
 */
- (IBAction)startSearch:(id)sender {
    
    NSLog(@"搜索");
    
    [self.inputView resignFirstResponder];
    
    if ([self.inputTextField.text isEqualToString:@""]) {
        
        UIAlertController *noContentAlert = [UIAlertController alertControllerWithTitle:@"" message:@"请输入搜索内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [noContentAlert addAction:cancle];
        
        [self presentViewController:noContentAlert animated:YES completion:nil];
    }
    
    else {
        
        [self.dataSource removeAllObjects];
        
        [self searchData:self.inputTextField.text];
    }
    
    
}

- (void)makeAlertView {
    NSLog(@"搜索结果为空，弹出提示框");
    //搜索结果 为空的时候  调用
    _alert = [[OZHAlertView alloc] init];
    _dict = [_alert alertViewWithTitle:@"用户不存在" AndButtonTitle:@"确定" AndTarget:self];
    
    _alert.delegate = self;
    
    [self.view addSubview:_dict[@"alert"]];
    [self.view addSubview:_dict[@"iv"]];
    
    [self.inputTextField resignFirstResponder];
}

- (void)dismissView {
    
    [_alert sure];
}

#pragma mark - TableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZRTSearchDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    if (self.isAddDoctor) {
        
        ZRTDoctorModel *model = self.dataSource[indexPath.row];
        cell.doctorNameLabel.text = model.RealName;
        cell.doctorAddressLabel.text =[NSString stringWithFormat:@"%@%@",model.Province,model.City];

    }
    
    else {
        
        ZRTPatientModel *model = self.dataSource[indexPath.row];
        cell.doctorNameLabel.text = model.NickName;
        cell.doctorAddressLabel.text =[NSString stringWithFormat:@"%@%@",model.Province,model.City];
    }
 
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZRTAddDoctorViewController *addDoctorVC = [[ZRTAddDoctorViewController alloc] init];
    
    addDoctorVC.isDoctor = self.isAddDoctor;
    if (self.isAddDoctor) { 
        addDoctorVC.dmodel = self.dataSource[indexPath.row];
    }
    else {
        addDoctorVC.pmodel = self.dataSource[indexPath.row];
    }
    
    addDoctorVC.concernArray = self.getDoctorInfo;
    addDoctorVC.myHealthyData = self.myHealthyData;
    
    
    addDoctorVC.delegate = self;
    
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:addDoctorVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - 
- (void)searchData:(NSString *)search {
    
    NSString *type;
    if (self.isAddDoctor) {
        type = @"2";
        NSLog(@"搜索医生");
    }
    else {
        type = @"1";
        NSLog(@"搜索患者");
    }
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] searchDoctorPatientWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andDocOrPat:type andSearchText:self.inputTextField.text andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        
        
        [weakSelf dealModelWithJsonDict:jsonDict];
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        NSLog(@"搜索 error == %@",error);
    }];

}

- (void)dealModelWithJsonDict:(NSDictionary *)dict {
    
    if (self.isAddDoctor) {
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTDoctorModel *dmodel = [ZRTDoctorModel DoctorWithDic:dic];
            
            [self.dataSource addObject:dmodel];
        }
    }
    else {
        
        for (NSDictionary *dic in dict[@"ds"]) {
            
            ZRTPatientModel *pmodel = [ZRTPatientModel PatientWithDic:dic];
            
            [self.dataSource addObject:pmodel];
        }
    }
    
    
    if (self.dataSource.count == 0) {
        
        //未搜索到用户，就调用方法提示
        [self makeAlertView];
    }
    
    [self.searchResultTableView reloadData];
    
   
}

#pragma mark - 代理方法

-(void)backToMyDocOrPati {
    
    
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
