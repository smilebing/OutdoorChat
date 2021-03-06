//
//  LoginViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/28.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "LoginViewController.h"
#import "UIAlertController+Convenience.h"
#import "RegisterViewController.h"
#import "Config.h"
#import "XMPPTool.h"
#import "UserTool.h"
#import "AppDelegate.h"

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextFiled;
@end

@implementation LoginViewController


-(void) viewWillAppear:(BOOL)animated{
    
    //self.userNameTextFiled.text = [UserTool userName];
    //self.passwordTextFiled.text = [UserTool password];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    //从沙盒中读取用户名
    self.userNameTextFiled.text=[UserTool userName];

    
//    NSString * user=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
//    self.userNameTextFiled.text=user;
}

#pragma mark - Layout

- (void)setupUI{
    
    self.headView.layer.cornerRadius = 30;
    self.headView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.loginButton.layer.cornerRadius = 5;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - User Interaction

- (IBAction)loginButtonDidClicked:(id)sender {
    
   
    
    [self.view endEditing:YES];
    if (!(self.userNameTextFiled.text.length && self.passwordTextFiled.text.length)) {
        [UIAlertController showSimpleAlertControllerWithTitle:@"请输入完整信息" message:nil parentViewController:self];
    }
    
    
    //将用户名密码存放到沙盒
    NSString * user =self.userNameTextFiled.text;
    NSString * pwd =self.passwordTextFiled.text;
    
    [UserTool saveUserName:user];
    [UserTool savePassword:pwd];

    
    //登录接口
    XMPPTool *tool =[XMPPTool sharedXMPPTool];
    //tool.userName = self.userNameTextFiled.text;
    //tool.userPwd = self.passwordTextFiled.text;
    tool.operatingType = UserOperatingTypeLogin;
    
    
    __weak typeof (self) selfVc=self;
    //登录之前提示
    
    [tool userLogin:^(XMPPResultType type) {
        [selfVc handleResultType:type];
            }];
    
}

//处理结果
-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                //登录成功
                NSLog(@"result login success");
                [self loginSuccess];
                break;
            case XMPPResultTypeLoginFail:
                //登录失败
                NSLog(@"result login fail");
                [self loginFailure];
                break;
            case XMPPResultTypeNetWorkError:
                NSLog(@"网路超时");
                [self networkError];
            default:
                break;
        }

    });
}

//点击空白处收回键盘
- (void)keyboardHide:(id)sender{
    [self.view endEditing:YES];
}

//登录成功，显示主界面
- (void)loginSuccess{
    //保存用户登录成功数据
    [UserTool saveLoginStatus:YES];
    //隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];

    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    [delegate setupMainViewController];
//    [UserTool savePassword:self.passwordTextFiled.text];
//    [UserTool saveUserName:self.userNameTextFiled.text];
//    [UserTool saveLoginStatus:YES];
}

//登录失败，提示错误信息
- (void)loginFailure{
    //NSLog(@"这是登录错误内容 %@",error);
    [UIAlertController showSimpleAlertControllerWithTitle:@"登录失败" message:@"请检查用户名或者密码" parentViewController:self];
}

//网路超时
-(void)networkError{
     [UIAlertController showSimpleAlertControllerWithTitle:@"登录失败" message:@"网络不稳定" parentViewController:self];
}

-(void)dealloc{
    //NSLog(@"dealloc");
}
@end
