//
//  ILGLocalData.h
//  ZCLibProjectDEV
//
//  Created by Happy on 8/27/16.
//  Copyright © 2016 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILGLocalData : NSObject
/**
 *  NSUserDefaults保存、获取和删除数据
 */
+ (void)userDefaultSave:(id)object key:(NSString *)key;
+ (id)userDefaultObject:(NSString *)key;
+ (void)userDefaultRemoveObjectForKey:(NSString *)key;

/**
 *  KeyChain保存、获取和删除数据
 */
+ (BOOL)keyChainSave:(NSString *)object account:(NSString *)account;
+ (NSString *)keyChainObject:(NSString *)account;
+ (BOOL)keyChainDeleteObjectForAccount:(NSString *)account;


/**
 *  获取项目Preferences plist文件中的值
 *
 *  @param key key
 *
 *  CFBundleShortVersionString, CFBundleVersion
 */
+ (id)preferencePlistObject:(NSString *)key;

+ (NSString *)pathForDocuments;
+ (NSString *)filePathFromDocuments:(NSString *)fileName;
+ (BOOL)removeLocalFile:(NSString *)filePath;


+ (BOOL)archiverSave:(id)object path:(NSString *)path;
+ (id)unArchiverObject:(NSString *)path;
@end
