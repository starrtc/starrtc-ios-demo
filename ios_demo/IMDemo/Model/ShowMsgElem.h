//
//  ShowMsgElem.h
//  IMDemo
//
//  Created by  Admin on 2018/1/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowMsgElem : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isMySelf; //是否是自己消息

@property (nonatomic, assign) CGFloat rowHeight;

- (instancetype)initWithDict:(NSDictionary *)dict;


@end
