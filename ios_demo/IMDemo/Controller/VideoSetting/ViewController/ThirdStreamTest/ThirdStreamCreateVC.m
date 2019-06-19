//
//  IFThirdStreamCreateVC.m
//  IMDemo
//
//  Created by HappyWork on 2019/5/5.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "ThirdStreamCreateVC.h"
#import "InterfaceUrls.h"

@interface ThirdStreamCreateVC ()
@property (weak, nonatomic) IBOutlet UITextField *rtspNameText;
@property (weak, nonatomic) IBOutlet UITextField *rtspInfoUrl;

@end

@implementation ThirdStreamCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第三方拉流";
    // Do any additional setup after loading the view.
}
- (IBAction)createLiveButtonClicked:(id)sender {
    if(!_rtspNameText.text )
    {
        [UIWindow ilg_makeToast:@"名称不能为空"];
    }
    else if(!_rtspInfoUrl.text)
    {
        [UIWindow ilg_makeToast:@"拉流地址不能为空"];
    }
    else
    {
        [[XHClient sharedClient].roomManager createChatroom:_rtspNameText.text type:XHChatroomTypePublic completion:^(NSString *chatRoomID, NSError *error) {
            if(!error)
            {
                    [[[InterfaceUrls alloc] init] demopushRtsp:[AppConfig shareConfig].uploadProxyHost name:_rtspNameText.text chatroomId:chatRoomID listType:2 rtspUrl:_rtspInfoUrl.text];

            }
        }];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
