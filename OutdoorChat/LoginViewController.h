//
//  LoginViewController.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/28.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XMPPFramework/XMPPFramework.h>
@interface LoginViewController : UIViewController<XMPPStreamDelegate,UITextFieldDelegate>
@end
