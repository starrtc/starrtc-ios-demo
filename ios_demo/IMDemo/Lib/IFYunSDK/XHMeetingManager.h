//
//  XHMeetingManager.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/16.
//  Copyright © 2018年 Happy. All rights reserved.
//  会议

#import <UIKit/UIKit.h>

#import "XHVideoConfig.h"
#import "XHConstants.h"


@protocol XHMeetingManagerDelegate <NSObject>

/**
 有人加入会议
 @param uid  加入用户ID
 @param meetingID  会议ID
 @return 用于显示发言者视频画面的view
 */
- (UIView *)onJoined:(NSString *)uid meeting:(NSString *)meetingID;

/**
 有人离开会议
 @param uid  离开用户ID
 @param meetingID  会议ID
 */
- (void)onLeft:(NSString *)uid meeting:(NSString *)meetingID;

@optional

/**
 一些异常情况可能会引起会议出错，请在收到该回调后主动离开会议
 @param error  错误信息
 @param meetingID  会议ID
 */
- (void)onMeetingError:(NSError *)error meeting:(NSString *)meetingID;


/**
 成员数发生变化
 
 @param membersNumber 成员数
 */
- (void)meetingMembersNumberUpdated:(NSInteger)membersNumber;

/**
 自己被剔
 */
- (void)meetingUserKicked;

/**
 收到消息
 
 @param message 消息
 @param fromID  消息来源
 */
- (void)meetingMessageReceived:(NSString *)message fromID:(NSString *)fromID;

/**
 收到私信消息
 
 @param message 消息
 @param fromID  消息来源
 */
- (void)meetingPrivateMessageReceived:(NSString *)message fromID:(NSString *)fromID;

/**
 * 收到实时数据
 * @param data 数据
 * @param upId  用户ID
 */
- (void)onReceiveRealtimeData:(NSString *)data
                         upId:(NSString *)upId;


@end





@class XHMeetingItem;
@interface XHMeetingManager : NSObject

/**
 设置视频参数
 @param config 参数
 */
- (void)setVideoConfig:(XHVideoConfig *)config;

/**
 设置回调代理
 @param delegate 代理
 */
- (void)addDelegate:(id<XHMeetingManagerDelegate>)delegate;


/**
 * 设置拍摄时 设备的方向
 * @param deviceDirection 方向
 */
- (void)setDeviceDirection:(XHDeviceDirectionEnum) deviceDirection;

/**
 * 设置媒体类型
 * @param mediaType 类型
 */
- (void)setRtcMediaType:(XHRtcMediaTypeEnum) mediaType;


/**
 创建会议
 @param meetingItem  会议信息
 @param completion 回调
 */
- (void)createMeeting:(XHMeetingItem *)meetingItem completion:(void(^)(NSString *meetingID ,NSError *error))completion;

/**
 加入会议
  @param meetingID  会议ID
  @param completion 回调
 */
- (void)joinMeeting:(NSString *)meetingID completion:(void(^)(NSError *error))completion;

/**
 离开会议
 @param meetingID  会议ID
 @param completion 回调
 */
- (void)leaveMeeting:(NSString *)meetingID completion:(void(^)(NSError *error))completion;

/**
 返回切换后的摄像头方向
 @return 切换后的摄像头方向
 */
- (XHCameraDirection)switchCamera;

/**
 切换到大视频预览页面
 @param view  待切换画面
 */
- (void)changeToBigPreview:(UIView *)view;

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
 @param meetingId 会议id
 @param completion 回调
 */
- (void)muteMember:(NSString*)member
        muteSeconds:(NSInteger)seconds
       frommeeting:(NSString *)meetingId
         completion:(void(^)(NSError *error))completion;

/**
 解除禁言
 @param member 用户id
 @param meetingId 会议id
 @param completion 回调
 */
- (void)unMuteMember:(NSString *)member
         frommeeting:(NSString *)meetingId
           completion:(void(^)(NSError *error))completion;

/**
 剔除用户
 @param member 用户id
 @param meetingId 会议id
 @param completion 回调
 */
- (void)kickMember:(NSString *)member
         frommeeting:(NSString *)meetingId
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
 * @param meetingId  ID
 * @param info  消息
 * @param completion  回调
 */
-(void)saveToList:(NSString *)userId
             type:(NSInteger) type
        meetingId:(NSString *) meetingId
             info:(NSString *)info
       completion:(void(^)(NSError *error))completion;

/**
 * 查询会议室列表
 * @param userId 用户名
 * @param type  类型
 * @param completion 结果回调
 */
-(void)queryMeetingList:(NSString *)userId
                   type:(NSString *)type
             completion:(void(^)(NSString *listInfo, NSError *error))completion;

/**
 * 从会议室列表删除
 * @param meetingId 会议室ID
 * @param completion 结果回调
 */
-(void)deleteFromMeetingList:(NSString *)meetingId
                    listType:(NSInteger)listType
    completion:(void(^)(NSError *error))completion;


@end




@interface XHMeetingItem : NSObject

@property (nonatomic, copy) NSString *meetingName; //会议名称
@property (nonatomic, assign) XHMeetingType meetingType; //会议类型

@end
