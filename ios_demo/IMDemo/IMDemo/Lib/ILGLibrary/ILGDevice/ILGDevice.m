//
//  ILGDevice.m
//  ZCLibProjectDEV
//
//  Created by Happy on 8/27/16.
//  Copyright © 2016 Happy. All rights reserved.
//

#import "ILGDevice.h"

#import <AdSupport/AdSupport.h> //获取广告标示符的支持框架
#import <sys/utsname.h> //获取设备类型必备
#import <AudioToolbox/AudioToolbox.h> //手机振动需要

#import "ILGLocalData.h"
//#import "LGReachability.h"


@interface ILGDevice () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    ImagePickerCallBack _imagePickerCallback;
}
@end

@implementation ILGDevice
+ (instancetype)sharedInstance {
    static ILGDevice *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[ILGDevice alloc] init];
    });
    
    return manager;
}

- (void)fetchImageFromSystem:(int)sourceType viewController:(UIViewController *)vc callback:
(ImagePickerCallBack)callback {
    UIImagePickerControllerSourceType pickerSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (sourceType == 1) {
        pickerSourceType = UIImagePickerControllerSourceTypeCamera;
    }
    _imagePickerCallback = callback;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = pickerSourceType;
    
    vc ? nil:(vc = [UIApplication sharedApplication].keyWindow.rootViewController);
    [vc presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *chooseImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        _imagePickerCallback(chooseImage);

    }];
}


+ (NSString *)deviceUUIDString {
    NSString *uuid = [ILGLocalData keyChainObject:ZCDeviceInfo_Key_UUID];
    if (!uuid) {
        uuid = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        [ILGLocalData keyChainSave:uuid account:ZCDeviceInfo_Key_UUID];
    }
    return uuid;
}

+ (NSString *)advertisingIdentifier {
    NSString *idfa = [ILGLocalData keyChainObject:ZCDeviceInfo_Key_IDFA];
    if (!idfa) {
        idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [ILGLocalData keyChainSave:idfa account:ZCDeviceInfo_Key_IDFA];
    }
    return idfa;
}

+ (NSString *)deviceBrand {
    NSString *deviceType = [self deviceModel];
    
    if ([deviceType hasPrefix:@"iPhone"]) {
        return @"iPhone";
    } else if ([deviceType hasPrefix:@"iPod"]) {
        return @"iPod";
    } else if ([deviceType hasPrefix:@"iPad mini"]) {
        return @"iPad mini";
    } else  if ([deviceType hasPrefix:@"iPad air"]) {
        return @"iPad air";
    } else if ([deviceType hasPrefix:@"iPad"]) {
        return @"iPad";
    } else {
        return deviceType;
    }
}
+ (NSString *)deviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DeviceModel" ofType:@"plist"];
    NSDictionary *dataDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    return dataDic[deviceString];
}

+ (NSString *)deviceSystemVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (void)audioServicesPlaySystemSoundWithCompletion:(void (^)())callback {
    AudioServicesPlayAlertSoundWithCompletion(kSystemSoundID_Vibrate, ^{
        callback ? callback():nil;
    });

}
@end
