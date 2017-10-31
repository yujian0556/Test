//
//  ZRTLineController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/15.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTLineController.h"


@interface ZRTLineController ()<RCPluginBoardViewDelegate>

@property (nonatomic,strong) NSString *strCopy;

@end

@implementation ZRTLineController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self setUpNavBar];
    
    [self setUpPluginBoardView];
    
    // 不显示用户昵称
    self.displayUserNameInCell = NO;

    // 允许用户保存新照片到系统
    self.enableSaveNewPhotoToLocalSystem = YES;
    

}



-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = self.userName;
    
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark 功能板代理方法

-(void)setUpPluginBoardView
{
    
    self.pluginBoardView.pluginBoardDelegate = self;

    [self.pluginBoardView removeItemAtIndex:2];
    [self.pluginBoardView removeItemAtIndex:2];
    
    

}


// 点击头像
- (void)didTapCellPortrait:(NSString *)userId
{

    NSLog(@"%@",userId);

}

// 点击消息内容
- (void)didTapMessageCell:(RCMessageModel *)model
{

    
    if (model.content.class == [RCImageMessage class]) {
        
        [self presentImagePreviewController:model];
        
    }
    

}


// 点击消息中的链接
- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model
{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    

}




// 长按消息内容
- (void)didLongTouchMessageCell:(RCMessageModel *)model inView:(UIView *)view
{

    
    RCTextMessage *text = (RCTextMessage *)model.content;
    
    self.strCopy = text.content;
    
    UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyView)];
    
    
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
    
    [[UIMenuController sharedMenuController] setTargetRect:view.frame inView:view];
    
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated: YES];

}



// 点击消息中的电话号码
- (void)didTapPhoneNumberInMessageCell:(NSString *)phoneNumber model:(RCMessageModel *)model
{

    
}



-(void)copyView
{

    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    
    pboard.string = self.strCopy;


}


@end
