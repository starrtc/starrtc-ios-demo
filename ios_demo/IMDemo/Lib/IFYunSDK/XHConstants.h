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
    XHChatroomTypeUnable,   //占位
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


/**
 * 超级聊天室类型
 */
typedef NS_ENUM(NSInteger,  XHSuperRoomType) {
    XHSuperRoomTypeGlobalPublic , //无需登录和验证
    XHSuperRoomTypeLoginPublic , //需要登录，无需验证
    XHSuperRoomTypeLoginSpecify //需要登录和验证
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
    
    IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_SMALL_NONE,               //0
    IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_88SW_160SH,               //1

    IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_SMALL_NONE,               //2
    IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_120SW_160SH,              //3

    IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE,               //4
    IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_120SW_120SH,              //5
    IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_240SW_240SH,              //6

    IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_SMALL_NONE,               //7
    IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_90SW_160SH,               //8
    IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_180SW_320SH,              //9

    IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_SMALL_NONE,               //10
    IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_120SW_160SH,              //11
    IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_240SW_320SH,              //12

    IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_SMALL_NONE,               //13
    IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_160SW_160SH,              //14
    IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_320SW_320SH,              //15


    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE,              //16
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_90SW_160SH,              //17
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_180SW_320SH,             //18
    IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_360SW_640SH,             //19

    IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_SMALL_NONE,             //20
    IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_135SW_240SH,            //21
    IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_270SW_480SH,            //22
    IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_540SW_960SH,            //23

    IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE,                //24
    
};

typedef NS_ENUM(NSInteger, XHCodecTypeEnum)
{
    IOS_STAR_VIDEO_ENC_CONFIG_NOT_USE,                                  //0
    
    //hw big
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_START,                             //1 硬编边界
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_CUSTOM_PARAMS,                     //2 //硬編大圖自定義參數
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_176W_320H,                         //3
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_240W_320H,                         //4
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_480W_480H,                         //5
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_360W_640H,                         //6
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_480W_640H,                         //7
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_640W_640H,                         //8
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_720W_1280H,                        //9
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_1080W_1920H,                       //10
    
    IOS_STAR_VIDEO_ENC_CONFIG_HW_BIG_END,                               //11 硬编边界
    
    //small
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_START,                           //12 小图边界
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_120W_120H,                       //13
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_88W_160H,                        //14
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_90W_160H,                        //15
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_120W_160H,                       //16
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_160W_160H,                       //17
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_135W_240H,                       //18
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_240W_240H,                       //19
   
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_180W_320H,                       //20
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_240W_320H,                       //21
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_320W_320H,                       //22
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_270W_480H,                       //23
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_360W_640H,                       //24
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_540W_960H,                       //25
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_SMALL_END,                             //26
    
    //big
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_START,                             //27 大图边界
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_CUSTOM_PARAMS,                     //28 //軟編大圖自定義參數
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_176W_320H,                         //29
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_240W_320H,                         //30
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_480W_480H,                         //31
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_360W_640H,                         //32
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_480W_640H,                         //33
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_640W_640H,                         //34
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_720W_1280H,                        //35
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_1080W_1920H,                       //36
    
    IOS_STAR_VIDEO_ENC_CONFIG_SF_BIG_END,                               //37 大图边界
    
    IOS_STAR_VIDEO_ENC_CONFIG_MAX,                                      //38
};

typedef NS_ENUM(NSInteger,XHPlayerScaleType)
{
    DRAW_TYPE_TOP,       // 顶部对齐
    DRAW_TYPE_BOTTOM,    // 底部部对齐
    DRAW_TYPEDRAW_TYPE_CENTER_TOP,  //居中显示
    DRAW_TYPE_STRETCH,             //拉伸显示
    DRAW_TYPE_TOTAL_GRAPH         //全图显示
};

typedef NS_ENUM(NSInteger,XHRtcMediaTypeEnum)
{
    IOS_STAR_RTC_MEDIA_TYPE_VIDEO_AND_AUDIO,
    IOS_STAR_RTC_MEDIA_TYPE_VIDEO_ONLY,
    IOS_STAR_RTC_MEDIA_TYPE_AUDIO_ONLY
};

typedef NS_ENUM(NSInteger,XHDeviceDirectionEnum)
{
    STAR_DEVICE_DIRECTION_HOME_RIHGT,
    STAR_DEVICE_DIRECTION_HOME_BOTTOM,
    STAR_DEVICE_DIRECTION_HOME_LEFT,
    STAR_DEVICE_DIRECTION_HOME_TOP
};


/**
 * 视频编码格式配置
 */
typedef NS_ENUM(NSInteger,XHVideoCodecConfigEnum)
{
    IOS_STAR_STREAM_VIDEO_CODEC_H264,     //0
    IOS_STAR_STREAM_VIDEO_CODEC_H265,     //1
    IOS_STAR_STREAM_VIDEO_CODEC_MPEG1      //2
};

/**
 * 音频编码格式配置
 */
typedef NS_ENUM(NSInteger,XHAudioCodecConfigEnum)
{
    IOS_STAR_STREAM_AUDIO_CODEC_OPUS,     //0
    IOS_STAR_STREAM_AUDIO_CODEC_AAC,     //1
    IOS_STAR_STREAM_AUDIO_CODEC_MP2      //2 MPEG Audio Layer-2
};


static  NSString *AUTHKEY_PUBLIC                      = @"AUTHKEY-PUBLIC";
static  NSString *AUTHKEY_FREE                        = @"AUTHKEY-FREE";
static  NSString *APPID_FREE                          = @"APPID-FREE";

#endif /* XHConstants_h */
