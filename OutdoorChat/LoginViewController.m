//
//  LoginViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/28.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "Config.h"
#import "XMPPTool.h"

@interface LoginViewController ()

@end




@implementation LoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   // xmppTool=[XMPPTool sharedXMPPTool];
//    [self initXmpp];
    
    
    // 如果已登录就直接填充密码登陆
//    NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
//    
//    NSString *userName = [userDefult objectForKey:@"username"];
//    NSString *password = [userDefult objectForKey:@"password"];
//    NSLog(@"%@,%@",userName,password);
//    if (userName != nil && password != nil && ![userName isEqualToString:@""] && ![password isEqualToString:@""])
//    {
//        self.userNameTextFiled.text = userName;
//        self.passwordTextFiled.text = password;
//        [self xmppConnect];
//    }
//    
//    self.userNameTextFiled.delegate = self;
//    self.passwordTextFiled.delegate = self;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)showRegisterView:(UIButton *)sender {
   
    UIStoryboard *storybard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UIViewController *viewController = [storybard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    
    [self presentViewController:viewController animated:YES completion:^{}];
     }






- (IBAction)tapButton:(id)sender {
}







- (IBAction)LoginAction:(UIButton *)sender {
    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
    [xmppTool setLoginOrReg:loginTag];
    [xmppTool setUserName:@"iphone"];
    [xmppTool setUserPwd:@"iphone"];
    [xmppTool loginOrRegister];
}

@end
