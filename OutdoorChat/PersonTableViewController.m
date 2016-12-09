//
//  PersonTableViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/3.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "PersonTableViewController.h"
#import "XMPPTool.h"
#import "UserTool.h"
#import "MainNavigationController.h"
#import <XMPPFramework/XMPPvCardTemp.h>

@interface PersonTableViewController ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//手机号
@property (weak, nonatomic) IBOutlet UILabel *chatNumLabel;




@end

@implementation PersonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //显示当前用户的个人信息
    
    //使用coreData获取数据
    //1.上下文关联到数据库
    
    //2.FetchRequest
    
    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
    XMPPvCardTemp *myVCard= xmppTool.vCard.myvCardTemp;
    
    //设置头像
    if(myVCard.photo)
    {
        self.headView.image=[UIImage imageWithData:myVCard.photo];
    }
    
    //设置昵称
    self.nickNameLabel.text=myVCard.nickname;
    //设置账号
    NSString * user=[UserTool userName];
    self.chatNumLabel.text=[NSString stringWithFormat:@"微信号:%@",user];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
}




//注销
- (IBAction)sendOfflineToHost:(id)sender {
    XMPPTool * xmppTool = [XMPPTool sharedXMPPTool];
    //发送离线消息去服务器
    [xmppTool logout];
    //本地清空用户密码
    //[UserTool removeAll];
    [UserTool removePwd];
    //返回登录页面
       MainNavigationController *vc = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]].instantiateInitialViewController;
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
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
