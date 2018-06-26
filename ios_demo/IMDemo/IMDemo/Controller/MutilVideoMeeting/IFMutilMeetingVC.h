//
//  IFMutilMeetingVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

typedef NS_ENUM(int, IFMutilMeetingVCType) {
    IFMutilMeetingVCTypeJoin = 0, //加入
    IFMutilMeetingVCTypeCreate = 1 //创建
};

@interface IFMutilMeetingVC : IFBaseVC
@property NSString *meetingId;
@property (nonatomic, copy) NSString *meetingName;

- (instancetype)initWithType:(IFMutilMeetingVCType)type;

@end
