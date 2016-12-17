//
//  AddFriendTableViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/17.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "Config.h"
#import "XMPPTool.h"
#import "UserTool.h"

@interface AddFriendTableViewController ()<UITextFieldDelegate>

@end

@implementation AddFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //添加好友
    //1.获取好友账号
    NSString * user=textField.text;
    //WCLog(@"%@",user);
    
    
    //2.发送添加好友请求
    
    NSString * jidStr=[NSString stringWithFormat:@"%@@%@",user,XMPP_DOMAIN];
    XMPPJID * friendJid=[XMPPJID jidWithString:jidStr];

    //判断添加自己
    if([user isEqualToString:[UserTool userName]])
    {
        [self showAlert:@"不能添加自己"];
    }
    
    //判断好友是否已经添加
     else if([[XMPPTool sharedXMPPTool].xmppRosterCoreDataStorage userExistsWithJID:friendJid xmppStream:[XMPPTool sharedXMPPTool].xmppStream])
    {
        [self showAlert:@"好友已经存在"];
    }
     else
     {
    [[XMPPTool  sharedXMPPTool ].xmppRoster subscribePresenceToUser:friendJid];
         [self showAlert:@"请求发送成功"];
     }
    
    
    return YES;
}

-(void)showAlert:(NSString *)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

@end
