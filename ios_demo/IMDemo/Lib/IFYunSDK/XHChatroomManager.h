//
//  XHRoomManager.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/13.
//  Copyright © 2018年 Happy. All rights reserved.
//  聊天室

#import <Foundation/Foundation.h>
#import "XHConstants.h"

@protocol XHChatroomManagerDelegate <NSObject>

/**
 聊天室成员数发生变化

 @param chatroomID 聊天室id
 @param membersNumber 聊天室成员数
 */
- (void)chatroom:(NSString *)chatroomID didMembersNumberUpdated:(NSInteger)membersNumber;

/**
 自己被剔除当前聊天室

 @param kickOutUserId 用户id
 */
- (void)chatroomUserKicked:(NSString *)kickOutUserId;

/**
 聊天室关闭通知
 */
- (void)chatroomDidColsed;

/**
 收到聊天室消息

 @param message 消息
 */
- (void)chatroomMessagesDidReceive:(NSString *)message fromID:(NSString *)fromID;

/**
 收到聊天室私信消息
 
 @param message 消息
 */
- (void)chatroomPrivateMessagesDidReceive:(NSString *)message fromID:(NSString *)fromID;

/**
 聊天室报错
 
 @param errString 错误信息
 */
-(void)chatRoomErr:(NSString *)errString;

/**
 聊天余额不足
 */
-(void) chatroomSendMsgNoFee;


/**
 聊天室 自己被禁言
 @param remainTimeSec 禁言剩余秒数
 */
-(void) chatroomSendMsgBanned:(int) remainTimeSec;

@end




@interface XHChatroomManager : NSObject

- (void)addDelegate:(id<XHChatroomManagerDelegate>)delegate;
/**
 创建聊天室
 @param chatroomName 聊天室名称
 @param type 聊天室类型
 @param completion 回调
 */
- (void)createChatroom:(NSString *)chatroomName type:(XHChatroomType)type completion:(void(^)(NSString *chatRoomID,NSError *error))completion;

/**
 删除聊天室
 @param chatroomID 聊天室ID
 @param completion 回调
 */
- (void)deleteChatroom:(NSString *)chatroomID completion:(void(^)(NSError *error))completion;

/**
 加入聊天室
 @param chatroomID 聊天室ID
 @param completion 回调
 */
- (void)joinChatroom:(NSString *)chatroomID completion:(void(^)(NSError *error))completion;

/**
 退出聊天室
 @param chatroomID 聊天室ID
 @param completion 回调
 */
- (void)exitChatroom:(NSString *)chatroomID completion:(void(^)(NSError *error))completion;

/**
 聊天室禁言
 @param member 禁言成员
 @param seconds 禁言时间
 @param chatroomId 聊天室ID
 @param completion 回调
 */
- (void)muteMember:(NSString*)member
        muteSeconds:(NSInteger)seconds
       fromChatroom:(NSString *)chatroomId
         completion:(void(^)(NSError *error))completion;

/**
 聊天室取消禁言
 @param member 禁言成员
 @param chatroomId 聊天室ID
 @param completion 回调
 */
- (void)unMuteMember:(NSString *)member
         fromChatroom:(NSString *)chatroomId
           completion:(void(^)(NSError *error))completion;
/**
 聊天室踢出用户
 @param member 踢出成员
 @param chatroomId 聊天室ID
 @param completion 回调
 */
- (void)removeMember:(NSString *)member
         fromChatroom:(NSString *)chatroomId
           completion:(void(^)(NSError *error))completion;

/**
 发送消息
 @param message 消息
 @param completion 回调
 */
- (void)sendMessage:(NSString *)message completion:(void(^)(NSError *error))completion;

/**
 发送私信消息
 @param message 消息
 @param toID 收件人id
 @param completion 回调
 */
- (void)sendMessage:(NSString *)message toID:(NSString *)toID  completion:(void(^)(NSError *error))completion;


/**
 * 保存到列表
 * @param userId 用户名
 * @param type  类型
 * @param chatroomID  ID
 * @param info  消息
 * @param completion  回调
 */
-(void)saveToList:(NSString *)userId
             type:(NSInteger) type
       chatroomID:(NSString *) chatroomID
             info:(NSString *)info
       completion:(void(^)(NSError *error))completion;


/**
 * 查询聊天室列表
 * @param userId 用户名
 * @param type  类型
 * @param completion 回调
 */
- (void)queryChatroomList:(NSString *)userId
                     type:(NSString *) type
               completion:(void(^)(NSString *listInfo, NSError *error))completion;

/**
 * 从聊天室列表删除
 * @param chatroomId 聊天室ID
 * @param completion 结果回调
 */
- (void)deleteFromChatroomList:(NSString *) chatroomId
                      listType:(NSInteger)listType
                    completion:(void(^)(NSError *error))completion;

@end
