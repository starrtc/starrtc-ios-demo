//
//  VoipVideoVC.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"
typedef NS_ENUM(NSInteger , VoipVCStatus) {
    VoipVCStatus_Calling = 1,
    VoipVCStatus_Conversation = 2,
    VoipVCStatus_Receiving = 3,
};

typedef NS_ENUM(NSInteger , VoipShowType) {
    VoipShowType_Video = 1,
    VoipShowType_Audio = 2,
};

@interface VoipVideoVC : IFBaseVC

+ (instancetype)shareInstance;

- (instancetype)initWithNib;

@property (nonatomic, copy) NSString *targetId;//对方用户ID，（可能是呼叫方，也可能是接收方）

- (void)setupTargetId:(NSString*)targetId viopStatus:(VoipVCStatus)voipStatus showType:(VoipShowType)showType;

- (void)updateVoipState:(VoipVCStatus) voipStatus;

- (void)showVoipInViewController:(UIViewController *)delegate;
//返回
- (void)backup;

@end

