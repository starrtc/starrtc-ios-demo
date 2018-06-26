//
//  EchoTest.h
//  monitor_001
//
//  Created by  Admin on 2018/5/9.
//  Copyright © 2018年 ndp_001_Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EchoTestDelegate <NSObject>

- (void)echoTestCallback:(int)index
                      len:(int)len
                 timeCost:(int)timeCost;

@end

@interface EchoTest : NSObject

- (void)addDelegate:(id<EchoTestDelegate>)delegate;

-(void)initEchoTest;

@end
