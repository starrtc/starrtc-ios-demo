//
//  IFNetworking.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/23.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IFNetworkReachabilityStatusChangeNotification @"ifeng.networking.change"

typedef NS_ENUM(NSInteger, IFNetworkReachabilityStatus) {
    IFNetworkReachabilityStatusUnknown          = -1,
    IFNetworkReachabilityStatusNotReachable     = 0,
    IFNetworkReachabilityStatusReachableViaWWAN = 1,
    IFNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSInteger, IFSerializer) {
    IFHTTPSerializer          = 0,
    IFJSONSerializer     = 1,
};


@interface IFNetworking : NSObject

NS_ASSUME_NONNULL_BEGIN

//设置超时时间
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) IFSerializer requestSerializer;
@property (nonatomic, assign) IFSerializer responseSerializer;

//设置请求格式

//设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

+ (instancetype)manager;
+ (NSString*)networkingStatus;

//Post请求
- (void) POST:(nullable NSString *)URLString
       parameters:(nullable id)parameters
          success:(nullable void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
          failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

//Get请求
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

NS_ASSUME_NONNULL_END

@end
