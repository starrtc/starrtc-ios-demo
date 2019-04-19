//
//  XHLoginManager.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/13.
//  Copyright © 2018年 Happy. All rights reserved.
//  登录IM

#import <Foundation/Foundation.h>
#import "XHConstants.h"

@protocol XHLoginManagerDelegate <NSObject>

/**
 连接状态发生变化

 @param state 状态
 */
- (void)connectionStateDidChange:(XHSDKConnectionState)state;

/**
  账户从其他设备登录
 */
- (void)userAccountDidLoginFromOtherDevice;

/**
 关闭啦，需要重新登录
 */
- (void)userAccountDidLogout;

@end



@interface XHLoginManager : NSObject

- (void)addDelegate:(id<XHLoginManagerDelegate>)delegate;

/**
 * 公有云，SDK账号登录
 * @param authKey 从服务器获取的授权码
 * @param completion 结果回调
 */
- (void)login:(NSString *)authKey completion:(void(^)(NSError *error))completion;

/**
 * 公有云，免登陆时调用 测试用
 * @param completion 结果回调
 */
- (void)loginPublic:(void(^)(NSError *error))completion;

/**
 * 私有部署服务时调用
 * @param completion 结果回调
 */
- (void)loginFree:(void(^)(NSError *error))completion;


- (void)logout;

@end
