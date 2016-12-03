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

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface LoginViewController ()


@end




@implementation LoginViewController

-(void) viewWillAppear:(BOOL)animated{
    userNameTextFiled.text=[[NSUserDefaults standardUserDefaults]stringForKey:kXMPPmyJID];
    passwordTextFiled.text=[[NSUserDefaults standardUserDefaults]stringForKey:kXMPPmyPassword];
    
    passwordTextFiled.delegate=self;
    userNameTextFiled.delegate=self;
}

- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

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

//点击空白处收回键盘
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [userNameTextFiled resignFirstResponder];
    [passwordTextFiled resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/








- (IBAction)LoginAction:(UIButton *)sender {
    NSLog(@"按下了登陆");
    [self setField:userNameTextFiled forKey:kXMPPmyJID];
    [self setField:passwordTextFiled forKey:kXMPPmyPassword];
    
        NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
    
        NSString *userName = [userDefult objectForKey:@"username"];
        NSString *password = [userDefult objectForKey:@"password"];
    
    NSLog(@"登陆name:%@ pwd:%@",userName,password);
    
    XMPPTool * xmppTool =[XMPPTool sharedXMPPTool];
    [xmppTool setUserPwd:password];
    [xmppTool setUserName:userName];
    [xmppTool setLoginOrReg:loginTag];
    [xmppTool loginOrRegister];
    
    //[self dismissViewControllerAnimated:YES completion:NULL];
}

@synthesize userNameTextFiled;
@synthesize passwordTextFiled;

@end
