//
//  AppConfig.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/5/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "AppConfig.h"
#import "InterfaceUrls.h"

#define APPID @"starRTC"
#define Platform @"iOS"
#define ConfigUpdateTime @"2018-06-18 09:00"

static NSString * const kAppConfigParametersPublicKey = @"AppConfigParameters";
static NSString * const kAppConfigParametersPrivateKey = @"AppConfigParametersPrivate";

@interface AppConfig ()
{
    BOOL _liveEnable;
}
@end

@implementation AppConfig

+ (instancetype)shareConfig {
    static AppConfig *appConfigManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //appConfigManager = [[self alloc] initWithType:[AppConfig SDKServiceType]];
        appConfigManager = [[self alloc] initWithType:IFServiceTypePrivate];
        
    });
    return appConfigManager;
}

- (instancetype)initWithType:(IFServiceType)type
{
    self = [super init];
    if (self) {
        _userId = UserId;
        _appId = IFHAppId;
        _host = @"http://call.skyinfor.cc:28080/aec/list";   // http://www.starrtc.com/aec/list
        _loginHost = @"ips2.starrtc.com:9920";
        
        NSString *appConfigParamsKey = (type == IFServiceTypePublic)? kAppConfigParametersPublicKey:kAppConfigParametersPrivateKey;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *params = [userDefaults objectForKey:appConfigParamsKey];
        if (params) {
            [self setValuesForKeysWithDictionary:params];
            
        } else {
            if (type == IFServiceTypePrivate) {
//                                        _messageHost = @"call.skyinfor.cc:19903";  //  call.skyinfor.cc test.starrtc.com  demo.starrtc.com
//                                        _chatHost = @"call.skyinfor.cc:19906";
//                                        _uploadHost = @"call.skyinfor.cc:19931";
//                                        _downloadHost = @"call.skyinfor.cc:19928";
//                                        _voipHost = @"call.skyinfor.cc:10086";
//                                        _uploadProxyHost = @"call.skyinfor.cc:19932";
                
                _getIMGroupListHost = @"http://www.starrtc.com/aec/group/list.php";
                _getIMGroupInfoHost =  @"http://www.starrtc.com/aec/group/members.php";
                _otherListSaveHost = @"http://www.starrtc.com/aec/list/save.php";
                _otherListQueryHost = @"http://www.starrtc.com/aec/list/query.php";
                _otherListDeleteHost = @"http://www.starrtc.com/aec/list/del.php";
//
//                            _messageHost = @"beta.starrtc.com:19903";
//                            _chatHost = @"beta.starrtc.com:19906";
//                            _uploadHost = @"beta.starrtc.com:19931";
//                            _downloadHost = @"beta.starrtc.com:19928";
//                            _voipHost = @"beta.starrtc.com:10086";
//                            _uploadProxyHost = @"beta.starrtc.com:19932";
                _messageHost = @"demo.starrtc.com:19903";
                _chatHost = @"demo.starrtc.com:19906";
                _uploadHost = @"demo.starrtc.com:19931";
                _downloadHost = @"demo.starrtc.com:19928";
                _voipHost = @"demo.starrtc.com:10086";
                _uploadProxyHost = @"demo.starrtc.com:19932";
//                _messageHost = @"aisee.f3322.org:19903";
//                _chatHost = @"aisee.f3322.org:19906";
//                _uploadHost = @"aisee.f3322.org:19931";
//                _downloadHost = @"aisee.f3322.org:19928";
//                _voipHost = @"aisee.f3322.org:10086";
//                _uploadProxyHost = @"aisee.f3322.org:19932";
            } else {
                _messageHost = @"ips2.starrtc.com:9904";
                _chatHost = @"ips2.starrtc.com:9907";
                _uploadHost = @"ips2.starrtc.com:9929";
                _downloadHost = @"ips2.starrtc.com:9926";
                _voipHost = @"voip2.starrtc.com:10086";
                _uploadProxyHost = @"liveproxy.starrtc.com:19932";
            }
        }
        
        self.videoEnabled = YES;
        self.audioEnabled = YES;
    }
    return self;
}

+ (BOOL)liveEnable {
    return [[AppConfig shareConfig] liveEnable];
}

- (BOOL)liveEnable{
    return _liveEnable;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (void)checkAppConfig{

#ifdef DEBUG
    _liveEnable = YES;
    return;
#endif
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateformatter setTimeZone:sourceTimeZone];
    NSDate *configUpdateDate = [dateformatter dateFromString:ConfigUpdateTime];
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:configUpdateDate] == NSOrderedDescending) {
        NSString *vesion = [ILGLocalData preferencePlistObject:@"CFBundleShortVersionString"];
        NSString *parameter = [NSString stringWithFormat:@"platform=%@&version=v%@&appid=%@",Platform,vesion,APPID];
        
        [InterfaceUrls getAppConfigUrlParameter:parameter success:^(id responseObject) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            if (data && [data objectForKey:@"liveStatus"]) {
                
                _liveEnable = [[data objectForKey:@"liveStatus"] boolValue];
                
            }
        } failure:^(NSError *error) {
            NSLog(@"AppConfig失败");
        }];
    } else {
        _liveEnable = NO;
        NSLog(@"还没到时间");
    }
    
}

+ (void)saveSystemSettingsForPublic:(NSDictionary *)params {
    [[NSUserDefaults standardUserDefaults] setObject:params forKey:kAppConfigParametersPublicKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)saveSystemSettingsForPrivate:(NSDictionary *)params {
    [[NSUserDefaults standardUserDefaults] setObject:params forKey:kAppConfigParametersPrivateKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (AppConfig *)appConfigForLocal:(IFServiceType)type {
    return [[AppConfig alloc] initWithType:type];
}

static NSString * const kIFSDKServiceTypeKey = @"kIFSDKServiceTypeKey";
+ (void)switchSDKServiceType
{
    IFServiceType type = IFServiceTypePublic;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:kIFSDKServiceTypeKey]) {
        IFServiceType tmpType = [[userDefaults objectForKey:kIFSDKServiceTypeKey] integerValue];
        if (tmpType == IFServiceTypePublic) {
            type = IFServiceTypePrivate;
        } else {
            type = IFServiceTypePublic;
        }
    } else {
        type = IFServiceTypePrivate;
    }
    
    [userDefaults setObject:@(type) forKey:kIFSDKServiceTypeKey];
    [userDefaults synchronize];
}

+ (IFServiceType)SDKServiceType
{
     return IFServiceTypePrivate;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if ([userDefaults objectForKey:kIFSDKServiceTypeKey]) {
//        return [[userDefaults objectForKey:kIFSDKServiceTypeKey] integerValue];
//    } else {
//        return IFServiceTypePublic;
//    }
}

static NSString * const AEventCenterEnable = @"AEventCenterEnable";

//切换aec状态
+ (void)switchAecEnableStatus
{
    BOOL aecEnable = false;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:AEventCenterEnable])
    {
        aecEnable = true;
       
    }
    else
    {
        BOOL tmpType = [[userDefaults objectForKey:AEventCenterEnable] integerValue];
        if (tmpType == true) {
            aecEnable = false;
        } else {
            aecEnable = true;
        }
    }
    
    [userDefaults setObject:@(aecEnable) forKey:AEventCenterEnable];
    [userDefaults synchronize];

}
//获取是否开启aec
+ (BOOL)AEventCenterEnable
{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:AEventCenterEnable]) {
            return [[userDefaults objectForKey:AEventCenterEnable] integerValue];
        } else {
            return false;
        }
}

@end
