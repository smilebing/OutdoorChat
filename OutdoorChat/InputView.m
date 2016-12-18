//
//  InputView.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/17.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "InputView.h"

@implementation InputView

+(instancetype)inputView{
    return [[[NSBundle mainBundle]loadNibNamed:@"InputView" owner:nil options:nil]lastObject];
}

@end
