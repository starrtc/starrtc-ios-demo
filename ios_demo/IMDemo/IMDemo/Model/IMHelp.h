//
//  IMHelp.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SenderVoipVideoVC.h"
@interface IMHelp : NSObject

+ (instancetype)shareManager;

@property (nonatomic, weak) UIViewController * delegate;

- (void)startMonitoring;
- (void)stopMonitoring;

- (void)clearHelp;

@end
