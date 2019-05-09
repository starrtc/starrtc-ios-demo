//
//  MessageGroupCreateViewController.m
//  IMDemo
//
//  Created by  Admin on 2018/1/5.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "MessageGroupCreateViewController.h"
#import "MessageGroupViewController.h"

@interface MessageGroupCreateViewController ()

@end

@implementation MessageGroupCreateViewController

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
    self.title = @"创建消息群";
    
    self.sessionView.alertTitle = @"专属群组的名称";
    self.sessionView.textFieldPlaceholder = @"输入群组名称";
    self.sessionView.funcBtnTitle = @"创建新群组";
    self.sessionView.isHasControl = NO;
}


#pragma mark - Event


#pragma mark - Delegate
- (void)sessionViewCreateBtnDidClicked:(NSString *)name {
    if(name.length == 0) {
        [UIView ilg_makeToast:@"群组名称不能为空"];
        
    } else {
        [self.view showProgressWithText:@"创建中..."];
        
        __weak typeof(self) weakSelf = self;
        [[XHClient sharedClient].groupManager createGroup:name completion:^(NSString *groupID, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view hideProgress];
                
                if (error) {
                    [UIView ilg_makeToast:error.localizedDescription];
                    
                } else {
                    MessageGroupViewController *receive = [[MessageGroupViewController alloc] init];
                    receive.m_Group_Name = name;
                    receive.m_Group_ID = groupID;
                    receive.creatorID = [IMUserInfo shareInstance].userID;
                    
                    NSMutableArray *vcArr = weakSelf.navigationController.viewControllers.mutableCopy;
                    [vcArr removeLastObject];
                    [vcArr addObject:receive];
                    [weakSelf.navigationController setViewControllers:vcArr];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"IFGroupListRefreshNotif" object:nil];
                }
            });
        }];
    }
}

@end
