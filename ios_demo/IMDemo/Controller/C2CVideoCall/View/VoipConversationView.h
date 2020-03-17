//
//  VoipConversationView.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VoipConversationView;
@protocol VoipConversationViewDelegate <NSObject>



//挂断
- (void)voipConversationViewDidHangup:(VoipConversationView*) voipConversationView;
//切换摄像头
- (void)voipConversationViewSwitchCamera:(VoipConversationView*) voipConversationView;
//录屏
- (void)voipConversationViewRecordScreen:(VoipConversationView*) voipConversationView;

@end

@interface VoipConversationView : IFBaseView

- (void)setupUserNickname:(NSString*)nickname isAudio:(BOOL)isAudio;

@property (nonatomic, weak) id<VoipConversationViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *selfView;
@property (weak, nonatomic) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UIButton *hangUpButton;
@property (weak, nonatomic) IBOutlet UILabel *hangUpLabel;

@end
