//
//  SpeechChatListVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechChatListVC.h"
#import "SpeechChatListCell.h"
#import "IFNetworkingInterfaceHandle.h"
#import "MJRefresh.h"
#import "GuestSpeechChatVC.h"
#import "CreateSpeechChatVC.h"
#import "SpeechChatVC.h"

@interface SpeechChatListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpeechChatListVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
- (void)requestLoadAudioList{
    
}
- (void)requetRefreshAudioList{
//    ID=%@&Name=%@&Creator=%@
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setObject:[XHClient sharedClient].config.agentID forKey:@"appid"];
    [IFNetworkingInterfaceHandle requestAudioListWithParameters:parameters success:^(id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        switch (status) {
            case 1:{
                [self.tableViewDataSource removeAllObjects];
                NSArray *dataList = [responseObject objectForKey:@"data"];
                NSArray<SpeechRoomModel*> *list = [AssignToObject QGCustomModel:@"SpeechRoomModel" ToArray:dataList];
                [self.tableViewDataSource addObjectsFromArray:list];
            }
                break;
                
            default:
                break;
        }
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
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
        
        if ([model.Creator isEqualToString:UserId]) {
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
