//
//  IMHelp.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IMHelp.h"
#import "VoipReadyVC.h"
#import "VoipVideoVC.h"
#import "SenderVoipVideoVC.h"
#import "XHClient.h"
#import "VoipHistoryManage.h"
#import "XHEchoCancellation.h"
@interface IMHelp ()<XHVoipManagerDelegate>

{
    
}

@end

@implementation IMHelp

+ (instancetype)shareManager {
    static IMHelp * staticIMHelp = nil;
    static dispatch_once_t imOnceToken;
    dispatch_once(&imOnceToken, ^{
        staticIMHelp = [[IMHelp alloc] init];
    });
    return staticIMHelp;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)startMonitoring
{
    [[XHClient sharedClient].voipManager addDelegate:self];
}
- (void)stopMonitoring
{

}

- (void)clearHelp
{
    
}
#pragma mark XHVoipManagerDelegate
/*
 *收到呼叫
 * @fromID 对方ID
 */
- (void)onCalling:(NSString *)fromID{
    //保存历史记录
    [[VoipHistoryManage manage] addVoip:fromID];
    //设置对方UserId
    [[VoipVideoVC shareInstance] setupTargetId:fromID viopStatus:VoipVCStatus_Receiving];
    [[VoipVideoVC shareInstance] showVoipInViewController:self.delegate];
}
//对方已挂断
- (void)onHangup:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方已挂断"];
    [[VoipVideoVC shareInstance] backup];
}
//对方已取消呼叫  取消和挂断是一回事？？？？
- (void)onCancled:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方已取消"];
    [[VoipVideoVC shareInstance] backup];
}
//呼叫被对方拒绝
- (void)onRefused:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方拒绝通话"];
    [[VoipVideoVC shareInstance] backup];
}
//对方线路正忙
- (void)onBusy:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方正忙"];
    [[VoipVideoVC shareInstance] backup];
}
//对方接通
- (void)onConnected:(NSString *)fromID{
    [[VoipVideoVC shareInstance] updateVoipState:VoipVCStatus_Conversation];
}
//连接报错
- (void)onError:(NSError *)error{
    
    [UIWindow ilg_makeToast:[NSString stringWithFormat:@"连接出错，已中止通话：%@",error.userInfo]];
    [[VoipVideoVC shareInstance] backup];
}
//成功挂断，可以正常关闭
-(void)onStop:(NSString *)code{
    [[VoipVideoVC shareInstance] backup];
}

@end
