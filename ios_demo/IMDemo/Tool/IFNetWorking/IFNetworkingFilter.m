//
//  IFNetworkingFilter.m
//  IfengSmallVideo
//
//  Created by Hanxiaojie on 2017/11/24.
//  Copyright © 2017年 凤凰新媒体. All rights reserved.
//

#import "IFNetworkingFilter.h"
#define IFCustomErrorDomain @"com.ifeng.error"
@interface IFNetworkingFilter()

@end

@implementation IFNetworkingFilter

+ (instancetype)shareManager {
    static IFNetworkingFilter *networkingFilter = nil;
    static dispatch_once_t oncetime;
    dispatch_once(&oncetime, ^{
        networkingFilter = [[IFNetworkingFilter alloc] init];
    });
    return networkingFilter;
}

- (void) addSessionDataTask:(NSURLSessionDataTask*)sessionTask responseObject:(id _Nullable)responseObject success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)sessionTask.response;
    
    NSLog(@"请求地址：%@",httpResponse.URL.absoluteString);
    switch ([httpResponse statusCode]) {
        case 200:  //表示该请求响应成功
        {
            /*
             
             在这里根据自己的项目需求进行信息过滤，例如登录、token 、服务器错误码处理
             
             */
            
            //这个地方不一定调用success回调，如果是服务器code码错误，建议调用failure
            success(sessionTask,responseObject);
            
            
//            if (responseObject) {
//                if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                    NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
//
//                    if (code == 200) {
//                        printf("请求结果：%s\n",[[responseObject objectForKey:@"desc"] UTF8String]);
//                        success(sessionTask,responseObject);
//                    } else if(code == 10101) {
//                        [self showLoginView];
//                        NSError *error = [NSError errorWithDomain:ISVCustomErrorDomain code:code userInfo:responseObject];
//                        failure(sessionTask,error);
//                    } else if([[responseObject objectForKey:@"infocode"] integerValue] == 10000){
//                        printf("请求结果：%s\n",[[responseObject objectForKey:@"desc"] UTF8String]);
//                        success(sessionTask,responseObject);
//                    }
//
//                    else if(failure){
//
//                        NSString *desc = [responseObject objectForKey:@"desc"];
//                        if ([NSString isEmpty:desc]) {
//                            desc = @"未找到 desc 字段";
//                        }
//                        [UIWindow ilg_makeToast:desc];
//                        printf("请求结果：%s\n",[desc UTF8String]);
//                        NSLog(@"%@",responseObject);
//                        NSError *error = [NSError errorWithDomain:ISVCustomErrorDomain code:code userInfo:responseObject];
//                        failure(sessionTask,error);
//                    }
//
//                } else {
//                    success(sessionTask,responseObject);
//                }
//                NSLog(@"%@",responseObject);
//            } else {
//                responseObject = [NSMutableDictionary dictionaryWithCapacity:4];
//                [responseObject setObject:@"200" forKey:@"code"];
//                [responseObject setObject:@"" forKey:@"data"];
//                [responseObject setObject:@"处理成功，返回数据为空" forKey:@"desc"];
//                [responseObject setObject:@"1" forKey:@"success"];
//                [responseObject setObject:[self getCurrentTimestamp] forKey:@"time"];
//                NSLog(@"%@",responseObject);
//                success(sessionTask,responseObject);
//            }

        }
            break;
            
        default:
        {
            if (failure) {
                NSString *desc = @"未知信息";
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:desc                                                                   forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:IFCustomErrorDomain code:[httpResponse statusCode] userInfo:userInfo];
                failure(sessionTask,error);
            }
        }
            break;
    }
}

- (void) addSessionDataTask:(NSURLSessionDataTask*)task failureError:(NSError * _Nonnull) error failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
    
    NSLog(@"请求地址：%@",httpResponse.URL.absoluteString);
    NSInteger code = error.code;
    NSLog(@"错误信息 = %@",error);
    switch (code) {
        case -1001:
//            [UIWindow ilg_makeToast:@"网络状况不好，请求超时！"];
            break;
        case -1004:
//            [UIWindow ilg_makeToast:@"阿偶！服务器去度假了，请稍后重试"];
            break;
        case -1009:
//            [UIWindow ilg_makeToast:@"亲！您是不是忘了打开网络连接"];
            break;
        default:
//            [UIWindow ilg_makeToast:@"服务器累的满头大汗，请稍后再试吧！"];
            break;
    }
    if (failure) {
        failure(task,error);
    }
    
}

@end
