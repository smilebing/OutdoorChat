////
////  XMPPData.h
////  OutdoorChat
////
////  Created by 朱贺 on 2016/12/1.
////  Copyright © 2016年 朱贺. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <XMPPFramework/XMPPFramework.h>
//#import <XMPPFramework/XMPPRosterCoreDataStorage.h>
//#import <XMPPFramework/XMPPMessage.h>
//
//#ifndef XMPPData_h
//#define XMPPData_h
//
//
//#endif /* XMPPData_h */
//
//@interface XMPPData:NSObject
//@property(strong,nonatomic) XMPPStream *xmppStream;
//@property(assign,nonatomic) BOOL isRegister;
//@property(strong,nonatomic) NSString*user,*pwd,*hostName,*domain;
//@property(assign,nonatomic) UInt16 port;
//@property(strong,nonatomic) XMPPRosterCoreDataStorage * rosterStorage;//花名册存储
//@property(strong,nonatomic) XMPPRoster * rosterModule;//花名册模块
//@property(strong,nonatomic) XMPPMessageArchivingCoreDataStorage *msgStorage;//消息存储
//@property(strong,nonatomic) XMPPMessageArchiving * msgModule;//消息模块
//@property(strong,nonatomic) NSFetchedResultsController *fetFriend;//查询好友的Fetch
//@property(strong,nonatomic) NSFetchedResultsController *fetMsgRecord;//查询消息的Fetch
//@end
//
//typedef enum {//发送消息类型的枚举
//    
//    text,
//    
//    image,
//    
//    audio
//    
//} MsgType;
