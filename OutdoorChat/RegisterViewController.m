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
#import "UIAlertController+Convenience.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@end

@implementation RegisterViewController


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"register view lodad");
    [self registerOberserver];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)keyboardHide:(id)sender{
    
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)registerButtonDidClicked:(id)sender {
    
    XMPPTool * tool =[XMPPTool sharedXMPPTool];
    
    tool.userName = self.userNameTextField.text;
    tool.userPwd = self.passwordTextField.text;
    tool.operatingType = UserOperatingTypeRegister;
    
    [tool loginOrRegister];
    
}

- (IBAction)dismissButtonDidClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Private

- (void)registerOberserver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailure) name:UserRegisterFailureNotificatiion object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess) name:UserRegisterSuccessNotification object:nil];
}

- (void)registerSuccess{
    
    [UIAlertController showSimpleAlertControllerWithTitle:@"注册成功" message:nil parentViewController:self];
    
}

- (void)registerFailure{
    
     [UIAlertController showSimpleAlertControllerWithTitle:@"注册失败" message:nil parentViewController:self];
}




@end
