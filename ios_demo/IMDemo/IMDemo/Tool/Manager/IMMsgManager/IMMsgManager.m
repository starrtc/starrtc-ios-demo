//
//  IMMsgManager.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/6/11.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IMMsgManager.h"

#import "ILGFMDBManager.h"

NSString * const kSessionTableName = @"C2CSesstionList";

@interface IMMsgManager () <XHChatManagerDelegate>

@end

@implementation IMMsgManager

static IMMsgManager *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[IMMsgManager alloc] init];
        
    });
    return instance;
}

- (void)addDelegateForC2CMsg {
    [[XHClient sharedClient].chatManager addDelegate:instance];
}

#pragma mark XHChatManagerDelegate
- (void)chatMessageDidReceived:(NSString *)message fromID:(NSString *)uid {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf saveC2CChatHistory:uid userID:uid msg:message isUnRead:![weakSelf.sessionIDForChating isEqualToString:uid]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:IMChatMsgReceiveNotif object:@{@"message":message, @"uid":uid}];
    });
}

- (void)saveSessionList:(NSString *)sessionID msg:(NSString *)msg isUnRead:(BOOL)isUnRead {
    NSString *createSql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ (sessionID text PRIMARY KEY, lastMsg text, lastTime text, unReadNum integer, iconColor text);", kSessionTableName];

    int number = isUnRead ? 1:0;
    NSString *lastTime = [NSDate ilg_timeStamp];
    if ([[ILGFMDBManager sharedInstance] executeUpdate:createSql]) {
        NSArray *array = [self lookupC2CSession:sessionID];
        if (array.count > 0) {
            int unReadNum = [array[0][@"unReadNum"] intValue] + number;
            NSString *sql = [NSString stringWithFormat:@"update %@ set lastMsg='%@',lastTime='%@',unReadNum='%d' where sessionID='%@';", kSessionTableName, msg, lastTime, unReadNum, sessionID];
            [[ILGFMDBManager sharedInstance] executeUpdate:sql];
            
        } else {
            NSString *iconColor = [UIColor ilg_randomColorHex];
            
            NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (sessionID, lastMsg, lastTime, unReadNum, iconColor) values ('%@', '%@', '%@', '%d', '%@');", kSessionTableName, sessionID, msg, lastTime, number, iconColor];
            [[ILGFMDBManager sharedInstance] executeUpdate:insertSql];
        }
        
    } else {
        
    }
}

- (int)unReadNumForSessionList {
    int unReadNum = 0;
    NSString *sql = [NSString stringWithFormat:@"select unReadNum from %@;", kSessionTableName];
    NSArray *array = [[ILGFMDBManager sharedInstance] executeQuery:sql];
    for (NSDictionary *dic in array) {
        unReadNum += [dic[@"unReadNum"] intValue];
    }
    return unReadNum;
}

- (NSArray *)lookupC2CSession:(NSString *)sessionID {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where sessionID = '%@';", kSessionTableName, sessionID];
    NSArray *array = [[ILGFMDBManager sharedInstance] executeQuery:sql];
    return array;
}

- (NSArray *)c2cSessionList {
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by lastTime DESC;", kSessionTableName];
    NSArray *result = [[ILGFMDBManager sharedInstance] executeQuery:sql];
    return result;
}

- (void)clearUnReadNumForSession:(NSString *)sessionID {
    NSString *sql = [NSString stringWithFormat:@"update %@ set unReadNum=0 where sessionID='%@';", kSessionTableName, sessionID];
    [[ILGFMDBManager sharedInstance] executeUpdate:sql];
}

- (void)saveC2CChatHistory:(NSString *)sessionID userID:(NSString *)uid msg:(NSString *)message isUnRead:(BOOL)isUnRead {
    NSString *tableName = [@"chatCecord" stringByAppendingString:sessionID];
    NSString *createSql = [NSString stringWithFormat:@"create table IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, userID text, message text, lastTime text, unReadNum integer, iconColor text);", tableName];
    
    NSString *lastTime = [NSDate ilg_timeStamp];
    if ([[ILGFMDBManager sharedInstance] executeUpdate:createSql]) {
        int unReadNum = isUnRead ? 1:0;
        NSString *iconColor = [UIColor ilg_randomColorHex];

        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (userID, message, lastTime, unReadNum, iconColor) values ('%@', '%@', '%@', '%d', '%@');", tableName, uid, message, lastTime, unReadNum, iconColor];
        [[ILGFMDBManager sharedInstance] executeUpdate:insertSql];
        
    } else {
        
    }
    
    [self saveSessionList:sessionID msg:message isUnRead:isUnRead];
}

- (NSArray *)c2cChatHistory:(NSString *)sessionID {
    NSString *tableName = [@"chatCecord" stringByAppendingString:sessionID];
    NSString *sql = [NSString stringWithFormat:@"select * from %@;", tableName];
    NSArray *result = [[ILGFMDBManager sharedInstance] executeQuery:sql];
    return result;
}
@end
