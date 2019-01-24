//
//  SpeechMessagesView.h
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechMessageCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpeechMessagesView : UIView

- (void)addMessage:(SpeechMessageModel*)message;

@end

NS_ASSUME_NONNULL_END
