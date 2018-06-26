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
#import "XHEchoCancellation.h"
#define subPathPCM @"/Documents/xbMedia"
#define stroePath [NSHomeDirectory() stringByAppendingString:subPathPCM]
@interface VoipVideoVC ()<CallingVoipViewDelegate,ReceiveVoipViewDelegate,VoipConversationViewDelegate>
{
    VoipVCStatus _voipStatus;  //当前控制器的Voip 连接状态
    
    NSMutableArray <A*> *_buffs;
    Byte * lastBuff[1000];
    NSString *pcmFile_input;
    NSFileHandle *fileHandle_input;
    NSString *pcmFile_output;
    NSFileHandle *fileHandle_output;
    
}
@property (weak, nonatomic) CallingVoipView *callingView;
@property (weak, nonatomic) VoipConversationView *conversationView;
@property (weak, nonatomic) ReceiveVoipView *receiveView;

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
    _buffs = [NSMutableArray arrayWithCapacity:15];
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
    
    
    [self setupUI];
    [self initWriteToFile];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

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
void    showRawData( char *pBuf, int bufLen )
{
    
    int            temI, secondI, t_Loop;
    const    int T_HM = 64 ;
    
    
    if( bufLen < 0x00 )
    {
        return ;
    }
    
    t_Loop = bufLen ;//显示所有的数据
    //t_Loop = bufLen > T_HM ? T_HM : bufLen;
    //    t_Loop = bufLen < T_HM ? T_HM : bufLen;
    
    printf( "\n\n\tTotal:      %d ( 0x%.8X )", bufLen, bufLen );
    
    for ( temI=0x00; temI<t_Loop; temI++ )
    {
        if ( temI % 16 == 0x00 )
        {
            printf( "\n\t%.8X    ", temI );
        }
        
        
        printf( "%.2X, ", *(unsigned char*)( pBuf + temI ) );
        //        printf( "%c  ", *(unsigned char*)( pBuf + temI ) );
        
        if ( temI % 16 == 15 )
        {
            printf( "\t\t" );
            
            for( secondI=temI-15; secondI<=temI; secondI++ )
            {
                if ( isprint( *( pBuf + secondI ) ) )
                {
                    printf("%c", (char)*(pBuf+secondI));
                }
                else
                {
                    printf( "." );
                }
            }
        }
    }
    
    temI   = ( temI / 16 ) * 16;
    
    for( secondI=0x00; secondI<( 16 - ( t_Loop - temI ) ); secondI++ )
    {
        printf( "    " );
    }
    
    printf( "\t\t" );
    
    for( ; temI<t_Loop; temI++ )
    {
        if ( isprint( *( pBuf + temI ) ) )
        {
            printf("%c", (char)*(pBuf+temI));
        }
        else
        {
            printf( "." );
        }
    }
    
    
    
    
    printf( "\n\n" );
    
    
    
}
- (void)setupUI{
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
            break;
        default:
            self.callingView.hidden = NO;
            self.receiveView.hidden = YES;
            self.conversationView.hidden = YES;
            break;
    }
}
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
    [[XHEchoCancellation shared] stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showError:(NSError*)error{
//    [UIWindow ilg_makeToast:[NSString stringWithFormat:@"%@",error.userInfo]];
}

-(void)initWriteToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    pcmFile_input = [documentsDirectory stringByAppendingPathComponent:@"voipEchoCancel_input.pcm"];
    [fileManager removeItemAtPath:pcmFile_input error:nil];
    [fileManager createFileAtPath:pcmFile_input contents:nil attributes:nil];
    fileHandle_input = [NSFileHandle fileHandleForWritingAtPath:pcmFile_input];
    
    pcmFile_output = [documentsDirectory stringByAppendingPathComponent:@"voipEchoCancel_output.pcm"];
    [fileManager removeItemAtPath:pcmFile_output error:nil];
    [fileManager createFileAtPath:pcmFile_output contents:nil attributes:nil];
    fileHandle_output = [NSFileHandle fileHandleForWritingAtPath:pcmFile_output];
}

- (void)writeData_input:(NSData *)data
{
    if (fileHandle_input) {
        [fileHandle_input writeData:data];
    }
}

- (void)writeData_output:(NSData *)data
{
    if (fileHandle_output) {
        [fileHandle_output writeData:data];
    }
}
@end

@implementation A

- (void)setMData:(void * _Nullable)mData mDataByteSize:(UInt32)mDataByteSize {
    _mData = malloc(sizeof(Byte)*mDataByteSize);
    memcpy(_mData, mData, mDataByteSize);
    _mDataByteSize = mDataByteSize;
}

- (void)free{
    free(_mData);
}


@end
