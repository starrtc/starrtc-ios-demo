//
//  VoipConversationView.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipConversationView.h"

@implementation VoipConversationView

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
