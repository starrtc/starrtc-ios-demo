//
//  IFC2CSessionListVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/5/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFC2CSessionListVC.h"
#import "C2CViewController.h"
#import "ChatRoomViewController.h"

#import "IFListView.h"
#import "IFListViewCell.h"

#import "IMMsgManager.h"

@interface IFC2CSessionListVC () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation IFC2CSessionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArr = [NSMutableArray array];
    [_dataArr addObjectsFromArray:[[IMMsgManager sharedInstance] c2cSessionList]];
    
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageDidReceive:) name:IMChatMsgReceiveNotif object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}


#pragma mark - UI

- (void)createUI {
    self.title = @"一对一会话列表";
    
    CGRect frame = self.view.bounds;
    IFListView *listView = [[IFListView alloc] initWithDelegate:self frame:frame];
    [self.view addSubview:listView];
    
    [listView.tableView registerClass:[IFListViewCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    listView.tableView.rowHeight = 95;
    [listView.button setTitle:@"创建会话" forState:UIControlStateNormal];
    [listView.button addTarget:self action:@selector(createButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _tableView = listView.tableView;
}


#pragma mark - Delegate
#pragma mark tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                            TableSampleIdentifier];

    NSDictionary *record = self.dataArr[indexPath.row];
    cell.topL.text = record[@"sessionID"];
    cell.leftBottomL.text = record[@"lastMsg"];
    int number = [record[@"unReadNum"] intValue];
    
    cell.bottomL.textColor = [UIColor whiteColor];
    cell.bottomL.font = [UIFont systemFontOfSize:16];
    if (number == 0) {
        cell.bottomL.text = nil;
        cell.bottomL.backgroundColor = [UIColor clearColor];
    } else {
        cell.bottomL.text = [NSString stringWithFormat:@" %d ", number];
        cell.bottomL.backgroundColor = [UIColor redColor];
    }
    cell.rightL.hidden = NO;
    cell.rightL.text = [NSDate ilg_timeFromTimeStamp:record[@"lastTime"] format:@"MM:dd HH:mm"];
    cell.bgImageView.backgroundColor = [UIColor colorWithHexString:record[@"iconColor"]];
    [cell.iconBtn setImage:[UIImage imageNamed:@"im_groupList_icon"] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *record = [self.dataArr[indexPath.row] mutableCopy];
    NSString *targetID = record[@"sessionID"];
    [IMMsgManager sharedInstance].sessionIDForChating = targetID;
    
    //To do: 更新消息记录位置
    [[IMMsgManager sharedInstance] clearUnReadNumForSession:targetID];
    record[@"unReadNum"] = @"0";
    [self.dataArr replaceObjectAtIndex:indexPath.row withObject:record];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    ChatRoomViewController *vc = [[ChatRoomViewController alloc] init];
    vc.fromType = IFChatroomVCTypeFromC2C;
    vc.targetID = targetID;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Event

- (void)createButtonClicked:(UIButton *)button {
    C2CViewController *vc = [[C2CViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatMessageDidReceive:(NSNotification *)notif {
    NSDictionary *dic = notif.object;
    
    NSArray *array = [[IMMsgManager sharedInstance] c2cSessionList];
    [_dataArr removeAllObjects];
    [_dataArr addObjectsFromArray:array];
    [_tableView reloadData];
    
    NSLog(@"来新消息啦");
}


#pragma mark - Other
- (void)requestForList {
    [self.dataArr removeAllObjects];
    
    if ([IMUserInfo shareInstance].c2cSessionList.count == 0) {
        
        NSArray *cacheList = [ILGLocalData unArchiverObject:[ILGLocalData filePathFromDocuments:@"c2cSessionList"]];
        if (cacheList) {
            [self.dataArr addObjectsFromArray:cacheList];
            [[IMUserInfo shareInstance].c2cSessionList addObjectsFromArray:cacheList];
        }
    } else {
        [self.dataArr addObjectsFromArray:[IMUserInfo shareInstance].c2cSessionList];
    }
}
@end
