//
//  Config.h
//  OutdoorChat
//
//  Created by 朱贺 on 2016/11/28.
//  Copyright © 2016年 朱贺. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define HTTPSERVER @"你自己的文件上传地址"

#define XMPP_HOST @"127.0.0.1"
#define XMPP_PORT      5222
#define XMPP_DOMAIN    @"127.0.0.1"
#define XMPP_SUBDOMAIN @"group"
#define XMPP_RESOURCE  @"iOS"
#define XMPP_CONNECT_TIMEOUT 5.0


//通知
#define XMPP_ROSTER_CHANGE @"XMPP_ROSTER_CHANGE"
//*********************** 通知 *****************
#define USER_LOGIN_SUCCESS_NOTIFICATION     @"LOGIN_SUCCESS"
#define USER_LOGIN_FAIL_NOTIFICATION     @"LOGIN_FAIL"

#define USER_REGIST_RESULT_NOTIFICATION      @"REGIST_RESULT"



#define XMPP_ROSTER_CHANGE_NOTIFICATION @"XMPP_ROSTER_CHANGE"
#define XMPP_MESSAGE_CHANGE_NOTIFICATION @"XMPP_MESSAGE_CHANGE"
#define XMPP_GET_GROUPS_NOTIFICATION     @"XMPP_GET_GROUPS"
#endif /* Config_h */
