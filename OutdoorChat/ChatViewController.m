//
//  ChatViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/17.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "ChatViewController.h"
#import "InputView.h"
#import "XMPPTool.h"
#import "UserTool.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSFetchedResultsController * _resultController;
}
@property (nonatomic, strong) NSLayoutConstraint *inputViewButtomConstraint;//inputView底部约束
@property (nonatomic,strong) NSLayoutConstraint * inputViewHeightConstraint;//inputView高度约束
@property (nonatomic,weak) UITableView *tableView;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //代码排版
    [self setupView];
    
    //键盘监听
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //加载数据
    [self loadMsg];
}



-(void)setupView{
        //创建tableView
    UITableView * tableView=[[UITableView alloc]init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    
        //创建输入框view
    InputView * inputView=[InputView inputView ];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:inputView];
    
    //设置textView代理
    inputView.textView.delegate=self;
    self.tableView=tableView;
    
    //添加按钮事件
    [inputView.addButton addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //自动布局
    //水平方向的约束
    NSDictionary * views =@{@"tableView":tableView,
                            @"inputView":inputView};
    
    NSArray * tableViewHConstraints= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableViewHConstraints];
    
    NSArray * inputViewHConstraints= [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstraints];
    
    //垂直方向的约束
    NSArray * vConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[inputView(44)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vConstraints];
    
    
    //inputView的高度约束
    self.inputViewHeightConstraint =vConstraints[2];
    
    _inputViewButtomConstraint=[vConstraints lastObject];
}


//键盘显示
-(void)keyBoardShow:(NSNotification *)noti
{
    //获取键盘的高度
    CGRect kbEndFrame=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat kbHeight=kbEndFrame.size.height;
    
    self.inputViewButtomConstraint.constant=kbHeight;
    
    //表格滚动
    [self scrollToTableBottom];
}

//键盘隐藏
-(void)keyBoardHide:(NSNotification *)noti
{
    self.inputViewButtomConstraint.constant=0;
}


#pragma  mark 加载数据库数据，显示在表格
-(void)loadMsg
{
    
    //上下文
    NSManagedObjectContext * context =[XMPPTool sharedXMPPTool].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    //请求对象
    NSFetchRequest * request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];//聊天的表
    
    
    //过滤、排序
    //当前用户jid的信息
    //好友用户jid
    NSPredicate * pre =[NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[UserTool jid],self.friendJid.bare];
    request.predicate=pre;
    
    //时间升序
    NSSortDescriptor * timeSort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors=@[timeSort];
    
    //查询
    _resultController=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    
    //代理
    _resultController.delegate=self;
    NSError * error=nil;
    [_resultController performFetch:&error];

    
    if(error)
    {
        WCLog(@"%@",error);
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _resultController.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID=@"ChatCell";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    //获取聊天对象
    XMPPMessageArchiving_Message_CoreDataObject * msg=_resultController.fetchedObjects[indexPath.row];
    
    //显示消息
    if([msg.outgoing boolValue])
    {
        //自己发送的
        cell.textLabel.text= [NSString stringWithFormat:@"我说:%@", msg.body];

    }
    else
    {
        cell.textLabel.text= [NSString stringWithFormat:@"他说:%@", msg.body];
        //cell.textLabel.textColor=[UIColor purpleColor];

    }
    
    return  cell;
}


#pragma mark ResultController 代理
-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    //刷新数据
    [self.tableView reloadData];
    [self scrollToTableBottom];
    
}


#pragma mark TextView代理
-(void)textViewDidChange:(UITextView *)textView
{
    //获取ContentSize
    CGFloat contengHeight=textView.contentSize.height;
    
    //输入内容超过一行,小于三行
    if(contengHeight>33 &&contengHeight<68)
    {
        //NSLog(@"%@ ",contengHeight);
        self.inputViewHeightConstraint.constant=contengHeight+8;
    }
    
    //监听回车
    NSString * text=textView.text;
    if([text rangeOfString:@"\n"].length!=0)
    {
        //去除换行字符
        text=[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //发送数据
        [self sendMsgWithText:text];
        //清空数据
        textView.text=nil;
        //把inputView 的高度改回
        self.inputViewHeightConstraint.constant=44;
    }
}


#pragma mark 发送数据
-(void)sendMsgWithText:(NSString *)text
{
    XMPPMessage * msg=[XMPPMessage messageWithType:@"chat" to:self.friendJid];
    //设置内容
    [msg addBody:text];
    
    [[XMPPTool sharedXMPPTool].xmppStream sendElement:msg];
}

#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = _resultController.fetchedObjects.count - 1;
    
    //如果没有通信过
    if(lastRow<0)
    {
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 选择图片
-(void)addBtnClick
{
    UIImagePickerController * imagePick=[[UIImagePickerController alloc]init];
    imagePick.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.delegate=self;
    [self presentViewController:imagePick animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取图片
    
    //把图片发送到文件服务器
    
    //图片发送成功，把图片的URL传给openfire
}

@end
