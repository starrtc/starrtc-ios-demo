//
//  VoipList.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/18.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipListVC.h"
#import "VoipListTableViewCell.h"
#import "VoipReadyVC.h"
#import "VoipVideoVC.h"
#import "VoipHistoryManage.h"

@interface VoipListVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet UIButton *createVoipButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VoipListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewDataSource = [[VoipHistoryManage manage] getHistoryVoipList];
    [[VoipHistoryManage manage] sortList];
    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)setupUI{
    self.title = @"Voip会话列表";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    UINib * nibCell = [UINib nibWithNibName:@"VoipListTableViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibCell forCellReuseIdentifier:@"VoipListTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
}
#pragma mark -  点击事件

- (IBAction)createVoipButtonClicked:(UIButton *)sender {
    
    VoipReadyVC *vc = [[VoipReadyVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoipListTableViewCell * cell = (VoipListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"VoipListTableViewCell"];
    if (self.tableViewDataSource.count > indexPath.row) {
        [cell setupCellData:self.tableViewDataSource[indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0) __TVOS_PROHIBITED
{
    UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *userId = [self.tableViewDataSource[indexPath.row] objectForKey:@"userId"];
        [[VoipHistoryManage manage] deleteVoip:userId];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.tableViewDataSource.count) {
        NSString * userId = self.tableViewDataSource[indexPath.row][@"userId"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[VoipHistoryManage manage] visitUserInfoWithUserId:userId];
            [[VoipHistoryManage manage] sortList];
            [self.tableView reloadData];
        });
        [[VoipVideoVC shareInstance] setupTargetId:userId viopStatus:VoipVCStatus_Calling];
        [[VoipVideoVC shareInstance] showVoipInViewController:self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 64) {
        self.createVoipButton.hidden = NO;
        
    } else  if(scrollView.contentSize.height - scrollView.contentOffset.y < scrollView.frame.size.height + 49){
        self.createVoipButton.hidden = YES;
    } else {
        static CGFloat lastScrollOffset = 0;
        CGFloat y = scrollView.contentOffset.y;
        if (y > lastScrollOffset) {
            self.createVoipButton.hidden = YES;
        } else {
            //用户往下拖动，也就是屏幕内容向上滚动
            self.createVoipButton.hidden = NO;
        }
        lastScrollOffset = y;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
