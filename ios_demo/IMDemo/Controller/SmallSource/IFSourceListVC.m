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

@interface IFSourceListVC () <InterfaceUrlsdelegate>
@property (nonatomic, strong) IFListView *listView;
@property (nonatomic, strong) NSMutableArray *liveListArr;
@end

@implementation IFSourceListVC
{
    InterfaceUrls             *m_interfaceUrls;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];

    _liveListArr = [NSMutableArray array];
    
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    [UIView showProgressWithText:@"加载中..."];
    [m_interfaceUrls requestSourceList];
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
- (void)getMessageGroupListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    if(status == 1) {
        NSArray *listArr = [dict objectForKey:@"data"];
        
        [_liveListArr removeAllObjects];
        for (int index = 0; index < listArr.count; index++) {
            NSMutableDictionary *mutDic = [listArr[index] mutableCopy];
            mutDic[@"userIcon"] = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
            mutDic[@"coverIcon"] = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
            [_liveListArr addObject:mutDic];
        }
        
        [_listView.tableView reloadData];
    }
    
    if ([_listView.tableView respondsToSelector:@selector(setRefreshControl:)]) {
        if (_listView.tableView.refreshControl && _listView.tableView.refreshControl.refreshing) {
            [_listView.tableView.refreshControl endRefreshing];
        }
    }
    [UIView hiddenProgress];
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
    return _liveListArr.count;
}

/**
 * 设置table每一行的数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            TableSampleIdentifier];
    
    NSDictionary *dic = [_liveListArr objectAtIndex:indexPath.row];
    cell.topL.text = dic[@"Name"];
    cell.bottomL.text = [NSString stringWithFormat:@"创建者:%@", dic[@"Creator"]];
    cell.bgImageView.backgroundColor = [[IMUserInfo shareInstance] listIconColor:[NSString stringWithFormat:@"%@%@", dic[@"Name"], dic[@"Creator"]]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"list_list_icon"] forState:UIControlStateNormal];
    BOOL liveState = [dic[@"liveState"] boolValue];
    cell.rightL.hidden = !liveState;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = [_liveListArr objectAtIndex:indexPath.row];
    
    IFSourceVCType type = IFSourceVCTypeLook;
    if ([dic[@"Creator"] isEqualToString:[IMUserInfo shareInstance].userID]) {
        type = IFSourceVCTypeStart;
    }
    IFSourceVC *vc = [IFSourceVC viewControllerWithType:type];
    vc.liveId = dic[@"ID"];
    vc.creator = dic[@"Creator"];
//    [self.navigationController pushViewController:vc animated:YES];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
}


#pragma mark - Event

- (void)createBtnDidClicked {
    IFCreateSourceVC *vc = [[IFCreateSourceVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshList {
    [m_interfaceUrls requestSourceList];
}

@end
