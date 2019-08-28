//
//  IFSourceVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFSourceVC.h"

#import "IFVideoChatCell.h"

#import "InterfaceUrls.h"
#import "VideoSetParameters.h"

#import "XHWhitePanel2.h"

#import "IFLiveMessage.h"

@interface IFSourceVC () <UITableViewDelegate, UITableViewDataSource, XHLiveManagerDelegate, UITextFieldDelegate>
{
    NSString *sendMessageTargetID;
}
@property (nonatomic, strong) NSMutableArray *videoViewArr;
@property (nonatomic, strong) NSMutableDictionary *videoViewDic;

@property (nonatomic, strong) NSMutableArray *messageArr;

@property (nonatomic, assign) IFSourceVCType vcType;
@property (nonatomic, strong) XHWhitePanel2 *whitePanel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *videoStackViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *uidL;

@property (weak, nonatomic) IBOutlet UIButton *interactionBtn;
@property (weak, nonatomic) IBOutlet UIButton *audioEnableBtn;
@property (weak, nonatomic) IBOutlet UIButton *videoEnableBtn;

@property (weak, nonatomic) IBOutlet UIStackView *videoStackView;
@property (weak, nonatomic) IBOutlet UIView *whiteContainer;
@property (weak, nonatomic) IBOutlet UIView *chatContainer;


@property (weak, nonatomic) IBOutlet UIStackView *paintToolView;
@property (weak, nonatomic) IBOutlet UIButton *penBtn;
@property (weak, nonatomic) IBOutlet UIButton *laserBtn;
@property (weak, nonatomic) IBOutlet UIButton *revokeBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@property (weak, nonatomic) IBOutlet UIView *paintingPanel;
@property (weak, nonatomic) IBOutlet UIView *colorPanel;

@property (weak, nonatomic) IBOutlet UIView *chatMenuView;
@property (weak, nonatomic) IBOutlet UITextField *chatTF;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@end

@implementation IFSourceVC {
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (instancetype)initWithType:(IFSourceVCType)type {
    self = [super init];
    if (self) {
        _vcType = type;
    }
    return self;
}

+ (instancetype)viewControllerWithType:(IFSourceVCType)type {
    IFSourceVC *vc = [[IFSourceVC alloc] initWithNibName:@"IFSourceVC" bundle:[NSBundle mainBundle]];
    vc.vcType = type;
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoViewArr = [NSMutableArray array];
    self.videoViewDic = [NSMutableDictionary dictionary];
    _messageArr = [NSMutableArray array];
    sendMessageTargetID = nil;
    
    [self createUI];
    
    [self addObserver];
    
    __weak typeof(self) weakSelf = self;
    [[XHClient sharedClient].liveManager addDelegate:self];
    [[XHClient sharedClient].liveManager setVideoConfig:[VideoSetParameters locaParameters]];
    
    if (_vcType == IFSourceVCTypeLook) {
        [[XHClient sharedClient].liveManager watchLive:self.liveId completion:^(NSError *error) {
            if (error) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [UIView ilg_makeToast:[NSString stringWithFormat:@"watchLive error：%@", error.localizedDescription]];
            } else {

            }
        }];
    } else if (_vcType == IFSourceVCTypeStart || _vcType == IFSourceVCTypeCreate) {
        [self.whitePanel publish];
        
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
    self.title = [NSString stringWithFormat:@"直播编号：%@", self.liveId];
    
    XHWhitePanel2 *panelManager = [[XHWhitePanel2 alloc] initWithView:self.paintingPanel];
    [panelManager setFrame:CGRectMake(80, 0, 200, 200)];
    self.whitePanel = panelManager;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 5)];
    self.chatTF.leftView = leftView;
    self.chatTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.chatTableView registerClass:[IFVideoChatCell class] forCellReuseIdentifier:@"TableSampleIdentifier"];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(colorPanelDidClicked:)];
    [self.colorPanel addGestureRecognizer:tapGes];
    
    self.uidL.text = [NSString stringWithFormat:@" ID:%@  ", self.creator];
    
    if (_vcType == IFSourceVCTypeLook) {
        self.paintToolView.hidden = YES;
        self.audioEnableBtn.hidden = YES;
        self.videoEnableBtn.hidden = YES;
        
        self.interactionBtn.hidden = NO;
    } else {
        
    }
}

- (void)relayoutVideoViewsForLive {
    NSInteger number = self.videoStackView.arrangedSubviews.count;
    
    CGFloat height = self.videoStackView.width/1.5;
    self.videoStackViewHeight.constant = number * height;
}


#pragma mark - Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self p_sendMessage];
    return YES;
}

#pragma mark XHLiveManagerDelegate
- (UIView *)onActorJoined:(NSString *)uid live:(NSString *)liveID {
    if (self.videoViewArr.count >= 4) {
        [self.view ilg_makeToast:@"数目已达上限" position:ILGToastPositionCenter];
        return nil;
    }
    
    UIView *videoView = self.videoViewDic[uid];
    if (videoView) {
        
    } else {
        videoView = [[UIView alloc] init];
        videoView.clipsToBounds = YES;
        videoView.frame = CGRectMake(0, 0, self.videoStackView.width, self.videoStackView.width/1.5);
//        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClicked:)];
//        [videoView addGestureRecognizer:tapGes];
        
        [self.videoViewDic setObject:videoView forKey:uid];
    }
    
    [self.videoStackView insertArrangedSubview:videoView atIndex:self.videoStackView.arrangedSubviews.count];
    
    [self relayoutVideoViewsForLive];
    
    return videoView;
}

- (void)onActorLeft:(NSString *)uid live:(NSString *)liveID {
    if (self.videoStackView.arrangedSubviews.count == 0) {
        [self.view ilg_makeToast:@"数目已为零" position:ILGToastPositionCenter];
        return;
    }
    
    UIView *view = self.videoViewDic[uid];
    [self.videoStackView removeArrangedSubview:view];
    [view removeFromSuperview];
    
    [self.videoViewDic removeObjectForKey:uid];
    [self relayoutVideoViewsForLive];

    if (self.videoViewArr.count != 0) {
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
            [[XHClient sharedClient].liveManager changeToBroadcaster];
            
            [self.whitePanel publish];
            self.videoEnableBtn.hidden = NO;
            self.audioEnableBtn.hidden = NO;
            self.paintToolView.hidden = NO;
            self.laserBtn.hidden = YES;
            self.cleanBtn.hidden = YES;

        } else if (result == XHLiveJoinResult_refuse) {
            self.interactionBtn.selected = NO;
            [self.view ilg_makeToast:@"您的连麦申请被拒绝" position:ILGToastPositionCenter];
            
        } else {
            self.interactionBtn.selected = NO;
            [self.view ilg_makeToast:@"您的连麦申请超时" position:ILGToastPositionCenter];
            
        }
        
        self.interactionBtn.userInteractionEnabled = YES;
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

- (void)onReceiveRealtimeData:(NSString *)data
                         upId:(NSString *)upId {
    NSLog(@"SourceVC onReceiveRealtimeData");
    [self.whitePanel setPaintData:upId.integerValue data:data];
}

#pragma mark private function
-(NSString *)decodeMiniClassMsgContentData:(NSString *)txt
{
    NSError * error = nil;
    NSString *text = nil;
    NSData *recvMessage = [txt dataUsingEncoding:NSUTF8StringEncoding];
    
    id obj  = [NSJSONSerialization JSONObjectWithData:recvMessage options:NSJSONReadingMutableContainers error:&error];
    
    // 判断一下,id是NSMutableArray类型还是NSMutableDictionary
    if ([obj isKindOfClass:[NSArray class]]) {
        
        NSMutableArray * array = obj;
        NSLog(@"*************%@",array);
    }else{
        
        NSMutableDictionary * dict = obj;
        
         text = [dict objectForKey:@"text"] ;
    }
    return text;
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
    cell.titleLabel.textColor = [UIColor blackColor];
    
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
            [weakSelf.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[XHClient sharedClient].liveManager agreeApplyToBroadcaster:message.uid completion:^(NSError *error) {
                
            }];
            
            weakSelf.paintToolView.hidden = NO;
            weakSelf.laserBtn.hidden = YES;
            weakSelf.cleanBtn.hidden = YES;
        }];
        [alertController addAction:action];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            message.isJudgedForMic = YES;
            message.msgText = @"我要上麦(已拒绝)";
            [weakSelf.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[XHClient sharedClient].liveManager refuseApplyToBroadcaster:message.uid completion:^(NSError *error) {
                
            }];
        }];
        [alertController addAction:action2];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self showChooseAlert:message];
    }
}


-(void)showChooseAlert:(IFLiveMessage *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    NSArray *titles = @[@"私信",@"取消"];
    for (int index = 0; index < titles.count; index++)
    {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == titles.count - 1)
        {
            style = UIAlertActionStyleCancel;
        }
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[index] style:style handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     if(index == 0)
                                     {
                                         sendMessageTargetID = message.uid;
                                         _chatTF.text = [NSString stringWithFormat:@"[私%@]",message.uid];
                                         
                                     }
                                 }];
        [alertController addAction:action];
    }
    [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)penColorBtnClick:(UIButton *)sender {
    self.colorPanel.hidden = NO;
}

- (IBAction)lasterBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self.whitePanel laserPenOn];
    } else {
        [self.whitePanel laserPenOff];
    }
}

- (IBAction)revokeBtnClick:(id)sender {
    [self.whitePanel undo];
}

- (IBAction)cleanBtnClicked:(UIButton *)button {
    [self.whitePanel clean];
}

- (IBAction)backBtnClick:(id)btn {
    [[XHClient sharedClient].liveManager leaveLive:self.liveId completion:^(NSError *error) {
        if (error) {
            [UIView ilg_makeToast:error.localizedDescription];
        } else {
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)colorBtnClicked:(UIButton *)sender {
    self.colorPanel.hidden = YES;
    
    UIColor *color = [self colorWithBtnTag:sender.tag];
    self.penBtn.backgroundColor = color;
    [self.whitePanel setSelectColor:color];
}

- (IBAction)switchToChatContainer:(id)sender {
    self.whiteContainer.hidden = YES;
    self.chatContainer.hidden = NO;
}

- (IBAction)switchToPaintPanel:(id)sender {
    self.whiteContainer.hidden = NO;
    self.chatContainer.hidden = YES;
}

- (IBAction)sendMessage:(id)sender {
    [self p_sendMessage];
}

- (IBAction)interactionBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [[XHClient sharedClient].liveManager applyToBroadcaster:self.creator completion:^(NSError *error) {
            if (!error) {
                NSLog(@"上麦申请已发送");
            } else {
                NSLog(@"上麦申请发送失败:%@", error.localizedDescription);
                sender.userInteractionEnabled = YES;
            }
        }];
        
        sender.userInteractionEnabled = NO;
    } else {
        self.videoEnableBtn.hidden = YES;
        self.audioEnableBtn.hidden = YES;
        
        [self.whitePanel pause];
        self.paintToolView.hidden = YES;
        
        [[XHClient sharedClient].liveManager changeToAudience];
    }
}

- (IBAction)audioEnableBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[XHClient sharedClient].liveManager setAudioEnable:!sender.selected];
}
- (IBAction)videoEnableBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[XHClient sharedClient].liveManager setVideoEnable:!sender.selected];
}


//键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //动画
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.chatMenuView.transform = CGAffineTransformMakeTranslation(0, -kbHeight);
    }];
}

//键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //动画
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.chatMenuView.transform = CGAffineTransformIdentity;
    }];
}

- (void)colorPanelDidClicked:(UIGestureRecognizer *)ges {
    self.colorPanel.hidden = YES;
}


#pragma mark - Other

- (void)insertNewMessage:(NSString *)text userId:(NSString *)userId {
//    NSDictionary *dict = [self dictionaryWithJsonString:text];
    IFLiveMessage *message = [[IFLiveMessage alloc] init];
    message.msgText = [NSString stringWithFormat:@"%@:%@", userId, text];
    message.msgType = 0;
    message.uid = userId;
    [self insertNewMessage:message];
}

- (void)insertNewMessage:(IFLiveMessage *)elem {
    elem.msgHeight = [IFVideoChatCell caculateTextHeightWithMaxWidth:self.chatTableView.width - [IFVideoChatCell reserveWithForCell] text:elem.msgText];
    [self.messageArr addObject:elem];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.chatTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

- (void)addObserver {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (UIColor *)colorWithBtnTag:(NSInteger)tag {
    UIColor *color = [UIColor blackColor];
    
    switch (tag) {
        case 1:
            color = [UIColor blackColor];
            break;
        case 2:
            color = [UIColor redColor];
            break;
        case 3:
            color = [UIColor orangeColor];
            break;
        case 4:
            color = [UIColor greenColor];
            break;
        case 5:
            color = [UIColor blueColor];
            break;
        case 6:
            color = [UIColor purpleColor];
            break;
            
        default:
            break;
    }
    
    return color;
}

- (void)p_sendMessage {
    if (self.chatTF.text.length == 0) {
        return;
    }
    
    NSString *text = self.chatTF.text;
    NSString *uid = [IMUserInfo shareInstance].userID;
    self.chatTF.text = nil;
    
    NSMutableDictionary *mdict1 = [NSMutableDictionary dictionary];
    [mdict1 setObject:@"text" forKey:@"type"];
    [mdict1 setObject:[IMUserInfo shareInstance].userID forKey:@"from"];
    [mdict1 setObject:@"" forKey:@"fromAvatar"];
    [mdict1 setObject:[IMUserInfo shareInstance].userID forKey:@"fromNick"];
    [mdict1 setObject:text forKey:@"text"];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:mdict1 options:0 error:nil];
    NSString* strMessage = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    if(sendMessageTargetID == nil)
    {
        [[XHClient sharedClient].liveManager sendMessage:strMessage completion:^(NSError *error) {
            
        }];
    }
    else
    {
        [[XHClient sharedClient].liveManager sendMessage:strMessage toID:sendMessageTargetID completion:^(NSError *error) {
            
        }];
        sendMessageTargetID = nil;
    }
    
    IFLiveMessage *message = [[IFLiveMessage alloc] init];
    message.msgText = [NSString stringWithFormat:@"%@:%@", uid, text];
    message.msgType = 0;
    message.uid = uid;
    [self insertNewMessage:message];
    
    [self.chatTF resignFirstResponder];
}


@end
