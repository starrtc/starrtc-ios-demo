//
//  XHConstants.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/19.
//  Copyright © 2018年 Happy. All rights reserved.
//

#ifndef XHConstants_h
#define XHConstants_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XHSDKConnectionState) {
    XHSDKConnectionStateDisconnect = 1, //断开连接
    XHSDKConnectionStateReconnect //重新连接成功
};
////消息推送設置
//  NSString * IOS_MSG_PUSH_MODE_ALL_OFF = @"MSG_PUSH_MODE_ALL_OFF";        //关闭所有推送
//  NSString * IOS_MSG_PUSH_MODE_ALL_ON = @"MSG_PUSH_MODE_ALL_ON";        //开启所有推送
//  NSString * IOS_MSG_PUSH_MODE_ONLY_CALLING = @"MSG_PUSH_MODE_ONLY_CALLING";   //仅开启推送voip通话请求信息

typedef NS_ENUM(NSInteger, XHChatroomType) {
    //会议类型
    XHChatroomTypePublic=1 , //无需登录和验证
    XHChatroomTypeLogin  //需要登录，无需验证
};


typedef NS_ENUM(NSInteger, XHCameraDirection) {
    XHCameraDirectionFront, //前置摄像头
    XHCameraDirectionBack //后置摄像头
};

typedef NS_ENUM(NSInteger, XHMeetingType) {
    XHMeetingTypeGlobalPublic, //无需登录和验证
    XHMeetingTypeLoginPublic, //需要登录，无需验证
    XHMeetingTypeLoginSpecXHy //需要登录和验证
};

typedef NS_ENUM(NSInteger, XHLiveJoinResult)
{
    //加入直播的结果
    XHLiveJoinResult_Accept,
    XHLiveJoinResult_refuse,
    XHLiveJoinResult_outtime
};

typedef NS_ENUM(NSInteger, XHLiveType) {
    XHLiveTypeGlobalPublic, //无需登录和验证
    XHLiveTypeLoginPublic, //需要登录，无需验证
    XHLiveTypeLoginSpecXHy //需要登录和验证
};


typedef NS_ENUM(NSInteger, XHMediaEcodeConfigEnum)
{
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_H264_AAC,
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_H264_OPUS,
    
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_H265_AAC,
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_H265_OPUS,
    
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_VP9_AAC,
    IOS_Star_VIDEO_AND_AUDIO_CODEC_CONFIG_VP9_OPUS
};

typedef NS_ENUM(NSInteger, XHCropTypeEnum) {
    
    IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE,         //0
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE,         //1
    IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE,        //2
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE,        //3
    
    
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_80SW_160SH,        //4
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_112SW_160SH,        //5
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_160SW_160SH,        //6
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_176SW_320SH,        //7
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_240SW_320SH,        //8
    IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_320SW_320SH,        //9
    
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_80SW_160SH,        //10
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_112SW_160SH,    //11
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_160SW_160SH,    //12
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_176SW_320SH,    //13
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH,    //14
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_320SW_320SH,    //15
};
typedef NS_ENUM(NSInteger, XHCodecTypeEnum)
{
    IOS_STAR_VIDEO_ENC_CONFIG_NOT_USE,                                //0
    
    //hw big
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_CUSTOM_PARAMS,                 //1 //硬編大圖自定義參數
    IOS_STAR_VIDEO_ENC_CONFIG_HW_368W_640H_FPS15_RATE500_GOP15,        //2
    IOS_STAR_VIDEO_ENC_CONFIG_HW_368W_640H_FPS15_RATE500_GOP30,        //3
    IOS_STAR_VIDEO_ENC_CONFIG_HW_368W_640H_FPS15_RATE500_GOP45,        //4
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_480W_480H_FPS15_RATE500_GOP45,        //5
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_720W_1280H_FPS15_RATE800_GOP15,    //6
    IOS_STAR_VIDEO_ENC_CONFIG_HW_720W_1280H_FPS15_RATE800_GOP30,    //7
    IOS_STAR_VIDEO_ENC_CONFIG_HW_720W_1280H_FPS15_RATE800_GOP45,    //8
    
    //small
    IOS_STAR_VIDEO_ENC_CONFIG_SF_80W_160H_FPS5_RATE50_GOP15,         //9 //适合一行放4个预览图
    IOS_STAR_VIDEO_ENC_CONFIG_SF_112W_160H_FPS5_RATE60_GOP15,         //10 //适合一行放3个预览图
    IOS_STAR_VIDEO_ENC_CONFIG_SF_160W_160H_FPS5_RATE70_GOP15,         //11 //适合一行放2个预览图
    IOS_STAR_VIDEO_ENC_CONFIG_SF_176W_320H_FPS5_RATE80_GOP15,        //12 //适合一行放4个预览图
    IOS_STAR_VIDEO_ENC_CONFIG_SF_240W_320H_FPS5_RATE90_GOP15,        //13 //适合一行放3个预览图
    IOS_STAR_VIDEO_ENC_CONFIG_SF_320W_320H_FPS5_RATE100_GOP15,        //14 //适合一行放2个预览图
    
    //big
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_CUSTOM_PARAMS,                 //15 //軟編大圖自定義參數
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_368W_640H_FPS15_RATE500_GOP15,        //16
    IOS_STAR_VIDEO_ENC_CONFIG_SF_368W_640H_FPS15_RATE500_GOP30,        //17
    IOS_STAR_VIDEO_ENC_CONFIG_SF_368W_640H_FPS15_RATE500_GOP45,        //18
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_480W_480H_FPS15_RATE500_GOP45,        //19
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_720W_1280H_FPS15_RATE800_GOP15,    //20
    IOS_STAR_VIDEO_ENC_CONFIG_SF_720W_1280H_FPS15_RATE800_GOP30,    //21
    IOS_STAR_VIDEO_ENC_CONFIG_SF_720W_1280H_FPS15_RATE800_GOP45,    //22
    IOS_STAR_VIDEO_ENC_CONFIG_MAX,                                    //23
};

typedef NS_ENUM(NSInteger,XHPlayerScaleType)
{
    DRAW_TYPE_TOP,       // 顶部对齐
    DRAW_TYPE_BOTTOM,    // 底部部对齐
    DRAW_TYPEDRAW_TYPE_CENTER_TOP,  //居中显示
    DRAW_TYPE_STRETCH,             //拉伸显示
    DRAW_TYPE_TOTAL_GRAPH         //全图显示
};

#endif /* XHConstants_h */
