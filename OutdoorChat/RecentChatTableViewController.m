//
//  RecentChatTableViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/29.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "RecentChatTableViewController.h"
#import "XMPPTool.h"
@interface RecentChatTableViewController ()

@end

@implementation RecentChatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //监听登录状态通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStatusChange) name:XMPPLoginStatusChangeNotification object:nil];
    
   }


-(void)loginStatusChange:(NSNotification *)noti{
    
   
    
}




@end
