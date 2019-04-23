//
//  MessageGroupListViewController.m
//  IMDemo
//
//  Created by  Admin on 2018/1/5.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "MessageGroupListViewController.h"

#import "MessageGroupViewController.h"
#import "MessageGroupCreateViewController.h"

#import "IFListView.h"
#import "IFListViewCell.h"

@interface MessageGroupListViewController () <UITableViewDataSource,UITableViewDelegate,InterfaceUrlsdelegate>

@end

@implementation MessageGroupListViewController
{
    UITableView               *_tableView;
    InterfaceUrls             *m_interfaceUrls;
    
    NSMutableArray            *m_GroupInfo;
    NSInteger selectItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    m_GroupInfo = [NSMutableArray array];
    
    // 请求群组列表
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    
    [UIView showProgressWithText:@"加载中..."];
    [self refreshChatroomList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatroomList) name:@"IFGroupListRefreshNotif" object:nil];

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
    self.title = @"群组列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    
    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建群组" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tableView = listView.tableView;
    
    if ([listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshChatroomList) forControlEvents:UIControlEventValueChanged];
        [listView.tableView setRefreshControl:refreshControl];
    }
}

#pragma mark - Event

- (void)createGroupButtonClicked:(UIButton *)button
{
    MessageGroupCreateViewController *vc = [[MessageGroupCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshChatroomList {
    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [m_interfaceUrls demoRequestGroupList];
        });
    } else {
        [[XHClient sharedClient].groupManager queryGroupList:^(NSString *listInfo, NSError *error) {
            
        }];
    }
}


#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate
- (void)getMessageGroupListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    
    [m_GroupInfo removeAllObjects];
    if(status == 1) {

        NSDictionary *info = [dict objectForKey:@"data"];
        for (NSMutableDictionary *dict in info) {
            MessageGroupInfo *new_groupInfo = [[MessageGroupInfo alloc] init];
            new_groupInfo.groupName =  [dict objectForKey:@"groupName"];
            new_groupInfo.creator =  [dict objectForKey:@"creator"];
            new_groupInfo.groupId =  [dict objectForKey:@"groupId"];
            [m_GroupInfo addObject:new_groupInfo];
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

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_GroupInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    
    NSUInteger row = [indexPath row];
    MessageGroupInfo* one_chatinfo = [m_GroupInfo objectAtIndex:row];
    cell.topL.text = one_chatinfo.groupName;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", one_chatinfo.creator];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", one_chatinfo.groupName, one_chatinfo.creator]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"im_groupList_icon"] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectItem = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageGroupViewController *receive = [[MessageGroupViewController alloc] init];
    receive.USER_TYPE = @"GROUP_ID";
    MessageGroupInfo* one_groupinfo = [m_GroupInfo objectAtIndex:selectItem];
    receive.m_Group_ID = one_groupinfo.groupId;
    receive.m_Group_Name = one_groupinfo.groupName;
    receive.creatorID = one_groupinfo.creator;
    [self.navigationController pushViewController:receive animated:YES];
}

@end


@implementation MessageGroupInfo

@end
