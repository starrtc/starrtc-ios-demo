//
//  IFLiveMessage.h
//  IMDemo
//
//  Created by HappyWork on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFLiveMessage : NSObject
@property (nonatomic, assign) int msgType; //消息类型
@property (nonatomic, copy) NSString *msgText; //消息文本
@property (nonatomic, copy) NSString *uid; //消息发送者uid
@property (nonatomic, copy) NSString *iconName; //随机分配的头像名称

@property (nonatomic, assign) CGFloat msgHeight; //消息高度
@property (nonatomic, assign) BOOL isJudgedForMic; //是否审批此连麦
@end

NS_ASSUME_NONNULL_END
