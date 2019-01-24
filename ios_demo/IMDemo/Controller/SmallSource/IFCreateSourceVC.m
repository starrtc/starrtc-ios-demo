//
//  IFCreateSourceVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFCreateSourceVC.h"

#import "IFSourceVC.h"

#import "InterfaceUrls.h"

@interface IFCreateSourceVC ()

@end

@implementation IFCreateSourceVC

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
    self.title = @"创建小班课";
    
    self.sessionView.alertTitle = @"请在下方输入课程名称";
    self.sessionView.textFieldPlaceholder = @"输入课程名称";
    self.sessionView.funcBtnTitle = @"创建小班课";
}


#pragma mark - Event


#pragma mark - Delegate
- (void)sessionViewCreateBtnDidClicked:(NSString *)name {
    if(name.length == 0) {
        [UIView ilg_makeToast:@"课程名称不能为空"];
        
    } else {
        [UIView showProgressWithText:@"创建中..."];
        __weak typeof(self) weakSelf = self;
        XHLiveItem *liveItem = [[XHLiveItem alloc] init];
        liveItem.liveName = name;
        liveItem.liveType = self.sessionView.isPublic ? XHLiveTypeGlobalPublic:XHLiveTypeLoginPublic;
        [[XHClient sharedClient].liveManager createLive:liveItem completion:^(NSString *liveID, NSError *error) {
            [UIView hiddenProgress];
            
            if (error) {
                [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"创建课程失败：%@", error.localizedDescription] position:ILGToastPositionCenter];
                
            } else {
                [[[InterfaceUrls alloc] init] reportSuorce:name ID:liveID creator:[IMUserInfo shareInstance].userID];
                
                IFSourceVC *receive = [IFSourceVC viewControllerWithType:IFSourceVCTypeCreate];
                receive.liveId = liveID;
                receive.creator = [IMUserInfo shareInstance].userID;

                NSMutableArray *vcArr = weakSelf.navigationController.viewControllers.mutableCopy;
                [vcArr removeLastObject];
                [vcArr addObject:receive];
//                [weakSelf.navigationController setViewControllers:vcArr];
                [weakSelf.navigationController presentViewController:receive animated:NO completion:nil];
            }
        }];
    }
}
@end
