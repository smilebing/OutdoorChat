//
//  AppDelegate.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPRoster.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
- (void)setupMainViewController;

@end

