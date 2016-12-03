//
//  QRJMainNavigationController.m
//  NewIT
//
//  Created by Alfa on 16/5/1.
//  Copyright © 2016年 alfa. All rights reserved.
//

#import "MainNavigationController.h"


@implementation MainNavigationController

-(void)viewDidLoad{
    
    [super viewDidLoad];
   
    [self setupNavigationBar];
}
-(void)setupNavigationBar{
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.352 green:0.114 blue:0.944 alpha:1.000]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowOffset = CGSizeMake(0, 0);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,shadow, NSShadowAttributeName,[UIFont boldSystemFontOfSize:15.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    self.title=@"bobofree";
}
@end
