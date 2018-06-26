//
//  ChatRoomViewController.m
//  IMDemo
//
//  Created by  Admin on 2017/12/25.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "ChatRoomViewController.h"

#import "ShowMsgElem.h"
#import "IMUserInfo.h"

#import "IFChatView.h"
#import "IFChatCell.h"

#import "IMMsgManager.h"

#define INTERVAL_KEYBOARD  20

@interface ChatRoomViewController () <IFChatViewDelegate, XHChatManagerDelegate, XHChatroomManagerDelegate>

@end

@implementation ChatRoomViewController
{
    IFChatView *_chatView;
    NSMutableArray *enumNSstringArray;
    
    BOOL _isPrivateMsgState; //是否处于私信状态
    NSString *_privateMsgTargetID; //私信方uid
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof(self) weakSelf = self;
    [self createUI];
    
    enumNSstringArray = [NSMutableArray array];

    if (_fromType == IFChatroomVCTypeFromList ||
        _fromType == IFChatroomVCTypeFromCreate) { //聊天室
        self.title = self.mRoomName;
        
        [[XHClient sharedClient].roomManager addDelegate:self];
        
        if (_fromType == IFChatroomVCTypeFromList) {
            
        }
        [[XHClient sharedClient].roomManager joinChatroom:self.mRoomId completion:^(NSError *error) {
            if (error) {
                [UIView ilg_makeToast:error.localizedDescription];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
        
        // 聊天室创建者有权删除聊天室，不要啦，不要啦
        if ([self.mCreaterId isEqualToString:[IMUserInfo shareInstance].userID]) {
//            [self setRightButtonImage:@"btn_user"];
        }
        
    } else if (_fromType == IFChatroomVCTypeFromC2C) { //C2C
        self.title = [NSString stringWithFormat:@"%@", self.targetID];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageDidReceive:) name:IMChatMsgReceiveNotif object:nil];
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = [[IMMsgManager sharedInstance] c2cChatHistory:weakSelf.targetID];
            for (int index = 0; index < array.count; index++) {
                NSDictionary *subDic = array[index];
                ShowMsgElem *msgElem = [weakSelf convertMsgToModel:subDic[@"message"] userID:subDic[@"userID"]];
                [enumNSstringArray addObject:msgElem];
            }
            [_chatView.tableView reloadData];
            [weakSelf scrollTableToFoot:NO];
        });
        
    } else {
        [UIView ilg_makeToast:@"跳转来源参数不对"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self addNoticeForKeyboard];
}

- (void)dealloc {
    [IMMsgManager sharedInstance].sessionIDForChating = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (void)createUI {
    self.title = self.mRoomName;

    IFChatView *chatView = [[IFChatView alloc] initWithDelegate:self];
    [self.view addSubview:chatView];
    chatView.textField.placeholder = @"来聊吧";
    _chatView = chatView;
    
    __weak typeof(self) weakSelf = self;
    [chatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
}

#pragma mark - Event

- (void)leftButtonClicked:(UIButton *)button {
    if (_fromType == IFChatroomVCTypeFromList ||
        _fromType == IFChatroomVCTypeFromCreate) {
        [[XHClient sharedClient].roomManager exitChatroom:self.mRoomId completion:^(NSError *error) {
            
        }];
    }
    
    [super leftButtonClicked:button];
}

- (void)rightButtonClicked:(UIButton *)button {
    if ([self.mCreaterId isEqualToString:[IMUserInfo shareInstance].userID]) {
        [[XHClient sharedClient].roomManager deleteChatroom:self.mRoomId completion:^(NSError *error) {
            if (error) {
                [UIView ilg_makeToast:[NSString stringWithFormat:@"删除聊天室失败:%@", error.localizedDescription]];
                
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IFChatroomListRefreshNotif" object:nil];

                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

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

///键盘显示事件
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
    
    [_chatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view).offset(-kbHeight);
    }];
    [self.view layoutIfNeeded];
    
    //设置动画结束
    [UIView commitAnimations];
}

///键盘消失事件
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

- (void)kick:(NSString *)userID {
    __weak typeof(self) weakSelf = self;
    [[XHClient sharedClient].roomManager removeMember:userID fromChatroom:self.mRoomId completion:^(NSError *error) {
        if (error) {
            [weakSelf.view ilg_makeToast:error.localizedDescription position:ILGToastPositionCenter];
        } else {
            [weakSelf.view ilg_makeToast:@"移除成功" position:ILGToastPositionCenter];
        }
    }];
}

- (void)mute:(NSString *)userID {
    __weak typeof(self) weakSelf = self;
    [[XHClient sharedClient].roomManager muteMember:userID muteSeconds:60 fromChatroom:self.mRoomId completion:^(NSError *error) {
        if (error) {
            [weakSelf.view ilg_makeToast:error.localizedDescription position:ILGToastPositionCenter];
        } else {
            [weakSelf.view ilg_makeToast:@"禁言成功" position:ILGToastPositionCenter];
        }
    }];
}

- (void)privateMsg:(NSString *)userID {
    _isPrivateMsgState = YES;
    
    _chatView.textField.text = nil;
    _chatView.textField.placeholder = @"请输入私信内容";
}

- (void)chatMessageDidReceive:(NSNotification *)notif {
    NSDictionary *dic = notif.object;
    NSString *msg = dic[@"message"];
    NSString *uid = dic[@"uid"];
    
    [self showTrace:msg userID:uid isMySelf:NO];
}


#pragma mark - Delegate
#pragma mark IFChatViewDelegate
- (void)chatViewDidSendText:(NSString *)text {
    __weak typeof(self) weakSelf = self;
    
    if (self.fromType == IFChatroomVCTypeFromC2C) {
        [[XHClient sharedClient].chatManager sendMessage:text toID:self.targetID completion:^(NSError *error) {
            if (error) {
                [UIView ilg_makeToast:@"c2c消息发送失败"];
                
            } else {
                
            }
        }];
        [[IMMsgManager sharedInstance] saveC2CChatHistory:self.targetID userID:UserId msg:text isUnRead:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:IMChatMsgReceiveNotif object:@{@"message":text, @"uid":UserId}];
        
    } else {
        if (_isPrivateMsgState) {
            [[XHClient sharedClient].roomManager sendMessage:text toID:_privateMsgTargetID completion:^(NSError *error) {
                if (error) {
                    [weakSelf.view ilg_makeToast:error.localizedDescription position:ILGToastPositionCenter];
                } else {
                    [weakSelf.view ilg_makeToast:@"发送私信成功" position:ILGToastPositionCenter];
                }
            }];
            
            _isPrivateMsgState = NO;
            _privateMsgTargetID = nil;
            _chatView.textField.placeholder = @"来聊吧";
        } else {
            [[XHClient sharedClient].roomManager sendMessage:text completion:^(NSError *error) {
                if (error) {
                    [UIView ilg_makeToast:@"聊天室消息发送失败"];
                } else {
                    [weakSelf showTrace:text userID:[IMUserInfo shareInstance].userID isMySelf:YES];
                }
            }];
        }
        
    }
}

#pragma mark XHChatroomManagerDelegate
- (void)chatroom:(NSString *)chatroomID didMembersNumberUpdated:(NSInteger)membersNumber {
    NSLog(@"聊天室成员数量发生变化%d", (int)membersNumber);
    self.title = [NSString stringWithFormat:@"%@(%d人在线)", self.mRoomName, (int)membersNumber];
}

- (void)chatroomUserKicked:(NSString *)kickOutUserId {
    [UIView ilg_makeToast:@"您已被管理员剔除"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatroomDidColsed {
    [UIView ilg_makeToast:@"聊天室被关闭"];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatroomMessagesDidReceive:(NSString *)message fromID:(NSString *)fromID {
    [self showTrace:message userID:fromID isMySelf:NO];
}

- (void)chatroomPrivateMessagesDidReceive:(NSString *)message fromID:(NSString *)fromID {
    [UIView ilg_makeToast:@"收到私信啦"];
    [self showTrace:message userID:fromID isMySelf:NO];
}

- (void)chatRoomErr:(NSString *)errString {
    [UIView ilg_makeToast:errString];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chatroomSendMsgNoFee {
    
}

- (void)chatroomSendMsgBanned:(int)remainTimeSec {
    
}

#pragma mark tableView

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return enumNSstringArray.count;;
}

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

- (NSArray *)actionTitleArr:(NSString *)targetID {
    if ([targetID isEqualToString:[IMUserInfo shareInstance].userID]) { //自己
        return @[];
    } else if ([[IMUserInfo shareInstance].userID isEqualToString:self.mCreaterId]) { //不是自己，而且自己是拥有者
        return @[@"踢出房间", @"禁止发言", @"私信"];
    } else { //自己是普通成员
        return @[@"私信"];
    }
}
- (NSArray *)actionEventArr:(NSString *)targetID {
    if ([targetID isEqualToString:[IMUserInfo shareInstance].userID]) { //自己
        return @[];
    } else if ([[IMUserInfo shareInstance].userID isEqualToString:self.mCreaterId]) { //不是自己，而且自己是拥有者
        return @[@"kick:", @"mute:", @"privateMsg:"];
    } else { //自己是普通成员
        return @[@"privateMsg:"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowMsgElem *newMsgElem = enumNSstringArray[indexPath.row];
    _privateMsgTargetID = newMsgElem.userID;
    NSLog(@"choose ID %@", newMsgElem.userID);
    
    if (_fromType == IFChatroomVCTypeFromC2C) {
        
    } else {
        NSArray *actionTitleArr = [self actionTitleArr:newMsgElem.userID];
        if (actionTitleArr.count > 0) {
            NSArray *actionEventArr = [self actionEventArr:newMsgElem.userID];
            
            __weak typeof(self) weakSelf = self;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:newMsgElem.userID message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            for (NSInteger index = 0; index < actionTitleArr.count; index++) {
                UIAlertAction *action = [UIAlertAction actionWithTitle:actionTitleArr[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf performSelector:NSSelectorFromString(actionEventArr[index]) withObject:newMsgElem.userID];
                }];
                [alertController addAction:action];
            }
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowMsgElem *newMsgElem = enumNSstringArray[indexPath.row];
    return newMsgElem.rowHeight;
}


#pragma mark - other
- (void)showManagerDialog:(NSString *)userID
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    UIAlertAction *home1Action = [UIAlertAction actionWithTitle:@"剔出房间" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertController addAction:home1Action];
    UIAlertAction *home2Action = [UIAlertAction actionWithTitle:@"禁止发言" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertController addAction:home2Action];
    UIAlertAction *home3Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:home3Action];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showTrace:(NSString *)msg userID:(NSString *)userID isMySelf:(BOOL)isMySelf
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ShowMsgElem *newMsgElem = [self convertMsgToModel:msg userID:userID];
        [enumNSstringArray addObject:newMsgElem];
        [_chatView.tableView reloadData];
        [self scrollTableToFoot:NO];
    });
}

- (ShowMsgElem *)convertMsgToModel:(NSString *)msg userID:(NSString *)userID {
    ShowMsgElem *newMsgElem = [[ShowMsgElem alloc] init];
    newMsgElem.userID = userID;
    newMsgElem.text = msg;
    newMsgElem.isMySelf = [userID isEqualToString:UserId];
    newMsgElem.rowHeight = [IFChatCell caculateTextHeightWithMaxWidth:_chatView.tableView.width - [IFChatCell reserveWithForCell] text:msg];
    return newMsgElem;
}

- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger s = [_chatView.tableView numberOfSections];  //有多少组
    if (s<1) return;  //无数据时不执行 要不会crash
    NSInteger r = [_chatView.tableView numberOfRowsInSection:s-1]; //最后一组有多少行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [_chatView.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
@end
