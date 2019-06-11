//
//  VoipConversationView.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipConversationView.h"

@interface VoipConversationView ()

@property (weak, nonatomic) IBOutlet UIImageView *nickImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *callTimeLabel;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int count;

@end
@implementation VoipConversationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _nickImage.hidden = YES;
        _nickNameLabel.hidden = YES;
        _callTimeLabel.hidden = YES;
    }
    return self;
}


- (void)startTimer
{  //开始</span>
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.count = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
}



- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.count++;
    
    _callTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.count/60,self.count%60];
}



- (void)dealloc {   //销毁NSTimer</span>
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


- (void)setupUserNickname:(NSString*)nickname isAudio:(BOOL)isAudio
{
    if(isAudio)
    {
        _nickNameLabel.text = nickname;
        _nickNameLabel.hidden = NO;
        _nickImage.hidden = NO;
        _callTimeLabel.hidden = NO;
        [self startTimer];
    }
    else
    {
        _nickNameLabel.hidden = YES;
        _nickImage.hidden = YES;
        _callTimeLabel.hidden = YES;
    }
}

- (IBAction)switchCameraButtonClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(voipConversationViewSwitchCamera:)]){
        [_delegate voipConversationViewSwitchCamera:self];
    }
    
}
- (IBAction)hangupButtonClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(voipConversationViewDidHangup:)]){
        [_delegate voipConversationViewDidHangup:self];
    }
}

- (IBAction)recordScreenButtonClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(voipConversationViewRecordScreen:)]){
        [_delegate voipConversationViewRecordScreen:self];
    }
}

@end
