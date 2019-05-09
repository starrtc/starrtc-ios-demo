//
//  ChatRoomListViewController.h
//  IMDemo
//
//  Created by  Admin on 2017/12/25.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceUrls.h"

#import "IFBaseVC.h"

@interface ChatRoomListViewController : IFBaseVC<UITableViewDataSource,UITableViewDelegate,InterfaceUrlsdelegate>

@end


@interface IFChatroomItem: NSObject

@property NSString *ID;
@property NSString *name;
@property NSString *creatorId;
@property NSString *USER_TYPE;

@end
