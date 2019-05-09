//
//  IFLiveListVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

@interface IFLiveListVC : IFBaseVC

@end

@interface IFLiveItem : NSObject
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *liveName;
@property (nonatomic, copy) NSString *userIcon; //用户头像
@property (nonatomic, copy) NSString *coverIcon; //封面
@end
