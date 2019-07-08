//
//  SpeechRoomModel.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperRoomModel : NSObject

@property (nonatomic, strong) NSString *Creator;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *Name;

@property (nonatomic, assign) NSInteger liveState;

@end

NS_ASSUME_NONNULL_END
