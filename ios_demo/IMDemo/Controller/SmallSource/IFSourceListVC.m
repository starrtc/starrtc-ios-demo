//
//  IFSourceListVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFSourceListVC.h"

#import "IFSourceVC.h"
#import "IFCreateSourceVC.h"

#import "IFListView.h"
#import "IFListViewCell.h"

#import "InterfaceUrls.h"
#import "XHCustomConfig.h"

@interface IFSourceListVC () <InterfaceUrlsdelegate>
@property (nonatomic, strong) IFListView *listView;
@property (nonatomic, strong) NSMutableArray *listArr;
@end

@implementation IFSourceListVC
{
    InterfaceUrls             *m_interfaceUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];

    _listArr = [NSMutableArray array];

    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    [self refreshList];

//    [UIView showProgressWithText:@"加载中..."];
//    [m_interfaceUrls requestSourceList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createUI {
    self.title = @"小班课列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    _listView = listView;
    
    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建小班课" forState:UIControlStateNormal];
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
    
    IFSourceItem *item = [_listArr objectAtIndex:indexPath.row];
    cell.topL.text = item.liveName;
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", item.creatorID];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", item.liveName, item.creatorID]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"list_list_icon"] forState:UIControlStateNormal];
//    BOOL liveState = [dic[@"liveState"] boolValue];
//    cell.rightL.hidden = !liveState;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IFSourceItem *item = [_listArr objectAtIndex:indexPath.row];
    
    IFSourceVCType type = IFSourceVCTypeLook;
    if ([item.creatorID isEqualToString:[IMUserInfo shareInstance].userID]) {
        type = IFSourceVCTypeStart;
    }
    IFSourceVC *vc = [IFSourceVC viewControllerWithType:type];
    vc.liveId = item.ID;
    vc.creator = item.creatorID;
//    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}


#pragma mark - Event

- (void)createBtnDidClicked {
    IFCreateSourceVC *vc = [[IFCreateSourceVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList
{
    [self.view showProgressWithText:@"加载中..."];
    
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoQueryList:LIST_TYPE_CLASS];
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
                    
                    IFSourceItem *item = [[IFSourceItem alloc] init];
                    item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                    item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                    item.liveName = subDic[@"name"];
                    item.creatorID = subDic[@"creator"];
                    item.ID = subDic[@"id"];
                    
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
                    
                    IFSourceItem *item = [[IFSourceItem alloc] init];
                    item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                    item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                    item.liveName = subDic[@"name"];
                    item.creatorID = subDic[@"creator"];
                    item.ID = subDic[@"id"];
                    
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


@implementation IFSourceItem


@end
