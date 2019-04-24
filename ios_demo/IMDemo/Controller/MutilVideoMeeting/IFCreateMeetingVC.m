//
//  IFCreateMeetingVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFCreateMeetingVC.h"

#import "IFMutilMeetingVC.h"

#import "InterfaceUrls.h"

#import "XHCustomConfig.h"

@interface IFCreateMeetingVC ()

@end

@implementation IFCreateMeetingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)createUI {
    self.title = @"创建会议室";
    
    self.sessionView.alertTitle = @"专属会议的名称";
    self.sessionView.textFieldPlaceholder = @"输入会议名称";
    self.sessionView.funcBtnTitle = @"创建新会议";
}


#pragma mark - Event


#pragma mark - Delegate
- (void)sessionViewCreateBtnDidClicked:(NSString *)name {
    if (name.length == 0) {
        NSLog(@"会议室名称不能为空");
        
    } else {
        [UIView showProgressWithText:@"创建中..."];
        __weak typeof(self) weakSelf = self;
        XHMeetingItem *meetingItem = [[XHMeetingItem alloc] init];
        meetingItem.meetingName = name;
        meetingItem.meetingType = self.sessionView.isPublic ? XHMeetingTypeGlobalPublic:XHMeetingTypeLoginPublic;
        [[XHClient sharedClient].meetingManager createMeeting:meetingItem completion:^(NSString *meetingID, NSError *error) {
            [UIView hiddenProgress];
            if (error) {
                [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"创建会议失败：%@", error.localizedDescription] position:ILGToastPositionCenter];
                
            } else {
                if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
                    [[[InterfaceUrls alloc] init] reportMeeting:name ID:meetingID creator:[IMUserInfo shareInstance].userID];
                } else {
                    [[XHClient sharedClient].meetingManager saveToList:UserId type:CHATROOM_LIST_TYPE_MEETING meetingId:meetingID info:name completion:^(NSError *error) {
                        
                    }];
                }
                
                IFMutilMeetingVC *receive = [[IFMutilMeetingVC alloc] initWithType:IFMutilMeetingVCTypeCreate];
                receive.meetingId = meetingID;
                receive.meetingName = name;

                NSMutableArray *vcArr = self.navigationController.viewControllers.mutableCopy;
                [vcArr removeLastObject];
                [vcArr addObject:receive];
                [self.navigationController setViewControllers:vcArr];
            }
        }];
    }
}
@end
