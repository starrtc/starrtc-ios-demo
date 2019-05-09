//
//  AppDelegate.m
//  IMDemo
//
//  Created by  Admin on 2017/12/18.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "XHCustomConfig.h"
#import "InterfaceUrls.h"
#import <Bugly/Bugly.h>
#import "IQKeyboardManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
    [[AppConfig shareConfig] checkAppConfig];
    
    [self setupForIFSDK];
    
    [Bugly startWithAppId:@"9b09df1886"];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - other

- (void)setupForIFSDK {
    XHCustomConfig *config = [[XHCustomConfig alloc] init];
    config.agentID = [AppConfig shareConfig].appId;  //必填项
    
    IFServiceType type = [AppConfig SDKServiceType];
    AppConfig *appConfig = [AppConfig appConfigForLocal:type];
    if (type == IFServiceTypePublic) {
        config.serverType = SERVER_TYPE_PUBLIC;
        
        config.starLoginURL = appConfig.loginHost;
        config.imScheduleURL = appConfig.messageHost;
        config.chatRoomScheduleURL = appConfig.chatHost;
        config.liveSrcScheduleURL = appConfig.uploadHost;
        config.liveVdnScheduleURL = appConfig.downloadHost;
        config.voipScheduleURL = appConfig.voipHost;

        [config sdkInit:UserId];
        
    } else {
        config.serverType = SERVER_TYPE_CUSTOM;

        config.imServerURL = appConfig.messageHost;
        config.chatRoomServerURL = appConfig.chatHost;
        config.liveSrcServerURL = appConfig.uploadHost;
        config.liveVdnServerURL = appConfig.downloadHost;
        config.voipServerURL = appConfig.voipHost;

        [config sdkInitForFree:UserId];
    }
}

@end
