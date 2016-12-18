//
//  ChatViewController.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/17.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPJID.h>

@interface ChatViewController : UIViewController
@property (nonatomic ,strong) XMPPJID * friendJid;
@end
