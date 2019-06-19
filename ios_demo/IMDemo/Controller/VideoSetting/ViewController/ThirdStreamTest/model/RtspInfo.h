//
//  RtspInfo.h
//  IMDemo
//
//  Created by  Admin on 2019/6/14.
//  Copyright © 2019年  Admin. All rights reserved.
//

#ifndef RtspInfo_h
#define RtspInfo_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtspInfo : NSObject

@property (nonatomic, strong) NSString *Creator;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *Name;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSString *isLiveOn;

@property (nonatomic, assign) NSString *rtsp;


@end

NS_ASSUME_NONNULL_END

#endif /* RtspInfo_h */
