//
//  IFNetworkingManage.m
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/9.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import "IFNetworkingManager.h"
#import "MD5Util.h"
#import "AFNetworking.h"
#import "IFNetworkingFilter.h"
#define IFRequestTime 15
#define SignKey @"ifengifeng"

@interface IFNetworkingManager ()

@property (nonatomic, strong) IFNetworking *manager;

@end

@implementation IFNetworkingManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [IFNetworking manager];
    }
    return self;
}
+ (instancetype) manager {
    return [[self alloc] init];
}
+ (instancetype)shareManager {
    static IFNetworkingManager *networkingManager = nil;
    static dispatch_once_t oncetime;
    dispatch_once(&oncetime, ^{
        networkingManager = [[IFNetworkingManager alloc] init];
    });
    return networkingManager;
}

//设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [self.manager setValue:value forHTTPHeaderField:field];
}
//请求类型
- (void)setRequestSerializer:(IFSerializer)requestSerializer {
    [self.manager setRequestSerializer:requestSerializer];
}


//Get请求
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    
    
    
    [self.manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功的数据进行过滤
        [[IFNetworkingFilter shareManager] addSessionDataTask:task responseObject:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败的数据进行过滤
        [[IFNetworkingFilter shareManager] addSessionDataTask:task failureError:error failure:failure];
    }];
    
}

@end
