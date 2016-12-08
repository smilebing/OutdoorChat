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




- (void)viewDidLoad {
    [super viewDidLoad];

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


//注册事件
- (IBAction)registerButtonDidClicked:(id)sender {
    
    XMPPTool * tool =[XMPPTool sharedXMPPTool];
    tool.userName = self.userNameTextField.text;
    tool.userPwd = self.passwordTextField.text;
    tool.operatingType = UserOperatingTypeRegister;
    //查看注册的结果
    [tool userRegister:^(XMPPResultType type) {
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                NSLog(@"result register success");
                [self registerSuccess];
                break;
            
            case XMPPResultTypeRegisterFail:
                NSLog(@"result register fail");
                [self registerFailure];
                break;
            case XMPPResultTypeNetWorkError:
                NSLog(@"网络超时");
                [self networkError];
            default:
                break;
        }
    }  ];
    
}

//返回
- (IBAction)dismissButtonDidClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark 注册结果
//注册成功
- (void)registerSuccess{
    [UIAlertController showSimpleAlertControllerWithTitle:@"注册成功" message:nil parentViewController:self];
}

//注册失败
- (void)registerFailure{
    //NSLog(@"注册失败 %@",error);
    [UIAlertController showSimpleAlertControllerWithTitle:@"注册失败" message:@"用户已经存在" parentViewController:self];
}

//网路超时
-(void)networkError{
    [UIAlertController showSimpleAlertControllerWithTitle:@"登录失败" message:@"网络不稳定" parentViewController:self];
}



@end
