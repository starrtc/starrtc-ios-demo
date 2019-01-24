//
//  IFNetworking.m
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/23.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import "IFNetworking.h"
#import "AFNetworking.h"
#import "IFNetworkingFilter.h"
static NSInteger IFRequestTime = 15;
static IFNetworkReachabilityStatus networkReachabilityStatus = IFNetworkReachabilityStatusUnknown;

@interface IFNetworking ()
{
    AFHTTPSessionManager * _sessionManager;
    
}
@end

@implementation IFNetworking

+ (void)load {
    [super load];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        networkReachabilityStatus = (IFNetworkReachabilityStatus)status;
        [[NSNotificationCenter defaultCenter] postNotificationName:IFNetworkReachabilityStatusChangeNotification object:nil userInfo:@{@"AFNetworkReachabilityStatus":@(status)}];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer.timeoutInterval = IFRequestTime;  //设置请求超时时间
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        _timeoutInterval = 15;
    }
    return self;
}

+ (instancetype)manager {
    return [[[IFNetworking class] alloc] init];
}

//+ (instancetype)shareManager {
//    static IFNetworking *networkingManage = nil;
//    static dispatch_once_t oncetime;
//    dispatch_once(&oncetime, ^{
//        networkingManage = [[IFNetworking alloc] init];
//    });
//    return networkingManage;
//}

+ (NSString*)networkingStatus {
    NSString *status = nil;
    switch (networkReachabilityStatus) {
        case IFNetworkReachabilityStatusUnknown:
            status = @"Unknown";
            break;
        case IFNetworkReachabilityStatusNotReachable:
            status = @"NotReachable";
            break;
        case IFNetworkReachabilityStatusReachableViaWWAN:
            status = @"WWAN";
            break;
        case IFNetworkReachabilityStatusReachableViaWiFi:
            status = @"WiFi";
            break;
        default:
            break;
    }
    return status;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
    _sessionManager.requestSerializer.timeoutInterval = timeoutInterval;
    _timeoutInterval = timeoutInterval;
}

- (void)setRequestSerializer:(IFSerializer)requestSerializer {
    _requestSerializer = requestSerializer;
    switch (requestSerializer) {
        case IFHTTPSerializer:
            _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case IFJSONSerializer:
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;

        default:
            _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
    }
}
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

//Post请求
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable id)parameters
      success:(nullable void (^)(NSURLSessionDataTask * task, id _Nullable responseObject))success
      failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    
    [_sessionManager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //添加过滤器，对数据进行过滤
        [[IFNetworkingFilter shareManager] addSessionDataTask:task responseObject:responseObject success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//Get请求
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure{
    [_sessionManager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:success failure:failure];
}


@end
