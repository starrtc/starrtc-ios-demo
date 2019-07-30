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

- (void)getListResponse:(id)responseContent;
- (void)getMessageGroupListResponse:(id)responseContent;
-(void)getGroupMemberList:(id)responseContent;
-(void)getDemoDeleteFromListFin:(id)responseContent;
-(void)getRtspForwardFin:(id)responseContent;
-(void)getRtspStopFin:(id)responseContent;
-(void)getRtspResumeFin:(id)responseContent;
-(void)getRtspDeleteFin:(id)responseContent;


// 暂时没用
- (void)getMeetingListResponse:(id)respnseContent;
- (void)getLiveListResponse:(id)respnseContent;
- (void)getChatRoomListResponse:(id)responseContent;

- (void)getMessageGroupMemberResponse:(id)respnseContent;

- (void)requestDidComplete:(id)respnseContent;
@end

@interface InterfaceUrls: NSObject


-(void)demoSaveTolist:(NSInteger)listType
                   ID:(NSString *)ID
                 data:(NSString *)data;


-(void)demoDeleteFromList:(NSString *)userId
                 listType:(NSString *)listType
                       roomId:(NSString *)roomId;


-(void)demoQueryList:(NSString *)listType;


-(void)demoQueryImGroupList:(NSString *)userId;

-(void)demoQueryImGroupInfo:(NSString *)userId
                    groupId:(NSString *)groupId;

// 转发rtsp流
-(void)demopushStreamUrl:(NSString *)userId
                  server:(NSString *)server
                    name:(NSString *)name
              chatroomId:(NSString *)chatroomId
                listType:(NSInteger)listType
              streamType:(NSString *)streamType
               streamUrl:(NSString *)streamUrl;

// 恢复转发rtsp流
-(void)demoResumePushRtsp:(NSString *)userId
                   server:(NSString *)server
                   liveId:(NSString *)liveId
                     rtsp:(NSString *)rtsp;

// 停止转发rtsp流
-(void)demoStopPushRtsp:(NSString *)userId
                 server:(NSString *)server
                 liveId:(NSString *)liveId;

//删除rtsp流记录
-(void)demoDeleteRtsp:(NSString *)userId
               server:(NSString *)server
               liveId:(NSString *)liveId;













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

- (void)reportChatroom:(NSInteger)listType
                    ID:(NSString *)ID
                  data:(NSString *)data;
//聊天室列表
- (void)demoRequestChatroomList:(NSInteger)listType;

//群列表
-(void)demoRequestGroupList;

//小课班列表
- (void)requestSourceList;

//群成员列表
-(void)demoRequestGroupMembers:(NSString *)groupID;

//公有部署下第三方流列表
- (void)requestForThirdStreamList;



//获取authKey
+(void)getAuthKey:(NSString * ) userID
            appid:(NSString *) appid
              url:(NSString *)url
         callback:(void(^)(BOOL status, NSString * data))callback;

+(void)getAppConfigUrlParameter:(NSString*)parameter success:(void(^)(id responseObject))success failure:(void(^)(NSError* error))failure;

@property (nonatomic, weak) id<InterfaceUrlsdelegate> delegate;

@end
