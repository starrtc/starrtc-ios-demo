//
//  IFLiveVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

typedef NS_ENUM(int, IFLiveVCType) {
    IFLiveVCTypeLook = 0, //观看他人直播
    IFLiveVCTypeStart = 1, //开始直播
    IFLiveVCTypeCreate = 2 //创建新直播
};

@interface IFLiveVC : IFBaseVC
@property (nonatomic, copy) NSString *liveId;
@property (nonatomic, copy) NSString *creator;

@property NSString *USER_TYPE;

- (instancetype)initWithType:(IFLiveVCType)type;
@end


@interface IFLiveMessage : NSObject
@property (nonatomic, assign) int msgType; //消息类型
@property (nonatomic, copy) NSString *msgText; //消息文本
@property (nonatomic, copy) NSString *uid; //消息发送者uid
@property (nonatomic, copy) NSString *iconName; //随机分配的头像名称

@property (nonatomic, assign) CGFloat msgHeight; //消息高度
@property (nonatomic, assign) BOOL isJudgedForMic; //是否审批此连麦
@end
