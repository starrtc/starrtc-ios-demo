//
//  IFThirdStreamTestListVC.m
//  IMDemo
//
//  Created by HappyWork on 2019/5/5.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "ThirdStreamTestListVC.h"
#import "ThirdStreamCreateVC.h"

#import "IFListView.h"
#import "IFListViewCell.h"

#import "InterfaceUrls.h"

@interface ThirdStreamTestListVC () <InterfaceUrlsdelegate>
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) IFListView *listView;
@property (nonatomic, strong) InterfaceUrls *m_interfaceUrls;
@end

@implementation ThirdStreamTestListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self createUI];
    
    [self refreshList];
}


#pragma mark - Data

- (void)initData {
    _listArr = [NSMutableArray array];
    
    _m_interfaceUrls = [[InterfaceUrls alloc] init];
    _m_interfaceUrls.delegate = self;
}


#pragma mark - UI

- (void)createUI {
    self.title = @"第三方流列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    _listView = listView;
    
    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建第三方拉流" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    if ([listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refreshList) forControlEvents:UIControlEventValueChanged];
        [listView.tableView setRefreshControl:refreshControl];
    }
}


#pragma mark - delegate
#pragma mark InterfaceUrlsdelegate
- (void)requestDidComplete:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    //    int status = [[dict objectForKey:@"status"] intValue];
    NSArray *listArr = [dict objectForKey:@"data"];
    [self refreshListDidEnd:listArr];
}

#pragma mark tableView delegate
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
    
//    NSUInteger row = [indexPath row];
//    IFMeetingItem *item = [_listArr objectAtIndex:row];
//    cell.topL.text = item.meetingName;
//    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.creatorName];
//    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.meetingName, item.creatorName]];
//    [cell.iconBtn setImage:[UIImage imageNamed:item.userIcon] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    IFMeetingItem *item = [_listArr objectAtIndex:indexPath.row];
//
//    IFMutilMeetingVC *vc = [[IFMutilMeetingVC alloc] initWithType:IFMutilMeetingVCTypeJoin];
//    vc.meetingId = item.meetingID;
//    vc.meetingName = item.meetingName;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Event

- (void)createBtnDidClicked
{
    ThirdStreamCreateVC *vc = [[ThirdStreamCreateVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList
{
    [self.view showProgressWithText:@"加载中..."];
    
    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        [self.m_interfaceUrls requestForThirdStreamList];
    } else {
        
        [self.m_interfaceUrls requestForThirdStreamList];
        
//        __weak typeof(self) weakSelf = self;
//        [[XHClient sharedClient].meetingManager queryMeetingList:@"" type:[NSString stringWithFormat:@"%d", CHATROOM_LIST_TYPE_MEETING] completion:^(NSString *listInfo, NSError *error) {
//            NSArray *listArr = nil;
//            if (listInfo) {
//                NSData *jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
//                listArr = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                          options:NSJSONReadingMutableContainers
//                                                            error:nil];
//            }
//
//            [weakSelf refreshListDidEnd:listArr];
//        }];
        
        [self refreshListDidEnd:nil];
    }
}

- (void)refreshListDidEnd:(NSArray *)listArr
{
    if (listArr.count != 0) {
        [_listArr removeAllObjects];
        
        if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
            for (int index = 0; index < listArr.count; index++) {
                NSDictionary *subDic = listArr[index];
                
//                IFMeetingItem *item = [[IFMeetingItem alloc] init];
//                //                item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
//                item.userIcon = @"meeting_list_icon";
//                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
//                item.meetingName = subDic[@"Name"];
//                item.creatorName = subDic[@"Creator"];
//                item.meetingID = subDic[@"ID"];
//
//                [_listArr addObject:item];
            }
        } else {
            for (int index = 0; index < listArr.count; index++) {
                NSString *str = listArr[index];
                NSString *strDecoded = [str ilg_URLDecode];
                NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
                if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                
//                IFMeetingItem *item = [[IFMeetingItem alloc] init];
//                //                item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
//                item.userIcon = @"meeting_list_icon";
//                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
//                item.meetingName = subDic[@"name"];
//                item.creatorName = subDic[@"creator"];
//                item.meetingID = subDic[@"id"];
//
//                [_listArr addObject:item];
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
