//
//  UIAlertController+Convenience.h
//  ZHTC
//
//  Created by USER on 15/2/3.
//  Copyright (c) 2015年 SJCJ. All rights reserved.
//  快速生成方法

#import <UIKit/UIKit.h>

@interface UIAlertController (Convenience)

/**
 *  快捷创建一个 alertController（alertView）提示窗
 *
 *  @param title          标题
 *  @param message        详细信息描述
 *  @param viewController alertController 父控制器
 */
+ (void)showSimpleAlertControllerWithTitle:(NSString *)title
                                   message:(NSString *)message
                      parentViewController:(UIViewController *)viewController;

/**
 *  快捷创建一个 alertController（alertView） 带回调Block提示窗
 *
 *  @param title          标题
 *  @param message        详细信息描述
 *  @param viewController alertController 展现的父控制器
 *  @param ok             确定回调block
 *  @param cancel         取消回调block
 */
+ (void)showSimpleAlertControllerWithTitle:(NSString *)title
                                   message:(NSString *)message
                      parentViewController:(UIViewController *)viewController
                                   BlockOk:(void (^)())ok
                               BlockCancel:(void (^)())cancel;


/**
 *  快捷创建一个 alertController（ActionSheet）带3个按钮（1个取消按钮）提示窗
 *
 *  @param firstTitle     第1个按钮标题
 *  @param secondTitle    第2个按钮标题
 *  @param cancelTitle    取消按钮标题
 *  @param viewController alertController 展现的父控制器
 *  @param fristBlock     第一个按钮回调block
 *  @param secondBlock    第二个按钮回调block
 */
+ (void)showSimpleActionSheetWithFirstTitle:(NSString *)firstTitle
                                secondTitle:(NSString *)secondTitle
                                cancelTitle:(NSString *)cancelTitle
                       parentViewController:(UIViewController *)viewController
                                 firstBlock:(void (^)())fristBlock
                               secondeBlock:(void (^)())secondBlock;

/**
 *  快捷创建一个 alertController（ActionSheet）带2个按钮（1个取消按钮）提示窗
 *
 *  @param firstTitle     第1个按钮标题
 *  @param cancelTitle    取消按钮标题
 *  @param viewController alertController 展现的父控制器
 *  @param fristBlock     第一个按钮回调block
 */
+ (void)showSimpleActionSheetWithFirstTitle:(NSString *)firstTitle
                                cancelTitle:(NSString *)cancelTitle
                       parentViewController:(UIViewController *)viewController
                                 firstBlock:(void (^)())fristBlock;

@end
