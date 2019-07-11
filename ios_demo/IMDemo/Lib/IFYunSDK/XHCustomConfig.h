//
//  XHCustomConfig.h
//  starLibrary
//
//  Created by  Admin on 2019/4/8.
//  Copyright © 2019年  Admin. All rights reserved.
//

#ifndef XHCustomConfig_h
#define XHCustomConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XHConstants.h"

static NSString *SERVER_TYPE_PUBLIC = @"PUBLIC";
static NSString *SERVER_TYPE_CUSTOM = @"CUSTOM";
static  int LIST_TYPE_CHATROOM = 0;
static  int LIST_TYPE_LIVE = 1;
static  int LIST_TYPE_LIVE_PUSH = 2;
static  int LIST_TYPE_MEETING = 3;
static  int LIST_TYPE_MEETING_PUSH = 4;
static  int LIST_TYPE_CLASS = 5;
static  int LIST_TYPE_CLASS_PUSH = 6;
static  int LIST_TYPE_AUDIO_LIVE = 7;
static  int LIST_TYPE_AUDIO_LIVE_PUSH = 8;
static  int LIST_TYPE_SUPER_ROOM = 9;
static  int LIST_TYPE_SUPER_ROOM_PUSH = 10;
static NSString *LIST_TYPE_LIVE_ALL = @"1,2";
static NSString * LIST_TYPE_MEETING_ALL = @"3,4";
static NSString * LIST_TYPE_CLASS_ALL = @"5,6";
static NSString * LIST_TYPE_AUDIO_LIVE_ALL  = @"7,8";
static NSString * LIST_TYPE_SUPER_ROOM_ALL  = @"9,10";
static NSString * LIST_TYPE_PUSH_ALL  = @"2,4,6,8,10";




@interface XHCustomConfig : NSObject

@property (nonatomic, strong) NSString *serverType;
/* 应用ID*/
@property (nonatomic, strong) NSString *agentID;
/* 登陆服务*/
@property (nonatomic, strong) NSString *starLoginURL;
/* 消息服务*/
@property (nonatomic, strong) NSString *imScheduleURL;
/* 聊天室服务*/
@property (nonatomic, strong) NSString *chatRoomScheduleURL;
/* 上传服务*/
@property (nonatomic, strong) NSString *liveSrcScheduleURL;
/* 下载服务*/
@property (nonatomic, strong) NSString *liveVdnScheduleURL;
/* live代理服务*/
@property (nonatomic, strong) NSString *liveProxyScheduleURL;
///* voip服务*/
@property (nonatomic, strong) NSString *voipScheduleURL;

// 私有
/* 消息服务*/
@property (nonatomic, strong) NSString *imServerURL;
/* 聊天室服务*/
@property (nonatomic, strong) NSString *chatRoomServerURL;
/* 上传服务*/
@property (nonatomic, strong) NSString *liveSrcServerURL;
/* 下载服务*/
@property (nonatomic, strong) NSString *liveVdnServerURL;
/* live代理服务*/
@property (nonatomic, strong) NSString *liveProxyServerURL;
/* voip服务*/
@property (nonatomic, strong) NSString *voipServerURL;

//  正常SDK登录
-(void)sdkInit:(NSString *)userId;

// 暂时没用
-(void)sdkInitWithoutAudioCheck:(NSString *)userId;

// 开放版SDK初始化
-(void)sdkInitForFree:(NSString *)userId;


@end
#endif /* XHCustomConfig_h */
