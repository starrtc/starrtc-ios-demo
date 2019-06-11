//
//  XHBeautyManager.h
//  starLibrary
//
//  Created by  Admin on 2019/6/3.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarVideoData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XHBeautyManagerDelegate <NSObject>

/**
 收到待处理的美颜数据
 @param videoData 数据
 */
-(void) onFrame:(StarVideoData *) videoData;

@end


@interface XHBeautyManager : NSObject

- (void)addDelegate:(id<XHBeautyManagerDelegate>)delegate;

/**
 * 回填处理后的视频数据入列备用
 * @param videoData 处理后的视频数据
 */
-(void) backfillData:(StarVideoData *) videoData;

@end

NS_ASSUME_NONNULL_END
