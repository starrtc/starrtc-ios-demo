//
//  XHSuperRoomManager.h
//  starLibrary
//
//  Created by  Admin on 2019/7/10.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XHVideoConfig.h"

NS_ASSUME_NONNULL_BEGIN


@protocol XHSuperRoomManagerDelegate <NSObject>

/**
 有人加入直播
 @param uid 加入用户的ID
 @param liveID 直播间ID
 @return 用于显示发言者视频画面的view
 */
- (UIView *)onActorJoined:(NSString *)uid live:(NSString *)liveID;

/**
 有人离开直播
 
 @param uid 离开用户的ID
 @param liveID 直播间ID
 */
- (void)onActorLeft:(NSString *)uid live:(NSString *)liveID;



/**
 一些异常情况可能会引起会议出错，请在收到该回调后主动离开直播
 @param error 错误信息
 @param liveID 直播间ID
 */
- (void)onSuperRoomError:(NSError *)error live:(NSString *)liveID;


/**
 成员数发生变化
 
 @param membersNumber 成员数
 */
- (void)liveMembersNumberUpdated:(NSInteger)membersNumber;


/**
 自己被剔
 */
- (void)liveUserKicked;

/**
 * 自己被禁言
 * @param seconds 被禁言的时长
 */
- (void)onSelfMuted:(NSInteger) seconds;


/**
 * 自己连麦被强制停止
 @param liveID 直播间ID
 */
- (void)onCommandToStopPlay:(NSString *)liveID;


/**
 收到消息
 
 @param message 消息
 */
- (void)liveMessageReceived:(NSString *)message fromID:(NSString *)fromID;

/**
 收到私信消息
 
 @param message 消息
 @param fromID 消息来源
 */
- (void)livePrivateMessageReceived:(NSString *)message fromID:(NSString *)fromID;


/**
 * 收到实时数据
 * @param data 数据
 * @param upId  用户ID
 */
- (void)onReceiveRealtimeData:(NSString *)data
                         upId:(NSString *)upId;

@end



@interface XHSuperRoomItem : NSObject

@property (nonatomic, copy) NSString *superRoomName;
@property (nonatomic, copy) NSString *superRoomID;
@property (nonatomic, assign) XHSuperRoomType superRoomType;

@end

@interface XHSuperRoomManager : NSObject


/**
 设置视频参数
 
 @param config 参数
 */
- (void)setVideoConfig:(XHVideoConfig *)config;

/**
 设置回调代理
 
 @param delegate 代理
 */
- (void)addDelegate:(id<XHSuperRoomManagerDelegate>)delegate;


/**
 * 设置媒体类型
 * @param mediaType 类型
 */
- (void)setRtcMediaType:(XHRtcMediaTypeEnum) mediaType;

/**
 * 创建直播
 * @param superRoomItem XHSuperRoomItem 用于指定直播的名字和类型
 * @param completion 结果回调
 */
- (void)createSuperRoom:(XHSuperRoomItem *) superRoomItem completion:(void(^)(NSString *liveID, NSError *error))completion;

/**
 * 加入超级聊天室
 * @param roomID 直播ID
 * @param completion 结果回调
 */
- (void)joinSuperRoom:(NSString *)liveID completion:(void(^)(NSError *error))completion;

/**
 *  停止发言
 *  @param completion 结果回调
 */
- (void)layDownMic:(void(^)(NSError *error))completion;

/**
 * 申请发言
 * @param completion 结果回调
 */
- (void)pickUpMic:(void(^)(NSError *error))completion;

/**
 * 离开聊天室
 * @param completion 结果回调
 */
- (void)leaveSuperRoom:(void(^)(NSError *error))completion;

/**
 停止连卖
 
 @param toID  停止对象
 @param completion 回调
 */
- (void)commandToAudience:(NSString *)toID
               completion:(void(^)(NSError *error))completion;

/**
 返回切换后的摄像头方向
 
 @return 切换后的摄像头方向
 */
- (XHCameraDirection)switchCamera;

/**
 切换到大视频预览页面
 
 @param view  待切换画面
 */
- (void)changeToBig:(UIView *)view;
/**
 切换到小视频预览页面
 @param view  待切换画面
 */
- (void)changeToSmall:(UIView *)view;



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
- (void)sendMessage:(NSString *)message toID:(NSString *)toID completion:(void(^)(NSError *error))completion;



/**
 禁言
 
 @param member 用户id
 @param seconds 禁言时长，单位为秒
 @param completion 回调
 */
- (void)muteMember:(NSString *)member
       muteSeconds:(NSInteger)seconds
        completion:(void(^)(NSError *error))completion;

/**
 解除禁言
 
 @param member 用户id
 @param liveId 会议id
 @param completion 回调
 */
- (void)unMuteMember:(NSString *)member
            fromLive:(NSString *)liveId
          completion:(void(^)(NSError *error))completion;

/**
 剔除用户
 
 @param member 用户id
 @param completion 回调
 */
- (void)kickMember:(NSString *)member
        completion:(void(^)(NSError *error))completion;


/**
 * 开关音频
 @param enable 开关
 */
- (void)setAudioEnable:(BOOL) enable;

/**
 * 开关视频
 @param enable 开关
 */
- (void)setVideoEnable:(BOOL) enable;

/**
 * 保存到列表
 * @param userId 用户名
 * @param type  类型
 * @param liveId  ID
 * @param info  消息
 * @param completion  回调
 */
-(void)saveToList:(NSString *)userId
             type:(NSInteger) type
           liveId:(NSString *) liveId
             info:(NSString *)info
       completion:(void(^)(NSError *error))completion;



/**
 * 查询直播列表
 * @param userId 用户ID
 * @param type 类型
 * @param completion 结果回调
 *
 */
- (void)querySuperRoomList:(NSString *)userId
                 type:(NSString *)type
           completion:(void(^)(NSString *listInfo, NSError *error))completion;

/**
 * 从直播列表删除
 * @param liveId 直播ID
* @param listType list 类型
 * @param completion 结果回调
 */
- (void)deleteFromSuperRoomList:(NSString *)liveId
                       listType:(NSInteger)listType
                completion:(void(^)(NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
