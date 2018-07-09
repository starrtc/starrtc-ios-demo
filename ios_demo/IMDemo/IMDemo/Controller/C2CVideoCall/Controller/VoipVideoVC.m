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
#import "XQEchoCancellation.h"
#import "VideoSetParameters.h"
#define subPathPCM @"/Documents/xbMedia"
#define stroePath [NSHomeDirectory() stringByAppendingString:subPathPCM]
@interface VoipVideoVC ()<CallingVoipViewDelegate,ReceiveVoipViewDelegate,VoipConversationViewDelegate>
{
    VoipVCStatus _voipStatus;  //当前控制器的Voip 连接状态
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
        
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _voipStatus = VoipVCStatus_Calling;
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
    
    self.callingView.frame = self.view.bounds;
    self.receiveView.frame = self.view.bounds;
    self.conversationView.frame = self.view.bounds;
    
    [self.view addSubview:self.callingView];
    [self.view addSubview:self.receiveView];
    [self.view addSubview:self.conversationView];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupUI];
    [[XHClient sharedClient].voipManager setVideoConfig:[VideoSetParameters locaParameters]];
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
    [self.callingView setupUserNickname:self.targetId];
    [self.receiveView setupUserNickname:self.targetId];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
 
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)setupUI{
    self.navigationController.navigationBarHidden = YES;
    switch (_voipStatus) {
        case VoipVCStatus_Calling:
            self.callingView.hidden = NO;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = YES;
            break;
        case VoipVCStatus_Receiving:
            self.callingView.hidden = YES;
            self.receiveView.hidden = NO;
            self.conversationView.hidden = YES;
            
            break;
        case VoipVCStatus_Conversation:
            self.callingView.hidden = YES;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = NO;
            //[self.echoCancellation start];
            break;
        default:
            self.callingView.hidden = NO;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = YES;
            break;
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

- (void)setupTargetId:(NSString*)targetId viopStatus:(VoipVCStatus)voipStatus{
    [self setupVoipState:voipStatus];
    self.targetId = targetId;
    
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


@end
