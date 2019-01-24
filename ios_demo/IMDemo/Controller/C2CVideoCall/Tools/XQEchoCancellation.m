//
//  XQEchoCancellation.m
//  iOSEchoCancellation
//
//  Created by xxb on 2017/8/25.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "XQEchoCancellation.h"

typedef struct MyAUGraphStruct{
    AUGraph graph;
    AudioUnit remoteIOUnit;
} MyAUGraphStruct;


@interface XQEchoCancellation ()
{
    MyAUGraphStruct myStruct;
}
@property (nonatomic,assign) BOOL isCloseService; //没有声音服务
@property (nonatomic,assign) BOOL isNeedInputCallback; //需要录音回调(获取input即麦克风采集到的声音回调)
@property (nonatomic,assign) BOOL isNeedOutputCallback; //需要播放回调(output即向发声设备传递声音回调)

@end

@implementation XQEchoCancellation

@synthesize streamFormat;

+ (instancetype)shared
{
    static XQEchoCancellation *cancel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cancel = [[self alloc] init];
    });
    return cancel;
}
+ (instancetype)manager{
    return [[self alloc] init];
}

- (instancetype)init
{
    if (self = [super init])
    {
        _echoCancellationStatus = XQEchoCancellationStatus_close;
        self.isCloseService = YES;
        [self startService];
    }
    return self;
}

- (void)startInput
{
    [self startService];
    self.isNeedInputCallback = YES;
}
- (void)stopInput
{
    self.isNeedInputCallback = NO;
}
- (void)startOutput
{
    [self startService];
    self.isNeedOutputCallback = YES;
}
- (void)stopOutput
{
    self.isNeedOutputCallback = NO;
}
- (void)startService
{
    if (self.isCloseService == NO)
    {
        return;
    }
    
    [self setupSession];
    
    [self createAUGraph:&myStruct];
    
    [self setupRemoteIOUnit:&myStruct];
    
    [self startGraph:myStruct.graph];
    
    AudioOutputUnitStart(myStruct.remoteIOUnit);
    
    self.isCloseService = NO;
    NSLog(@"startService完成");
}
- (void)start{
    [self startInput];
    [self startOutput];
}
- (void)stop
{
    self.bl_input = nil;
    self.bl_output = nil;
    AudioOutputUnitStop(myStruct.remoteIOUnit);
    [self stopGraph:myStruct.graph];
    myStruct.graph = NULL;
    myStruct.remoteIOUnit = NULL;
}
- (void)openEchoCancellation
{
    if (self.isCloseService == YES)
    {
        return;
    }
    [self openOrCloseEchoCancellation:0];
}
- (void)closeEchoCancellation
{
    if (self.isCloseService == YES)
    {
        return;
    }
    [self openOrCloseEchoCancellation:1];
}
///0 开启，1 关闭
-(void)openOrCloseEchoCancellation:(UInt32)newEchoCancellationStatus
{
    if (self.isCloseService == YES)
    {
        return;
    }
    UInt32 echoCancellation;
    UInt32 size = sizeof(echoCancellation);
    CheckError(AudioUnitGetProperty(myStruct.remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &echoCancellation,
                                    &size),
               "kAUVoiceIOProperty_BypassVoiceProcessing failed");
    if (newEchoCancellationStatus == echoCancellation)
    {
        return;
    }
    
    CheckError(AudioUnitSetProperty(myStruct.remoteIOUnit,
                                    kAUVoiceIOProperty_BypassVoiceProcessing,
                                    kAudioUnitScope_Global,
                                    0,
                                    &newEchoCancellationStatus,
                                    sizeof(newEchoCancellationStatus)),
               "AudioUnitSetProperty kAUVoiceIOProperty_BypassVoiceProcessing failed");
    _echoCancellationStatus = newEchoCancellationStatus == 0 ? XQEchoCancellationStatus_open : XQEchoCancellationStatus_close;
}

-(void)startGraph:(AUGraph)graph
{
    CheckError(AUGraphInitialize(graph),
               "AUGraphInitialize failed");
    CheckError(AUGraphStart(graph),
               "AUGraphStart failed");
    _echoCancellationStatus = XQEchoCancellationStatus_open;
}

- (void)stopGraph:(AUGraph)graph
{
    if (self.isCloseService == YES)
    {
        return;
    }
    CheckError(AUGraphUninitialize(graph),
               "AUGraphUninitialize failed");
    CheckError(AUGraphStop(graph),
               "AUGraphStop failed");
    CheckError(AUGraphClose(graph), "AUGraphClose failed");
    
    self.isCloseService = YES;
    _echoCancellationStatus = XQEchoCancellationStatus_close;
}


-(void)createAUGraph:(MyAUGraphStruct*)augStruct{
    //Create graph
    CheckError(NewAUGraph(&augStruct->graph),
               "NewAUGraph failed");
    
    //Create nodes and add to the graph
    AudioComponentDescription inputcd = {0};
    inputcd.componentType = kAudioUnitType_Output;
    inputcd.componentSubType = kAudioUnitSubType_VoiceProcessingIO;
    inputcd.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    AUNode remoteIONode;
    //Add node to the graph
    CheckError(AUGraphAddNode(augStruct->graph,
                              &inputcd,
                              &remoteIONode),
               "AUGraphAddNode failed");
    
    //Open the graph
    CheckError(AUGraphOpen(augStruct->graph),
               "AUGraphOpen failed");
    
    //Get reference to the node
    CheckError(AUGraphNodeInfo(augStruct->graph,
                               remoteIONode,
                               &inputcd,
                               &augStruct->remoteIOUnit),
               "AUGraphNodeInfo failed");
}


-(void)setupRemoteIOUnit:(MyAUGraphStruct*)augStruct{
    //Open input of the bus 1(input mic)
    UInt32 inputEnableFlag = 1;
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    1,
                                    &inputEnableFlag,
                                    sizeof(inputEnableFlag)),
               "Open input of bus 1 failed");
    
    //Open output of bus 0(output speaker)
    UInt32 outputEnableFlag = 1;
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,
                                    0,
                                    &outputEnableFlag,
                                    sizeof(outputEnableFlag)),
               "Open output of bus 0 failed");
    
    UInt32 mFramesPerPacket = 1;
    UInt32 mBytesPerFrame = kChannels * kBits / 8;
    //Set up stream format for input and output
    streamFormat.mFormatID = kAudioFormatLinearPCM;
    streamFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    streamFormat.mSampleRate = kRate;
    streamFormat.mFramesPerPacket = mFramesPerPacket;
    streamFormat.mBytesPerFrame = mBytesPerFrame;
    streamFormat.mBytesPerPacket = mBytesPerFrame * mFramesPerPacket;
    streamFormat.mBitsPerChannel = kBits;
    streamFormat.mChannelsPerFrame = kChannels;
    
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &streamFormat,
                                    sizeof(streamFormat)),
               "kAudioUnitProperty_StreamFormat of bus 0 failed");
    
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    1,
                                    &streamFormat,
                                    sizeof(streamFormat)),
               "kAudioUnitProperty_StreamFormat of bus 1 failed");
    
    AURenderCallbackStruct input;
    input.inputProc = InputCallback_xb;
    input.inputProcRefCon = (__bridge void *)(self);
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Output,
                                    1,
                                    &input,
                                    sizeof(input)),
               "couldnt set remote i/o render callback for output");
    
    AURenderCallbackStruct output;
    output.inputProc = outputRenderTone_xb;
    output.inputProcRefCon = (__bridge void *)(self);
    CheckError(AudioUnitSetProperty(augStruct->remoteIOUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Input,
                                    0,
                                    &output,
                                    sizeof(output)),
               "kAudioUnitProperty_SetRenderCallback failed");
}

-(void)createRemoteIONodeToGraph:(AUGraph*)graph
{
    
}

-(void)setupSession
{
    NSError *error = nil;
    AVAudioSession* session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:&error];
    [session setActive:YES error:nil];
}


#pragma mark - 其他方法

static void CheckError(OSStatus error, const char *operation)
{
    if (error == noErr) return;
    char errorString[20];
    // See if it appears to be a 4-char-code
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(error);
    if (isprint(errorString[1]) && isprint(errorString[2]) &&
        isprint(errorString[3]) && isprint(errorString[4])) {
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    } else
        // No, format it as an integer
        sprintf(errorString, "%d", (int)error);
    fprintf(stderr, "Error: %s (%s)\n", operation, errorString);
    exit(1);
}

OSStatus InputCallback_xb(void *inRefCon,
                       AudioUnitRenderActionFlags *ioActionFlags,
                       const AudioTimeStamp *inTimeStamp,
                       UInt32 inBusNumber,
                       UInt32 inNumberFrames,
                       AudioBufferList *ioData){
    
    XQEchoCancellation *echoCancellation = (__bridge XQEchoCancellation*)inRefCon;
    if (echoCancellation.isNeedInputCallback == NO)
    {
//        NSLog(@"没有开启声音输入回调");
        return noErr;
    }
    MyAUGraphStruct *myStruct = &(echoCancellation->myStruct);
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = NULL;
    bufferList.mBuffers[0].mDataByteSize = 0;

    AudioUnitRender(myStruct->remoteIOUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      1,
                                      inNumberFrames,
                                      &bufferList);
//    AudioBuffer buffer = bufferList.mBuffers[0];
    
    if (echoCancellation.bl_input)
    {
        echoCancellation.bl_input(&bufferList);
    }

//    NSLog(@"InputCallback");
    return noErr;
}
OSStatus outputRenderTone_xb(
                          void *inRefCon,
                          AudioUnitRenderActionFlags 	*ioActionFlags,
                          const AudioTimeStamp 		*inTimeStamp,
                          UInt32 						inBusNumber,
                          UInt32 						inNumberFrames,
                          AudioBufferList 			*ioData)

{
    //TODO: implement this function
    memset(ioData->mBuffers[0].mData, 0, ioData->mBuffers[0].mDataByteSize);
    
    XQEchoCancellation *echoCancellation = (__bridge XQEchoCancellation*)inRefCon;
    if (echoCancellation.isNeedOutputCallback == NO)
    {
        //        NSLog(@"没有开启声音输出回调");
        return noErr;
    }
    if (echoCancellation.bl_output)
    {
        echoCancellation.bl_output(ioData,inNumberFrames);
    }

//    NSLog(@"outputRenderTone");
    return 0;
}

+ (void)volume_controlOut_buf:(short *)out_buf in_buf:(short *)in_buf in_len:(int)in_len in_vol:(float)in_vol
{
    volume_control(out_buf, in_buf, in_len, in_vol);
}

// 音量控制
// output: para1 输出数据
// input : para2 输入数据
//         para3 输入长度
//         para4 音量控制参数,有效控制范围[0,100]
// 超过100，则为倍数，倍数为in_vol减去98的数值
int volume_control(short* out_buf,short* in_buf,int in_len, float in_vol)
{
    int i,tmp;
    
    // in_vol[0,100]
    float vol = in_vol - 98;
    
    if(-98 < vol  &&  vol <0 )
    {
        vol = 1/(vol*(-1));
    }
    else if(0 <= vol && vol <= 1)
    {
        vol = 1;
    }
    /*else if(1 < vol && vol <= 2)
     {
     vol = vol;
     }*/
    else if(vol <= -98)
    {
        vol = 0;
    }
    //    else if(2 = vol)
    //    {
    //        vol = 2;
    //    }
    
    for(i=0; i<in_len/2; i++)
    {
        tmp = in_buf[i]*vol;
        if(tmp > 32767)
        {
            tmp = 32767;
        }
        else if( tmp < -32768)
        {
            tmp = -32768;
        }
        out_buf[i] = tmp;
    }
    
    return 0;
}

- (void)dealloc{
    NSLog(@"XQEchoCancellation dealloc");
}

@end
