//
//  XHVideoConfig.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/17.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHConstants.h"

@interface XHVideoConfig : NSObject
@property (nonatomic, assign) XHCropTypeEnum resolution; //分辨率
@property (nonatomic, assign) BOOL openGLEnable; //YES表示使用openGL渲染
@property (nonatomic, assign) BOOL hwEncodeEnable;//YES表示使用硬编码
@property (nonatomic, assign) BOOL videoEnable;  //YES表示使用视频
@property (nonatomic, assign) BOOL audioEnable;  //YES表示使用音频
@property (nonatomic, assign) BOOL dynamicBitrateAndFPSEnable;  //YES表示使用动态调节帧率码率
@property (nonatomic, assign) BOOL voipP2PEnable;  //YES表示使用voip p2p 模式
@property (nonatomic, assign) int bigVideoBitrate;  //大图码率
@property (nonatomic, assign) int bigVideoFPS;  //大图帧率
@property (nonatomic, assign) int smallVideoBitrate;  //小图码率
@property (nonatomic, assign) int smallVideoFPS;  //小图帧率
@property (nonatomic, assign) XHAudioCodecConfigEnum audioCodecType;
@property (nonatomic, assign) XHVideoCodecConfigEnum videoCodecType;
+ (instancetype)defaultConfig;

@end
