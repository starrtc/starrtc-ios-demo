//
//  GuestSpeechChatVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "GuestSpeechChatVC.h"
#import "SpeechChatMenuView.h"
#import "SpeechMembersView.h"
#import "SpeechMessagesView.h"
#import "XHClient.h"

@interface GuestSpeechChatVC ()<SpeechChatMenuViewDelegate,XHLiveManagerDelegate>
@property (nonatomic, strong) SpeechChatMenuView *chatMenuView;
@property (nonatomic, strong) SpeechMembersView *membersView;
@property (nonatomic, strong) SpeechMessagesView *messagesView;
@end

@implementation GuestSpeechChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupHandle];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = self.roomInfo.Name;
    [self.view addSubview:self.chatMenuView];
    [self.view addSubview:self.membersView];
    [self.view insertSubview:self.messagesView atIndex:0];
}
- (void)setupHandle{
    
    self.membersView.roomInfo = self.roomInfo;
    
    [[XHClient sharedClient].liveManager setVideoEnable:NO];
    [[XHClient sharedClient].liveManager setAudioEnable:NO];
    [[XHClient sharedClient].liveManager setRtcMediaType:IOS_STAR_RTC_MEDIA_TYPE_AUDIO_ONLY];
    [[XHClient sharedClient].liveManager addDelegate:self];
    [[XHClient sharedClient].liveManager watchLive:self.roomInfo.ID completion:^(NSError *error) {
        
    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.chatMenuView.frame = CGRectMake(0, self.view.height - 60, self.view.width, 60);
    CGFloat topHeight = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
    self.membersView.frame = CGRectMake(0, topHeight + 10, self.view.width, 265);
    self.messagesView.frame = CGRectMake(0, CGRectGetMaxY(self.membersView.frame), self.view.width, self.view.height - CGRectGetMaxY(self.membersView.frame) - self.chatMenuView.height);
}
#pragma mark - init
- (SpeechChatMenuView*)chatMenuView{
    if (!_chatMenuView) {
        _chatMenuView = [SpeechChatMenuView instanceFromNib];
        _chatMenuView.delegate = self;
    }
    return _chatMenuView;
}
- (SpeechMembersView*)membersView{
    if (!_membersView) {
        _membersView = [SpeechMembersView instanceFromNib];
        //        _membersView.delegate = self;
    }
    return _membersView;
}
- (SpeechMessagesView*)messagesView{
    if (!_messagesView) {
        _messagesView = [SpeechMessagesView instanceFromNib];
    }
    return _messagesView;
}

#pragma mark - 点击

- (IBAction)upVideoButtonClicked:(UIButton *)sender {
    [[XHClient sharedClient].liveManager applyToBroadcaster:self.roomInfo.Creator completion:^(NSError *error) {
        [UIWindow ilg_makeToast:@"申请发送成功，正在等待房主同意..."];
    }];
}

//父类方法
- (void)leftButtonClicked:(UIButton *)button
{
    [[XHClient sharedClient].liveManager leaveLive:self.roomInfo.ID completion:^(NSError *error) {
        
    }];
    [super leftButtonClicked:button];
}

#pragma mark - SpeechChatMenuViewDelegate <NSObject>

- (void)speechChatMenuView:(SpeechChatMenuView*)chatMenuView sendText:(NSString*)text{
    [[XHClient sharedClient].liveManager sendMessage:text completion:^(NSError *error) {
        if (error == nil) {
            SpeechMessageModel *model = [[SpeechMessageModel alloc] initWithNickname:UserId content:text];
            [self.messagesView addMessage:model];
            NSLog(@"发送成功");
        }
        
    }];
}
- (void)speechChatMenuViewStartSpeech:(SpeechChatMenuView*)chatMenuView{
    [[XHClient sharedClient].liveManager setAudioEnable:YES];
}
- (void)speechChatMenuViewStopSpeech:(SpeechChatMenuView*)chatMenuView{
    [[XHClient sharedClient].liveManager setAudioEnable:NO];
}
#pragma mark - XHLiveManagerDelegate <NSObject>

/**
 有人加入直播
 @param uid 加入用户的ID
 @param liveID 直播间ID
 @return 用于显示发言者视频画面的view
 */
- (UIView *)onActorJoined:(NSString *)uid live:(NSString *)liveID{
    [self.membersView addMember:uid];
    return nil;
}

/**
 有人离开直播
 
 @param uid 离开用户的ID
 @param liveID 直播间ID
 */
- (void)onActorLeft:(NSString *)uid live:(NSString *)liveID{

    [self.membersView removeMember:uid];
    
}

/**
 申请上麦者收到 加入直播的审批回复
 @param result 结果
 @param liveID 直播间ID
 */
- (void)onBroadcastResponsed:(XHLiveJoinResult)result live:(NSString *)liveID{
    NSString *content;
    switch (result) {
        case XHLiveJoinResult_Accept:
            content = @"房主接收了您的申请";
            [[XHClient sharedClient].liveManager changeToBroadcaster];
            break;
        case XHLiveJoinResult_refuse:
            content = @"房主拒绝了您的申请";
            break;
        default:
            content = @"申请无应答，请尝试再次申请";
            break;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}


/**
 观众收到 加入直播的邀请
 @param uid 邀请用户ID
 @param liveID 直播间ID
 */
- (void)onInviteBroadcast:(NSString *)uid live:(NSString *)liveID{
    
}

/**
 房间创建者收到 是否连麦的回复
 @param result 结果
 @param liveID 直播间ID
 */
- (void)onInviteResponsed:(XHLiveJoinResult)result live:(NSString *)liveID{
    
}


/**
 * 自己连麦被强制停止
 @param liveID 直播间ID
 */
- (void)onCommandToStopPlay:(NSString *)liveID{
    [UIWindow ilg_makeToast:@"连麦被强制停止"];
}


/**
 一些异常情况可能会引起会议出错，请在收到该回调后主动离开直播
 @param error 错误信息
 @param liveID 直播间ID
 */
- (void)onLiveError:(NSError *)error live:(NSString *)liveID{
    
}


/**
 成员数发生变化
 
 @param membersNumber 成员数
 */
- (void)liveMembersNumberUpdated:(NSInteger)membersNumber{
    
}

/**
 自己被剔
 */
- (void)liveUserKicked{
    
}

/**
 收到消息
 
 @param message 消息
 */
- (void)liveMessageReceived:(NSString *)message fromID:(NSString *)fromID{
    SpeechMessageModel *model = [[SpeechMessageModel alloc] initWithNickname:fromID content:message];
    [self.messagesView addMessage:model];
}

/**
 收到私信消息
 
 @param message 消息
 @param fromID 消息来源
 */
- (void)livePrivateMessageReceived:(NSString *)message fromID:(NSString *)fromID{
    
}


/**
 * 收到实时数据
 * @param data 数据
 * @param upId  用户ID
 */
- (void)onReceiveRealtimeData:(NSString *)data
                         upId:(NSString *)upId{
    
}
@end
