//
//  IFChatView.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseView.h"
#import "SuperRoomMessageModel.h"

@interface SuperRoomChatView : IFBaseView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewForMemberList;
@property (nonatomic, strong) NSMutableArray *messagesDataSource;

- (instancetype)initWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate;
- (void)addMessage:(SuperRoomMessageModel*)message;

@end
