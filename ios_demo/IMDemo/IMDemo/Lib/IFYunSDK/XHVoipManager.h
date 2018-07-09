//
//  XHVoipManager.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/16.
//  Copyright © 2018年 Happy. All rights reserved.
//  一对一视频

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "XHVideoConfig.h"
#import "XHConstants.h"

@protocol XHVoipManagerDelegate <NSObject>

/*
 *收到呼叫
 * @fromID 对方ID
 */
- (void)onCalling:(NSString *)fromID;
/*
 *对方已挂断
 * @fromID 对方ID
 */
- (void)onHangup:(NSString *)fromID;

/*
 *对方已取消呼叫
 * @fromID 对方ID
 */
- (void)onCancled:(NSString *)fromID;

/*
 *呼叫被对方拒绝
 * @fromID 对方ID
 */
- (void)onRefused:(NSString *)fromID;

/*
 *对方线路正忙
 * @fromID 对方ID
 */
- (void)onBusy:(NSString *)fromID;

/*
 *对方接通
 * @fromID 对方ID
 */
- (void)onConnected:(NSString *)fromID;

/*
 *连接报错
 * @fromID 对方ID
 */
- (void)onError:(NSError *)error;

/*
 *成功挂断，可以正常关闭
 * @fromID 对方ID
 */
-(void)onStop:(NSString *)code;

@end

typedef NS_ENUM(NSInteger, XHVideoConnectionType)
{
    XHVideoConnectionType_Caller,  //主叫方
    XHVideoConnectionType_Callee   //被叫方
};


@interface XHVoipManager : NSObject

- (void)addDelegate:(id<XHVoipManagerDelegate>)delegate;

/**
 设置视频参数
 
 @param config 参数
 */
- (void)setVideoConfig:(XHVideoConfig *)config;

/**
 返回切换后的摄像头方向
 @return 切换后的摄像头方向
 */
- (XHCameraDirection)switchCamera;

/*
 *设置主方和对方的视频画面
 @param selfPreview 预览画面
 @param targetView 对方画面
 */
- (void)setupView:(UIView *)selfPreview targetView:(UIView *)targetView;

// --- 主叫方 ---

/**
  发起视频通话
  @param toID 呼叫对象
  @param completion 回调
  */
- (void)call:(NSString *)toID completion:(void(^)(NSError *error))completion;

/**
 取消视频通话
 @param toID 取消对象
 @param completion 回调
 */
- (void)cancel:(NSString *)toID completion:(void(^)(NSError *error))completion;

// --- 被叫方 ---

/**
 接收视频通话
 @param fromID 拨叫方
 @param completion 回调
 */
- (void)accept:(NSString *)fromID completion:(void(^)(NSError *error))completion;

/**
 拒绝视频通话
 @param fromID 拨叫方
 @param completion 回调
 */
- (void)refuse:(NSString *)fromID completion:(void(^)(NSError *error))completion;

// --- 双方 ---

/**
 挂断视频通话
 @param fromID 被挂断ID
 @param completion 回调
 */
- (void)hangup:(NSString *)fromID completion:(void(^)(NSError *error))completion;

// ~~~~~~~~~~~~~~~~~~~test for echoCancellation~~~~~~~~~~~~
-(void)setEchoCancellation:(BOOL)needEchoCancellation;

-(void)insert_AudioData:(Byte *)data
                    len:(UInt32)len;
//-(int)get_AudioData:(Byte *)readData;
-(Byte*)get_AudioData:(int *)readLength;

@end
