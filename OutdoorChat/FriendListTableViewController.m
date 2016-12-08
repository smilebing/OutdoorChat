//
//  FriendListTableViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/29.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "FriendListTableViewController.h"
#import "XMPPTool.h"
#import "Config.h"


@interface FriendListTableViewController ()
@property (nonatomic, retain) NSMutableArray    *contacts;
@end

@implementation FriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor colorWithRed:234 green:239 blue:245 alpha:1];
    
    self.tableView.tableFooterView = [UIView new];
    
    //注册通知中心
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rosterChange) name:XMPP_ROSTER_CHANGE object:nil];
      [self rosterChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contacts.count;
}


#pragma mark - notification event
//好友列表变化
- (void)rosterChange
{
    //从存储器中取出我得好友数组，更新数据源
    self.contacts = [NSMutableArray arrayWithArray:[[XMPPTool sharedXMPPTool].xmppRosterMemoryStorage unsortedUsers]];
    //[self.tableView reloadData];
    [self reloadInputViews];
    NSLog(@"收到通知");
}



-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"移除 FriendList 的observer");
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    XMPPUserMemoryStorageObject *user = self.contacts[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1001];
    nameLabel.text = user.jid.user;
    
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:1002];
    if ([user isOnline]) {
        statusLabel.text = @"[在线]";
        statusLabel.textColor = [UIColor blackColor];
        nameLabel.textColor = [UIColor blackColor];
    } else {
        statusLabel.text = @"[离线]";
        statusLabel.textColor = [UIColor grayColor];
        nameLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
