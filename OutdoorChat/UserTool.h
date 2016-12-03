//
//  LoginTool.h
//  OutdoorChat
//
//  Created by Alfa on 16/12/3.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject


/**
 保存用户名

 @param userName 用户名
 */
+ (void)saveUserName:(NSString *)userName;

/**
 返回用户名

 @return 用户名
 */
+ (NSString *)userName;


/**
 保存密码

 @param password 密码
 */
+ (void)savePassword:(NSString *)password;

/**
 返回密码

 @return 密码
 */
+ (NSString *)password;


/**
 保存用户登录状态

 @param status 登录状态
 */
+ (void)saveLoginStatus:(BOOL)status;

/**
 返回用户状态

 @return 用户状态
 */
+ (BOOL)loginStatus;

/**
 移除本地存储的所有信息
 */
+ (void)removeAll;


@end
