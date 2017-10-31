//
//  ZRTAddDoctorViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/7/6.
//  Copyright © 2015年 moyifan. All rights reserved.
//

#import "ZRTAddDoctorViewController.h"

#import "ZRTDoctorPatientView.h"
#import "Helper.h"
#import "ZRTHealthyListTableViewCell.h"
#import "ZRTHealthyModel.h"

#import "MBProgressHUD+MJ.h"

@interface ZRTAddDoctorViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ZRTAddDoctorViewController
{
    NSMutableDictionary *_openRecordDict;
    NSMutableDictionary *_cellGroup;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpArrayAndDictionary];
    
    [self setNavigationBar];
    
    [self setUpDoctorView];
    
}



#pragma mark - 初始化数组等
- (void)setUpArrayAndDictionary {
    _openRecordDict = [[NSMutableDictionary alloc] init];
    _cellGroup = [[NSMutableDictionary alloc] init];
    self.dataSource = [[NSMutableArray alloc] init];
    
    [self.dataSource addObjectsFromArray:self.myHealthyData];
}

#pragma mark - 设置界面

- (void)setUpDoctorView {
    
    self.view.backgroundColor = KGrayColor;
    
    ZRTDoctorPatientView *dpV = [[ZRTDoctorPatientView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 106)];
    dpV.backgroundColor = [UIColor whiteColor];
    
    dpV.isDoctor = self.isDoctor;
    
    
    __weak typeof(self) weakSelf = self;
    __block ZRTDoctorPatientView *weakDPV = dpV;
    
    if (self.isDoctor) {
        [self.concernArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            ZRTDoctorModel *model = (ZRTDoctorModel *)obj;
            
            //已关注医生的id 和 当前id 相同,按钮显示为已关注
            dpV.addButton.selected = [_dmodel.Id isEqualToString:model.Id];
            
        }];
    }
    else {
        
        [self.concernArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            ZRTPatientModel *model = (ZRTPatientModel *)obj;
            
            dpV.addButton.selected = [_pmodel.Id isEqualToString:model.Id];
            
        }];
    }
    
    
    
    //添加关注block，写入网络请求
    dpV.block = ^{
        
        //关注按钮未选中状态进行  关注 网络请求
        if (!weakDPV.addButton.isSelected) {
            
            weakDPV.addButton.selected = !weakDPV.addButton.isSelected;
            
            if (self.isDoctor) {
                [[OZHNetWork sharedNetworkTools] addConcernWithUserId:[DEFAULT objectForKey:@"RongyunDict"][@"UserId"] andObject:self.dmodel.Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
                    
                    [weakSelf judgeWithState:jsonDict[@"Success"]];
                    
                } andFailure:^(OZHNetWork *manager, NSError *error) {
                    NSLog(@"添加医生关注error == %@",error);
                }];
            }
            else {
                [[OZHNetWork sharedNetworkTools] addConcernWithUserId:[DEFAULT objectForKey:@"RongyunDict"][@"UserId"] andObject:self.pmodel.Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
                    
                    [weakSelf judgeWithState:jsonDict[@"Success"]];
                    
                } andFailure:^(OZHNetWork *manager, NSError *error) {
                    NSLog(@"添加病人关注error == %@",error);
                }];
            }
            
        }
        
//        if (self.isDoctor) {
//            [[OZHNetWork sharedNetworkTools] addConcernWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"RongyunDict"][@"UserId"] andObject:self.dmodel.Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
//                
//                [weakSelf judgeWithState:jsonDict[@"Success"]];
//                
//            } andFailure:^(OZHNetWork *manager, NSError *error) {
//                NSLog(@"添加医生关注error == %@",error);
//            }];
//        }
//        else {
//            [[OZHNetWork sharedNetworkTools] addConcernWithUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"RongyunDict"][@"UserId"] andObject:self.pmodel.Id andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
//                
//                [weakSelf judgeWithState:jsonDict[@"Success"]];
//                
//            } andFailure:^(OZHNetWork *manager, NSError *error) {
//                NSLog(@"添加病人关注error == %@",error);
//            }];
//        }
        
        //修改按钮
        
    };
    
    if (self.isDoctor) {
        [self.view addSubview:[dpV createAddDoctorViewWithModel:self.dmodel]];
    }
    else {
        [self.view addSubview:[dpV createAddDoctorViewWithModel:self.pmodel]];
    }
    
    
    if (self.isDoctorOrNot) {
        [self setUpHealthyListViewWithFrame:dpV.frame];
    }
    
}

- (void)judgeWithState:(NSString *)state {
    
    if ([state isEqualToString:@"1"]) {
        UIAlertController *success = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注成功" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [success addAction:cancle];
        
        [self presentViewController:success animated:YES completion:nil];
    }
    else {
        UIAlertController *failure = [UIAlertController alertControllerWithTitle:@"提示" message:@"关注失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [failure addAction:cancle];
        
        [self presentViewController:failure animated:YES completion:nil];
    }

    
}


- (void)setUpHealthyListViewWithFrame:(CGRect)rect {
//整个健康档案列表部分是一个View
    UIView *healthyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rect) + 15, KScreenWidth, KScreenHeight - CGRectGetMaxY(rect) - 15 - 58)];
    healthyView.backgroundColor = [UIColor whiteColor];
    
    //190,231,223
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 23, KScreenWidth - 20 * 2, 40)];
    titleLabel.text = @"我的健康档案列表";
    titleLabel.font = [UIFont systemFontOfSize:18];
    [titleLabel setBackgroundColor:KHealthyColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
#define Knumber -7
    
    UITableView *listTB = [[UITableView alloc] initWithFrame:CGRectMake(- Knumber, CGRectGetMaxY(titleLabel.frame) + 24, KScreenWidth  Knumber, KScreenHeight - 106 - 15 - 23 - 40 - 24 - 58 - 64) style:UITableViewStylePlain];
    listTB.delegate = self;
    listTB.dataSource = self;
    listTB.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [listTB registerClass:[ZRTHealthyListTableViewCell class] forCellReuseIdentifier:@"healthyListCell"];
    
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    listTB.tableFooterView = clearView;

    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(listTB.frame),KScreenWidth - 15*2, 1)];
    lineView.backgroundColor = KGrayColor;
    
    
    
    UIButton *allSelectBtn = [Helper createButton:CGRectMake(19,CGRectGetMaxY(lineView.frame) + 13, 46, 25) title:nil image:[UIImage imageNamed:@"全选_03"] target:self selector:@selector(allSelect)];
    
    UIButton *cancleAllSelectBtn = [Helper createButton:CGRectMake(CGRectGetMaxX(allSelectBtn.frame) + 16, CGRectGetMinY(allSelectBtn.frame), 74, 25) title:nil image:[UIImage imageNamed:@"取消全选_03"] target:self selector:@selector(cancleAllSelect)];
    
    //228,57
    UIButton *showToDoctorBtn = [Helper createButton:CGRectMake(KScreenWidth - 19 - 114, CGRectGetMinY(allSelectBtn.frame), 228 /2, 57 /2) title:nil image:[UIImage imageNamed:@"公开_03"] target:self selector:@selector(showToDoctor)];
    
    
    
    [healthyView addSubview:titleLabel];
    [healthyView addSubview:listTB];
    [healthyView addSubview:lineView];
    
    [healthyView addSubview:allSelectBtn];
    [healthyView addSubview:cancleAllSelectBtn];
    [healthyView addSubview:showToDoctorBtn];
    
    [self.view addSubview:healthyView];
}

- (void)allSelect {

    [[_cellGroup allValues] enumerateObjectsUsingBlock:^(ZRTHealthyListTableViewCell *cell, NSUInteger idx, BOOL *stop) {
        cell.selectBtn.selected = YES;
    }];
    
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [_openRecordDict setObject:self.dataSource[idx] forKey:[NSString stringWithFormat:@"%ld",(unsigned long)idx]];
    }];
    
    

}

- (void)cancleAllSelect {

    
    [[_cellGroup allValues] enumerateObjectsUsingBlock:^(ZRTHealthyListTableViewCell *cell, NSUInteger idx, BOOL *stop) {
        cell.selectBtn.selected = NO;
    }];
    
    [_openRecordDict removeAllObjects];
}

- (void)showToDoctor {
    
    //展示给医生网络请求
    
    NSMutableArray *list = [NSMutableArray arrayWithArray:[_openRecordDict allValues]];
    
    NSMutableString *listString = [[NSMutableString alloc] init];
    
    [list enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
       
        if (idx != list.count - 1) {
            [listString appendFormat:@"%@,",obj];
        }
        else {
            [listString appendString:obj];
        }
        
    }];
    
    NSLog(@"%@",listString);
    
    [self showToDoctorNetworkingWithHealthyList:listString];
    
}

#pragma mark - 导航条
- (void)setNavigationBar {
    
    if (self.isDoctor) {
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTHealthyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"healthyListCell"];
    
    
    for (UIView *obj in cell.contentView.subviews) {
        [obj removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    [cell fillCellWithModel:self.dataSource[indexPath.row] AndCount:indexPath.row];
    
    NSArray *keysArray = [_openRecordDict allKeys];
    for (NSString *keyName in keysArray) {
        
        if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:keyName]) {
            
            cell.selectBtn.selected = YES;
            
        }
        
    }
    
    [_cellGroup setObject:cell forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ZRTHealthyListTableViewCell *cell = [_cellGroup objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    
    cell.selectBtn.selected = !cell.selectBtn.isSelected;
    
    if (cell.selectBtn.isSelected) {
        
        ZRTHealthyModel *model = self.dataSource[indexPath.row];
        
        [_openRecordDict setObject:model.ID forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    else {
        [_openRecordDict removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    
}

- (void)showToDoctorNetworkingWithHealthyList:(NSString *)list {
    
    __weak typeof(self) weakSelf = self;
    
    [[OZHNetWork sharedNetworkTools] showToDoctorWithUserId:[DEFAULT objectForKey:@"UserDict"][@"Id"] andDoctorID:_dmodel.Id andHealthyDataList:list andSuccess:^(OZHNetWork *manager, NSDictionary *jsonDict) {
        
        if ([jsonDict[@"Success"] isEqualToString:@"1"]) {
            [weakSelf showSuccess];
        }
        
    } andFailure:^(OZHNetWork *manager, NSError *error) {
        
        NSLog(@"展示给医生 error == %@",error);
        
    }];

}

- (void)showSuccess {
    
    
    [MBProgressHUD showSuccess:@"公开成功~"];
    
    [self.navigationController popViewControllerAnimated:NO];
    
    
    if ([self.delegate respondsToSelector:@selector(backToMyDocOrPati)]) {
        [self.delegate backToMyDocOrPati];
    }
}

- (void)showFailure {
    [MBProgressHUD showError:@"公开失败~"];
}

@end

