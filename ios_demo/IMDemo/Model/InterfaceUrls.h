//
//  InterfaceUrls.h
//  monitor_001
//
//  Created by  Admin on 2017/11/4.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AppConfigURL @"https://api.starrtc.com/demo/app_config?"


@protocol InterfaceUrlsdelegate <NSObject>
@optional
- (void)getMeetingListResponse:(id)respnseContent;
- (void)getLiveListResponse:(id)respnseContent;
- (void)getChatRoomListResponse:(id)respnseContent;
- (void)getMessageGroupListResponse:(id)respnseContent;
- (void)getMessageGroupMemberResponse:(id)respnseContent;
@end

@interface InterfaceUrls: NSObject

- (void)reportMeeting:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator;
//会议室列表
-(void)demoRequestMeetingList;

//上报互动直播列表信息
-(void)demoReportChatAndLive:(NSString *) channelId
                  chatroomId:(NSString *)chatroomId;

- (void)reportLive:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator;
- (void)reportSuorce:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator;

//互动直播列表
- (void)demoRequestLiveList;

- (void)reportChatroom:(NSString *)name ID:(NSString *)ID creator:(NSString *)creator;
//聊天室列表
- (void)demoRequestChatroomList;

//群列表
-(void)demoRequestGroupList;

//小课班列表
- (void)requestSourceList;

//群成员列表
-(void)demoRequestGroupMembers:(NSString *)groupID;

//获取authKey
+(void)getAuthKey:(NSString * ) userID
            appid:(NSString *) appid
              url:(NSString *)url
         callback:(void(^)(BOOL status, NSString * data))callback;

+(void)getAppConfigUrlParameter:(NSString*)parameter success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

@property (nonatomic, weak) id<InterfaceUrlsdelegate> delegate;

@end
