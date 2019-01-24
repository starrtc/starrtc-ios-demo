//
//  SpeechMessageModel.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechMessageModel.h"

@implementation SpeechMessageModel
- (instancetype)initWithNickname:(NSString*)nickname content:(NSString*)content{
    if (self = [super init]) {
        self.nickname = nickname;
        self.content = content;
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    [super setValue:value forUndefinedKey:key];
}
@end
