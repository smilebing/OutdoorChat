//
//  XMPPTool.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "Config.h"
#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/XMPPRoster.h>
#import <XMPPFramework/XMPPMessageArchivingCoreDataStorage.h>
#import <XMPPFramework/XMPPRosterCoreDataStorage.h>

#import <XMPPFramework/XMPPRosterMemoryStorage.h>
#import <XMPPFramework/XMPPIncomingFileTransfer.h>
#import <XMPPFramework/XMPPAutoPing.h>
#import <XMPPFramework/XMPPReconnect.h>

#ifndef XMPPTool_h
#define XMPPTool_h
#endif /* XMPPTool_h */


typedef NS_ENUM(NSInteger,UserOperatingType){
    
    UserOperatingTypeLogin = 0,
    UserOperatingTypeRegister,
    UserOperatingTypeLogout
};

UIKIT_EXTERN NSString *const UserLoginSuccessNotification; //登录成功的通知
UIKIT_EXTERN NSString *const UserLoginFailureNotification; //登录失败
UIKIT_EXTERN NSString *const UserRegisterSuccessNotification; //注册的通知
UIKIT_EXTERN NSString *const UserRegisterFailureNotificatiion; //注册失败
UIKIT_EXTERN NSString *const UserLogoutNotification; //注销的通知
UIKIT_EXTERN NSString *const UserConnectTimeout; //连接超时

@interface XMPPTool : NSObject <XMPPStreamDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPIncomingFileTransferDelegate>
@property (nonatomic,retain)NSString *  userName;//用户名
@property (nonatomic,retain)NSString *  userPwd;//密码
@property (nonatomic,assign)UserOperatingType operatingType;//判断是登录还是注册


@property(nonatomic,retain)XMPPStream *xmppStream;//通道
@property (nonatomic, strong) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;
@property (nonatomic, strong) XMPPPresence *receivePresence;


//单例
+(XMPPTool*)sharedXMPPTool;
//登录注册方法
-(void)loginOrRegister;
//注销登录
-(void)sendOffLineToHost;

-(NSArray *)getFriendList;

//登录
-(void)userLogin;
//注册
-(void)userRegister;
//添加好友
-(void)addFriend:(XMPPJID *) friendJID;
//退出登录
-(void)logout;

@end
