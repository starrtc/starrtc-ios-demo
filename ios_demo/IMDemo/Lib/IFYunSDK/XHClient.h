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
#import "XHVideoSource.h"
#import "XHSuperRoomManager.h"

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
@property (nonatomic, strong, readonly) XHVideoSource *beautyManager;
@property (nonatomic, strong, readonly) XHSuperRoomManager *superRoomManager;
+ (instancetype)sharedClient;


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
