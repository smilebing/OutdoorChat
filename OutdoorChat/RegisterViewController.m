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

@interface RegisterViewController ()

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (IBAction)RegisterAction:(UIButton *)sender {
    //单例模式的xmpp连接类
    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
    //开始注册
    NSLog(@"register button down");
    [xmppTool setUserName:@"test"];
    [xmppTool setUserPwd:@"tt"];
    [xmppTool setLoginOrReg:registerTag];
    [xmppTool loginOrRegister];
}


@end
