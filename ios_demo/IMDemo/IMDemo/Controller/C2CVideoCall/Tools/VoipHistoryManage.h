//
//  VoipHistoryManage.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/5/8.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoipHistoryManage : NSObject

+ (instancetype)manage;

- (NSMutableArray*)getHistoryVoipList;
- (void)deleteVoip:(NSString*)userId;
- (void)addVoip:(NSString*)userId;
- (void)visitUserInfoWithUserId:(NSString*)userId;
- (void)sortList;

@end
