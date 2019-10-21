//
//  StarAudioData.h
//  starLibrary
//
//  Created by  Admin on 2019/10/18.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StarAudioData : NSObject
@property (atomic) unsigned char * data;
@property (atomic) long dataLength;
@property (atomic) long index;



@end

NS_ASSUME_NONNULL_END
