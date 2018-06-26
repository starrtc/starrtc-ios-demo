//
//  AppConfig.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/5/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (instancetype)shareConfig;

- (BOOL)liveEnable;
- (void)checkAppConfig;

@end
