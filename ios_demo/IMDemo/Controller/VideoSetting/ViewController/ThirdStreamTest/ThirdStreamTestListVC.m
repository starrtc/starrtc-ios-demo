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

#import "XHCustomConfig.h"
#import "XHClient.h"
#import "RtspInfo.h"

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
- (void)getListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    NSArray *listArr = [dict objectForKey:@"data"];
    if (status == 1) {
        [self refreshListDidEnd:listArr];
    } else {
        [self refreshListDidEnd:nil];
    }
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
    
    RtspInfo *item = [_listArr objectAtIndex:indexPath.row];
    cell.topL.text = item.Name;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.Creator];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.Name, item.ID]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"list_list_icon"] forState:UIControlStateNormal];
    //To do:直播状态处理
    //    BOOL liveState = [dic[@"liveState"] boolValue];
    //    cell.rightL.hidden = !liveState;
    
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
    
    if ([AppConfig AEventCenterEnable])
    {
        [self.m_interfaceUrls demoQueryList:LIST_TYPE_PUSH_ALL];
    }
    else
    {
        
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].roomManager queryChatroomList:UserId type:LIST_TYPE_PUSH_ALL completion:^(NSString *listInfo, NSError *error) {
            NSData *jsonData = nil;
            NSArray *listuserDefineDataList;
            if (listInfo) {
                jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
                id obj  = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                
                if ([obj isKindOfClass:[NSArray class]]) {
                    
                    NSMutableArray * array = obj;
                    NSLog(@"*************%@",array);
                }else{
                    
                    NSMutableDictionary * dict = obj;
                    NSString * userDefineDataList = [dict objectForKey:@"userDefineDataList"] ;
                    if(userDefineDataList)
                    {
                        listuserDefineDataList = [userDefineDataList componentsSeparatedByString:@","];
                    }
                    
                }
            }
            
            [weakSelf refreshListDidEnd:listuserDefineDataList];
            
        }];
    }
}

- (void)refreshListDidEnd:(NSArray *)listArr
{
    if(listArr)
    {
        if (_listArr.count != 0)
        {
            [_listArr removeAllObjects];
        }
        if([AppConfig AEventCenterEnable])
        {
            for (int index = 0; index < listArr.count; index++)
            {
                NSString *str = [listArr[index] objectForKey:@"data"];
                if(str)
                {
                    NSString *strDecoded = [str ilg_URLDecode];
                    if(!strDecoded)
                    {
                        continue;
                    }
                    NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                    if(!jsonData)
                    {
                        continue;
                    }
                    NSError *error = nil;
                    NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
                    if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                        continue;
                    }
                    
                    RtspInfo *item = [[RtspInfo alloc] init];
                    item.Name = subDic[@"name"];
                    item.Creator = subDic[@"creator"];
                    item.rtsp = subDic[@"rtsp"];
                    item.ID = subDic[@"id"];
                    if(subDic[@"type"])
                    {
                        item.type = [subDic[@"type"] integerValue];
                    }
                    else
                    {
                        item.type = LIST_TYPE_CHATROOM;
                    }
                    
                    [_listArr addObject:item];
                }
            }
        }
        else
        {
            for (int index = 0; index < listArr.count; index++) {
                NSString *str = listArr[index];
                if(str)
                {
                    NSString *strDecoded = [str ilg_URLDecode];
                    NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
                    if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                        continue;
                    }
                    
                    RtspInfo *item = [[RtspInfo alloc] init];
                    item.Name = subDic[@"name"];
                    item.Creator = subDic[@"creator"];
                    item.rtsp = subDic[@"rtsp"];
                    item.ID = subDic[@"id"];
                    if(subDic[@"type"])
                    {
                        item.type = [subDic[@"type"] integerValue];
                    }
                    else
                    {
                        item.type = LIST_TYPE_CHATROOM;
                    }
                    
                    [_listArr addObject:item];
                }
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
