//
//  XMPPTool.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "XMPPTool.h"
#import "UserTool.h"



NSString *const UserLoginSuccessNotification = @"UserLoginSuccessNotification";
NSString *const UserLoginFailureNotification = @"UserLoginFailureNotification";
NSString *const UserRegisterSuccessNotification = @"UserRegisterSuccessNotification";
NSString *const UserRegisterFailureNotificatiion = @"UserRegisterFailureNotificatiion";
NSString *const UserLogoutNotification = @"UserLogoutNotification";
NSString *const UserConnectTimeout = @"UserConnectTimeout";

@interface XMPPTool ()     
    @property XMPPResultBlock resultBlock;

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

- (XMPPStream *)xmppStream
{
    if (!_xmppStream) {
        _xmppStream = [[XMPPStream alloc] init];
        
        //socket 连接的时候 要知道host port 然后connect
        [self.xmppStream setHostName:XMPP_HOST];
        [self.xmppStream setHostPort:XMPP_PORT];
        //为什么是addDelegate? 因为xmppFramework 大量使用了多播代理multicast-delegate ,代理一般是1对1的，但是这个多播代理是一对多得，而且可以在任意时候添加或者删除
        [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        
        
        
        // 3.好友模块 支持我们管理、同步、申请、删除好友
        _xmppRosterMemoryStorage = [[XMPPRosterMemoryStorage alloc] init];
        _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_xmppRosterMemoryStorage];
        [_xmppRoster activate:self.xmppStream];
        
        //同时给_xmppRosterMemoryStorage 和 _xmppRoster都添加了代理
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
        //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
        [_xmppRoster setAutoFetchRoster:YES]; //自动同步，从服务器取出好友
        //关掉自动接收好友请求，默认开启自动同意
        [_xmppRoster setAutoAcceptKnownPresenceSubscriptionRequests:NO];
        
        //4.消息模块，这里用单例，不能切换账号登录，否则会出现数据问题。
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage dispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 9)];
        [_xmppMessageArchiving activate:self.xmppStream];
        
        //5、文件接收
        _xmppIncomingFileTransfer = [[XMPPIncomingFileTransfer alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
        [_xmppIncomingFileTransfer activate:self.xmppStream];
        [_xmppIncomingFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_xmppIncomingFileTransfer setAutoAcceptFileTransfers:YES];
    }
    return _xmppStream;
}


//登录
- (void)userLogin:(XMPPResultBlock)resultBlock
{
    //先把block存起来
    self.resultBlock=resultBlock;
    
    // 1.建立TCP连接
    // 2.把我自己的jid与这个TCP连接绑定起来
    // 3.认证（登录：验证jid与密码是否正确，加密方式 不可能以明文发送）--（出席：怎样告诉服务器我上线，以及我得上线状态
    //这句话会在xmppStream以后发送XML的时候加上 <message from="JID">
    WCLog(@"userLogin");
    [self xmppStream];
    //构建用户Jid
    XMPPJID *jid = [XMPPJID jidWithUser:[UserTool userName] domain:XMPP_DOMAIN resource:XMPP_RESOURCE];
    self.xmppStream.myJID=jid;
    
    //判断连接状态
    if(self.xmppStream.isConnected)
    {
        [self.xmppStream disconnect];
    }
    [self.xmppStream connectWithTimeout:4.0 error:nil];
}


//注册方法
- (void)userRegister:(XMPPResultBlock)resultBlock
{
    //先把block存起来
    self.resultBlock=resultBlock;
    
    [self xmppStream];

    //构建用户Jid
    XMPPJID *jid = [XMPPJID jidWithUser:self.userName domain:XMPP_DOMAIN resource:XMPP_RESOURCE];
    self.xmppStream.myJID=jid;
    //判断连接状态
    if(self.xmppStream.isConnected)
    {
        [self.xmppStream disconnect];
    }
    
    [self.xmppStream connectWithTimeout:4.0 error:nil];
}

//添加好友
- (void)addFriend:(XMPPJID *)aJID
{
    //这里的nickname是我对它的备注，并非他得个人资料中得nickname
    [self.xmppRoster addUser:aJID withNickname:@"好友"];
}

//发送在线信息给服务器
- (void)goOnline
{
    // 发送一个<presence/> 默认值avaliable 在线 是指服务器收到空的presence 会认为是这个
    // status ---自定义的内容，可以是任何的。
    // show 是固定的，有几种类型 dnd、xa、away、chat，在方法XMPPPresence 的intShow中可以看到
    XMPPPresence *presence = [XMPPPresence presence];
    [presence addChild:[DDXMLNode elementWithName:@"status" stringValue:@"我现在很忙"]];
    [presence addChild:[DDXMLNode elementWithName:@"show" stringValue:@"xa"]];
    
    [self.xmppStream sendElement:presence];
}

/**
 *  退出登录
 */
- (void)logout
{
    // 1." 发送 "离线" 消息",不设置type的默认是available
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [self.xmppStream disconnect];
    [self.xmppStream removeDelegate:self];
    self.xmppReconnect.autoReconnect = NO;
    [self.xmppReconnect deactivate];
    [self.xmppAutoPing deactivate];
    [self.xmppRoster deactivate];
    [self.xmppMessageArchiving deactivate];
    [self.xmppIncomingFileTransfer deactivate];
    self.xmppStream = nil;
    WCLog(@"注销成功");
}

#pragma mark ===== XMPPStream delegate =======
//socket 连接建立成功
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    WCLog(@"%s",__func__);
}

//连接服务器成功
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
        if (self.operatingType == UserOperatingTypeLogin) {
            //进行登录
            [sender authenticateWithPassword:[UserTool password] error:nil];
            WCLog(@"执行了登录操作");
        }
        else if(self.operatingType == UserOperatingTypeRegister)
        {
            //注册操作
            [sender registerWithPassword:[UserTool password] error:nil];
            WCLog(@"执行了注册操作");
        }
        else
        {
            WCLog(@"没有赋枚举值，不知道你要干啥");
        }
}

#pragma mark 与主机断开连接
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    //如果有错误，代表连接失败
    //如果没有错误，表示正常的断开连接
    if(error &&_resultBlock)
    {
        _resultBlock(XMPPResultTypeNetWorkError);
    }
    WCLog(@"与服务器断开连接%@",error);
}

//登录失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    //判断block有无值，再回调给控制器
    if(self.resultBlock){
        self.resultBlock(XMPPResultTypeLoginFail);
    }
    WCLog(@"登录失败 %@",error);
}

//登录成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    //发送上线信息
    [self goOnline];
    //判断block有无值，再回调给控制器
    if(self.resultBlock){
        self.resultBlock(XMPPResultTypeLoginSuccess);
    }
    WCLog(@"登录成功");
}

// 注册新用户成功时的回调
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    //判断block有无值，再回调给控制器
    if(self.resultBlock){
        self.resultBlock(XMPPResultTypeRegisterSuccess);
    }
    WCLog(@"注册新用户成功");
}

// 注册新用户失败时的回调
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    //判断block有无值，再回调给控制器
    if(self.resultBlock){
        self.resultBlock(XMPPResultTypeRegisterFail);
    }
    WCLog(@"注册新用户失败");
}




#pragma mark ===== 好友模块 委托=======
/** 收到出席订阅请求（代表对方想添加自己为好友) */
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //添加好友一定会订阅对方，但是接受订阅不一定要添加对方为好友
    self.receivePresence = presence;
    
    NSString *message = [NSString stringWithFormat:@"【%@】想加你为好友",presence.from.bare];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    [alertView show];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //收到对方取消定阅我得消息
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        //从我的本地通讯录中将他移除
        [self.xmppRoster removeUser:presence.from];
    }
}



/**
 * 开始同步服务器发送过来的自己的好友列表
 **/
- (void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender
{
    WCLog(@"xmppRosterDidBeginPopulating");
}

/**
 * 同步结束
 **/
//收到好友列表IQ会进入的方法，并且已经存入我的存储器
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    WCLog(@"xmppRosterDidEndPopulating");
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_ROSTER_CHANGE object:nil];
}



//收到每一个好友
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    //WCLog(@"didReceiveRosterItem \n%@",item);
}

// 如果不是初始化同步来的roster,那么会自动存入我的好友存储器
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
    WCLog(@"xmppRosterDidChange");
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_ROSTER_CHANGE object:nil];
}

#pragma mark ===== 文件接收=======
/** 是否同意对方发文件给我 */
- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didReceiveSIOffer:(XMPPIQ *)offer
{
    WCLog(@"%s",__FUNCTION__);
    //弹出一个是否接收的询问框
    //    [self.xmppIncomingFileTransfer acceptSIOffer:offer];
}

//- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender didSucceedWithData:(NSData *)data named:(NSString *)name
//{
//    XMPPJID * jid=[sender ]
//    //XMPPJID *jid = [sender.senderJID copy];
//    WCLog(@"%s",__FUNCTION__);
//    //在这个方法里面，我们通过带外来传输的文件
//    //因此我们的消息同步器，不会帮我们自动生成Message,因此我们需要手动存储message
//    //根据文件后缀名，判断文件我们是否能够处理，如果不能处理则直接显示。
//    //图片 音频 （.wav,.mp3,.mp4)
//    NSString *extension = [name pathExtension];
//    if (![@"wav" isEqualToString:extension]) {
//        return;
//    }
//    //创建一个XMPPMessage对象,message必须要有from
//    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:jid];
//    //将这个文件的发送者添加到Message的from
//    [message addAttributeWithName:@"from" stringValue:sender.senderJID.bare];
//    [message addSubject:@"audio"];
//    
//    //保存data
//    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    path = [path stringByAppendingPathComponent:[XMPPStream generateUUID]];
//    path = [path stringByAppendingPathExtension:@"wav"];
//    [data writeToFile:path atomically:YES];
//    
//    [message addBody:path.lastPathComponent];
//    
//    [self.xmppMessageArchivingCoreDataStorage archiveMessage:message outgoing:NO xmppStream:self.xmppStream];
//}

#pragma mark - Message
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    WCLog(@"收到信息");
    WCLog(@"%s--%@",__FUNCTION__, message);
    //XEP--0136 已经用coreData实现了数据的接收和保存
    
}

//获取好友列表的回调
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    WCLog(@"获取好友列表的回调");
    //WCLog(@"好友列表iq:%@",iq);
    // 以下两个判断其实只需要有一个就够了
    NSString *elementID = iq.elementID;
    if (![elementID isEqualToString:@"getMyRooms"]) {
        return YES;
    }
    
    NSArray *results = [iq elementsForXmlns:@"http://jabber.org/protocol/disco#items"];
    if (results.count < 1) {
        return YES;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (DDXMLElement *element in iq.children) {
        if ([element.name isEqualToString:@"query"]) {
            for (DDXMLElement *item in element.children) {
                if ([item.name isEqualToString:@"item"]) {
                    [array addObject:item];          //array  就是你的群列表
                }
            }
        }
    }
    
    //发送通知，FriendListView接受
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_GET_GROUPS_NOTIFICATION object:array];
    [[NSNotificationCenter defaultCenter] postNotificationName:XMPP_ROSTER_CHANGE object:array];

    return YES;
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        WCLog(@"0000");
        [self.xmppRoster rejectPresenceSubscriptionRequestFrom:_receivePresence.from];
    } else {
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:_receivePresence.from andAddToRoster:YES];
    }
}




@end
