//
//  AppDelegate.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "AppDelegate.h"
#import "UserTool.h"
#import "MainTabBarViewController.h"
#import "Config.h"
#import "XMPPTool.h"


@interface AppDelegate ()



@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    //判断用户的登录状态
    BOOL isLogin = [UserTool loginStatus];

    //WCLog(@"登录状态: %bool",isLogin);
    if (isLogin) {
            XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
            [xmppTool userLogin:^(XMPPResultType type) {
                WCLog(@"根据保存的登录状态重新登录");
            }];
        [self setupMainViewController];
    }else{
        UIViewController *vc = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
        self.window.rootViewController = vc ;
    }
    
    
    [self.window makeKeyAndVisible];

    //打印沙盒路径
    //NSString * path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //NSLog(@"path %@",path);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}









#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Private

- (void)setupMainViewController{
//    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
//    [xmppTool userLogin:^(XMPPResultType type) {
//        WCLog(@"根据保存的登录状态重新登录");
//    }];
    self.window.rootViewController = [[MainTabBarViewController alloc]init];
}

@end
