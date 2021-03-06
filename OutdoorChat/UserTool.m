//
//  LoginTool.m
//  OutdoorChat
//
//  Created by Alfa on 16/12/3.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "UserTool.h"
#include "Config.h"
static NSString * const kUserNameKey = @"kUserNameKey";
static NSString * const kUserPasswordKey = @"kUserPasswordKey";
static NSString * const kUserLoginStatusKey = @"kUserLoginStatusKey";
static NSString * const kUserJidKey=@"kUserJidKey";

@implementation UserTool

#pragma mark - Public Interface

+(void)saveJid:(NSString *)jid
{
    [self saveObjectValue:jid forKey:kUserJidKey];
}

+(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",[self userName],XMPP_DOMAIN];
}

+ (void)saveUserName:(NSString *)userName{
    
    [self saveObjectValue:userName forKey:kUserNameKey];
}

+ (NSString *)userName{
    
    return [self objectValueForKey:kUserNameKey];
}

+ (void)savePassword:(NSString *)password{
    
    [self saveObjectValue:password forKey:kUserPasswordKey];
}

+ (NSString *)password{
    
    return [self objectValueForKey:kUserPasswordKey];
}

+ (void)saveLoginStatus:(BOOL)status{
    
    [self saveBoolValue:status forKey:kUserLoginStatusKey];
}

+ (BOOL)loginStatus{
    
    return [self boolValueForKey:kUserLoginStatusKey];
}

+(void)removePwd{
    [self saveBoolValue:NO forKey:kUserLoginStatusKey];

    [self saveObjectValue:@"" forKey:kUserPasswordKey];
}

+ (void)removeAll{
    
    [self saveBoolValue:NO forKey:kUserLoginStatusKey];
    [self saveObjectValue:@"" forKey:kUserNameKey];
    [self saveObjectValue:@"" forKey:kUserPasswordKey];
}

//+(void)saveUserInfoToSanbox{
//    NSUserDefaults * defaults=[NSUserDefaults standardUserDefaults];
//    [defaults setObject: forKey:<#(nonnull NSString *)#>]
//}


#pragma mark - Private

+ (void)saveObjectValue:(id)value forKey:(NSString *)key{
    
    NSUserDefaults *accout = [NSUserDefaults standardUserDefaults];
    [accout removeObjectForKey:key];
    [accout setObject:value forKey:key];
    [accout synchronize];
}

+ (void)saveBoolValue:(BOOL)value forKey:(NSString *)key{
    NSUserDefaults *accout = [NSUserDefaults standardUserDefaults];
    [accout removeObjectForKey:key];
    [accout setBool:value forKey:key];
    [accout synchronize];
}

+ (id)objectValueForKey: (NSString *)key{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)boolValueForKey: (NSString *)key{
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
