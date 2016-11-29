//
//  XMPPTool.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "XMPPTool.h"
#import "XMPPRoster.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import <XMPPFramework/XMPPFramework.h>

@interface XMPPTool ()<XMPPStreamDelegate>      

@property(strong,nonatomic) XMPPRosterCoreDataStorage * rosterStorage;//花名册存储
@property(strong,nonatomic) XMPPRoster * rosterModule;//花名册模块
@property (nonatomic,retain)XMPPStream *myStream;//通道

@end

@implementation XMPPTool

//单例
+(XMPPTool *)sharedXMPPTool
{
    static XMPPTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[XMPPTool alloc]init];
    });
    return tool;
}

//设置通道连接服务器的方法
-(void)setStreamAndConnSever
{
    _myStream = [[XMPPStream alloc]init];
    
    _myStream.hostName = @"127.0.0.1";
    _myStream.hostPort = 5222;
    //设置代理
    [_myStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

//登录或者注册
-(void)loginOrRegister
{
    if (!_myStream) {
        [self setStreamAndConnSever];
    }
    
    //构建用户Jid
    XMPPJID *jid = [XMPPJID jidWithUser:self.userName domain:@"127.0.0.1" resource:@"iPhone"];
    
    //设置通道属性
    _myStream.myJID = jid;
    
    //判断当前连接状态,已经连了就先断开
    if (_myStream.isConnected) {
        [_myStream disconnect];
    }
    

    //连接服务器
    NSError *error = nil;
     [_myStream connectWithTimeout:5 error:&error];
    if (error) {
        NSLog(@"连接失败");
    }
}

#pragma mark -- xmpp代理
//连接成功的代理方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{

    if (self.loginOrReg == loginTag) {
        //进行登录
        [sender authenticateWithPassword:self.userPwd error:nil];
    }
    else if(self.loginOrReg == registerTag)
    {
        //注册操作
        
        [sender registerWithPassword:self.userPwd error:nil];
        NSLog(@"执行了注册操作");
    }
    else
    {
        NSLog(@"没有赋枚举值，不知道你要干啥");
    }
}

//连接超时
-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    NSLog(@"连接超时");
}

#pragma mark -- 登录的协议方法
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"登录成功");
    //密码进入userDefault
    NSUserDefaults *userDefult = [NSUserDefaults standardUserDefaults];
    [userDefult setObject:self.userName forKey:@"username"];
    [userDefult setObject:self.userPwd forKey:@"password"];
    //设置在线状态
    XMPPPresence * pre = [XMPPPresence presence];
    [self.myStream sendElement:pre];
    
    UIStoryboard *storybard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController = [storybard instantiateViewControllerWithIdentifier:@"mainController"];
    
    //获取当前view,显示用户主页面
    [[self getCurrentVC] presentViewController:viewController animated:YES completion:^{
    }];
}


-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"登录失败");
}




#pragma mark -- 注册的协议方法
-(void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
}

-(void)sendOffLineToHost{
    // 1." 发送 "离线" 消息",不设置type的默认是available
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_myStream sendElement:offline];
    // 2. 与服务器断开连接
    [_myStream disconnect];
    NSLog(@"注销成功");
}



//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
