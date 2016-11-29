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


typedef enum
{
    loginTag = 0,
    registerTag,
    zhuxiao
}myTags;

@interface XMPPTool : NSObject
@property (nonatomic,retain)NSString *  userName;//用户名
@property (nonatomic,retain)NSString *  userPwd;//密码
@property (nonatomic,assign)myTags loginOrReg;//判断是登录还是注册
@property LoginViewController * loginView;
//单例
+(XMPPTool*)sharedXMPPTool;
//登录注册方法
-(void)loginOrRegister;
//注销登录
-(void)sendOffLineToHost;
@end
