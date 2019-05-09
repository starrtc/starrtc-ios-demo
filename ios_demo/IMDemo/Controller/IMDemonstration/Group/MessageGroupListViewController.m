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
@property (nonatomic, strong) IFListView *listView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation MessageGroupListViewController
{
    InterfaceUrls *m_interfaceUrls;
    
    NSInteger selectItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self createUI];

    [self refreshList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"IFGroupListRefreshNotif" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data

- (void)initData {
    _listArr = [NSMutableArray array];
    
    // 请求群组列表
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
}


#pragma mark - UI

- (void)createUI {
    self.title = @"群组列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    _listView = listView;
    
    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建群组" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
        [listView.tableView setRefreshControl:refreshControl];
    }
}


#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate
- (void)getMessageGroupListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    NSArray *listArr = [dict objectForKey:@"data"];
    if (status == 1 && [listArr isKindOfClass:[NSArray class]]) {
        [self refreshListDidEnd:listArr];
    } else {
        [self refreshListDidEnd:nil];
    }
}

#pragma mark tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    
    NSUInteger row = [indexPath row];
    IFGroupItem *item = [_listArr objectAtIndex:row];
    cell.topL.text = item.groupName;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.creatorId];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.groupName, item.creatorId]];
    [cell.iconBtn setImage:[UIImage imageNamed:item.userIcon] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectItem = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageGroupViewController *receive = [[MessageGroupViewController alloc] init];
    receive.USER_TYPE = @"GROUP_ID";
    IFGroupItem* item = [_listArr objectAtIndex:selectItem];
    receive.m_Group_ID = item.groupId;
    receive.m_Group_Name = item.groupName;
    receive.creatorID = item.creatorId;
    [self.navigationController pushViewController:receive animated:YES];
}


#pragma mark - Event

- (void)createGroupButtonClicked:(UIButton *)button
{
    MessageGroupCreateViewController *vc = [[MessageGroupCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList
{
    [self.view showProgressWithText:@"加载中..."];
    
    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        [m_interfaceUrls demoRequestGroupList];
    } else {
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].groupManager queryGroupList:^(NSString *listInfo, NSError *error) {
            NSArray *listArr = nil;
            if (listInfo) {
                NSData *jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
                listArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf refreshListDidEnd:listArr];
            });
        }];
    }
}

- (void)refreshListDidEnd:(NSArray *)listArr
{
    if (listArr.count != 0) {
        [_listArr removeAllObjects];
        
        if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
            for (int index = 0; index < listArr.count; index++) {
                NSDictionary *subDic = listArr[index];
                
                IFGroupItem *item = [[IFGroupItem alloc] init];
                item.userIcon = @"im_groupList_icon";
                item.groupName = subDic[@"groupName"];
                item.creatorId = subDic[@"creator"];
                item.groupId = subDic[@"groupId"];
                
                [_listArr addObject:item];
            }
        } else {
            for (int index = 0; index < listArr.count; index++) {
                NSDictionary *subDic = listArr[index];
                if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                
                IFGroupItem *item = [[IFGroupItem alloc] init];
                item.userIcon = @"im_groupList_icon";
                item.groupName = subDic[@"groupName"];
                item.creatorId = subDic[@"creator"];
                item.groupId = subDic[@"groupId"];
                
                [_listArr addObject:item];
            }
        }
        
        [_listView.tableView reloadData];
    }
    
    [self.view hideProgress];
    if ([_listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        if (_listView.tableView.refreshControl && _listView.tableView.refreshControl.refreshing) {
            [_listView.tableView.refreshControl endRefreshing];
        }
    }
}

@end


@implementation IFGroupItem

@end
