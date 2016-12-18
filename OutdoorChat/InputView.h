//
//  InputView.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/17.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

+(instancetype)inputView;
@end
