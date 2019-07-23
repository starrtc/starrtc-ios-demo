//
//  CreateSuperRoomVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/8.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "CreateSuperRoomVC.h"
#import "XHClient.h"
#import "IFNetworkingInterfaceHandle.h"
#import "SuperRoomVC.h"
#import "XHCustomConfig.h"
#import "InterfaceUrls.h"

@interface CreateSuperRoomVC ()
@property (weak, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *priviteStatusSwitch;

@end

@implementation CreateSuperRoomVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)setupUI{
    self.navigationItem.title = @"创建超级聊天室";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
}
- (IBAction)createButtonClicked:(UIButton *)sender {
    if ([self.roomNameTextField.text length] > 0) {
        XHSuperRoomItem *superRoom = [XHSuperRoomItem new];
        superRoom.superRoomName = self.roomNameTextField.text;
        superRoom.superRoomType = XHLiveTypeGlobalPublic;
        __weak typeof(self) weakSelf = self;
//        if(self.priviteStatusSwitch.on){
//            meeting.liveType = XHLiveTypeLoginPublic;
//        } else {
//            meeting.liveType = XHLiveTypeLoginSpecXHy;
//        }
//        ID=%@&Name=%@&Creator=%@
        [[XHClient sharedClient].superRoomManager createSuperRoom:superRoom  completion:^(NSString *liveID, NSError *error) {
            if (error == nil)
            {
                NSDictionary *infoDic = @{@"id":liveID,
                                          @"creator":UserId,
                                          @"name":superRoom.superRoomName
                                          };
                NSString *infoStr = [infoDic ilg_jsonString];
                if ([AppConfig AEventCenterEnable] )
                {
                    [[[InterfaceUrls alloc] init] demoSaveTolist:LIST_TYPE_SUPER_ROOM ID:liveID data:[infoStr ilg_URLEncode]];
                }
                else
                {
                    
                    [[XHClient sharedClient].liveManager saveToList:UserId type:LIST_TYPE_SUPER_ROOM liveId:liveID info:[infoStr ilg_URLEncode] completion:^(NSError *error) {
                        
                    }];
                }
                
                SuperRoomVC *vc = [SuperRoomVC instanceFromNib];
                SuperRoomModel *roomModel = [[SuperRoomModel alloc] init];
                roomModel.liveName = superRoom.superRoomName;
                roomModel.ID = liveID;
                roomModel.creatorID = UserId;
                roomModel.liveState = 1;
                vc.roomInfo = roomModel;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                NSLog(@"%@",error);
                [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"创建直播失败：%@", error.localizedDescription] position:ILGToastPositionCenter];
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
