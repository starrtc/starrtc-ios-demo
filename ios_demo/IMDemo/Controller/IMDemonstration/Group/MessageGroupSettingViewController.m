//
//  MessageGroupSettingViewController.m
//  IMDemo
//
//  Created by  Admin on 2018/1/10.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "MessageGroupSettingViewController.h"

#import "IFGroupMemberCell.h"

@interface MessageGroupSettingViewController () <InterfaceUrlsdelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *m_GroupMemberInfo;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isMute;
@end

const int kSectionViewHeight = 55;
const static CGFloat kCollectionLineSpace = 18;
const static CGFloat kCollectionInteritemSpace = 22;
const static CGFloat kCollectionTopSpace = 21;
const static CGFloat kCollectionBottomSpace = 28;

static NSString *kMuteKey = @"kMuteKey";

@implementation MessageGroupSettingViewController
{
    UITableView               *DataTable;
    InterfaceUrls             *m_interfaceUrls;

    UIView *_headerView;
    UIView *_footerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    [self initData];
    
    [self requestForGroupInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initData {
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    
    _m_GroupMemberInfo = [NSMutableArray array];
}


#pragma mark - getter

- (BOOL)isMute {
//    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
//        BOOL isOn = [[ILGLocalData userDefaultObject:kMuteKey] boolValue];
//        return isOn;
//    } else
    {
        return _isMute;
    }
}


#pragma mark - UI

- (void)createUI {
    self.title = @"群组信息";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.tableFooterView = [self tableFooterView];
}

- (UIView *)tableHeaderView {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 280)];
    containerView.backgroundColor = [UIColor clearColor];
    _headerView = containerView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = kCollectionLineSpace;
    layout.minimumInteritemSpacing = kCollectionInteritemSpace;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [containerView addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[IFGroupMemberCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.leading.equalTo(containerView);
        make.trailing.equalTo(containerView);
        make.bottom.equalTo(containerView).offset(-10);
    }];
    
    return containerView;
}

- (UIView *)tableFooterView {
    CGFloat miniHeight = self.tableView.height - self.tableView.tableHeaderView.height - kSectionViewHeight - 64;
    if (miniHeight < 120) {
        miniHeight = 120;
    }
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, miniHeight)];
    containerView.backgroundColor = [UIColor clearColor];
    _footerView = containerView;
    
    UIButton *manageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [manageBtn setTitle:@"成员管理" forState:UIControlStateNormal];
    [manageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    manageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    manageBtn.backgroundColor = [UIColor greenColor];
    manageBtn.layer.masksToBounds = YES;
    manageBtn.layer.cornerRadius = 22;
    [manageBtn addTarget:self action:@selector(manageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitle:@"删除群" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    deleteBtn.backgroundColor = [UIColor redColor];
    deleteBtn.layer.masksToBounds = YES;
    deleteBtn.layer.cornerRadius = 22;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isOwner) {
        //    [containerView addSubview:manageBtn];
        [containerView addSubview:deleteBtn];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(containerView).offset(15);
            make.trailing.equalTo(containerView).offset(-15);
            make.bottom.equalTo(containerView).offset(-23);
            make.height.mas_equalTo(44);
        }];
        
        //    [manageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.bottom.equalTo(deleteBtn.mas_top).offset(-12);
        //        make.leading.equalTo(deleteBtn);
        //        make.trailing.equalTo(deleteBtn);
        //        make.height.equalTo(deleteBtn);
        //    }];
    }
    
    return containerView;
}

// 代理函数
- (void)getMessageGroupMemberResponse:(id)respnseContent {
    NSDictionary *dict = respnseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    if(status == 1) {
        NSMutableArray *mutArr = [[NSMutableArray alloc] init];
        NSArray *list = [dict objectForKey:@"data"];
        
        for (NSDictionary *dict in list) {
            NSString *newMemberID =  [dict objectForKey:@"userId"];
            [mutArr addObject:newMemberID];
        }
        if (self.isOwner) {
            [mutArr addObject:@""];
        }
        
        [self handleGroupInfo:mutArr];
    } else {
        [UIView ilg_makeToast:@"获取群组信息失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Event

- (void)manageBtnClick:(UIButton *)button {
//    [self removeMember:nil];
}

- (void)deleteBtnClick:(UIButton *)button {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确定要删除此群吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XHClient sharedClient].groupManager deleteGroup:weakSelf.groupID completion:^(NSError *error) {
            if (error) {
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IFGroupListRefreshNotif" object:nil];

                [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[weakSelf.navigationController.viewControllers.count - 3] animated:YES];
            }
        }];
    }];
    [alertController addAction:sureAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)switchValueChanged:(UISwitch *)switchControl {
    BOOL isMute = switchControl.on;
    
//    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
//        [ILGLocalData userDefaultSave:@(isMute) key:kMuteKey];
//    } else
    {
        [[XHClient sharedClient].groupManager setGroup:_groupID pushEnable:isMute completion:^(NSError *error) {
            
        }];
    }
}

#pragma mark - Delegate
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (kCollectionInteritemSpace * 4) - 15*2) / 5.0;
    CGFloat height = width/52*82;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(kCollectionTopSpace, 15, kCollectionBottomSpace, 15);
    return edgeInsets;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _m_GroupMemberInfo.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userId = _m_GroupMemberInfo[indexPath.row];

    IFGroupMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (userId.length) {
        cell.iconIV.image = [UIImage imageNamed:@"voip_header"];
        cell.label.text = userId;
    } else {
        cell.iconIV.image = [UIImage imageNamed:@"member_add"];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *userId = _m_GroupMemberInfo[indexPath.row];
    
    if (self.isOwner) {
        if (userId.length) {
            [self removeMember:userId];
            
        } else {
            [self addMember];
        }
    } else {
        [self.view ilg_makeToast:[NSString stringWithFormat:@"他的用户ID为%@", userId] position:ILGToastPositionCenter];
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionViewHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *tableSecsionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kSectionViewHeight)];
    tableSecsionView.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"131313"];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"消息免打扰";
    
    UISwitch *switchControl = [[UISwitch alloc] init];
    [switchControl addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [tableSecsionView addSubview:label];
    [tableSecsionView addSubview:switchControl];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(tableSecsionView).offset(15);
        make.centerY.equalTo(tableSecsionView);
    }];
    [switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(tableSecsionView).offset(-16);
        make.centerY.equalTo(tableSecsionView);
    }];
    
    [switchControl setOn:self.isMute animated:NO];
    
    return tableSecsionView;
}


#pragma mark - Other
- (void)addMember {
    __weak typeof(self) weakSelf = self;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"添加成员" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"用户ID";
//        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        
        if (namefield.text.length == 0) {
            [weakSelf.view ilg_makeToast:@"对方ID不能为空" position:ILGToastPositionCenter];
            return ;
        }
        [[XHClient sharedClient].groupManager addGroupMembers:@[namefield.text] toGroup:weakSelf.groupID completion:^(NSError *error) {
            if (!error) {
//                [UIView ilg_makeToast:@"添加成员成功"];
                [weakSelf.m_GroupMemberInfo insertObject:namefield.text atIndex:weakSelf.m_GroupMemberInfo.count - 1];
                [weakSelf.collectionView reloadData];
            } else {
                [NSString stringWithFormat:@"添加成员失败:%@", error.localizedDescription];
            }
        }];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@" cancel");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)removeMember:(NSString *)userId {
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        if (userId.length != 0) {
            textField.text = userId;
        }
        textField.placeholder = @"用户ID";
        textField.enabled = NO;
//        textField.textColor = [UIColor blueColor];
//        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"踢出群" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
       
        if ([namefield.text isEqualToString:[IMUserInfo shareInstance].userID]) {
            [weakSelf.view ilg_makeToast:@"不能踢出自己" position:ILGToastPositionCenter];
            return ;
        }
        
        [[XHClient sharedClient].groupManager deleteGroupMembers:@[namefield.text] fromGroup:weakSelf.groupID completion:^(NSError *error) {
            if (!error) {
//                [UIView ilg_makeToast:@"删除成员成功"];
                [weakSelf.m_GroupMemberInfo removeObject:userId];
                [weakSelf.collectionView reloadData];
                
            } else {
                [NSString stringWithFormat:@"踢出成员失败:%@", error.localizedDescription];
            }
        }];
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@" cancel");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)requestForGroupInfo {
//    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
//        [m_interfaceUrls demoRequestGroupMembers:_groupID];
//        
//    } else
    {
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].groupManager queryGroupInfo:self.groupID completion:^(NSString *listInfo, NSError *error) {
            NSDictionary *dict = nil;
            if (error == nil && listInfo) {
                NSData *jsonData = [listInfo dataUsingEncoding:NSUTF8StringEncoding];
                dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
            }
            
            if (dict) {
                NSArray *list = [dict objectForKey:@"data"];
                self.isMute = [dict[@"ignore"] boolValue];
                
                NSMutableArray *mutArr = [NSMutableArray array];
                for (NSDictionary *dict in list) {
                    NSString *newMemberID =  [dict objectForKey:@"userId"];
                    [mutArr addObject:newMemberID];
                }
                
                if (self.isOwner) {
                    [mutArr addObject:@""];
                }
                
                [weakSelf handleGroupInfo:mutArr];
            }
        }];
    }
}

- (void)handleGroupInfo:(NSArray *)list
{
    if (list.count == 0) {
        return;
    }
    
    [_m_GroupMemberInfo addObjectsFromArray:list];

    int lineNum = 0;
    if (_m_GroupMemberInfo.count%5 == 0) {
        lineNum = (int)(_m_GroupMemberInfo.count/5);
    } else {
        lineNum = (int)(_m_GroupMemberInfo.count/5) + 1;
    }
    
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - (kCollectionInteritemSpace * 4) - 15*2) / 5.0;
    CGFloat rowHeight = width/52*82;
    
    CGFloat tableHeaderViewHeight = kCollectionTopSpace + kCollectionBottomSpace + (lineNum - 1)*kCollectionInteritemSpace + lineNum*rowHeight;
    if (tableHeaderViewHeight > 300) {
        tableHeaderViewHeight = 300;
    }
    self.tableView.tableHeaderView.height = tableHeaderViewHeight + 10;
    [_collectionView reloadData];
    
    CGFloat miniHeight = self.tableView.height - self.tableView.tableHeaderView.height - kSectionViewHeight - 64;
    if (miniHeight < 120) {
        miniHeight = 120;
    }
    self.tableView.tableFooterView.height = miniHeight;
    [self.tableView reloadData];
}
@end
