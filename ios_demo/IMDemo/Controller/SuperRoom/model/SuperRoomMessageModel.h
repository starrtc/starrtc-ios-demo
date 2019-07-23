//
//  SpeechMessageModel.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomMessageModel : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic) BOOL isMic;
@property (nonatomic, strong) NSString *content;
- (instancetype)initWithNickname:(NSString*)nickname content:(NSString*)content;

@end

NS_ASSUME_NONNULL_END
