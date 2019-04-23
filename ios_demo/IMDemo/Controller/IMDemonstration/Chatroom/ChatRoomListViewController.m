//
//  ChatRoomListViewController.m
//  IMDemo
//
//  Created by  Admin on 2017/12/25.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "ChatRoomListViewController.h"

#import "ChatRoomViewController.h"
#import "ChatRoomCreateViewController.h"

#import "IFListView.h"
#import "IFListViewCell.h"

@interface ChatRoomListViewController ()

@end

@implementation ChatRoomListViewController
{
    UITableView               *_tableView;
    InterfaceUrls             *m_interfaceUrls;
    
    NSMutableArray            *m_ChatInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    
    m_ChatInfo = [NSMutableArray array];
    
    // 请求会议室列表
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    [UIView showProgressWithText:@"加载中..."];
    [m_interfaceUrls demoRequestChatroomList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatroomList) name:@"IFChatroomListRefreshNotif" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI

- (void)createUI {
    self.title = @"聊天室列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];

    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建聊天室" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createChatroomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tableView = listView.tableView;
    
    if ([listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshChatroomList) forControlEvents:UIControlEventValueChanged];
        [listView.tableView setRefreshControl:refreshControl];
    }
}

#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate
- (void)getChatRoomListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    
    [m_ChatInfo removeAllObjects];
    if(status == 1) {
        NSDictionary *info = [dict objectForKey:@"data"];
        for (NSMutableDictionary *dict in info) {
            ChatroomInfo *new_chatInfo = [[ChatroomInfo alloc] init];
            new_chatInfo.roomName =  [dict objectForKey:@"Name"];
            new_chatInfo.createrId =  [dict objectForKey:@"Creator"];
            new_chatInfo.roomId =  [dict objectForKey:@"ID"];
            [m_ChatInfo addObject:new_chatInfo];
        }
    }
    
    if ([_tableView respondsToSelector:@selector(setRefreshControl:)]) {
        if (_tableView.refreshControl && _tableView.refreshControl.refreshing) {
            [_tableView.refreshControl endRefreshing];
        }
    }
    [UIView hiddenProgress];
    [_tableView reloadData];
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

/**
 * 设置table的行数
 */
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_ChatInfo.count;
}

/**
 * 设置table每一行的数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    NSUInteger row = [indexPath row];
    ChatroomInfo* one_chatinfo = [m_ChatInfo objectAtIndex:row];
    cell.topL.text = one_chatinfo.roomName;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", one_chatinfo.createrId];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", one_chatinfo.roomName, one_chatinfo.createrId]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"im_chatroomList_icon"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatRoomViewController *receive = [[ChatRoomViewController alloc] init];
    ChatroomInfo *selectItemObject = [m_ChatInfo objectAtIndex:indexPath.row];
    receive.mRoomId = selectItemObject.roomId;
    receive.mRoomName = selectItemObject.roomName;
    receive.mCreaterId = selectItemObject.createrId;
    receive.fromType = IFChatroomVCTypeFromList;
    
    [self.navigationController pushViewController:receive animated:YES];
}


#pragma mark - Event

- (void)createChatroomButtonClicked:(UIButton *)button {
    ChatRoomCreateViewController *vc = [[ChatRoomCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshChatroomList {
    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [m_interfaceUrls demoRequestChatroomList];
        });
    } else {
        [[XHClient sharedClient].roomManager queryChatroomList:^(NSString *listInfo, NSError *error) {
            
        }];
    }
}

@end

@implementation ChatroomInfo

@end
