//
//  SuperRoomVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRoomVC.h"
#import "SuperRoomMenuView.h"
#import "SuperRoomMembersView.h"
#import "SuperRoomMessagesView.h"
#import "XHClient.h"
@interface SuperRoomVC ()<SuperRoomMenuViewDelegate,XHLiveManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) SuperRoomMenuView *chatMenuView;
@property (nonatomic, strong) SuperRoomMembersView *membersView;
@property (nonatomic, strong) SuperRoomMessagesView *messagesView;
@end

@implementation SuperRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupHandle];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = [NSString stringWithFormat:@"%@:%d人在线",_roomInfo.liveName,0];
    [self.view addSubview:self.chatMenuView];
    [self.view addSubview:self.membersView];
    [self.view addSubview:self.messagesView];
    
    [self.view bringSubviewToFront:self.messagesView];
}
- (void)setupHandle{
    self.membersView.roomInfo = self.roomInfo;
    [[XHClient sharedClient].superRoomManager setRtcMediaType:IOS_STAR_RTC_MEDIA_TYPE_AUDIO_ONLY];
    [[XHClient sharedClient].superRoomManager addDelegate:self];
    [[XHClient sharedClient].superRoomManager joinSuperRoom:self.roomInfo.ID completion:^(NSError *error) {
        if (error) {
            [UIWindow ilg_makeToast:@"开播失败"];
        }
    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.chatMenuView.frame = CGRectMake(0, self.view.height - 60, self.view.width, 60);
    CGFloat topHeight = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
    self.membersView.frame = CGRectMake(0, topHeight + 10, self.view.width, 365);
    self.messagesView.frame = CGRectMake(0, CGRectGetMaxY(self.membersView.frame), self.view.width, self.view.height - CGRectGetMaxY(self.membersView.frame) - self.chatMenuView.height);
}
#pragma mark - init
- (SuperRoomMenuView*)chatMenuView{
    if (!_chatMenuView) {
        _chatMenuView = [SuperRoomMenuView instanceFromNib];
        _chatMenuView.delegate = self;
    }
    return _chatMenuView;
}
- (SuperRoomMembersView*)membersView{
    if (!_membersView) {
        _membersView = [SuperRoomMembersView instanceFromNib];
//        _membersView.delegate = self;
    }
    return _membersView;
}
- (SuperRoomMessagesView*)messagesView{
    if (!_messagesView) {
        _messagesView = [SuperRoomMessagesView instanceFromNib];
        _messagesView.messageTableView.delegate = self;
        //_messagesView.delegate = self;
    }
    return _messagesView;
}
#pragma mark - 点击
//父类方法
- (void)leftButtonClicked:(UIButton *)button
{
    [[XHClient sharedClient].superRoomManager leaveSuperRoom:^(NSError *error) {
        
    }];
    [super leftButtonClicked:button];
}

#pragma mark - SuperRoomMenuViewDelegate <NSObject>

- (void)SuperRoomMenuView:(SuperRoomMenuView*)chatMenuView sendText:(NSString*)text{
    [[XHClient sharedClient].superRoomManager sendMessage:text completion:^(NSError *error) {
        if (error == nil) {
            SuperRoomMessageModel *model = [[SuperRoomMessageModel alloc] initWithNickname:UserId content:text];
            [self.messagesView addMessage:model];
        }
        NSLog(@"发送成功");
    }];
}
- (void)SuperRoomMenuViewStartSpeech:(SuperRoomMenuView*)chatMenuView{
    [[XHClient sharedClient].superRoomManager pickUpMic:^(NSError * _Nonnull error) {
        if(error)
        {
             [UIWindow ilg_makeToast:@"发言失败"];
        }
        else
        {
            [UIWindow ilg_makeToast:@"可以发言了"];
        }
    }];
}
- (void)SuperRoomMenuViewStopSpeech:(SuperRoomMenuView*)chatMenuView{
    [[XHClient sharedClient].superRoomManager layDownMic:^(NSError * _Nonnull error) {
        if(error)
        {
            [UIWindow ilg_makeToast:@"交出发言权限failed"];
        }
        else
        {
            [UIWindow ilg_makeToast:@"已经交出发言权限"];
        }
    }];
}

#pragma mark - SuperRoomMessagesViewDelegate <NSObject>

-(void)chooseItem:(NSString *)userID
{
    
}


-(void)showAlertChoose:(SuperRoomMessageModel *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    
    if(![message.nickname isEqualToString:UserId])
    {
        if(message.isMic)
        {
            NSArray *titles = @[@"踢出房间", @"禁止发言",@"下麦"];
            for (int index = 0; index < titles.count; index++)
            {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:titles[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                         {
                                             if (index == 0 )
                                             {
                                                 [[XHClient sharedClient].superRoomManager kickMember:message.nickname completion:^(NSError * _Nonnull error) {
                                                     
                                                 }];
                                             }
                                             else if(index == 1)
                                             {
                                                 [[XHClient sharedClient].superRoomManager muteMember:message.nickname muteSeconds:10 completion:^(NSError * _Nonnull error) {
                                                     
                                                 }];
                                             }
                                             else
                                             {
                                                 [[XHClient sharedClient].superRoomManager commandToAudience:message.nickname completion:^(NSError * _Nonnull error) {
                                                     
                                                 }];
                                             }
                                         }];
                [alertController addAction:action];
            }
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            NSArray *titles = @[@"踢出房间", @"禁止发言",@"上麦"];
            for (int index = 0; index < titles.count; index++)
            {
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:titles[index] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                         {
                                             if (index == 0 )
                                             {
                                                 [[XHClient sharedClient].superRoomManager kickMember:message.nickname completion:^(NSError * _Nonnull error) {
                                                     
                                                 }];
                                             }
                                             else if(index == 1)
                                             {
                                                 [[XHClient sharedClient].superRoomManager muteMember:message.nickname muteSeconds:10 completion:^(NSError * _Nonnull error) {
                                                     
                                                 }];
                                             }
                                         }];
                [alertController addAction:action];
            }
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

#pragma mark - XHSuperRoomManagerDelegate <NSObject>

/**
 有人加入直播
 @param uid 加入用户的ID
 @param liveID 直播间ID
 @return 用于显示发言者视频画面的view
 */
- (UIView *)onActorJoined:(NSString *)uid live:(NSString *)liveID{
    [self.membersView addMember:uid];
    return nil;
}

/**
 有人离开直播
 
 @param uid 离开用户的ID
 @param liveID 直播间ID
 */
- (void)onActorLeft:(NSString *)uid live:(NSString *)liveID{
    [self.membersView removeMember:uid];
}






/**
 * 自己连麦被强制停止
 @param liveID 直播间ID
 */
- (void)onCommandToStopPlay:(NSString *)liveID{
    
}


/**
 一些异常情况可能会引起会议出错，请在收到该回调后主动离开直播
 @param error 错误信息
 @param liveID 直播间ID
 */
- (void)onSuperRoomError:(NSError *)error live:(NSString *)liveID{
    
}


/**
 成员数发生变化
 
 @param membersNumber 成员数
 */
- (void)liveMembersNumberUpdated:(NSInteger)membersNumber{
    NSLog(@"############# superRoom liveMembersNumberUpdated ############# ");
    self.navigationItem.title = [NSString stringWithFormat:@"%@:%ld人在线",_roomInfo.liveName,(long)membersNumber];
}

/**
 自己被剔
 */
- (void)liveUserKicked{
    
}

/**
 收到消息
 
 @param message 消息
 */
- (void)liveMessageReceived:(NSString *)message fromID:(NSString *)fromID{
    
    SuperRoomMemberModel *roomModel = [SuperRoomMemberModel new];
    roomModel.uid = fromID;
    BOOL isMic =  [self.membersView.membersDataSource containsObject:roomModel];
    SuperRoomMessageModel *model = [[SuperRoomMessageModel alloc] initWithNickname:fromID content:message];
    model.isMic = isMic;
    [self.messagesView addMessage:model];
}

/**
 收到私信消息
 
 @param message 消息
 @param fromID 消息来源
 */
- (void)livePrivateMessageReceived:(NSString *)message fromID:(NSString *)fromID{
    
}


/**
 * 收到实时数据
 * @param data 数据
 * @param upId  用户ID
 */
- (void)onReceiveRealtimeData:(NSString *)data
                         upId:(NSString *)upId{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第%li个cell", (long)indexPath.row);
}

@end
