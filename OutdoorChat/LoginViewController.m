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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) viewWillAppear:(BOOL)animated{
    
    self.userNameTextFiled.text = [UserTool userName];
    self.passwordTextFiled.text = [UserTool password];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self registerObersver];
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
    // Dispose of any resources that can be recreated.
}


#pragma mark - User Interaction

- (IBAction)loginButtonDidClicked:(id)sender {
    
    [self.view endEditing:YES];
    if (!(self.userNameTextFiled.text.length && self.passwordTextFiled.text.length)) {
        [UIAlertController showSimpleAlertControllerWithTitle:@"请输入完整信息" message:nil parentViewController:self];
    }
    
    //登录接口
    XMPPTool *tool =[XMPPTool sharedXMPPTool];
    tool.userName = self.userNameTextFiled.text;
    tool.userPwd = self.passwordTextFiled.text;
    tool.operatingType = UserOperatingTypeLogin;
    [tool loginOrRegister];
}

//点击空白处收回键盘
- (void)keyboardHide:(id)sender{
    
    [self.view endEditing:YES];
}

#pragma mark - Private

- (void)registerObersver{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:UserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailure) name:UserLoginFailureNotification object:nil];
}

- (void)loginSuccess{
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [delegate setupMainViewController];
    [UserTool savePassword:self.passwordTextFiled.text];
    [UserTool saveUserName:self.userNameTextFiled.text];
    [UserTool saveLoginStatus:YES];
}

- (void)loginFailure{
    
    [UIAlertController showSimpleAlertControllerWithTitle:@"登录失败" message:nil parentViewController:self];
}

@end
