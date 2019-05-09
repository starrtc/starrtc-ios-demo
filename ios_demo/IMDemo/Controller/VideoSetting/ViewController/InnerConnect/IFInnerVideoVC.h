//
//  IFInnerVideoVC.h
//  IMDemo
//
//  Created by HappyWork on 2019/2/20.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , IFInnerConversationStatus) {
    IFInnerConversationStatus_Calling = 1,
    IFInnerConversationStatus_Conversation = 2,
    IFInnerConversationStatus_Receiving = 3,
};

NS_ASSUME_NONNULL_BEGIN

@interface IFInnerVideoVC : UIViewController

- (void)configureTargetId:(NSString *)targetId status:(IFInnerConversationStatus)status;
- (void)updateConversationState:(IFInnerConversationStatus)status;

- (void)backup;

@end

NS_ASSUME_NONNULL_END
