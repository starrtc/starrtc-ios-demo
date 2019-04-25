//
//  IFMutilMeetingVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFMutilMeetingListVC.h"

#import "IFMutilMeetingVC.h"
#import "IFCreateMeetingVC.h"

#import "IFListView.h"
#import "IFListViewCell.h"

#import "InterfaceUrls.h"

@interface IFMutilMeetingListVC () <InterfaceUrlsdelegate>
@property (nonatomic, strong) IFListView *listView;
@end

@implementation IFMutilMeetingListVC

{
    InterfaceUrls             *m_interfaceUrls;
    
    NSMutableArray            *_listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];

    _listArr = [NSMutableArray array];
    
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    
    [self refreshList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createUI {
    self.title = @"视频会议列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    _listView = listView;

    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建多人视频会议" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if ([listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
        [listView.tableView setRefreshControl:refreshControl];
    }
}

#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate
- (void)getMeetingListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
//    int status = [[dict objectForKey:@"status"] intValue];
    NSArray *listArr = [dict objectForKey:@"data"];
    [self refreshListDidEnd:listArr];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

/**
 * 设置table的行数
 */
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
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
    IFMeetingItem *item = [_listArr objectAtIndex:row];
    cell.topL.text = item.meetingName;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.creatorName];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.meetingName, item.creatorName]];
    [cell.iconBtn setImage:[UIImage imageNamed:item.userIcon] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IFMeetingItem *item = [_listArr objectAtIndex:indexPath.row];
    
    IFMutilMeetingVC *vc = [[IFMutilMeetingVC alloc] initWithType:IFMutilMeetingVCTypeJoin];
    vc.meetingId = item.meetingID;
    vc.meetingName = item.meetingName;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Event
- (void)createBtnDidClicked {
    IFCreateMeetingVC *vc = [[IFCreateMeetingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList {
    [UIView showProgressWithText:@"加载中..."];

    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        [m_interfaceUrls demoRequestMeetingList];
    } else {
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].meetingManager queryMeetingList:^(NSString *listInfo, NSError *error) {
            NSData *jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *listArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
            [weakSelf refreshListDidEnd:listArr];
        }];
    }
}

- (void)refreshListDidEnd:(NSArray *)listArr {
    if (listArr.count != 0) {
        [_listArr removeAllObjects];

        if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
            for (int index = 0; index < listArr.count; index++) {
                NSMutableDictionary *subDic = listArr[index];
                
                IFMeetingItem *item = [[IFMeetingItem alloc] init];
                //            item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                item.userIcon = @"meeting_list_icon";
                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                item.meetingName = subDic[@"Name"];
                item.creatorName = subDic[@"Creator"];
                item.meetingID = subDic[@"ID"];
                
                [_listArr addObject:item];
            }
        } else {
            
        }
        
        [_listView.tableView reloadData];
    }
    
    [UIView hiddenProgress];
    if ([_listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        if (_listView.tableView.refreshControl && _listView.tableView.refreshControl.refreshing) {
            [_listView.tableView.refreshControl endRefreshing];
        }
    }
}

@end

@implementation IFMeetingItem
@end
