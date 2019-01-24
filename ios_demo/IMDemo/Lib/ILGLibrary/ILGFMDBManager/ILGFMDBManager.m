//
//  ILGFMDBManager.m
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2018/6/11.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import "ILGFMDBManager.h"

#if __has_include("FMDB.h")
#import "FMDB.h"
#define ILGFMDBIsIncluded 1
#endif

@interface ILGFMDBManager ()
#ifdef ILGFMDBIsIncluded
@property (nonatomic, strong) FMDatabase *dataBase;
#endif
@end

@implementation ILGFMDBManager

static ILGFMDBManager *instance = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ILGFMDBManager alloc] init];
    });
    return instance;
}

- (void)configDBPath:(NSString *)DBPath {
#ifdef ILGFMDBIsIncluded
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:DBPath];
    }
#endif
}

- (BOOL)executeUpdate:(NSString *)sqlStr {
#ifdef ILGFMDBIsIncluded
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:[self pathForDataBase:@"defaultDBName.sqlite"]];
    }
    
    if ([self.dataBase open]) {
        BOOL result = [self.dataBase executeUpdate:sqlStr];
        [self.dataBase close];
        return result;
    } else {
        return NO;
    }
#else
    return NO;
#endif
}

- (NSArray *)executeQuery:(NSString *)sqlStr {
#ifdef ILGFMDBIsIncluded
    if (!_dataBase) {
        _dataBase = [FMDatabase databaseWithPath:[self pathForDataBase:@"defaultDBName.sqlite"]];
    }
    
    if ([self.dataBase open]) {
        FMResultSet *resultSet = [self.dataBase executeQuery:sqlStr];
        
        NSMutableArray *array = [NSMutableArray array];
        while ([resultSet next]) {
            NSDictionary *dic = [resultSet resultDictionary];
            [array addObject:dic];
        }
        
        [self.dataBase close];
        
        return array;
    } else {
        return nil;
    }
#else
    return nil;
#endif
}

#pragma mark - Other

- (NSString *)pathForDataBase:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    return [documentPath stringByAppendingPathComponent:name];
}

@end
