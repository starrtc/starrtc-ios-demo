//
//  SuperRoomListVC.m
//  IMDemo
//
//  Created by  Admin on 2019/7/2.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import "SuperRoomListVC.h"
#import "SuperRomListCell.h"
#import "SuperRoomVC.h"
#import "CreateSuperRoomVC.h"
#import "MJRefresh.h"
#import "InterfaceUrls.h"
#import "XHCustomConfig.h"

@interface SuperRoomListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    InterfaceUrls *m_interfaceUrls;
    SuperRoomModel *waitingDeleteItem;
}
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation SuperRoomListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [NSMutableArray array];
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    self.tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    [self setupUI];
    


}

- (void)setupUI{
    self.navigationItem.title = @"超级对讲机列表";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib * nibCell = [UINib nibWithNibName:@"SuperRoomListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:@"SuperRoomListCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requetRefreshSuperRoomList];
    }];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self requestLoadAudioList];
    //    }];
    [self.tableView.mj_header beginRefreshing];
    
    //添加长按事件
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressTableViewCell:)];
    gesture.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:gesture];
}



//tableViewCell长按事件
- (void)didLongPressTableViewCell:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        //获取到点击的位置
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return;
        
        //do something...
        waitingDeleteItem = [_tableViewDataSource objectAtIndex:indexPath.row];
        
        
        NSString *content = @"删除该条数据";
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:content preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteItem];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)deleteItem
{
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoDeleteFromList:waitingDeleteItem.creatorID listType:LIST_TYPE_SUPER_ROOM_ALL roomId:waitingDeleteItem.ID];
    }
    else
    {
        
        NSString *m_chatRoomID = [waitingDeleteItem.ID substringFromIndex:16];
        [[XHClient sharedClient].superRoomManager deleteFromSuperRoomList:m_chatRoomID listType:LIST_TYPE_SUPER_ROOM completion:^(NSError * _Nonnull error) {
            if(error == nil)
            {
                NSLog(@"删除成功");
                [self.tableViewDataSource removeObject:waitingDeleteItem];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }
            else
            {
                NSLog(@"删除失败");
            }
        }];
    }
}


#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate

-(void)getDemoDeleteFromListFin:(id)responseContent
{
    NSDictionary *dict = responseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    if (status == 1)
    {
        NSLog(@"删除成功");
        [self.tableViewDataSource removeObject:waitingDeleteItem];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    }
}

- (void)getListResponse:(id)responseContent {
    NSDictionary *dict = responseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    NSArray *listArr = [dict objectForKey:@"data"];
    if (status == 1) {
        [self.tableViewDataSource removeAllObjects];
        [_listArr removeAllObjects];
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
                    
                    SuperRoomModel *item = [[SuperRoomModel alloc] init];
                    item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                    item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                    item.liveName = subDic[@"name"];
                    item.creatorID = subDic[@"creator"];
                    item.ID = subDic[@"id"];
                    
                    [_listArr addObject:item];
                }
            }
            [self.tableViewDataSource addObjectsFromArray:_listArr];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            
        }
        
    }
    else
    {
        [self.tableView.mj_header endRefreshing];
    }
}

- (void)requetRefreshSuperRoomList{
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoQueryList:LIST_TYPE_SUPER_ROOM_ALL];
    }
    else
    {
        [[XHClient sharedClient].superRoomManager querySuperRoomList:@"" type:LIST_TYPE_SUPER_ROOM_ALL completion:^(NSString *listInfo, NSError *error)
         {
             if(error != nil)
             {
                 NSLog(@"%@", [error localizedDescription]);
                 if (_listArr.count != 0)
                 {
                     [_listArr removeAllObjects];
                 }
                 [self.tableViewDataSource addObjectsFromArray:_listArr];
                 [self.tableView reloadData];
                 [self.tableView.mj_header endRefreshing];
             }
             NSData *jsonData = nil;
             NSArray *listuserDefineDataList;
             if (listInfo) {
                 jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
                 id obj  = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
                 
                 if ([obj isKindOfClass:[NSArray class]]) {
                     
                     NSMutableArray * array = obj;
                     NSLog(@"*************%@",array);
                 }else{
                     
                     if (_listArr.count != 0)
                     {
                         [_listArr removeAllObjects];
                     }
                     
                     NSMutableDictionary * dict = obj;
                     NSString * userDefineDataList = [dict objectForKey:@"userDefineDataList"] ;
                     if(userDefineDataList)
                     {
                         listuserDefineDataList = [userDefineDataList componentsSeparatedByString:@","];
                         
                         for (int index = 0; index < listuserDefineDataList.count; index++)
                         {
                             NSString *str = listuserDefineDataList[index];
                             if(str)
                             {
                                 NSString *strDecoded = [str ilg_URLDecode];
                                 NSData *jsonData = [strDecoded dataUsingEncoding:NSUTF8StringEncoding];
                                 NSError *error = nil;
                                 NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                        options:NSJSONReadingMutableContainers
                                                                                          error:&error];
                                 if (!subDic || ![subDic isKindOfClass:[NSDictionary class]])
                                 {
                                     continue;
                                 }
                                 
                                 SuperRoomModel *item = [[SuperRoomModel alloc] init];
                                 item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                                 item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                                 item.liveName = subDic[@"name"];
                                 item.creatorID = subDic[@"creator"];
                                 item.ID = subDic[@"id"];
                                 
                                 [_listArr addObject:item];
                             }
                         }
                     }
                     
                     _listArr = (NSMutableArray *)[[_listArr reverseObjectEnumerator] allObjects];
                     [self.tableViewDataSource addObjectsFromArray:_listArr];
                     [self.tableView reloadData];
                     [self.tableView.mj_header endRefreshing];
                     
                 }
             }
         }];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuperRoomListCell * cell = (SuperRoomListCell*)[tableView dequeueReusableCellWithIdentifier:@"SuperRoomListCell"];
    if (self.tableViewDataSource.count > indexPath.row) {
        [cell setupCellData:self.tableViewDataSource[indexPath.row]];
    } else {
        [cell setupCellData:nil];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.tableViewDataSource.count) {
        
        SuperRoomModel *model = self.tableViewDataSource[indexPath.row];
        SuperRoomVC *vc = [SuperRoomVC instanceFromNib];
        vc.roomInfo = model;
        [self.navigationController pushViewController:vc animated:YES];

        
    }
}




- (IBAction)SuperRoomBtnclicked:(id)sender {
    CreateSuperRoomVC *vc = [CreateSuperRoomVC instanceFromNib];
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
