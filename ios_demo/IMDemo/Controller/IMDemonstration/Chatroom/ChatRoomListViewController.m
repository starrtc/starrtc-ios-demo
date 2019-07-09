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

#import "XHCustomConfig.h"

@interface ChatRoomListViewController ()
@property (nonatomic, strong) IFListView *listView;
@end

@implementation ChatRoomListViewController
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshList) name:@"IFChatroomListRefreshNotif" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initData {
    _listArr = [NSMutableArray array];
    
    // 请求会议室列表
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
}


#pragma mark - UI

- (void)createUI {
    self.title = @"聊天室列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    _listView = listView;

    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建聊天室" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createChatroomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    IFChatroomItem* item = [_listArr objectAtIndex:row];
    cell.topL.text = item.name;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.creatorId];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.name, item.creatorId]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"im_chatroomList_icon"] forState:UIControlStateNormal];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ChatRoomViewController *receive = [[ChatRoomViewController alloc] init];
    IFChatroomItem *item = [_listArr objectAtIndex:indexPath.row];
    receive.mRoomId = item.ID;
    receive.mRoomName = item.name;
    receive.mCreaterId = item.creatorId;
    receive.fromType = IFChatroomVCTypeFromList;
    
    [self.navigationController pushViewController:receive animated:YES];
}


#pragma mark - Event

- (void)createChatroomButtonClicked:(UIButton *)button {
    ChatRoomCreateViewController *vc = [[ChatRoomCreateViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)refreshList
{
    [self.view showProgressWithText:@"加载中..."];
    
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoQueryList:[NSString stringWithFormat:@"%d", LIST_TYPE_CHATROOM]];
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].roomManager queryChatroomList:@"" type:[NSString stringWithFormat:@"%d", LIST_TYPE_CHATROOM] completion:^(NSString *listInfo, NSError *error) {
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

               IFChatroomItem *item = [[IFChatroomItem alloc] init];
               item.name = subDic[@"name"];
               item.creatorId = subDic[@"creator"];
               item.ID = subDic[@"id"];

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
            
            IFChatroomItem *item = [[IFChatroomItem alloc] init];
            item.name = subDic[@"name"];
            item.creatorId = subDic[@"creator"];
            item.ID = subDic[@"id"];
            
            [_listArr addObject:item];
        }
      }
            
            [_listView.tableView reloadData];

//        }
    }
    [self.view hideProgress];
    if ([_listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        if (_listView.tableView.refreshControl && _listView.tableView.refreshControl.refreshing) {
            [_listView.tableView.refreshControl endRefreshing];
        }
    }
}

// data={"roomIdList":"a4alcSjTUWudiHOk,a4aKL1on4Wudgkjo,a4a@0X93MWudfqeS","creatorList":"142003,142003,142003","userDefineDataList":"Iij,Trr,Ttt"}

- (void)refreshListDidEnd_BK:(NSArray *)listArr
{
    if (listArr.count != 0) {
        [_listArr removeAllObjects];
        
        //if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
//            for (int index = 0; index < listArr.count; index++) {
//                NSDictionary *subDic = listArr[index];
//
//                IFChatroomItem *item = [[IFChatroomItem alloc] init];
//                item.name = subDic[@"Name"];
//                item.creatorId = subDic[@"Creator"];
//                item.ID = subDic[@"ID"];
//
//                [_listArr addObject:item];
//            }
//        } else
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

                IFChatroomItem *item = [[IFChatroomItem alloc] init];
                item.name = subDic[@"name"];
                item.creatorId = subDic[@"creator"];
                item.ID = subDic[@"id"];

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

@implementation IFChatroomItem

@end
