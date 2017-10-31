//
//  ZRTSubjectViewController.m
//  yiduoduo
//
//  Created by Olivier on 15/6/17.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTSubjectViewController.h"
#import "ZRTSubjectModel.h"
#import "ZRTSubjectTableViewCell.h"

static NSString *subjectCellReuseIdentifiy = @"subjuectCell";

@interface ZRTSubjectViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *subjectTV;

@end

@implementation ZRTSubjectViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createFakeData];
    
    [self createTableView];
}
#pragma mark - 假数据
- (void)createFakeData {
    
    for (NSInteger i = 0; i <= 5; i++) {
        ZRTSubjectModel *model = [[ZRTSubjectModel alloc] init];
        
        if (i == 0) {
            model.imageURLString = @"http://img46.nipic.com/20130627/2531170_073140324000_1.jpg";
            model.titleString = @"神经病专题";
            model.introduceString = @"神经病专题神经病专题神经病专题神经病专题";
        }
        else if (i == 2 || i == 4) {
            model.imageURLString = @"http://files.colabug.com/forum/201504/08/174344dcc4nswsixx7m7mp.jpg";
            model.titleString = @"心脏病专题";
            model.introduceString = @"心脏病专题心脏病专题心脏病专题心脏病专题心脏病专题心脏病专题心脏病专题心脏病专题";
        }
        else {
            model.imageURLString = @"http://image.tupian114.com/20120303/17055249.jpg.thumb.jpg";
            model.titleString = @"亚健康专题";
            model.introduceString = @"亚健康专题亚健康专题";
        }
        
        
        [self.dataSource addObject:model];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView

- (void)createTableView {
    
    self.subjectTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    
    self.subjectTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.subjectTV.delegate = self;
    self.subjectTV.dataSource = self;
    
    [self.subjectTV registerClass:[ZRTSubjectTableViewCell class] forCellReuseIdentifier:subjectCellReuseIdentifiy];
    
    [self.view addSubview:self.subjectTV];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZRTSubjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:subjectCellReuseIdentifiy];
    
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat cellHeight = [cell fillCellWithModel:self.dataSource[indexPath.row]];
    
    tableView.rowHeight = cellHeight;
    
    //NSLog(@"-->%.2f",cellHeight);
    
    return cell;
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
