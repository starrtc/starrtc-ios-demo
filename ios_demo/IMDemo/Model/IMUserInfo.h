//
//  IMUserInfo.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMUserInfo : NSObject

@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSMutableArray *c2cSessionList;

+ (instancetype)shareInstance;

- (UIColor *)listIconColor:(NSString *)key;

@end
