//
//  AppConfig.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/5/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *loginHost;
@property (nonatomic, strong) NSString *messageHost;
@property (nonatomic, strong) NSString *chatHost;
@property (nonatomic, strong) NSString *uploadHost;
@property (nonatomic, strong) NSString *downloadHost;
@property (nonatomic, strong) NSString *voipHost;
@property (nonatomic, assign) BOOL audioEnabled;
@property (nonatomic, assign) BOOL videoEnabled;

+ (instancetype)shareConfig;

- (BOOL)liveEnable;
- (void)checkAppConfig;

@end
