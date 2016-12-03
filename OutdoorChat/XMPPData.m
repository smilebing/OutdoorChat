////
////  XMPPData.m
////  OutdoorChat
////
////  Created by 朱贺 on 2016/12/1.
////  Copyright © 2016年 朱贺. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <XMPPFramework/XMPPMessageArchivingCoreDataStorage.h>
//
//
//
//#import "XMPPData.h"
//
//
//
//@implementation XMPPData
//
////开始连接聊天服务器
//-(BOOL) connectWithUserName:(NSString*) username andPwd:(NSString*) pwd andHostName:(NSString*) hostname andDomain:(NSString*) domain andHostPort:(UInt16) port andIsRegister:(BOOL) isRegister
//{
//    self.hostName = hostname;
//    self.port = port;
//    self.domain = domain;
//    self.user = username;
//    self.pwd = pwd;
//    self.isRegister = isRegister;
//    self.xmppStream = [[XMPPStream alloc] init];
//    //设置代理
//    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
//    //设置聊天服务器地址
//    self.xmppStream .hostName = hostname;
//    //设置聊天服务器端口 默认是5222
//    self.xmppStream.hostPort = port;
//    //设置Jid 就是用户名
//    XMPPJID *jid = [XMPPJID jidWithUser:username domain:domain resource:@"test"];
//    self.xmppStream.myJID = jid;
//    NSError * error = nil;
//    //验证连接
//    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
//    if (error) {
//        NSLog(@"连接失败：%@",error);
//        return NO;
//    }
//    else
//    {
//        //注册所有的模块
//        [self activeModules];
//        return  YES;
//    }
//}
//
////激活相关的模块
//-(void) activeModules
//{
//    //1.花名册存储对象
//    self.rosterStorage = [XMPPRosterCoreDataStorage sharedInstance];
//    //2.花名册模块
//    self.rosterModule = [[XMPPRoster alloc] initWithRosterStorage:self.rosterStorage];
//    //3.激活此模块
//    [self.rosterModule activate:self.xmppStream];
//    //4.添加roster代理
//    [self.rosterModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//    //1.消息存储对象
//    self.msgStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
//    self.msgModule = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:self.msgStorage];
//    [self.msgModule activate:self.xmppStream];
//    [self.msgModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
//    
//}
//
////下线
//-(void) logout
//{
//    //1.用户下线
//    NSLog(@"注销用户");
//    XMPPPresence *presene=[XMPPPresence presenceWithType:@unavailable];
//    //设置下线状态
//    [_xmppStream sendElement:presene];
//    //2.断开连接
//    [_xmppStream disconnect];
//    
//}
//
//
////添加好友
//-(BOOL) addFriend:(NSString*) friendName
//{
//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendName,self.domain]];
//    [self.rosterModule subscribePresenceToUser:friendJid];
//    return YES;
//}
//
////删除好友
//-(BOOL) deleteFriend:(NSString*) friendName
//{
//    XMPPJID * friendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",friendName,self.domain]];
//    [self.rosterModule removeUser:friendJid];
//    return  YES;
//    
//}
//
////获取好友列表
//-(NSArray*) getFriends
//{
//    NSManagedObjectContext *context = self.rosterStorage.mainThreadManagedObjectContext;
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@XMPPUserCoreDataStorageObject];
//    
//    //筛选本用户的好友
//    NSString *userinfo = [NSString stringWithFormat:@"%@@%@",self.user,self.domain];
//    
//    NSLog(@"userinfo = %@",userinfo);
//    NSPredicate *predicate =
//    [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ ",userinfo];
//    request.predicate = predicate;
//    
//    //排序
//    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@displayName ascending:YES];
//    request.sortDescriptors = @[sort];
//    
//    self.fetFriend = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    self.fetFriend.delegate = self;
//    NSError *error;
//    [self.fetFriend performFetch:&error];
////    
//    //返回的数组是XMPPUserCoreDataStorageObject  *obj类型的
//    //名称为 obj.displayName
//    NSLog(@%lu,(unsigned long)self.fetFriend.fetchedObjects.count);
//    return  self.fetFriend.fetchedObjects;
//}
//
////数据库有变化
////-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
////{
////    NSManagedObject *obj = anObject;
////    if([obj isKindOfClass:[XMPPMessageArchiving_Message_CoreDataObject class]])
////    {
////        NSLog(@聊天的信息的数据库发生变化);
////    }
////    else
////        NSLog(@数据库有变化);
////}
//
////与某个好友聊天
////-(BOOL) talkToFriend:(NSString*)friendsName andMsg:(NSString*) msg  andMsgType:(MsgType) msgT
////{
////    XMPPJID *toFriend = [XMPPJID jidWithUser:friendsName domain:self.domain resource:@A];//resource 随意，目前不影响
////    XMPPMessage * message = [[XMPPMessage alloc] initWithType:@chat to:toFriend];//chat类型是正常的聊天类型
////    [message addBody:msg];
////    [message addAttributeWithName:@msgType intValue:msgT];
////    [self.xmppStream sendElement:message];
////    return YES;
////}
//
////获得与某个好友的聊天记录
//-(NSArray*) getRecords:(NSString*) friendsName
//{
//    
//    //所有账号 和所有人的聊天记录都在同一个数据库内  所以 要写查询条件
//    NSManagedObjectContext *context = self.msgStorage.mainThreadManagedObjectContext;
//    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@XMPPMessageArchiving_Message_CoreDataObject];
//    NSString *userinfo = [NSString stringWithFormat:@%@@%@,self.user,self.domain];
//    NSString *friendinfo = [NSString stringWithFormat:@%@@%@,friendsName,self.domain];
//    NSPredicate *predicate =
//    [NSPredicate predicateWithFormat:@ streamBareJidStr = %@ and bareJidStr = %@,userinfo,friendinfo];
//    request.predicate = predicate;
//    
//    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@timestamp ascending:YES];
//    request.sortDescriptors = @[sort];
//    self.fetMsgRecord = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
//    self.fetMsgRecord.delegate = self;
//    NSError *error;
//    [self.fetMsgRecord performFetch:&error];
//    //   返回的值类型 XMPPMessageArchiving_Message_CoreDataObject
//    return self.fetMsgRecord.fetchedObjects;
//}
//
//
//
//
//
//
//
//
//
//
////连接成功的代理函数
//-(void)xmppStreamDidConnect:(XMPPStream *)sender
//{
//    NSLog(@连接成功);
//    if (self.isRegister) {
//        NSError* error = nil;
//        [sender registerWithPassword:self.pwd error:&error];
//        if (error) {
//            NSLog(@"注册失败1，%@",error);
//        }
//    }
//    else
//    {
//        NSError *error = nil;
//        [sender authenticateWithPassword:self.pwd error:&error];
//        if (error) {
//            NSLog(@"验证失败，%@",error);
//        }
//    }
//}
////连接失败代理函数
//-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
//{
//    NSLog(@"连接失败，%@",error);
//}
//
////验证成功代理函数
//-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
//{
//    NSLog(@"验证成功");
//    //4.登陆成功后 在线
//    [self.xmppStream sendElement:[XMPPPresence presence]];//用户在线
//}
////验证失败代理函数
//-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
//{
//    NSLog(@"验证失败,%@",error);
//}
//
////注册成功代理函数
//-(void)xmppStreamDidRegister:(XMPPStream *)sender
//{
//    NSLog(@"注册成功");
//}
//
////注册失败代理函数
//-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
//{
//    NSLog(@"注册失败,%@",error);
//}
//
////收到好友请求 代理函数
//-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
//{
//    NSString * presenceType = [presence type];
//    NSLog(@presenceType = %@,presenceType);
//    XMPPJID * fromJid = presence.from;
//    if ([presenceType isEqualToString:@subscribe]) {//是订阅请求  直接通过
//        [self.rosterModule acceptPresenceSubscriptionRequestFrom:fromJid andAddToRoster:YES];
//    }
//}
//
//-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item
//{
//    NSString *subscription = [item attributeStringValueForName:@subscription];
//    NSLog(@%@,subscription);
//    if ([subscription isEqualToString:@both]) {
//        NSLog(@"双方成为好友");
//    }
//}
