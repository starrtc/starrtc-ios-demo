//
//  IFMutilMeetingVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

@interface IFMutilMeetingListVC : IFBaseVC

@end


@interface IFMeetingItem : NSObject
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *meetingID;
@property (nonatomic, copy) NSString *meetingName;
@property (nonatomic, copy) NSString *userIcon; //用户头像
@property (nonatomic, copy) NSString *coverIcon; //封面
@end
