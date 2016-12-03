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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//XMPP数据流
@property (strong, nonatomic) XMPPStream * xmppStream;
@property (strong, nonatomic) NSManagedObjectContext *xmppManagedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *xmppRosterManagedObjectContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setupMainViewController;

@end

