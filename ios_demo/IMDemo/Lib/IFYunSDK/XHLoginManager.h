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

- (void)login:(NSString *)account authKey:(NSString *)authKey completion:(void(^)(NSError *error))completion;

- (void)logout;

@end
