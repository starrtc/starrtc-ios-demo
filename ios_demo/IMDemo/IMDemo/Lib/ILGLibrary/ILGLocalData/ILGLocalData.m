//
//  ILGLocalData.m
//  ZCLibProjectDEV
//
//  Created by Happy on 8/27/16.
//  Copyright © 2016 Happy. All rights reserved.
//

#import "ILGLocalData.h"
#import "ILGSFHFKeychainUtils.h"

@implementation ILGLocalData
#pragma mark - NSUserDefaults
+ (void)userDefaultSave:(id)object key:(NSString *)key {
    if (!object) {
        NSLog(@"object for key:%@ is nil", key);
        return;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:object forKey:key];
    [userDefault synchronize];
}
+ (id)userDefaultObject:(NSString *)key {
    NSString *resultStr = nil;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    resultStr = [userDefault objectForKey:key];
    
    return resultStr;
}
+ (void)userDefaultRemoveObjectForKey:(NSString *)key {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:key];
    [userDefault synchronize];
}


#pragma mark - KeyChain
#define APP_BUNDLE_INDENTIFIER [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
+ (BOOL)keyChainSave:(NSString *)object account:(NSString *)account {
    NSError *error = nil;
    BOOL isSuccess = [ILGSFHFKeychainUtils storeUsername:account andPassword:object forServiceName:APP_BUNDLE_INDENTIFIER updateExisting:YES error:&error];
    return isSuccess;
}
+ (NSString *)keyChainObject:(NSString *)account {
    NSError *error = nil;
    NSString *resultStr = [ILGSFHFKeychainUtils getPasswordForUsername:account andServiceName:APP_BUNDLE_INDENTIFIER error:&error];
    return resultStr;
}
+ (BOOL)keyChainDeleteObjectForAccount:(NSString *)account {
    NSError *error = nil;
    BOOL isSuccess = [ILGSFHFKeychainUtils deleteItemForUsername:account andServiceName:APP_BUNDLE_INDENTIFIER error:&error];
    return isSuccess;
}


+ (BOOL)archiverSave:(id)object path:(NSString *)path {
    return [NSKeyedArchiver archiveRootObject:object toFile:path];
}
+ (id)unArchiverObject:(NSString *)path {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}


#pragma mark - 获取项目Preferences plist文件中的值
+ (id)preferencePlistObject:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    NSDictionary *plistDic = [[NSBundle mainBundle] infoDictionary];
    return [plistDic objectForKey:key];
}
#pragma mark -

+ (NSString *)pathForDocuments {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    return documentPath;
}
+ (NSString *)filePathFromDocuments:(NSString *)fileName {
    return [[self pathForDocuments] stringByAppendingPathComponent:fileName];
}
+ (BOOL)removeLocalFile:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    [fileManager removeItemAtPath:filePath error:&error];
    
    if (error) {
        NSLog(@"删除本地文件%@失败", filePath);
        return NO;
    }
    
    return YES;
}

@end
