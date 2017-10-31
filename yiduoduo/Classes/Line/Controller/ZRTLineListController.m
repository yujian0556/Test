//
//  ZRTLineListController.m
//  yiduoduo
//
//  Created by 莫一凡 on 15/7/28.
//  Copyright (c) 2015年 moyifan. All rights reserved.
//

#import "ZRTLineListController.h"
#import "ZRTLineController.h"



#import "UIColor+RCColor.h"

#import "UIImageView+WebCache.h"


@interface ZRTLineListController ()


@property (nonatomic,strong) RCConversationModel *tempModel;

@end

@implementation ZRTLineListController




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
    
    [self setUpNavBar];

    [self refreshConversationTableViewIfNeeded];
    
    
    

    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.conversationListTableView.separatorColor = [UIColor colorWithHexString:@"dfdfdf" alpha:1.0f];
    
    
    
   // NSLog(@"data %@",self.conversationListDataSource);
    
    
}



-(void)setUpNavBar
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"btn_return"] highImage:nil target:self action:@selector(back)];
    
    self.navigationItem.title = @"消息中心";
    
}


- (void)back
{
    
    [self.navigationController popViewControllerAnimated:YES];
}




/**
 *  点击进入会话界面
 *
 *  @param conversationModelType 会话类型
 *  @param model                 会话数据
 *  @param indexPath             indexPath description
 */
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{

   // NSLog(@" %ld  %@  %@  ",model.conversationType,model.targetId,model.conversationTitle);

    
    
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_NORMAL) {
        ZRTLineController *_conversationVC = [[ZRTLineController alloc]init];
        _conversationVC.conversationType = model.conversationType;
        _conversationVC.targetId = model.targetId;
        _conversationVC.userName = model.conversationTitle;
        _conversationVC.title = model.conversationTitle;
      //  _conversationVC.conversation = model;
        
        self.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_conversationVC animated:YES];
    }


}



//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_SYSTEM targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}



////自定义cell
//-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//    
//    
//    NSLog(@"123");
//    
//    __block NSString *userName    = nil;
//    __block NSString *portraitUri = nil;
//    
//    //此处需要添加根据userid来获取用户信息的逻辑，extend字段不存在于DB中，当数据来自db时没有extend字段内容，只有userid
//    if (nil == model.extend) {
//        // Not finished yet, To Be Continue...
//        RCContactNotificationMessage *_contactNotificationMsg = (RCContactNotificationMessage *)model.lastestMessage;
//        NSDictionary *_cache_userinfo = [DEFAULTobjectForKey:_contactNotificationMsg.sourceUserId];
//        if (_cache_userinfo) {
//            userName = _cache_userinfo[@"username"];
//            portraitUri = _cache_userinfo[@"portraitUri"];
//            
//            NSLog(@" %@  %@",userName,portraitUri);
//            
//        }
//        
//    }else{
//        RCDUserInfo *user = (RCDUserInfo *)model.extend;
//        userName    = user.name;
//        portraitUri = user.portraitUri;
//    }
//    
//    RCDChatListCell *cell = [[RCDChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
//    cell.lblDetail.text =[NSString stringWithFormat:@"来自%@的好友请求",userName];
//    [cell.ivAva sd_setImageWithURL:[NSURL URLWithString:portraitUri] placeholderImage:[UIImage imageNamed:@"system_notice"]];
//    return cell;
//}
//
//
//
//
#pragma mark - 收到消息监听
-(void)didReceiveMessageNotification:(NSNotification *)notification
{
    
    
    
    //调用父类刷新未读消息数
    [super didReceiveMessageNotification:notification];
    [self resetConversationListBackgroundViewIfNeeded];
    
    
    //            [self notifyUpdateUnreadMessageCount]; super会调用notifyUpdateUnreadMessageCount
    
   

}


//- (void)updateBadgeValueForTabBarItem
//{
//    __weak typeof(self) __weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        int count = [[RCIMClient sharedRCIMClient]getUnreadCount:self.displayConversationTypeArray];
//        if (count>0) {
//            __weakSelf.tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",count];
//        }else
//        {
//            __weakSelf.tabBarItem.badgeValue = nil;
//        }
//        
//    });
//}

//












@end
