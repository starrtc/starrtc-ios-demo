//
//  VoipHistoryManage.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/5/8.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipHistoryManage.h"
@interface VoipHistoryManage ()
{
    NSMutableArray *_memoryVoipHistoryList;
    
}

@end
@implementation VoipHistoryManage

+ (instancetype)manage{
    static VoipHistoryManage * shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _memoryVoipHistoryList = [NSMutableArray arrayWithCapacity:20];
        NSArray *list = [[NSUserDefaults standardUserDefaults] objectForKey:@"VOIPLIST"];
        if (list == nil) {
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"VOIPLIST"];
            list = @[];
        } else if([list count] > 0 && [list[0] isKindOfClass:[NSString class]]){
            [[NSUserDefaults standardUserDefaults] setObject:@[] forKey:@"VOIPLIST"];
            list = @[];
        }
        [self initMemoryVoipHistoryWithDataSource:list];
    }
    return self;
}

- (void)initMemoryVoipHistoryWithDataSource:(NSArray*)list{
    
    [_memoryVoipHistoryList removeAllObjects];
    if (list && [list count] > 0) {
        for (NSDictionary *userInfo in list) {
            NSMutableDictionary * mutUserInfo = [NSMutableDictionary dictionaryWithCapacity:2];
            [mutUserInfo setObject:userInfo[@"userId"] forKey:@"userId"];
            if (userInfo[@"visitTime"]) {
                [mutUserInfo setObject:userInfo[@"visitTime"] forKey:@"visitTime"];
            } else {
                [mutUserInfo setObject:@([NSDate date].timeIntervalSince1970) forKey:@"visitTime"];
            }
            [_memoryVoipHistoryList addObject:mutUserInfo];
        }
    }
}

- (NSMutableArray*)getHistoryVoipList{
    return _memoryVoipHistoryList;
}

- (void)deleteVoip:(NSString*)userId{
    if (userId && ![userId   isEqualToString:@""] && [_memoryVoipHistoryList count] > 0 ) {
        BOOL flag = NO;
        for (NSInteger i = 0; i < _memoryVoipHistoryList.count; i ++) {
            NSMutableDictionary * dic = _memoryVoipHistoryList[i];
            if ([[dic objectForKey:@"userId"] isEqualToString:userId]) {
                [_memoryVoipHistoryList removeObjectAtIndex:i];
                flag = YES;
                break;
            }
        }
        if (flag) {
            [[NSUserDefaults standardUserDefaults] setObject:_memoryVoipHistoryList forKey:@"VOIPLIST"];
        }
    }
}
- (void)addVoip:(NSString*)userId{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (userId && ![userId isEqualToString:@""]) {
            BOOL flag = NO;
            for (NSInteger i = 0; i < _memoryVoipHistoryList.count; i ++) {
                NSMutableDictionary * dic = _memoryVoipHistoryList[i];
                if ([[dic objectForKey:@"userId"] isEqualToString:userId]) {
                    [dic setObject:@([NSDate date].timeIntervalSince1970) forKey:@"visitTime"];
                    flag = YES;
                    break;
                }
            }
            if (flag == NO) {
                NSMutableDictionary * userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
                [userInfo setObject:userId forKey:@"userId"];
                [userInfo setObject:@([NSDate date].timeIntervalSince1970) forKey:@"visitTime"];
                [_memoryVoipHistoryList addObject:userInfo];
            }
            [[NSUserDefaults standardUserDefaults] setObject:_memoryVoipHistoryList forKey:@"VOIPLIST"];
           
            
        } else {
            NSLog(@"addVoip 不能为 nil");
        }
    });
    
}

- (void)visitUserInfoWithUserId:(NSString*)userId{
    BOOL flag = NO;
    for (NSInteger i = 0; i < _memoryVoipHistoryList.count; i ++) {
        NSMutableDictionary * dic = _memoryVoipHistoryList[i];
        if ([[dic objectForKey:@"userId"] isEqualToString:userId]) {
            [dic setObject:@([NSDate date].timeIntervalSince1970) forKey:@"visitTime"];
            flag = YES;
            break;
        }
    }
    if (flag) {
        [[NSUserDefaults standardUserDefaults] setObject:_memoryVoipHistoryList forKey:@"VOIPLIST"];
    }
}

- (void)sortList{
    [_memoryVoipHistoryList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2[@"visitTime"] compare:obj1[@"visitTime"]];
    }];
}
@end
