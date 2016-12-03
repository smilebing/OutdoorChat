//
//  UIAlertController+Convenience.m
//  ZHTC
//
//  Created by USER on 15/2/3.
//  Copyright (c) 2015年 SJCJ. All rights reserved.
//

#import "UIAlertController+Convenience.h"

@implementation UIAlertController (Convenience)

#pragma mark - Alert
+ (void)showSimpleAlertControllerWithTitle:(NSString *)title
                                   message:(NSString *)message
                      parentViewController:(UIViewController *)viewController
{
    [self showSimpleAlertControllerWithTitle:title message:message parentViewController:viewController BlockOk:nil BlockCancel:nil];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
//    
//    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    [alertCtrl addAction:action];
//    
//    [viewController presentViewController:alertCtrl animated:YES completion:nil];
}

+ (void)showSimpleAlertControllerWithTitle:(NSString *)title
                                   message:(NSString *)message
                      parentViewController:(UIViewController *)viewController
                                   BlockOk:(void (^)())ok
                               BlockCancel:(void (^)())cancel
{
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (ok) {
            ok();
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancel) {
            cancel();
        }
    }];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:cancelAction];
    [alertCtrl addAction:okAction];
    
    [viewController presentViewController:alertCtrl animated:YES completion:nil];
}


#pragma mark - ActionSheet
+ (void)showSimpleActionSheetWithFirstTitle:(NSString *)firstTitle
                                secondTitle:(NSString *)secondTitle
                                cancelTitle:(NSString *)cancelTitle
                       parentViewController:(UIViewController *)viewController
                                 firstBlock:(void (^)())fristBlock
                               secondeBlock:(void (^)())secondBlock
{
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (fristBlock) {
            fristBlock();
        }
    }];
    
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:secondTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (secondBlock) {
            secondBlock();
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCtrl addAction:firstAction];
    [alertCtrl addAction:secondAction];
    [alertCtrl addAction:cancelAction];
    
    [viewController presentViewController:alertCtrl animated:YES completion:nil];
}

+ (void)showSimpleActionSheetWithFirstTitle:(NSString *)firstTitle
                                cancelTitle:(NSString *)cancelTitle
                       parentViewController:(UIViewController *)viewController
                                 firstBlock:(void (^)())fristBlock
{
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:firstTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (fristBlock) {
            fristBlock();
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCtrl addAction:firstAction];
    [alertCtrl addAction:cancelAction];
    
    [viewController presentViewController:alertCtrl animated:YES completion:nil];
}

@end
