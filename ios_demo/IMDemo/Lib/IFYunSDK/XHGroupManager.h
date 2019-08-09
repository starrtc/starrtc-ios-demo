//
//  XHGroupManager.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/13.
//  Copyright © 2018年 Happy. All rights reserved.
//  群组

#import <Foundation/Foundation.h>

@protocol XHGroupManagerDelegate <NSObject>

/**
 群组成员数目变化

 @param groupID 群组id
 @param membersNumber 最新成员数    底层暂时没提供查询接口？？？？
 */
- (void)group:(NSString*)groupID didMembersNumberUpdeted:(NSInteger)membersNumber;

/**
 自己被移除当前群组        底层暂时没提供接口？？？？？

 @param groupID 群组id
 */
- (void)groupUserKicked:(NSString*)groupID;

/**
 群组被删除通知         底层暂时没提供接口？？？？？

 @param groupID 群组id
 */
- (void)groupDidDeleted:(NSString*)groupID;

/**
 收到群组消息

 @param aMessage 消息
 @param fromID 消息来源
 @param groupID 群组id
 */
- (void)groupMessagesDidReceive:(NSString *)aMessage fromID:(NSString *)fromID groupID:(NSString *)groupID;

@end

@interface XHGroupManager : NSObject

- (void)addDelegate:(id<XHGroupManagerDelegate>)delegate;

/**
 创建群组
 @param groupName 群组名称
 @param completion 回调
 */
- (void)createGroup:(NSString *)groupName completion:(void(^)(NSString *groupID,NSError *error))completion;
/**
 删除群组
 @param groupID 群组ID
 @param completion 回调
 */
- (void)deleteGroup:(NSString *)groupID completion:(void(^)(NSError *error))completion;

/**
 添加群成员
 @param memberIds 成员ID数组
 @param groupID 群组ID
 @param completion 回调
 */
- (void)addGroupMembers:(NSArray<NSString*> *)memberIds toGroup:(NSString *)groupID completion:(void(^)(NSError *error))completion;

/**
 剔除群成员
 @param memberIds 成员ID数组
 @param groupID 群组ID
 */
- (void)deleteGroupMembers:(NSArray<NSString*> *)memberIds fromGroup:(NSString *)groupID completion:(void(^)(NSError *error))completion;

/**
 设置免打扰

 @param groupId 群组ID
 @param enable YES表示免打扰，NO表示解除免打扰
 @param completion 回调
 */
- (void)setGroup:(NSString *)groupId pushEnable:(BOOL)enable completion:(void(^)(NSError *error))completion;

/**
 发送消息
 
 @param message 消息内容
 @param groupID 群组ID
 @param atUsers @人员
 @param completion 回调
 */
- (void)sendMessage:(NSString *)message toGroup:(NSString *)groupID atUsers:(NSArray<NSString*> *)atUsers completion:(void(^)(NSError *error))completion;

/**
 * 查询群列表  私有
 * @param completion 结果回调
 */
-(void)queryGroupList:(void(^)(NSString * listInfo, NSError *error))completion;

/**
 *  查询群信息（免打扰状态+成员列表）  私有
 * @param groupID 查询的群ID
 * @param completion 结果回调
 */
-(void)queryGroupInfo:(NSString *) groupID
           completion:(void(^)(NSString * listInfo, NSError *error))completion;

@end
