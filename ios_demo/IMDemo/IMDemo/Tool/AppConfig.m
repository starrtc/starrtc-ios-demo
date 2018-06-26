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
        
        NSDictionary * parametersDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppConfigs"];
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

- (NSDictionary*)objectToDictionary{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:[NSNumber numberWithBool:_liveEnable] forKey:@"liveEnable"];
    return dic;
}
- (void)saveParametersToLocal{
    NSDictionary *parameters = [self objectToDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"AppConfigs"];
}

@end
