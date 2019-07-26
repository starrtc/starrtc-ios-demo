//
//  SuperRoomChatView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "SuperRoomChatView.h"


@interface SuperRoomChatView ()
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UIButton *button;
@end

@implementation SuperRoomChatView

- (instancetype)initWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = _delegate;
    tableView.dataSource = _delegate;
    tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.layer.masksToBounds = YES;
    tableView.layer.cornerRadius = 8;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView = tableView;
    
    
    [self addSubview:tableView];

    
    __weak typeof(self) weakSelf = self;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.leading.equalTo(weakSelf).offset(0);
        make.trailing.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(weakSelf).offset(-5);
    }];
    self.messagesDataSource = [NSMutableArray arrayWithCapacity:1];
}

- (void)addMessage:(SuperRoomMessageModel*)message{
    if (message == nil) {
        return;
    }
    if (self.messagesDataSource.count > 100) {
        [self.messagesDataSource removeObjectAtIndex:0];
    }
    [self.messagesDataSource addObject:message];
    [self.tableView reloadData];
    //    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesDataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}



#pragma mark - other


@end
