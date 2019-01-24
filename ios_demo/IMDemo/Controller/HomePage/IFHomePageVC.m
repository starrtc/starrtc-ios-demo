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
#import "SenderVoipVideoVC.h"
#import "IFLiveListVC.h"
#import "IFMutilMeetingListVC.h"
#import "IMHelp.h"
#import "VideoSetParameters.h"
#import "CircleTestVC.h"
#import "EMViewController.h"
#import "XHClient.h"
#import "InterfaceUrls.h"
@interface IFHomePageVC ()<XHLoginManagerDelegate>
{
    NSString *appid;
    NSString *authkeyUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (nonatomic, strong) SenderVoipVideoVC * senderVoipVideoVC;
@end

@implementation IFHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appid = @"BjR6QV3vUJ4d";
    authkeyUrl = @"https://api.starrtc.com/demo/authKey";
    
    [self setVideoParameters];  //设置视频参数
    [[XHClient sharedClient].loginManager addDelegate:self];
    
    [self login];
    
    //开启代理监听
    [[IMHelp shareManager] setDelegate:self];
    [[IMHelp shareManager] startMonitoring];
    [self hiddenLeftButton];
//    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}




#pragma mark 点击事件

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
    
    CircleTestVC *vc = [[CircleTestVC alloc] initWithNibName:@"CircleTestVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)videoSetButtonClicked:(UIButton *)sender {
    
    
//    EMViewController *vc = [[EMViewController alloc] init];
    VideoSettingVC * vc = [[VideoSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)logoutButtonClicked:(UIButton *)sender {
    
    if (sender.selected) {
        [self logout];
    } else {
        [self login];
    }
    
}

#pragma mark 其它
//设置视频参数
- (void)setVideoParameters
{
    VideoSetParameters *parameters = [VideoSetParameters locaParameters];
    [[XHClient sharedClient] setVideoConfig:parameters];
}
- (void)login{
    
    
    
    [UIWindow showProgressWithText:@"正在登录..."];
    [InterfaceUrls getAuthKey:UserId appid:@"BjR6QV3vUJ4d" url:@"https://api.starrtc.com/demo/authKey" callback:^(BOOL status, NSString *data) {
        if (status) {
            [[XHClient sharedClient].loginManager login:UserId authKey:data completion:^(NSError *error) {
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
        } else {
            [UIWindow hiddenProgress];
            NSLog(@"authKey 获取失败");
            self.userNickNameLabel.text = @"AuthKey 获取失败";
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
