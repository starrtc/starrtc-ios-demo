//
//  ReceiveVoipView.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReceiveVoipView;
@protocol ReceiveVoipViewDelegate <NSObject>

//拒绝来电
- (void)receiveVoipViewDidRefuse:(ReceiveVoipView*) receiveVoipView;
//同意来电
- (void)receiveVoipViewDidAgree:(ReceiveVoipView*) receiveVoipView;

@end

@interface ReceiveVoipView : IFBaseView

@property (nonatomic, weak) id<ReceiveVoipViewDelegate> delegate;
- (void)setupUserNickname:(NSString*)nickname;

@end
