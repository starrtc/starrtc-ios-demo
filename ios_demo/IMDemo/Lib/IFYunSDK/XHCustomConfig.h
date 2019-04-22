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

static NSString *SERVER_TYPE_PUBLIC = @"PUBLIC";
static NSString *SERVER_TYPE_CUSTOM = @"CUSTOM";

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
