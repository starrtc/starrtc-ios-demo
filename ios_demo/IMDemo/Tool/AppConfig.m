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

@interface AppConfig ()
{
    BOOL _liveEnable;
}
@end

@implementation AppConfig

+ (instancetype)shareConfig{
    static AppConfig *appConfigManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appConfigManager = [[self alloc] init];
    });
    return appConfigManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.host = @"https://api.starrtc.com/public";
        self.userId = UserId;
        self.appId = IFHAppId;
        self.messageHost = [XHClient sharedClient].config.imScheduleURL;
        self.chatHost = [XHClient sharedClient].config.chatRoomScheduleURL;
        self.videoEnabled = YES;
        self.audioEnabled = YES;
        self.loginHost = [XHClient sharedClient].config.starLoginURL;
        self.uploadHost = [XHClient sharedClient].config.liveSrcScheduleURL;
        self.voipHost = [XHClient sharedClient].config.voipServerURL;
        self.downloadHost = [XHClient sharedClient].config.liveVdnScheduleURL;
        NSDictionary * parametersDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppConfigParameters"];
        if (parametersDic) {
            [self setValuesForKeysWithDictionary:parametersDic];
        } else {
            _liveEnable = NO;
        }
    }
    return self;
}

+ (BOOL)liveEnable{
    return [[AppConfig shareConfig] liveEnable];
}

- (BOOL)liveEnable{
    return _liveEnable;
}

- (void)checkAppConfig{

#ifdef DEBUG
    _liveEnable = YES;
    [self saveParametersToLocal];
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
                
                [self saveParametersToLocal];
            }
        } failure:^(NSError *error) {
            NSLog(@"AppConfig失败");
        }];
    } else {
        _liveEnable = NO;
        [self saveParametersToLocal];
        NSLog(@"还没到时间");
    }
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}
- (NSDictionary*)objectToDictionary{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:[NSNumber numberWithBool:_liveEnable] forKey:@"liveEnable"];
    [dic setObject:self.host forKey:@"host"];
    [dic setObject:self.userId forKey:@"userId"];
    [dic setObject:self.appId forKey:@"appId"];
    [dic setObject:self.loginHost forKey:@"loginHost"];
    [dic setObject:self.messageHost forKey:@"messageHost"];
    [dic setObject:self.chatHost forKey:@"chatHost"];
    [dic setObject:self.uploadHost forKey:@"uploadHost"];
    [dic setObject:self.downloadHost forKey:@"downloadHost"];
    [dic setObject:self.voipHost forKey:@"voipHost"];
    [dic setObject:@(self.audioEnabled) forKey:@"audioEnabled"];
    [dic setObject:@(self.videoEnabled) forKey:@"videoEnabled"];
    return dic;
}
- (void)saveParametersToLocal{
    NSDictionary *parameters = [self objectToDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"AppConfigParameters"];
}

@end
