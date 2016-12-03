//
//  XMPPTool.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "XMPPTool.h"
#import "Config.h"
#import "XMPPRoster.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/XMPPRosterMemoryStorage.h>



@interface XMPPTool ()<XMPPStreamDelegate>      

@property(strong,nonatomic) XMPPRosterCoreDataStorage * rosterStorage;//花名册存储
@property(strong,nonatomic) XMPPRosterMemoryStorage * xmppRosterMemoryStorage;
@property(strong,nonatomic) XMPPRoster * rosterModule;//花名册模块
@property (nonatomic,retain)XMPPStream *myStream;//通道

@end

@implementation XMPPTool


//单例
+(XMPPTool *)sharedXMPPTool
{
    NSLog(@"单例获取XMPPTool");
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
    
    
    // 3.好友模块 支持我们管理、同步、申请、删除好友
    _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
    _rosterModule = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
    [_rosterModule activate:self.myStream];
    
    //同时给_xmppRosterMemoryStorage 和 _xmppRoster都添加了代理
    [_rosterModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
    [_rosterModule setAutoFetchRoster:YES]; //自动同步，从服务器取出好友
    //关掉自动接收好友请求，默认开启自动同意
    [_rosterModule setAutoAcceptKnownPresenceSubscriptionRequests:NO];
    NSLog(@"roster finish")  ;
    
}

/**
 * 同步结束
 **/
//收到好友列表IQ会进入的方法，并且已经存入我的存储器
//- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kXMPP_ROSTER_CHANGE object:nil];
//}
//
//#pragma mark - notification event
//- (void)rosterChange
//{
//    //从存储器中取出我得好友数组，更新数据源
//    self.contacts = [NSMutableArray arrayWithArray:[JKXMPPTool sharedInstance].xmppRosterMemoryStorage.unsortedUsers];
//    [self.tableView reloadData];
//    
//}

//登录或者注册 (void(^)(NSString *))callback;
-(void)loginOrRegiste:(void(^)(NSError *error))callback
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
        callback(error);
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
    UIAlertController * alertController= [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注册成功" preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    [alertController addAction:cancelAction];
    
    [[self getCurrentVC] presentViewController:alertController animated:YES completion:^{
        
    }];
}
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
}

//发送离线信息
-(void)sendOffLineToHost{
    // 1." 发送 "离线" 消息",不设置type的默认是available
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_myStream sendElement:offline];
    // 2. 与服务器断开连接
    [_myStream disconnect];
    NSLog(@"注销成功");
}

-(NSArray *)getFriendList{
    NSArray * array=nil;
    return array;
}

////添加好友
//-(BOOL) addFriend:(NSString*) friendName
//{
//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@%@@%@,friendName,MY_DOMAIN]];
//    [self.rosterModule subscribePresenceToUser:friendJid];
//    return YES;
//}
//
////删除好友
//-(BOOL) deleteFriend:(NSString*) friendName
//{
//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@%@@%@,friendName,MY_DOMAIN]];
//    [self.rosterModule removeUser:friendJid];
//    return  YES;
//    
//}

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
