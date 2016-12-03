//
//  RegisterViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/28.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "RegisterViewController.h"
#import <XMPPFramework/XMPPFramework.h>
#import "XMPPTool.h"

@interface RegisterViewController ()<XMPPStreamDelegate>

//@property (nonatomic, strong) XMPPStream *stream;

@end

@implementation RegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"register view lodad");

   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Delegate

- (void)xmppStreamDidSecure:(XMPPStream *)sender{
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBacktoLogin:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (IBAction)RegisterAction:(UIButton *)sender {
    //单例模式的xmpp连接类
    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
    //开始注册
    NSLog(@"按下了注册按键");
    NSString * userName=@"null";
    NSString * pwd=@"null";
    
    userName=[_userNameTextField text];
    pwd=[_firstPwdTextField text];
    NSLog(@"register name:%@ pwd:%@",userName,pwd);
    [xmppTool setUserName:userName];
    [xmppTool setUserPwd:pwd];
    [xmppTool setLoginOrReg:registerTag];
    [xmppTool loginOrRegiste:^(NSError *error) {
        if (error) {
            
        }
    }];
    
    //注册成功后提示，清空
    //注册失败后提示
}



@end
