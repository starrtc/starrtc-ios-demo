//
//  SpeechRoomModel.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpeechRoomModel : NSObject

@property (nonatomic, strong) NSString *creatorID;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *liveName;

@property (nonatomic, assign) NSInteger liveState;

@property (nonatomic, copy) NSString *userIcon; //用户头像
@property (nonatomic, copy) NSString *coverIcon; //封面

@end

NS_ASSUME_NONNULL_END
