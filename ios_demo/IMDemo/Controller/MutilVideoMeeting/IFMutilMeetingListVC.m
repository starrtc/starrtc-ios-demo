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
#import "XHCustomConfig.h"

@interface IFMutilMeetingListVC () <InterfaceUrlsdelegate>
@property (nonatomic, strong) IFListView *listView;
@end

@implementation IFMutilMeetingListVC
{
    InterfaceUrls *m_interfaceUrls;
    
    NSMutableArray *_listArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self createUI];

    [self refreshList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data

- (void)initData {
    _listArr = [NSMutableArray array];
    
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
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

- (void)createBtnDidClicked
{
    IFCreateMeetingVC *vc = [[IFCreateMeetingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList
{
    [self.view showProgressWithText:@"加载中..."];
    
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoQueryList:LIST_TYPE_MEETING];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].meetingManager queryMeetingList:UserId type:[NSString stringWithFormat:@"%d", LIST_TYPE_MEETING] completion:^(NSString *listInfo, NSError *error) {
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
            for (int index = 0; index < listArr.count; index++) {
                NSString *str = [listArr[index] objectForKey:@"data"];
                NSString *strDecoded = [str ilg_URLDecode];
                NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
                if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                
                IFMeetingItem *item = [[IFMeetingItem alloc] init];
                item.userIcon = @"meeting_list_icon";
                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                item.meetingName = subDic[@"name"];
                item.creatorName = subDic[@"creator"];
                item.meetingID = subDic[@"id"];
                
                [_listArr addObject:item];
            }
        }
        else
        {
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
                
                IFMeetingItem *item = [[IFMeetingItem alloc] init];
                item.userIcon = @"meeting_list_icon";
                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                item.meetingName = subDic[@"name"];
                item.creatorName = subDic[@"creator"];
                item.meetingID = subDic[@"id"];
                
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


- (void)refreshListDidEnd_bk:(NSData *)recvData
{
    NSString*str =  [[NSString alloc]initWithData:recvData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    if(recvData)
    {
        NSError * error = nil;
        id obj  = [NSJSONSerialization JSONObjectWithData:recvData options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *listroomIdList;
        NSArray *listcreatorList;
        NSArray *listuserDefineDataList;
        NSArray *listchannelIdList;
        
        
        // 判断一下,id是NSMutableArray类型还是NSMutableDictionary
        if ([obj isKindOfClass:[NSArray class]]) {
            
            NSMutableArray * array = obj;
            NSLog(@"*************%@",array);
        }else{
            
            NSMutableDictionary * dict = obj;
            
            NSString *channelIdList = [dict objectForKey:@"channelIdList"];
            
            NSString * roomIdList = [dict objectForKey:@"roomIdList"] ;
            
            NSString * creatorList = [dict objectForKey:@"creatorList"] ;
            
            NSString * userDefineDataList = [dict objectForKey:@"userDefineDataList"] ;
            
            if(roomIdList)
            {
                listroomIdList = [roomIdList componentsSeparatedByString:@","];
            }
            
            if(creatorList)
            {
                listcreatorList = [creatorList componentsSeparatedByString:@","];
            }
            
            if(userDefineDataList)
            {
                listuserDefineDataList = [userDefineDataList componentsSeparatedByString:@","];
            }
            
            if(channelIdList)
            {
                listchannelIdList = [channelIdList componentsSeparatedByString:@","];
            }
            
            if (_listArr.count != 0)
            {
                [_listArr removeAllObjects];
            }
            
            for (int index = 0; index < listuserDefineDataList.count; index++) {
                NSString *str = listuserDefineDataList[index];
                NSString *strDecoded = [str ilg_URLDecode];
                NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = nil;
                NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:&error];
                if (!subDic || ![subDic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                
                IFMeetingItem *item = [[IFMeetingItem alloc] init];
                //                item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                item.userIcon = @"meeting_list_icon";
                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                item.meetingName = subDic[@"name"];
                item.creatorName = subDic[@"creator"];
                item.meetingID = subDic[@"id"];
                
                [_listArr addObject:item];
            }
            [_listView.tableView reloadData];
            

        }
    }
    
    
    [self.view hideProgress];
    if ([_listView.tableView respondsToSelector:@selector(setRefreshControl:)])
    {
        if (_listView.tableView.refreshControl && _listView.tableView.refreshControl.refreshing)
        {
            [_listView.tableView.refreshControl endRefreshing];
        }
    }
    

}


@end

@implementation IFMeetingItem
@end
