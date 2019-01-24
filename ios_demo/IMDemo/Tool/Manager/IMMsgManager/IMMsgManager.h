//
//  IMMsgManager.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/6/11.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMMsgManager : NSObject
@property (nonatomic, copy) NSString *sessionIDForChating;


+ (instancetype)sharedInstance;

- (void)addDelegateForC2CMsg;

- (void)saveSessionList:(NSString *)sessionID msg:(NSString *)msg isUnRead:(BOOL)isUnRead;
- (NSArray *)c2cSessionList;
- (int)unReadNumForSessionList;
- (NSArray *)lookupC2CSession:(NSString *)sessionID;
- (void)clearUnReadNumForSession:(NSString *)sessionID;

- (void)saveC2CChatHistory:(NSString *)sessionID userID:(NSString *)uid msg:(NSString *)message isUnRead:(BOOL)isUnRead;
- (NSArray *)c2cChatHistory:(NSString *)sessionID;
@end
