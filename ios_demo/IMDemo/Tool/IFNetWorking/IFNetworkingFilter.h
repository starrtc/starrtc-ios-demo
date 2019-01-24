//
//  IFNetworkingFilter.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/24.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//
/*
 * IFNetworkingFilter主要是进行数据过滤操作
 */
#import <Foundation/Foundation.h>

@interface IFNetworkingFilter : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (instancetype)shareManager;

- (void) addSessionDataTask:(NSURLSessionDataTask*)task responseObject:(id _Nullable)responseObject success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;
- (void) addSessionDataTask:(NSURLSessionDataTask*)task failureError:(NSError * _Nonnull) error failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

NS_ASSUME_NONNULL_END
@end
