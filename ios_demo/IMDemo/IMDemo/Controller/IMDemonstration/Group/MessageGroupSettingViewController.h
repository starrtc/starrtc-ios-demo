//
//  MessageGroupSettingViewController.h
//  IMDemo
//
//  Created by  Admin on 2018/1/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceUrls.h"


#import "IFBaseVC.h"

@interface MessageGroupSettingViewController : IFBaseVC

@property NSString *groupID;
@property (nonatomic, assign) BOOL isOwner; //是否是群主

@end
