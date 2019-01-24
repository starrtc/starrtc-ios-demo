//
//  IFNetworkingManage.h
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/9.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

/*
 *本类主要是对接口进行二次处理，例如，加签名、md5、设置超时、缓存策略
 *需要使用者，根据视不同业务，对IFNetworking类封装不同的get、post、delete、put请求
 *
 */
 
 
#import <Foundation/Foundation.h>
#import "IFNetworking.h"
typedef NS_ENUM(NSUInteger, IFRequestCachePolicy){
    IFRequestDefaultCachePolicy = 1,             //默认缓存策略，对特定的 URL 请求使用网络协议中实现的缓存逻辑
    IFRequestReturnCacheDataElseLoad = 2,        //无论缓存是否过期，先使用本地缓存数据。如果缓存中没有请求所对应的数据，那么从原始地址加载数据。
    IFRequestReturnLocalCacheDataWhenFailure = 3,//当网络请求失败的时候，返回本地缓存数据
};

@interface IFNetworkingManager : NSObject
NS_ASSUME_NONNULL_BEGIN

+ (instancetype)manager;

@property (nonatomic, assign) IFSerializer requestSerializer;

//设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

//Get请求封装示例
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable id)parameters
     success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
     failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


//如果需要别的请求方式，直接在这里添加

NS_ASSUME_NONNULL_END
@end
