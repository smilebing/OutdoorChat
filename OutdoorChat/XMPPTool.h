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

//好友列表
#import <XMPPFramework/XMPPRoster.h>
#import <XMPPFramework/XMPPRosterCoreDataStorage.h>
#import <XMPPFramework/XMPPRosterMemoryStorage.h>

#import <XMPPFramework/XMPPMessageArchivingCoreDataStorage.h>

#import <XMPPFramework/XMPPIncomingFileTransfer.h>
#import <XMPPFramework/XMPPAutoPing.h>
#import <XMPPFramework/XMPPReconnect.h>
//电子名片头
#import <XMPPFramework/XMPPvCardTempModule.h>
#import <XMPPFramework/XMPPvCardCoreDataStorage.h>
//头像
#import <XMPPFramework/XMPPvCardAvatarModule.h>

typedef  enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFail,//登录失败
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFail,//注册失败
    XMPPResultTypeNetWorkError//网路异常
}XMPPResultType;


typedef void  (^XMPPResultBlock)(XMPPResultType  type ); //xmpp请求结果的block

typedef NS_ENUM(NSInteger,UserOperatingType){
    
    UserOperatingTypeLogin = 0,
    UserOperatingTypeRegister,
    UserOperatingTypeLogout
};



@interface XMPPTool : NSObject <XMPPStreamDelegate,XMPPRosterDelegate,XMPPRosterMemoryStorageDelegate,XMPPIncomingFileTransferDelegate>

@property (nonatomic,assign)UserOperatingType operatingType;//判断是登录还是注册

@property(nonatomic,retain)XMPPStream *xmppStream;//通道

@property (nonatomic, strong) XMPPReconnect *xmppReconnect; //自动连接模块

//花名册
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterMemoryStorage *xmppRosterMemoryStorage;

@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchiving;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;
@property (nonatomic, strong) XMPPPresence *receivePresence;

@property XMPPvCardTempModule *vCard;//电子名片
@property XMPPvCardCoreDataStorage *vCardStorage;//电子名片的数据存储
@property XMPPvCardAvatarModule * avatar ;//头像模块
//单例
+(XMPPTool*)sharedXMPPTool;

//登录
-(void)userLogin:(XMPPResultBlock)resultBlock;
//注册
-(void)userRegister:(XMPPResultBlock)resultBlock;

//退出登录
-(void)logout;

@end
