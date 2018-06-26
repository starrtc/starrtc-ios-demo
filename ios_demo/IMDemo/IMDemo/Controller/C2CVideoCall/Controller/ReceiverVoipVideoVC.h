//
//  ReceiverVoipVideoVC.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

@interface ReceiverVoipVideoVC : IFBaseVC

- (instancetype)initWithToUserID:(NSString*)toUserID;
//关闭视频通话
- (void)closeVoip;
- (void)adjustVideoPreviewSize:(CGSize)size;

@end
