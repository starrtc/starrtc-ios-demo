//
//  ILGFMDBManager.h
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2018/6/11.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILGFMDBManager : NSObject

+ (instancetype)sharedInstance;

/**
 配置数据库路径，如果不指定，则使用默认的

 @param DBPath 路径
 */
- (void)configDBPath:(NSString *)DBPath;

- (BOOL)executeUpdate:(NSString *)sqlStr;

- (NSArray *)executeQuery:(NSString *)sqlStr;

@end
