//
//  IFNetworkingInterface.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/9.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

/*
 整个项目中，所有的接口，都在本类中进行封装，优点：控制器只负责调起请求，传送参数，获取数据。与此同时控制器不再关心该接口请求的方式，参数格式化，以及所要连接的服务器地址。
 */
#import <Foundation/Foundation.h>

@interface IFNetworkingInterfaceHandle : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (NSString*)businessUrl;

#pragma mark-----首页接口示例-------
/**
 接口请求封装示例

 @param parameters 请求参数
 @param success 请求成功的回调
 @param failure 请求失败的回调
 */
+ (void)requestAudioListWithParameters:(NSDictionary*) parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;
+ (void)requestCreateAudioRoomWithParameters:(NSDictionary*) parameters success:(nullable void (^)(id _Nullable responseObject))success failure:(nullable void (^)(NSError *error))failure;
NS_ASSUME_NONNULL_END

@end

