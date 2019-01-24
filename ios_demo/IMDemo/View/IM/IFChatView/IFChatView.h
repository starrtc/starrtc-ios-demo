//
//  IFChatView.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseView.h"

@protocol IFChatViewDelegate <NSObject>
- (void)chatViewDidSendText:(NSString *)text;
@optional
@end

@interface IFChatView : IFBaseView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *tableViewForMemberList;
@property (nonatomic, strong) UIButton *micButton;

@property (nonatomic, strong) UITextField *textField;

- (instancetype)initWithDelegate:(id<UITableViewDelegate, UITableViewDataSource, IFChatViewDelegate>)delegate;

@end
