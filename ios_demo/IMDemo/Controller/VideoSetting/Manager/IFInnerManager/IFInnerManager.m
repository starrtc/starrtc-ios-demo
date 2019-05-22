//
//  IFInnerManager.m
//  IMDemo
//
//  Created by HappyWork on 2019/2/22.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "IFInnerManager.h"

#import "XHClient.h"

@interface IFInnerManager () <XHVoipManagerDelegate>
@end

@implementation IFInnerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[XHClient sharedClient].voipP2PManager addDelegate:self];
    }
    return self;
}

#pragma mark getter

- (IFInnerVideoVC *)videoVC {
    if (!_videoVC) {
        _videoVC = [[IFInnerVideoVC alloc] init];
    }
    return _videoVC;
}


#pragma mark - delegate

/*
 *收到呼叫
 * @fromID 对方ID
 */
- (void)onCalling:(NSString *)fromID {
    //保存历史记录

    //设置对方UserId
    [[self currentViewController] presentViewController:self.videoVC animated:YES completion:nil];
    [self.videoVC configureTargetId:fromID status:IFInnerConversationStatus_Receiving];
}
- (UIViewController *)currentViewController {
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (currentVC.presentedViewController) {
        currentVC = currentVC.presentedViewController;
    }
    
    return currentVC;
}

//对方已挂断
- (void)onHangup:(NSString *)fromID{
    NSLog(@"对方已挂断");
    [UIWindow ilg_makeToast:@"对方已挂断"];
    [self.videoVC backup];
}
//对方已取消呼叫  取消和挂断是一回事？？？？
- (void)onCancled:(NSString *)fromID{
    NSLog(@"对方已取消");
    [UIWindow ilg_makeToast:@"对方已取消"];
    [self.videoVC backup];
}
//呼叫被对方拒绝
- (void)onRefused:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方拒绝通话"];
    [self.videoVC backup];
}
//对方线路正忙
- (void)onBusy:(NSString *)fromID{
    [UIWindow ilg_makeToast:@"对方正忙"];
    [self.videoVC backup];
}
//对方接通
- (void)onConnected:(NSString *)fromID {
    [self.videoVC updateConversationState:IFInnerConversationStatus_Conversation];
}
//连接报错
- (void)onError:(NSError *)error{
    
    [UIWindow ilg_makeToast:[NSString stringWithFormat:@"连接出错，已中止通话：%@",error.userInfo]];
    [self.videoVC backup];
}
//成功挂断，可以正常关闭
-(void)onStop:(NSString *)code{
    [self.videoVC backup];
}

- (void)onMiss:(NSString *)fromID {
}


- (void)onReceiveRealtimeData:(NSString *)data { 
    
}


@end
