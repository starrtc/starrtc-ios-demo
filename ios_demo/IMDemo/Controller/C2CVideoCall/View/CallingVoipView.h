//
//  CallingVoipView.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CallingVoipView;
@protocol CallingVoipViewDelegate <NSObject>

//取消呼叫
- (void)callingVoipViewDidCancel:(CallingVoipView*) voipConversationView;

@end

@interface CallingVoipView : IFBaseView

@property (nonatomic, weak) id<CallingVoipViewDelegate> delegate;
- (void)setupUserNickname:(NSString*)nickname;

@end
