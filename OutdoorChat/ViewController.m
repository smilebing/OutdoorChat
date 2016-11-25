//
//  ViewController.m
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/25.
//  Copyright © 2016年 朱贺. All rights reserved.
//
#import "ViewController.h"


#import <XMPPFramework/XMPPFramework.h>

@interface ViewController ()
@property (nonatomic,strong) XMPPStream *stream ;
@end

@implementation ViewController

-(XMPPStream *) InitStream
{
//    if(self.stream == nil )
//    {
        self.stream=[[XMPPStream alloc] init];
        [self.stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
   // }
    return self.stream;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self InitStream];
    [self.stream setMyJID:[XMPPJID jidWithString:@"zhuhe@127.0.0.1"]];
    [self.stream setHostName:@"127.0.0.1"];
    [self.stream setHostPort:5222];
    
    NSError *error=nil;
    [self.stream connectWithTimeout:10.0 error:&error];
    if(error)
    {
        NSLog(@"connectWithTimeout :%@",error);
    }

}

-(void) xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError * error=nil;
    [self.stream authenticateWithPassword:@"zhuhe" error:&error];
    NSLog(@"au");
    if(error)
    {
        NSLog(@"authenticateWithPassword :%@",error);
    }
}

-(void) xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPPresence *presence=[XMPPPresence presence];
    [self.stream sendElement:presence];
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSString *msg = [[message elementsForName:@"body"] lastObject];
    NSLog(@"%@",msg);
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"didNotAuthenticate : %@",error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
