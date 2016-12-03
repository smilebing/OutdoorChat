//
//  XMPPTool.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "LoginViewController.h"
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

@interface XMPPTool : NSObject
@property (nonatomic,retain)NSString *  userName;//用户名
@property (nonatomic,retain)NSString *  userPwd;//密码
@property (nonatomic,assign)UserOperatingType operatingType;//判断是登录还是注册
@property LoginViewController * loginView;
//单例
+(XMPPTool*)sharedXMPPTool;
//登录注册方法
-(void)loginOrRegister;
//注销登录
-(void)sendOffLineToHost;

-(NSArray *)getFriendList;
@end
