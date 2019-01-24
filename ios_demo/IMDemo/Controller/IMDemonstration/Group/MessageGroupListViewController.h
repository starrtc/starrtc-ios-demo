//
//  MessageGroupListViewController.h
//  IMDemo
//
//  Created by  Admin on 2018/1/5.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceUrls.h"

#import "IFBaseVC.h"

@interface MessageGroupListViewController : IFBaseVC

@end


@interface MessageGroupInfo: NSObject

@property  NSString *  groupName;
@property  NSString *  creator;
@property  NSString *  groupId;

@end
