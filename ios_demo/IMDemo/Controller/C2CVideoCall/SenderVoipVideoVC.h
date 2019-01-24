//
//  SenderVoipVideoVC.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

typedef NS_ENUM(NSInteger , VoipType) {
    VoipType_send = 1,
    VoipType_receiver = 2,
};

#import "IFBaseVC.h"



@interface SenderVoipVideoVC : IFBaseVC

+ (instancetype)shareInstance;

- (instancetype)initWithToUserID:(NSString*)toUserID;

//关闭视频通话
- (void)closeVoip;
- (void)adjustVideoPreviewSize:(CGSize)size;

@end
