//
//  ProfileTableViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/12/9.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <XMPPFramework/XMPPvCardTempModule.h>
#import <XMPPFramework/XMPPvCardTemp.h>
#import "XMPPTool.h"
#import "UserTool.h"
#import "EditProfileTableViewController.h"

@interface ProfileTableViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,EditProfileTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headView; //头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel; //昵称
@property (weak, nonatomic) IBOutlet UILabel *chatNumLabel;//号码
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    [self loadVCard];

}

//加载电子名片
-(void)loadVCard{
    //显示个人数据
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
    self.chatNumLabel.text=user;
    
    //公司
    self.orgNameLabel.text=myVCard.orgName;
    
    //部门
    if(myVCard.orgUnits.count>0)
    {
        self.orgunitLabel.text=myVCard.orgUnits[0];
    }
    //职位
    self.titleLabel.text=myVCard.title;
    //电话
    self.phoneLabel.text=myVCard.note;
    
    //邮件
    self.emailLabel.text=myVCard.mailer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取cell.tag
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag=cell.tag;
    
    //判断
    switch (tag) {
        case 1:
        {
            //跳到下个控制器
            [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
            //NSLog(@"跳到下个控制器");
        }
            break;
        case 0:
        {
            //更换头像
           UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
            [sheet showInView:self.view];
            //NSLog(@"更换头像");
        }
            break;
        case 2:
            //点击账号，不做任何操作
            //NSLog(@"不做任何操作");
        default:
            break;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[EditProfileTableViewController class]]) {
        EditProfileTableViewController *editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

#pragma mark actionsheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 2){//取消
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // 设置代理
    imagePicker.delegate =self;
    
    // 设置允许编辑
    imagePicker.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        //照相
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        //相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
}


#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    WCLog(@"%@",info);
    // 获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headView.image = image;
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 更新到服务器
    [self editProfileTableViewControllerDidSave];
    
}

#pragma mark 编辑个人信息的控制器代理
// 保存
-(void)editProfileTableViewControllerDidSave{
    NSLog(@"editProfileTableViewControllerDidSave");
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [XMPPTool sharedXMPPTool].vCard.myvCardTemp ;
    
    // 图片
    myvCard.photo = UIImagePNGRepresentation(self.headView.image);
    
    // 昵称
    myvCard.nickname = self.nickNameLabel.text;
    
    // 公司
    myvCard.orgName = self.orgNameLabel.text;
    
    // 部门
    if (self.orgunitLabel.text.length > 0) {
        myvCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    
    // 职位
    myvCard.title = self.titleLabel.text;
    
    
    // 电话
    myvCard.note =  self.phoneLabel.text;
    
    // 邮件
    myvCard.mailer = self.emailLabel.text;
    
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    XMPPTool * xmppTool=[XMPPTool sharedXMPPTool];
    [xmppTool.vCard updateMyvCardTemp:myvCard];
    
    
}

@end
