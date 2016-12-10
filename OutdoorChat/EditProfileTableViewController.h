//
//  EditProfileTableViewController.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/9.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditProfileTableViewControllerDelegate <NSObject>

-(void)editProfileTableViewControllerDidSave;


@end

@interface EditProfileTableViewController : UITableViewController
@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<EditProfileTableViewControllerDelegate> delegate;

@end
