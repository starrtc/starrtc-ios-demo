//
//  MessageGroupViewController.m
//  IMDemo
//
//  Created by  Admin on 2018/1/5.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "MessageGroupViewController.h"
#import "ShowMsgElem.h"
#import "MessageGroupSettingViewController.h"
#import "InterfaceUrls.h"

#import "IFChatView.h"
#import "IFChatCell.h"

#define INTERVAL_KEYBOARD  2

@interface MessageGroupViewController () <IFChatViewDelegate, XHGroupManagerDelegate>
@property (nonatomic, strong) IFChatView *chatView;
@end

@implementation MessageGroupViewController
{
    int rowNum;
    NSMutableArray *m_GroupMemberInfo;
    NSMutableArray *enumNSstringArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    [[XHClient sharedClient].groupManager addDelegate:self];
    
    rowNum = 0;
    enumNSstringArray = [NSMutableArray array];
    [self addNoticeForKeyboard];
}

#pragma mark - UI
- (void)createUI {
    self.title = self.m_Group_Name;

    IFChatView *chatView = [[IFChatView alloc] initWithDelegate:self];
    [self.view addSubview:chatView];
    _chatView = chatView;
    
    __weak typeof(self) weakSelf = self;
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    
//    if ([self.creatorID isEqualToString:[IMUserInfo shareInstance].userID]) {
//    }
    [self setRightButtonImage:@"IM_friend_icon"];
}

#pragma mark - delegate
-(void)getMessageGroupMemberResponse:(NSData *)respnseContent
{
    NSLog(@" getMessageGroupMemberResponse \n");
    NSError * error = nil;
    id obj  = [NSJSONSerialization JSONObjectWithData:respnseContent options:NSJSONReadingMutableContainers error:&error];
    int status = 0x00;
    
    //{"status":1,"data":[{"userId":"demo330"},{"userId":"demo302"}]}
    // 判断一下,id是NSMutableArray类型还是NSMutableDictionary
    if ([obj isKindOfClass:[NSArray class]]) {
        
        NSMutableArray * array = obj;
        NSLog(@"*************%@",array);
    }else{
        
        NSMutableDictionary * dict = obj;
        
        status = [[dict objectForKey:@"status"] intValue];
        
        if(status == 1)
        {
            m_GroupMemberInfo = [[NSMutableArray alloc] init];
            NSDictionary *info = [dict objectForKey:@"data"];
            for (NSMutableDictionary *dict in info)
            {
                NSString *newMemberID =  [dict objectForKey:@"userId"];
                
                [m_GroupMemberInfo addObject:newMemberID];
            }
            
            [_chatView.tableViewForMemberList reloadData];
        }
    }
}


#pragma mark IFChatViewDelegate
- (void)chatViewDidSendText:(NSString *)text {
    [[XHClient sharedClient].groupManager sendMessage:text toGroup:self.m_Group_ID atUsers:nil completion:^(NSError *error) {
        if (error) {
            [UIView ilg_makeToast:error.localizedDescription];
        } else {

        }
    }];
    
    [self showTrace:text userID:[IMUserInfo shareInstance].userID];
}

#pragma mark XHGroupManagerDelegate
- (void)group:(NSString*)groupID didMembersNumberUpdeted:(NSInteger)membersNumber {
    self.title = [NSString stringWithFormat:@"%@(%d人在线)", self.m_Group_Name, (int)membersNumber];
}

- (void)groupUserKicked:(NSString*)groupID {
    [UIView ilg_makeToast:@"您已被管理员剔除"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)groupDidDeleted:(NSString*)groupID {
    [UIView ilg_makeToast:@"此群已被删除"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)groupMessagesDidReceive:(NSString *)aMessage fromID:(NSString *)fromID {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showTrace:aMessage userID:fromID];
    });
}

#pragma mark TableView
/**
 * 设置table的section
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

/**
 * 设置table的行数
 */
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _chatView.tableView) {
        return enumNSstringArray.count;;
    } else {
        return m_GroupMemberInfo.count;
    }
}
/**
 * 设置table每一行的数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    ShowMsgElem * getNewShowMsgElem =  [enumNSstringArray objectAtIndex:row];
    
    NSString *tableSampleIdentifier = getNewShowMsgElem.isMySelf ? @"TableSampleIdentifierRight":@"TableSampleIdentifierLeft";
    IFChatCellStyle cellStyle = getNewShowMsgElem.isMySelf ? IFChatCellStyleRight:IFChatCellStyleLeft;
    
    IFChatCell *cell = [tableView dequeueReusableCellWithIdentifier:
                        tableSampleIdentifier];
    if (cell == nil) {
        cell = [[IFChatCell alloc]
                initWithStyle:cellStyle
                reuseIdentifier:tableSampleIdentifier];
    }
    
    cell.iconIV.image = [UIImage imageNamed:@"voip_header"];
    cell.titleLabel.text = getNewShowMsgElem.userID;
    cell.subTitleLabel.text = getNewShowMsgElem.text;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _chatView.tableView) {
        ShowMsgElem *getNewShowMsgElem = [enumNSstringArray objectAtIndex:indexPath.row];

        return getNewShowMsgElem.rowHeight;
    } else {
        return 28;
    }
}


#pragma mark - Event
- (void)rightButtonClicked:(UIButton *)button {
    MessageGroupSettingViewController *vc = [[MessageGroupSettingViewController alloc] init];
    vc.groupID = self.m_Group_ID;
    if ([self.creatorID isEqualToString:[IMUserInfo shareInstance].userID]) {
        vc.isOwner = YES;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
//键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak typeof(self) weakSelf = self;
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:duration];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    [_chatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-kbHeight);
    }];
    [self.view layoutIfNeeded];
    //设置动画结束
    [UIView commitAnimations];
}

//键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    __weak typeof(self) weakSelf = self;
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        [_chatView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.view).offset(0);
        }];
    }];
    [self.view layoutIfNeeded];
}


#pragma mark - other

- (void)showTrace:(NSString *)msg
          userID:(NSString *)userID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShowMsgElem *newMsgElem = [[ShowMsgElem alloc] init];
        newMsgElem.userID = userID;
        newMsgElem.text = msg;
        if ([userID isEqualToString:[IMUserInfo shareInstance].userID]) {
            newMsgElem.isMySelf = YES;
        }
        [enumNSstringArray addObject:newMsgElem];
        newMsgElem.rowHeight = [IFChatCell caculateTextHeightWithMaxWidth:_chatView.tableView.width - [IFChatCell reserveWithForCell] text:msg];
        rowNum++;
        [self.chatView.tableView reloadData];
        [self scrollTableToFoot:NO];
    });
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [self.chatView.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [self.chatView.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.chatView.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}

@end
