//
//  SpeechChatListVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechChatListVC.h"
#import "SpeechChatListCell.h"
#import "IFNetworkingInterfaceHandle.h"
#import "MJRefresh.h"
#import "GuestSpeechChatVC.h"
#import "CreateSpeechChatVC.h"
#import "SpeechChatVC.h"
#import "InterfaceUrls.h"
#import "XHCustomConfig.h"

@interface SpeechChatListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    InterfaceUrls *m_interfaceUrls;
}

@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end

@implementation SpeechChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _listArr = [NSMutableArray array];
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    self.tableViewDataSource = [NSMutableArray arrayWithCapacity:1];
    [self setupUI];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"语音直播列表";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib * nibCell = [UINib nibWithNibName:@"SpeechChatListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:@"SpeechChatListCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requetRefreshAudioList];
    }];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self requestLoadAudioList];
    //    }];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Delegate
#pragma mark InterfaceUrlsdelegate
- (void)getListResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
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
                    
                    SpeechRoomModel *item = [[SpeechRoomModel alloc] init];
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


- (void)requestLoadAudioList{
    
}
- (void)requetRefreshAudioList
{
    
    if([AppConfig AEventCenterEnable])
    {
        [m_interfaceUrls demoQueryList:LIST_TYPE_AUDIO_LIVE];
    }
    else
    {
        [[XHClient sharedClient].liveManager queryLiveList:UserId type:[NSString stringWithFormat:@"%d", LIST_TYPE_LIVE] completion:^(NSString *listInfo, NSError *error)
         {
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
                                
                                SpeechRoomModel *item = [[SpeechRoomModel alloc] init];
                                item.userIcon = [NSString stringWithFormat:@"userListIcon%d", (int)random()%5 + 1];
                                item.coverIcon = [NSString stringWithFormat:@"videoList%d", (int)random()%6 + 1];
                                item.liveName = subDic[@"name"];
                                item.creatorID = subDic[@"creator"];
                                item.ID = subDic[@"id"];
                                
                                [_listArr addObject:item];
                            }
                        }
                    }
                    
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
    SpeechChatListCell * cell = (SpeechChatListCell*)[tableView dequeueReusableCellWithIdentifier:@"SpeechChatListCell"];
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
        
        SpeechRoomModel *model = self.tableViewDataSource[indexPath.row];
        
        if ([model.creatorID isEqualToString:UserId]) {
            SpeechChatVC *vc = [SpeechChatVC instanceFromNib];
            vc.roomInfo = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            GuestSpeechChatVC * vc = [GuestSpeechChatVC instanceFromNib];
            vc.roomInfo = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}
- (IBAction)createSpeechButtonClicked:(UIButton *)sender {
    CreateSpeechChatVC *vc = [CreateSpeechChatVC instanceFromNib];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
