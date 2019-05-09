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

@interface XHCustomConfig : NSObject

@property (nonatomic, assign)   NSString *appId;
@property (nonatomic, assign)   NSString * loginServerUrl;
@property (nonatomic, assign)   NSString *imScheduleUrl;
@property (nonatomic, assign)   NSString *liveSrcScheduleUrl;
@property (nonatomic, assign)   NSString * liveVdnScheduleUrl;
@property (nonatomic, assign)   NSString * chatroomScheduleUrl;
@property (nonatomic, assign)   NSString * voipServerUrl;
@property (nonatomic, assign)   NSString * imServerUrl;;
@property (nonatomic, assign)   NSString * chatroomServerUrl;
@property (nonatomic, assign)   NSString * liveSrcServerUrl;
@property (nonatomic, assign)   NSString * liveVdnServerUrl;

//  正常SDK登录
-(void)initSDK:(NSString *)userId
         appId:appId;

// 暂时没用
-(void)initSDKWithoutAudioCheck:(NSString *)userId;

// 开放版SDK初始化
-(void)initSDKForFree:(NSString *)userId
                appId:(NSString *)appId;


@end
#endif /* XHCustomConfig_h */
