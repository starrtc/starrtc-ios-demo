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
