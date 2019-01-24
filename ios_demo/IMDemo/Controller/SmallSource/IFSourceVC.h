//
//  IFSourceVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

typedef NS_ENUM(int, IFSourceVCType) {
    IFSourceVCTypeLook = 0, //观看他人课程
    IFSourceVCTypeStart = 1, //开始课程
    IFSourceVCTypeCreate = 2 //创建新课程
};

@interface IFSourceVC : IFBaseVC
@property (nonatomic, copy) NSString *liveId;
@property (nonatomic, copy) NSString *creator;

@property NSString *USER_TYPE;

+ (instancetype)viewControllerWithType:(IFSourceVCType)type;
@end
