//
//  XHBeautyManager.h
//  starLibrary
//
//  Created by  Admin on 2019/6/3.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StarVideoData.h"
#import "StarAudioData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XHVideoSourceDelegate <NSObject>

/**
 暴露每帧视频数据(同步返回处理后的数据)
 @param videoData 数据
 */
-(StarVideoData *) onVideoFrame:(StarVideoData *) videoData;


/**
 暴露每帧音频数据(同步返回处理后的数据)
 @param audioData 数据
 */
-(StarAudioData *) onAudioFrame:(StarAudioData *) audioData;



@end


@interface XHVideoSource : NSObject

- (void)addDelegate:(id<XHVideoSourceDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END
