//
//  IFLiveVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFLiveVC.h"

#import "IFChatView.h"
#import "IFVideoChatCell.h"

#import "InterfaceUrls.h"
#import "VideoSetParameters.h"

@interface IFLiveVC () <IFChatViewDelegate, UITableViewDelegate, UITableViewDataSource, XHLiveManagerDelegate>
@property (nonatomic, strong) NSMutableArray *videoViewArr;
@property (nonatomic, strong) UIView *videoContentView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSMutableDictionary *videoViewDic;

@property (nonatomic, strong) NSMutableArray *messageArr;
@property (nonatomic, strong) IFChatView *chatView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation IFLiveVC {
    IFLiveVCType _vcType;
}

- (instancetype)initWithType:(IFLiveVCType)type {
    self = [super init];
    if (self) {
        _vcType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoViewArr = [NSMutableArray array];
    self.videoViewDic = [NSMutableDictionary dictionary];
    _messageArr = [NSMutableArray array];

    [self createUI];
    
    if (_vcType == IFLiveVCTypeLook) {
        self.chatView.micButton.hidden = NO;
        [self.chatView.micButton addTarget:self action:@selector(micBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.chatView.micButton.hidden = YES;
    }
    
    [self addNoticeForKeyboard];
    
    __weak typeof(self) weakSelf = self;
    [[XHClient sharedClient].liveManager addDelegate:self];
    [[XHClient sharedClient].liveManager setVideoConfig:[VideoSetParameters locaParameters]];
    
    if (_vcType == IFLiveVCTypeLook) {
        [[XHClient sharedClient].liveManager watchLive:self.liveId completion:^(NSError *error) {
            if (error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [UIView ilg_makeToast:[NSString stringWithFormat:@"watchLive error：%@", error.localizedDescription]];
            } else {

            }
        }];
    } else if (_vcType == IFLiveVCTypeStart || _vcType == IFLiveVCTypeCreate) {
        [[XHClient sharedClient].liveManager startLive:self.liveId completion:^(NSError *error) {
            if (error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [UIView ilg_makeToast:[NSString stringWithFormat:@"startLive error：%@", error.localizedDescription]];
            } else {

            }
        }];
    } else {
        [UIView ilg_makeToast:@"vcType不存在"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setNavigationBarColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self setNavigationBarColor:[UIColor colorWithHexString:@"ff6c00"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)createUI {
    self.view.backgroundColor = [UIColor blackColor];
    self.title = [NSString stringWithFormat:@"直播编号：%@", self.liveId];

    UIView *videoContentView = [[UIView alloc] init];
    [self.view insertSubview:videoContentView atIndex:0];
    _videoContentView = videoContentView;
   
    // 互动直播布局
    __weak typeof(self) weakSelf = self;
    [videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(ios 11, *)) {
            //make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
            make.top.equalTo(weakSelf.view);
        } else {
            make.top.equalTo(weakSelf.view).offset(0);
        }
        make.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(weakSelf.view);
        make.height.equalTo(videoContentView.mas_width).multipliedBy(4/3.0);
    }];
    
//    UIScrollView *scrollView = [[UIScrollView alloc] init];
//    scrollView.contentSize = CGSizeMake(self.view.width*2, self.view.height);
//    scrollView.bounces = NO;
//    scrollView.pagingEnabled = YES;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.userInteractionEnabled = NO;
//    [self.view addSubview:scrollView];
//    _scrollView = scrollView;
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view);
//        make.leading.equalTo(weakSelf.view);
//        make.trailing.equalTo(weakSelf.view);
//        make.height.equalTo(weakSelf.view);
//    }];
    
    IFChatView *chatView = [[IFChatView alloc] initWithDelegate:self];
    [chatView setFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - 200, CGRectGetMaxX(self.view.frame), 200)];
//    [scrollView addSubview:chatView];
    [self.view addSubview:chatView];
    self.chatView = chatView;
    
    _tableView = chatView.tableView;
    _tableView.backgroundColor = [UIColor clearColor];
}

- (void)relayoutVideoViewsForLive {
    NSInteger number = self.videoViewArr.count;
    
    CGFloat width = self.videoContentView.width;
    CGFloat height = self.videoContentView.height;
    
    switch (number) {
        case 1:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width, height)];
            break;
            
        case 2:
        case 3:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width/3*2, height)];
            for (NSInteger index = 1; index < number; index++) {
                [self.videoViewArr[index] setFrame:CGRectMake(width/3*2, height/2*(index - 1), width/3, height/2)];
            }
            break;
            
        case 4:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width, height - width/2)];
            for (NSInteger index = 1; index < number; index++) {
                [self.videoViewArr[index] setFrame:CGRectMake(width/3*(index - 1), height - width/2, width/3, width/2)];
            }
            break;
            
        case 5:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width/3*2, height/3*2)];
            for (NSInteger index = 1; index < number; index++) {
                if (index < 3) {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*(index - 1), height/3*2, width/3, height/3)];
                } else {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*2, height/(number - 3)*(index - 3), width/3, height/(number - 3))];
                }
            }
            break;
            
        case 6:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width/3*2, height/3*2)];
            for (NSInteger index = 1; index < number; index++) {
                if (index < 3) {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*(index - 1), height/3*2, width/3, height/3)];
                } else {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*2, height/(number - 3)*(index - 3), width/3, height/(number - 3))];
                }
            }
            break;
            
        case 7:
            [self.videoViewArr[0] setFrame:CGRectMake(0, 0, width/3*2, height/4*3)];
            for (NSInteger index = 1; index < number; index++) {
                if (index < 3) {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*(index - 1), height/4*3, width/3, height/4)];
                } else {
                    [self.videoViewArr[index] setFrame:CGRectMake(width/3*2, height/(number - 3)*(index - 3), width/3, height/(number - 3))];
                }
            }
            break;
        default:
            break;
    }
    
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor yellowColor]];
    for (int index = 0; index < self.videoViewArr.count; index++) {
        UIView *view = self.videoViewArr[index];
//        view.backgroundColor = colors[index];
    }
}


#pragma mark - Delegate
#pragma mark IFChatViewDelegate
- (void)chatViewDidSendText:(NSString *)text {
    [[XHClient sharedClient].liveManager sendMessage:text completion:^(NSError *error) {

    }];
    [self insertNewMessage:text userId:[IMUserInfo shareInstance].userID];
}

#pragma mark XHLiveManagerDelegate
- (UIView *)onActorJoined:(NSString *)uid live:(NSString *)liveID {
    if (self.videoViewArr.count >= 7) {
        [self.view ilg_makeToast:@"数目已达上限" position:ILGToastPositionCenter];
        return nil;
    }
    
    UIView *videoView = self.videoViewDic[uid];
    if (videoView) {
        [self.videoContentView insertSubview:videoView atIndex:0];
        [self.videoViewArr addObject:videoView];
        
    } else {
        videoView = [[UIView alloc] init];
        videoView.clipsToBounds = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClicked:)];
        [videoView addGestureRecognizer:tapGes];
        
        [self.videoContentView insertSubview:videoView atIndex:0];
        [self.videoViewArr addObject:videoView];
        [self.videoViewDic setObject:videoView forKey:uid];
    }
    
    [self relayoutVideoViewsForLive];
    
    return videoView;
}

- (void)onActorLeft:(NSString *)uid live:(NSString *)liveID {
    if (self.videoViewArr.count == 0) {
        [self.view ilg_makeToast:@"数目已为零" position:ILGToastPositionCenter];
        return;
    }
    
    UIView *view = self.videoViewDic[uid];
    [view removeFromSuperview];
    [self.videoViewArr removeObject:view];
//    [self.videoViewDic removeObjectForKey:uid];
    
    if (self.videoViewArr.count != 0) {
        [self relayoutVideoViewsForLive];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//主播收到观众发起的连麦申请
- (void)onApplyBroadcast:(NSString *)uid live:(NSString *)liveID {
    dispatch_async(dispatch_get_main_queue(), ^{
        IFLiveMessage *message = [[IFLiveMessage alloc] init];
        message.msgText = [NSString stringWithFormat:@"%@:我要上麦", uid];
        message.uid = uid;
        message.msgType = 1;
        [self insertNewMessage:message];
    });
}
/**
 观众收到连麦申请的回复消息
 */
- (void)onBroadcastResponsed:(XHLiveJoinResult)result live:(NSString *)liveID {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == XHLiveJoinResult_Accept) {
            [self.view ilg_makeToast:@"您的连麦申请成功" position:ILGToastPositionCenter];
            self.chatView.micButton.selected = YES;
            [[XHClient sharedClient].liveManager changeToBroadcaster];

        } else if (result == XHLiveJoinResult_refuse) {
            [self.view ilg_makeToast:@"您的连麦申请被拒绝" position:ILGToastPositionCenter];
            
        } else {
            [self.view ilg_makeToast:@"您的连麦申请超时" position:ILGToastPositionCenter];
            
        }
    });
}

/**
 一些异常情况可能会引起会议出错，请在收到该回调后主动离开直播
 */
- (void)onLiveError:(NSError *)error live:(NSString *)liveID {
    [self leftButtonClicked:nil];
}

/**
 成员数发生变化
 */
- (void)liveMembersNumberUpdated:(NSInteger)membersNumber {
    
}

/**
 收到消息
 */
- (void)liveMessageReceived:(NSString *)message fromID:(NSString *)fromID {
    [self insertNewMessage:message userId:fromID];
}

/**
 收到私信消息
*/
- (void)livePrivateMessageReceived:(NSString *)message fromID:(NSString *)fromID {
    [self insertNewMessage:message userId:fromID];
}


#pragma mark tableView
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    
    IFVideoChatCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = [[IFVideoChatCell alloc]
                initWithStyle:IFChatCellStyleLeft
                reuseIdentifier:TableSampleIdentifier];
    }
    
    IFLiveMessage *elem = self.messageArr[indexPath.row];
    cell.titleLabel.text = elem.msgText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IFLiveMessage *message = self.messageArr[indexPath.row];
    if (message.msgType == 1 && !message.isJudgedForMic) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            message.isJudgedForMic = YES;
            message.msgText = [message.msgText stringByAppendingString:@"(已同意)"];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[XHClient sharedClient].liveManager agreeApplyToBroadcaster:message.uid completion:^(NSError *error) {
                
            }];
        }];
        [alertController addAction:action];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            message.isJudgedForMic = YES;
            message.msgText = @"我要上麦(已拒绝)";
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[XHClient sharedClient].liveManager refuseApplyToBroadcaster:message.uid completion:^(NSError *error) {
                
            }];
        }];
        [alertController addAction:action2];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IFLiveMessage *elem = self.messageArr[indexPath.row];
    return elem.msgHeight;
}

#pragma mark - Event

- (void)leftButtonClicked:(UIButton *)button {
    [[XHClient sharedClient].liveManager leaveLive:self.liveId completion:^(NSError *error) {
        if (error) {
            [UIView ilg_makeToast:error.localizedDescription];
        } else {
        }
    }];
    
    [super leftButtonClicked:button];
}

- (void)tapGesClicked:(UIGestureRecognizer *)ges {
    UIView *targetView = ges.view;
    
    UIView *bigView = self.videoViewArr[0];
    if (targetView == bigView || self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    CGRect bigFrame = bigView.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        bigView.frame = targetView.frame;
        targetView.frame = bigFrame;
    } completion:^(BOOL finished) {
        NSInteger targetIndex = [self.videoViewArr indexOfObject:targetView];
        [self.videoViewArr exchangeObjectAtIndex:0 withObjectAtIndex:targetIndex];
        _isAnimating = NO;
    }];
}

- (void)micBtnClicked:(UIButton *)button {
    if (button.selected) { //发起下麦
        [[XHClient sharedClient].liveManager changeToAudience];
        button.selected = NO;
        
    } else { //发起上麦
        [[XHClient sharedClient].liveManager applyToBroadcaster:self.creator completion:^(NSError *error) {
            if (!error) {
                NSLog(@"上麦申请已发送");
            } else {
                NSLog(@"上麦申请发送失败:%@", error.localizedDescription);
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
    
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:duration];
    //??使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    
    _chatView.bottom = self.view.height - kbHeight;
    [self.chatView layoutIfNeeded];
    
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
        _chatView.bottom = weakSelf.view.height;

    }];
    [self.view layoutIfNeeded];
}


#pragma mark - Other

- (void)insertNewMessage:(NSString *)text userId:(NSString *)userId {
    IFLiveMessage *message = [[IFLiveMessage alloc] init];
    message.msgText = [NSString stringWithFormat:@"%@:%@", userId, text];
    message.msgType = 0;
    message.uid = userId;
    [self insertNewMessage:message];
}

- (void)insertNewMessage:(IFLiveMessage *)elem {
    elem.msgHeight = [IFVideoChatCell caculateTextHeightWithMaxWidth:_chatView.tableView.width - [IFVideoChatCell reserveWithForCell] text:elem.msgText];
    [self.messageArr addObject:elem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end


@implementation IFLiveMessage
@end
