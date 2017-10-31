//
//  ZRTCaseTableViewCell.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/4/29.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTHomeCaseTableViewCell.h"
#import "ZRTCaseCell.h"


static NSString *caseCellReuseIdentifier = @"CaseCell";

@interface ZRTHomeCaseTableViewCell () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *CaseTableView;

@end

@implementation ZRTHomeCaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //设置代理，注册Cell
    self.CaseTableView.delegate = self;
    self.CaseTableView.dataSource = self;
    
    self.CaseTableView.separatorStyle = NO;
    self.CaseTableView.showsVerticalScrollIndicator = NO;
    
    [self.CaseTableView registerNib:[UINib nibWithNibName:@"ZRTCaseCell" bundle:nil] forCellReuseIdentifier:caseCellReuseIdentifier];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 传递数组
 */
- (void)PassDataArray:(NSArray *)array
{
    
    self.CaseDataArray = array;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CaseDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZRTCaseCell *caseCell = [tableView dequeueReusableCellWithIdentifier:caseCellReuseIdentifier];
    
    [caseCell fillCellWithModel:self.CaseDataArray[indexPath.row]];
    
    return caseCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.jumpBlock(self.CaseDataArray[indexPath.row]);
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
@end
