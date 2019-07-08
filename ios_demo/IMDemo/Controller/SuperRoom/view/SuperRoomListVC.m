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
#import "GuestSuperRoomVC.h"
#import "MJRefresh.h"


@interface SuperRoomListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SuperRoomListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        [self requetRefreshAudioList];
    }];
    //    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        [self requestLoadAudioList];
    //    }];
    [self.tableView.mj_header beginRefreshing];
}


- (void)requetRefreshAudioList{
    //    ID=%@&Name=%@&Creator=%@
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [parameters setObject:[AppConfig shareConfig].appId forKey:@"appid"];
//    [IFNetworkingInterfaceHandle requestAudioListWithParameters:parameters success:^(id  _Nullable responseObject) {
//        [self.tableView.mj_header endRefreshing];
//        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
//        switch (status) {
//            case 1:{
//                [self.tableViewDataSource removeAllObjects];
//                NSArray *dataList = [responseObject objectForKey:@"data"];
//                NSArray<SpeechRoomModel*> *list = [AssignToObject QGCustomModel:@"SpeechRoomModel" ToArray:dataList];
//                [self.tableViewDataSource addObjectsFromArray:list];
//            }
//                break;
//
//            default:
//                break;
//        }
//        [self.tableView reloadData];
//
//    } failure:^(NSError * _Nonnull error) {
//        [self.tableView.mj_header endRefreshing];
//    }];
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
        
        if ([model.Creator isEqualToString:UserId]) {
            SuperRoomVC *vc = [SuperRoomVC instanceFromNib];
            vc.roomInfo = model;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            GuestSuperRoomVC * vc = [GuestSuperRoomVC instanceFromNib];
            vc.roomInfo = model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}




- (IBAction)SuperRoomBtnclicked:(id)sender {
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
