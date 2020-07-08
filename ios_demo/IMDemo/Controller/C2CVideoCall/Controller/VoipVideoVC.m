//
//  VoipVideoVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipVideoVC.h"
#import "CallingVoipView.h"
#import "ReceiveVoipView.h"
#import "VoipConversationView.h"
#import "XHClient.h"
#import "VideoSetParameters.h"
#define subPathPCM @"/Documents/xbMedia"
#define stroePath [NSHomeDirectory() stringByAppendingString:subPathPCM]
@interface VoipVideoVC ()<CallingVoipViewDelegate,ReceiveVoipViewDelegate,VoipConversationViewDelegate>
{
    VoipVCStatus _voipStatus;  //当前控制器的Voip 连接状态
    VoipShowType _showType;   // 音频还是视频
    CGRect smallFrame;
}
@property (weak, nonatomic) CallingVoipView *callingView;
@property (weak, nonatomic) VoipConversationView *conversationView;
@property (weak, nonatomic) ReceiveVoipView *receiveView;
//@property (nonatomic, strong) XQEchoCancellation *echoCancellation;
@end

@implementation VoipVideoVC

+ (instancetype)shareInstance
{
    static VoipVideoVC * staticVoipVideoVC = nil;
    static dispatch_once_t voipOnceToken;
    dispatch_once(&voipOnceToken, ^{
        staticVoipVideoVC = [[VoipVideoVC alloc] initWithNibName:@"VoipVideoVC" bundle:[NSBundle mainBundle]];
    });
    return staticVoipVideoVC;
}

- (instancetype)initWithNib{
    if (self = [super initWithNibName:@"VoipVideoVC" bundle:[NSBundle mainBundle]]) {
        _voipStatus = VoipVCStatus_Calling;
        _showType = VoipShowType_Video;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _voipStatus = VoipVCStatus_Calling;
        _showType = VoipShowType_Video;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.callingView = [CallingVoipView instanceFromNIB];
    self.receiveView = [ReceiveVoipView instanceFromNIB];
    self.conversationView = [VoipConversationView instanceFromNIB];
    
    self.callingView.delegate = self;
    self.receiveView.delegate = self;
    self.conversationView.delegate = self;
    
    self.callingView.frame = CGRectMake(0, 200, self.view.size.width, 400);
    self.receiveView.frame = self.view.bounds;
    self.conversationView.frame = self.view.bounds;
    self.conversationView.selfView = [[UIView alloc] init];
    [self.conversationView.selfView setFrame:CGRectMake(15, 20, 116, 155)];
    [self.conversationView addSubview:self.conversationView.selfView];
    
    
    
    [self.view addSubview:self.callingView];
    [self.view addSubview:self.receiveView];
    [self.view addSubview:self.conversationView];
    [self.view sendSubviewToBack:self.conversationView];
    
     [[XHClient sharedClient].beautyManager addDelegate:self];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupUI];
    [[XHClient sharedClient].voipManager setVideoConfig:[VideoSetParameters locaParameters]];

    if(_showType == VoipShowType_Audio)
    {
        if(_voipStatus == VoipVCStatus_Calling)
        {
            [[XHClient sharedClient].voipManager audioCall:self.targetId completion:^(NSError *error) {
                if (error) {
                    [self showError:error];
                    [self backup];
                }
            }];
        }
        [self.callingView setupUserNickname:self.targetId isAudio:YES];
        [self.receiveView setupUserNickname:self.targetId  isAudio:YES];
    }
    else
    {
        //设置用于视频显示的View
        [[XHClient sharedClient].voipManager setupView:self.conversationView.selfView targetView:self.conversationView.targetView];
        if (_voipStatus == VoipVCStatus_Calling) {

            [[XHClient sharedClient].voipManager call:self.targetId completion:^(NSError *error) {
                if (error) {
                    [self showError:error];
                    [self backup];
                }
            }];
        }
        [self.callingView setupUserNickname:self.targetId isAudio:NO];
        [self.receiveView setupUserNickname:self.targetId  isAudio:NO];
    }


    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)layoutSubviews {
    __weak typeof(self) weakSelf = self;
    // 布局
    [self.conversationView.selfView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(ios 11, *)) {
            //            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
            //            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        } else {
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
    }];
}


- (void)setupUI{
    self.navigationController.navigationBarHidden = YES;
    switch (_voipStatus) {
        case VoipVCStatus_Calling:
        {
            self.callingView.hidden = NO;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = NO;
//            smallFrame = self.conversationView.selfView.frame;
//            self.conversationView.selfView = [[UIView alloc] init];
//            self.conversationView.selfView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//            [self.conversationView addSubview:self.conversationView.selfView];
//            [self.conversationView bringSubviewToFront:self.conversationView.selfView];
//            __weak typeof(self) weakSelf = self;
//            // 布局
//            [self.conversationView.selfView mas_makeConstraints:^(MASConstraintMaker *make) {
//                if (@available(ios 11, *)) {
//                    make.top.equalTo(weakSelf.view);
//                    make.bottom.equalTo(weakSelf.view);
//                } else {
//                    make.top.equalTo(weakSelf.view);
//                    make.bottom.equalTo(weakSelf.view);
//                }
//                make.left.equalTo(weakSelf.view);
//                make.right.equalTo(weakSelf.view);
//            }];
            self.conversationView.hangUpButton.hidden = YES;
            self.conversationView.hangUpLabel.hidden = YES;
            break;
    }
        case VoipVCStatus_Receiving:
            self.callingView.hidden = YES;
            self.receiveView.hidden = NO;
            self.conversationView.hidden = YES;
            
            break;
        case VoipVCStatus_Conversation:
        {
            self.callingView.hidden = YES;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = NO;
//            self.conversationView.selfView = [[UIView alloc] init];
//            [self.conversationView.selfView setFrame:CGRectMake(15, 20, 116, 155)];
//            [self.conversationView addSubview:self.conversationView.selfView];
            self.conversationView.hangUpButton.hidden = NO;
            self.conversationView.hangUpLabel.hidden = NO;
            //[self.echoCancellation start];
            
//            __weak typeof(self) weakSelf = self;
//            // 布局
//            [self.conversationView.selfView mas_makeConstraints:^(MASConstraintMaker *make) {
///Users/admin/Desktop/starrtc_ios/starLibrary/starLibrary/model/core/im/StarIMMessageBuilder.h                if (@available(ios 11, *)) {
//                    //            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
//                    //            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
//                    make.top.equalTo(weakSelf.view);
//                    make.bottom.equalTo(weakSelf.view.mas_top).offset(155);
//                } else {
//                    make.top.equalTo(weakSelf.view);
//                    make.bottom.equalTo(weakSelf.view.mas_top).offset(155);
//                }
//                make.left.equalTo(weakSelf.view);
//                make.right.equalTo(weakSelf.view.mas_left).offset(116);
//            }];
//            if (_voipStatus != VoipVCStatus_Calling)
//            {
//                //设置用于视频显示的View
//                [[XHClient sharedClient].voipManager setupView:self.conversationView.selfView targetView:self.conversationView.targetView];
//            }
            break;
    }
        default:
            self.callingView.hidden = NO;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = YES;
            break;
    }
    if(_showType == VoipShowType_Audio)
    {
        [self.conversationView setupUserNickname: self.targetId isAudio:YES];
    }
    else
    {
        [self.conversationView setupUserNickname: self.targetId isAudio:NO];

    }
}

//- (XQEchoCancellation*)echoCancellation{
//    if (!_echoCancellation) {
//        _echoCancellation = [XQEchoCancellation manager];
//         __block XHVoipManager *voipManager = [XHClient sharedClient].voipManager;
//        _echoCancellation.bl_input = ^(AudioBufferList *bufferList) {
//            AudioBuffer buffer = bufferList->mBuffers[0];
//            Byte *mDate = (Byte*)malloc(sizeof(Byte)*buffer.mDataByteSize);
//            memcpy(mDate,buffer.mData,buffer.mDataByteSize);
//            [voipManager insert_AudioData:mDate len:buffer.mDataByteSize];
//        };
//        _echoCancellation.bl_output = ^(AudioBufferList *bufferList, UInt32 inNumberFrames) {
//            AudioBuffer buffer = bufferList->mBuffers[0];
//            int length = buffer.mDataByteSize;
//            NSLog(@"=length = %d",length);
//            Byte *tempByte = [voipManager get_AudioData:&length];
//            NSLog(@"-length = %d",length);
//            memcpy(buffer.mData,tempByte,length);
//            buffer.mDataByteSize = length;
//
//        };
//    }
//    return _echoCancellation;
//}

- (void)setupTargetId:(NSString*)targetId viopStatus:(VoipVCStatus)voipStatus showType:(VoipShowType)showType{
    [self setupVoipState:voipStatus];
    [self setupShowType:showType];
    self.targetId = targetId;
    
}

- (void)setupShowType:(VoipShowType) showType
{
    _showType = showType;
}

- (void)setupVoipState:(VoipVCStatus) voipStatus
{
    _voipStatus = voipStatus;
}

- (void)updateVoipState:(VoipVCStatus) voipStatus{
    [self setupVoipState:voipStatus];
    [self setupUI];
}

#pragma mark - CallingVoipViewDelegate
//取消呼叫
- (void)callingVoipViewDidCancel:(CallingVoipView*) voipConversationView
{
    [[XHClient sharedClient].voipManager cancel:self.targetId completion:^(NSError *error) {
        if (error) {
            [self showError:error];
        }
        [self backup];
    }];
}
#pragma mark - ReceiveVoipViewDelegate
//拒绝来电
- (void)receiveVoipViewDidRefuse:(ReceiveVoipView*) receiveVoipView
{
    [[XHClient sharedClient].voipManager refuse:self.targetId completion:^(NSError *error) {
        if (error) {
            [self showError:error];
        }
        [self backup];
    }];
}
//同意来电
- (void)receiveVoipViewDidAgree:(ReceiveVoipView*) receiveVoipView
{
    [[XHClient sharedClient].voipManager accept:self.targetId completion:^(NSError *error) {
        if (error) {
            [self showError:error];
            [self backup];
        }else {
            [self updateVoipState:VoipVCStatus_Conversation];
        }
    }];
}
#pragma mark - VoipConversationViewDelegate
//挂断
- (void)voipConversationViewDidHangup:(VoipConversationView*) voipConversationView
{
    [[XHClient sharedClient].voipManager hangup:self.targetId completion:^(NSError *error) {
        if (error) {
            [self showError:error];
        }
        [self backup];
    }];
}
//切换摄像头
- (void)voipConversationViewSwitchCamera:(VoipConversationView*) voipConversationView
{
    [[XHClient sharedClient].voipManager switchCamera];
}
//录屏
- (void)voipConversationViewRecordScreen:(VoipConversationView*) voipConversationView
{
    
}

- (void)showVoipInViewController:(UIViewController *)delegate{
    
    //防止重复push
    if([self.navigationController visibleViewController] != self && self.isBeingPresented == NO){
        if (delegate.navigationController) {
            [delegate.navigationController pushViewController:self animated:YES];
        } else {
            [delegate presentViewController:self animated:YES completion:nil];
        }
    }
}

- (void)backup{
//    [self.echoCancellation stop];
//    self.echoCancellation = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showError:(NSError*)error{
//    [UIWindow ilg_makeToast:[NSString stringWithFormat:@"%@",error.userInfo]];
}


#pragma mark - XHBeautyManagerDelegate

/**
 暴露每帧视频数据(同步返回处理后的数据)
 @param videoData 数据
 */
-(StarVideoData *) onVideoFrame:(StarVideoData *) videoData
{
    return videoData;
}

/**
 暴露每帧音频数据(同步返回处理后的数据)
 @param audioData 数据
 */
-(StarAudioData *) onAudioFrame:(StarAudioData *) audioData
{
    return audioData;
}


@end
