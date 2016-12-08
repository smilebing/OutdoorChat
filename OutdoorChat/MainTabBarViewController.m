//
//  QRJMainTabBarViewController.m
//  NewIT
//
//  Created by Alfa on 16/7/27.
//  Copyright © 2016年 alfa. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "MainNavigationController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainNavigationController *recent = [UIStoryboard storyboardWithName:@"Recent" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    [self addOneSubViewController:recent title:@"最近" imageName:nil selectedImageName:nil];
    MainNavigationController *friend = [UIStoryboard storyboardWithName:@"Friend" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    [self addOneSubViewController:friend title:@"联系人" imageName:@"tabbar_friend" selectedImageName:nil];
    
    MainNavigationController *map = [UIStoryboard storyboardWithName:@"Map" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    [self addOneSubViewController:map title:@"地图" imageName:nil selectedImageName:nil];
    
    
    
  
    
    MainNavigationController *personal = [UIStoryboard storyboardWithName:@"Personal" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    [self addOneSubViewController:personal title:@"我" imageName:nil selectedImageName:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 将一个控制器加入到Tabbar中

 @param subViewController 控制器
 @param title 控制器标题
 @param imageName 正常状态下的图片
 @param selectedImageName 选中状态下的图片
 */
-(void)addOneSubViewController:(UIViewController*)subViewController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName{
    
    subViewController.tabBarItem.title=title;
    subViewController.tabBarItem.image=[UIImage imageNamed:imageName];
    
    UIImage*selectedImage=[UIImage imageNamed:selectedImageName];
    
    subViewController.tabBarItem.selectedImage=selectedImage;
    
    [self addChildViewController:subViewController];
    
    
    
}

    
   
@end
