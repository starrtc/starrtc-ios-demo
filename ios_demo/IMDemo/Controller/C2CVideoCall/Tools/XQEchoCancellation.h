//
//  XQEchoCancellation.h
//  iOSEchoCancellation
//
//  Created by xxb on 2017/8/25.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum : NSUInteger {
    XQEchoCancellationRate_16k = 16000,
    XQEchoCancellationRate_20k = 20000,
    XQEchoCancellationRate_44k = 44100,
    XQEchoCancellationRate_96k = 96000
} XQEchoCancellationRate;

#define kRate (XQEchoCancellationRate_16k) //采样率
#define kChannels   (1)//声道数
#define kBits       (16)//位数


typedef enum : NSUInteger {
    XQEchoCancellationStatus_open,
    XQEchoCancellationStatus_close
} XQEchoCancellationStatus;

typedef void (^XQEchoCancellation_inputBlock)(AudioBufferList *bufferList);
typedef void (^XQEchoCancellation_outputBlock)(AudioBufferList *bufferList,UInt32 inNumberFrames);

@interface XQEchoCancellation : NSObject
///是否开启了回声消除
@property (nonatomic,assign,readonly) XQEchoCancellationStatus echoCancellationStatus;
@property (nonatomic,assign,readonly) AudioStreamBasicDescription streamFormat;
///录音的回调，回调的参数为从麦克风采集到的声音
@property (nonatomic,copy) XQEchoCancellation_inputBlock bl_input;
///播放的回调，回调的参数 buffer 为要向播放设备（扬声器、耳机、听筒等）传的数据，在回调里把数据传给 buffer
@property (nonatomic,copy) XQEchoCancellation_outputBlock bl_output;

+ (instancetype)shared;
+ (instancetype)manager;
- (void)startInput;
- (void)stopInput;

- (void)startOutput;
- (void)stopOutput;

- (void)openEchoCancellation;
- (void)closeEchoCancellation;

///开启服务，需要另外去开启 input 或者 output 功能
- (void)startService;

- (void)start;
///停止所有功能（包括录音和播放）
- (void)stop;

// 音量控制 
// output: para1 输出数据
// input : para2 输入数据
//         para3 输入长度
//         para4 音量控制参数,有效控制范围[0,100]
// 超过100，则为倍数，倍数为in_vol减去98的数值
+ (void)volume_controlOut_buf:(short *)out_buf in_buf:(short *)in_buf in_len:(int)in_len in_vol:(float)in_vol;

@end
