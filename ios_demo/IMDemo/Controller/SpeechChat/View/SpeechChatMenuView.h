//
//  SpeechChatMenuView.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SpeechChatMenuView;
@protocol SpeechChatMenuViewDelegate <NSObject>

- (void)speechChatMenuView:(SpeechChatMenuView*)chatMenuView sendText:(NSString*)text;
- (void)speechChatMenuViewStartSpeech:(SpeechChatMenuView*)chatMenuView;
- (void)speechChatMenuViewStopSpeech:(SpeechChatMenuView*)chatMenuView;

@end

/**
 使用分类instanceFromNib方法进行初始化
 */
@interface SpeechChatMenuView : UIView

@property (nonatomic, weak) id<SpeechChatMenuViewDelegate> delegate;

-(void)hiddenAudioButton;

-(void)showAudioButton;



@end

NS_ASSUME_NONNULL_END
