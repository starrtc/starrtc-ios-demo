//
//  XHClient.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/12.
//  Copyright © 2018年 Happy. All rights reserved.
//
#import "XHChatManager.h"
#import "XHLoginManager.h"
#import "XHChatroomManager.h"
#import "XHGroupManager.h"
#import "XHVoipManager.h"
#import "XHMeetingManager.h"
#import "XHLiveManager.h"
#import "XHVoipP2PManager.h"

 static NSString *SERVER_TYPE_PUBLIC = @"PUBLIC";
 static NSString *SERVER_TYPE_CUSTOM = @"CUSTOM";

@interface XHSDKConfig:NSObject

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
//@property (nonatomic, strong) NSString *voipScheduleURL;

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


@end

@protocol XHClientDelegate <NSObject>

- (void)getPushMode:(NSString *)pushMode;

@end


@interface XHClient : NSObject

@property (nonatomic, strong, readonly) XHLoginManager *loginManager;
@property (nonatomic, strong, readonly) XHChatroomManager *roomManager;
@property (nonatomic, strong, readonly) XHGroupManager *groupManager;
@property (nonatomic, strong, readonly) XHChatManager *chatManager;
@property (nonatomic, strong, readonly) XHVoipManager *voipManager;
@property (nonatomic, strong, readonly) XHVoipP2PManager *voipP2PManager;
@property (nonatomic, strong, readonly) XHMeetingManager *meetingManager;
@property (nonatomic, strong, readonly) XHLiveManager *liveManager;
@property (nonatomic, strong, readonly) XHSDKConfig *config;

+ (instancetype)sharedClient;

- (void)initSDKWithConfiguration:(XHSDKConfig *)config;

- (void)setVideoConfig:(XHVideoConfig *)videoConfig;

- (void)addDelegate:(id<XHClientDelegate>) delegate;

/**
 设置推送模式
 @param pushMode 推送模式
 @param completion 回调
 */
- (void)setPushMode:(NSString *)pushMode completion:(void(^)(NSError *error))completion;


/**
 获取推送模式  因为获取推送模式需要去服务器更新，所以以回调的形式返回给用户
 */
- (void)getPushMode;



@end
