//
//  ILGDevice.h
//  ZCLibProjectDEV
//
//  Created by Happy on 8/27/16.
//  Copyright © 2016 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h> //获取广告标示符的支持框架

//#import "DeviceBatteryManager.h"
//#import "NetStatusManager.h"
//#import "PhoneNumManager.h"
//#import "SignalStrengthManager.h"

#define ZCDeviceInfo_Key_UUID @"ILGDeviceUUID"
#define ZCDeviceInfo_Key_IDFA @"ILGDeviceIDFA"

typedef void(^ImagePickerCallBack)(UIImage *image);

#pragma mark 网络类型
typedef NS_ENUM(NSInteger, ZCNetworkKind) {
    ZCNetworkKind2G = 1,
    ZCNetworkKind3G,
    ZCNetworkKind4G,
    ZCNetworkKindWLAN, //无线局域网
    ZCNetworkKindCellular, //蜂窝网
    ZCNetworkKindOther
};

@interface ILGDevice : NSObject
+ (instancetype)sharedInstance;

/**
 *  获取identifierForVendor
 */
+ (NSString *)deviceUUIDString;

/**
 *  获取广告标示符
 */
+ (NSString *)advertisingIdentifier;

/**
 *  设备类型，比如iPhone、iPad、iPod、iPad air、iPad mini
 */
+ (NSString *)deviceBrand;
/**
 *  设备类型，比如iPhone1,1
 */
+ (NSString *)deviceModel;

/**
 *  网络类型，WiFi和WWAN
 */
//+ (NSString *)networkName;
//+ (ZCNetworkKind)networkKind;

/**
 *  设备系统版本号
 */

+ (NSString *)deviceSystemVersion;

/**
 手机振动

 @param callback 振动结束回到
 */
+ (void)audioServicesPlaySystemSoundWithCompletion:(void(^)())callback;

/**
 从相册或者相机获取Image

 @param sourceType 0从相册读取，1从相机读取，默认从相册读取
 @param vc 图片读取ViewController的呈现ViewController
 @param callback 回调
 */
- (void)fetchImageFromSystem:(int)sourceType viewController:(UIViewController *)vc callback:(ImagePickerCallBack)callback;
@end
