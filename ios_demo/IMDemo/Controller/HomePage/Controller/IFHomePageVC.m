//
//  IFHomePageVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/3/29.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFHomePageVC.h"
#import "VideoSettingVC.h"
#import "VoipListVC.h"
#import "ViewController.h"
#import "IFLiveListVC.h"
#import "IFMutilMeetingListVC.h"
#import "IMHelp.h"
#import "VideoSetParameters.h"
#import "CircleTestVC.h"
#import "EMViewController.h"
#import "XHClient.h"
#import "InterfaceUrls.h"
#import "SuperRoomListVC.h"
#import "IMMsgManager.h"
#import "SpeechChatListVC.h"

#import "IFSourceListVC.h"

@interface IFHomePageVC ()<XHLoginManagerDelegate>
{
//    NSString *appid;
//    NSString *authkeyUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *iMButton;
@property (weak, nonatomic) IBOutlet UIButton *videoSetButton;
@property (weak, nonatomic) IBOutlet UIButton *voipButton;
@property (weak, nonatomic) IBOutlet UIButton *liveButton;
@property (weak, nonatomic) IBOutlet UIButton *meettingButton;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIView *manyVideoView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UIView *liveView;
@property (weak, nonatomic) IBOutlet UIView *videoSetView;
@property (weak, nonatomic) IBOutlet UIView *imView;
@property (weak, nonatomic) IBOutlet UIView *voipView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageTipImageView;

@end

@implementation IFHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setVideoParameters];  //设置视频参数
    [[XHClient sharedClient].loginManager addDelegate:self];
    
    [self login];
    
    //开启代理监听
    [[IMHelp shareManager] setDelegate:self];
    [[IMHelp shareManager] startMonitoring];
    [self hiddenLeftButton];
    self.headerImageView.image = [UIImage imageWithUserId:UserId];

    [[IMMsgManager sharedInstance] addDelegateForC2CMsg];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self setupLiveEnable:[AppConfig shareConfig].liveEnable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageDidReceive:) name:IMChatMsgReceiveNotif object:nil];
    
    int unReadNum = [[IMMsgManager sharedInstance] unReadNumForSessionList];
    if (unReadNum) {
        self.messageTipImageView.hidden = NO;
    } else {
        self.messageTipImageView.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMChatMsgReceiveNotif object:nil];
}

- (void)setupLiveEnable:(BOOL)enable{
    
    self.manyVideoView.hidden = !enable;
    self.liveView.hidden = !enable;
    if (!enable) {
        self.circleView.y = CGRectGetMaxY(self.imView.frame) + 7;
        self.videoSetView.y = CGRectGetMaxY(self.voipView.frame) + 7;
    } else {
        self.circleView.y = CGRectGetMaxY(self.manyVideoView.frame) + 7;
        self.videoSetView.y = CGRectGetMaxY(self.liveView.frame) + 7;
    }
}

#pragma mark 点击事件

- (IBAction)setButtonClicked:(UIButton *)sender {
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"VideoSettings" bundle:nil];
//    VideoSettingVC * vc = [board instantiateViewControllerWithIdentifier:@"VideoSettingVC"];
    VideoSettingVC * vc = [[VideoSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)imButtonClicked:(UIButton *)sender {
    ViewController *vc = [[ViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)c2cButtonClicked:(UIButton *)sender {
    if(UserOnline){
        VoipListVC * vc = [[VoipListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [UIWindow ilg_makeToast:@"您当前处于离线状态！请先登录"];
    }
}

- (IBAction)liveButtonClicked:(UIButton *)sender {
    
    if (UserOnline) {
        IFLiveListVC *vc = [[IFLiveListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)meetingButtonClicked:(UIButton *)sender {
    
    if (UserOnline) {
        IFMutilMeetingListVC *vc = [[IFMutilMeetingListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (IBAction)circleTestButtonClicked:(UIButton *)sender {
    if (UserOnline) {
        IFSourceListVC *vc = [[IFSourceListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    CircleTestVC *vc = [[CircleTestVC alloc] initWithNibName:@"CircleTestVC" bundle:[NSBundle mainBundle]];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)videoSetButtonClicked:(UIButton *)sender {
    
//    SpeechChatListVC *listVC = [SpeechChatListVC instanceFromNib];
//    [self.navigationController pushViewController:listVC animated:YES];
    
    SuperRoomListVC *listVC = [SuperRoomListVC instanceFromNib];
    [self.navigationController pushViewController:listVC animated:YES];
    
    
}
- (IBAction)logoutButtonClicked:(UIButton *)sender {
    
    if (sender.selected) {
        [self logout];
    } else {
        [self login];
    }
    
}

- (void)chatMessageDidReceive:(NSNotification *)notif {
    NSDictionary *dic = notif.object;
    NSString *uid = dic[@"uid"];
    
    if (![uid isEqualToString:[IMMsgManager sharedInstance].sessionIDForChating]) {
        self.messageTipImageView.hidden = NO;
    }

    NSLog(@"来新消息啦");
}

#pragma mark 其它
//设置视频参数
- (void)setVideoParameters
{
    VideoSetParameters *parameters = [VideoSetParameters locaParameters];
    [[XHClient sharedClient] setVideoConfig:parameters];
}

- (void)login
{
    [UIWindow showProgressWithText:@"正在登录..."];

    [[XHClient sharedClient].loginManager loginFree:^(NSError *error) {
        [UIWindow hiddenProgress];
        if(error == nil){
            [UIWindow ilg_makeToast:@"登录成功"];
            self.userNickNameLabel.text = UserId;
            self.loginButton.selected = YES;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"UserOnline"];
        } else{
            [UIWindow ilg_makeToast:@"登录失败"];
            self.userNickNameLabel.text = @"登录失败";
            self.loginButton.selected = NO;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"UserOnline"];
        }
    }];
}

- (void)logout {
    [[XHClient sharedClient].loginManager logout];
    self.userNickNameLabel.text = @"--";
    self.loginButton.selected = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
