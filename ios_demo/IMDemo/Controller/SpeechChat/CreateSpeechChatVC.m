//
//  CreateSpeechChatVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "CreateSpeechChatVC.h"
#import "XHClient.h"
#import "IFNetworkingInterfaceHandle.h"
#import "SpeechChatVC.h"
@interface CreateSpeechChatVC ()
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *priviteStatusSwitch;

@end

@implementation CreateSpeechChatVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"创建语音直播间";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
}
- (IBAction)createButtonClicked:(UIButton *)sender {
//    SpeechChatVC *vc = [SpeechChatVC instanceFromNib];
//    vc.meettingName = @"meeting.meetingName";
//    vc.meettingID = @"meeting.meetingName";
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    if ([self.roomNameTextField.text length] > 0) {
        XHLiveItem *meeting = [XHLiveItem new];
        meeting.liveName = self.roomNameTextField.text;
        if(self.priviteStatusSwitch.on){
            meeting.liveType = XHLiveTypeLoginPublic;
        } else {
            meeting.liveType = XHLiveTypeLoginSpecXHy;
        }
//        ID=%@&Name=%@&Creator=%@
        [[XHClient sharedClient].liveManager createLive:meeting completion:^(NSString *liveID, NSError *error) {
            if (error == nil) {
                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:1];
                [parameters setObject:liveID forKey:@"ID"];
                [parameters setObject:meeting.liveName forKey:@"Name"];
                [parameters setObject:[IMUserInfo shareInstance].userID forKey:@"Creator"];
                [parameters setObject:[XHClient sharedClient].config.agentID forKey:@"appid"];
                [IFNetworkingInterfaceHandle requestCreateAudioRoomWithParameters:parameters success:^(id  _Nullable responseObject) {
                    
                    NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
                    if (status == 1) {
                        SpeechChatVC *vc = [SpeechChatVC instanceFromNib];
                        SpeechRoomModel *roomModel = [[SpeechRoomModel alloc] init];
                        roomModel.Name = meeting.liveName;
                        roomModel.ID = liveID;
                        roomModel.Creator = UserId;
                        roomModel.liveState = 1;
                        vc.roomInfo = roomModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                } failure:^(NSError * _Nonnull error) {
                    
                }];
            } else {
                NSLog(@"%@",error);
            }
            
        }];
    } else {
        [UIWindow ilg_makeToast:@"名称不能为空"];
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
