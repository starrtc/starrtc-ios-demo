//
//  ChatRoomCreateViewController.m
//  IMDemo
//
//  Created by  Admin on 2017/12/27.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "ChatRoomCreateViewController.h"
#import "ChatRoomViewController.h"

#import "InterfaceUrls.h"
#import "XHCustomConfig.h"

@interface ChatRoomCreateViewController ()

@end

@implementation ChatRoomCreateViewController

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
    self.title = @"创建聊天室";

    self.sessionView.alertTitle = @"专属聊天室的名称";
    self.sessionView.textFieldPlaceholder = @"输入聊天室名称";
    self.sessionView.funcBtnTitle = @"创建聊天室";
}


#pragma mark - Event

#pragma mark - Delegate
- (void)sessionViewCreateBtnDidClicked:(NSString *)name {
    if(name.length == 0) {
        [UIView ilg_makeToast:@"聊天室名称不能为空"];
        
    } else {
        XHChatroomType type = self.sessionView.isPublic ? XHChatroomTypePublic:XHChatroomTypeLogin;
        [[XHClient sharedClient].roomManager createChatroom:name type:type completion:^(NSString *chatRoomID, NSError *error) {
            if (error) {
                [UIView ilg_makeToast:error.localizedDescription];
                
            } else {
                if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
                    [[[InterfaceUrls alloc] init] reportChatroom:name ID:chatRoomID creator:[IMUserInfo shareInstance].userID];
                } else {
                    NSDictionary *infoDic = @{@"id":chatRoomID,
                                              @"creator":UserId,
                                              @"name":name
                                              };
                    NSString *infoStr = [infoDic ilg_jsonString];
                    [[XHClient sharedClient].roomManager saveToList:UserId type:CHATROOM_LIST_TYPE_CHATROOM chatroomID:chatRoomID info:[infoStr ilg_URLEncode] completion:^(NSError *error) {
                        
                    }];
                }
                
                ChatRoomViewController *receive = [[ChatRoomViewController alloc] init];
                receive.mRoomName = name;
                receive.mRoomId = chatRoomID;
                receive.mCreaterId = [IMUserInfo shareInstance].userID;
                receive.fromType = IFChatroomVCTypeFromCreate;
                
                NSMutableArray *vcArr = self.navigationController.viewControllers.mutableCopy;
                [vcArr removeLastObject];
                [vcArr addObject:receive];
                [self.navigationController setViewControllers:vcArr];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IFChatroomListRefreshNotif" object:nil];
            }
        }];
    }
}
@end
