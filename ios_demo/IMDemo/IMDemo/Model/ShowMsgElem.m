//
//  ShowMsgElem.m
//  IMDemo
//
//  Created by  Admin on 2018/1/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "ShowMsgElem.h"

@implementation ShowMsgElem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        _userID = dict[@"userId"];
        _text = dict[@"text"];
    }
    return self;
}

@end
