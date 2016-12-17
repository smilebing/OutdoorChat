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
#import "UserTool.h"


@interface FriendListTableViewController ()<NSFetchedResultsControllerDelegate>

@property(nonatomic,strong)NSArray * friends;
@property(nonatomic,strong)NSFetchedResultsController *resultController;
@end

@implementation FriendListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从数据库里面加载好友列表显示
    [self loadFriendsTwo];
    
}

//加载好友列表
-(void)loadFriends
{
    //1.使用coreData获取数据
    NSManagedObjectContext * context= [XMPPTool sharedXMPPTool].xmppRosterCoreDataStorage.mainThreadManagedObjectContext;
    
    //2.FetchRequest 查表
    NSFetchRequest * request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤和排序
    //过滤当前登录用户的好友
    NSString * jid=[UserTool jid] ;
    NSLog(@"jid=%@",jid);
    NSPredicate * pre=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate=pre;
    
    //排序
    NSSortDescriptor * sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors=@[sort];
    //4.请求获取数据
    NSError * error=nil;
    self.friends =[context executeFetchRequest:request error:&error ];
    //NSLog(@"%@",self.friends);
    
}

-(void)loadFriendsTwo
{
    //1.使用coreData获取数据
    NSManagedObjectContext * context= [XMPPTool sharedXMPPTool].xmppRosterCoreDataStorage.mainThreadManagedObjectContext;
    
    //2.FetchRequest 查表
    NSFetchRequest * request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    //3.设置过滤和排序
    //过滤当前登录用户的好友
    NSString * jid=[UserTool jid] ;
    NSLog(@"jid=%@",jid);
    NSPredicate * pre=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate=pre;
    
    //排序
    NSSortDescriptor * sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors=@[sort];
    
    
    //4.请求获取数据
    _resultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate=self;
    NSError * error=nil;
    
    [_resultController performFetch:&error];
    if(error)
    {
        WCLog(@"获取好友列表出错 %@",error);
    }
}


#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.friends.count;
    return _resultController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID=@"contactCell";
    UITableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:ID];
    //获取对应好友
    XMPPUserCoreDataStorageObject * friend = _resultController.fetchedObjects[indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1001];
    nameLabel.text = friend.jidStr;
    
    
    //判断好友状态
    //sectionNum
    //0-在线 ，1-离开，2-离线
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:1002];
    switch ([friend.sectionNum intValue]) {
        case 0:
            statusLabel.text=@"[在线]";
            statusLabel.textColor = [UIColor blackColor];
            nameLabel.textColor = [UIColor blackColor];
            break;
        case 1:
            statusLabel.text=@"[离开]";
            statusLabel.textColor = [UIColor redColor];
            nameLabel.textColor = [UIColor redColor];
            break;
            
        default:
            statusLabel.text=@"[离线]";
            statusLabel.textColor = [UIColor grayColor];
            nameLabel.textColor = [UIColor grayColor];
            break;
    }
    

    
    return cell;
}



-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)
    {
        WCLog(@"删除好友");
        XMPPUserCoreDataStorageObject * friend = _resultController.fetchedObjects[indexPath.row];
        XMPPJID * friendJid=friend.jid;
        [[XMPPTool sharedXMPPTool].xmppRoster removeUser:friendJid];
    }
}

#pragma mark 当数据库内容发生改变
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    WCLog(@"数据库数据发生改变");
    //刷新表格
    [self.tableView reloadData];
}





@end
