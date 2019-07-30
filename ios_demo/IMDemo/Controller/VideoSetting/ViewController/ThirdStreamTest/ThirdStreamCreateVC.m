//
//  IFThirdStreamCreateVC.m
//  IMDemo
//
//  Created by HappyWork on 2019/5/5.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "ThirdStreamCreateVC.h"
#import "InterfaceUrls.h"
#import "XHCustomConfig.h"

@interface ThirdStreamCreateVC () <InterfaceUrlsdelegate>
{
    InterfaceUrls *m_interfaceUrls;
    int           createType;
    NSString      *m_chatRoomID;
}
@property (weak, nonatomic) IBOutlet UITextField *rtspNameText;
@property (weak, nonatomic) IBOutlet UITextField *rtspInfoUrl;

@end

@implementation ThirdStreamCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"第三方拉流";
    m_interfaceUrls = [[InterfaceUrls alloc] init];
    m_interfaceUrls.delegate = self;
    // Do any additional setup after loading the view.
}
- (IBAction)createLiveButtonClicked:(id)sender {
    createType = LIST_TYPE_LIVE_PUSH;
    [self createStream];

}
- (IBAction)createMeetingButtonClicked:(id)sender {
    createType = LIST_TYPE_MEETING_PUSH;
    [self createStream];
}


-(void)createStream
{
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
                m_chatRoomID = chatRoomID;
                NSString *streamType = @"";
                if([_rtspInfoUrl.text containsString:@"rtsp://"])
                {
                    streamType = @"rtsp";
                }
                else if ([_rtspInfoUrl.text containsString:@"rtmp://"])
                {
                    streamType = @"rtmp";
                }
                // rtsp://184.72.239.149/vod/mp4://BigBuckBunny_175k.mov
                [m_interfaceUrls demopushStreamUrl:UserId server:[AppConfig shareConfig].uploadProxyHost name:_rtspNameText.text chatroomId:chatRoomID listType:createType streamType:streamType streamUrl:_rtspInfoUrl.text];
                
            }
        }];
    }
}
#pragma mark -InterfaceUrlsdelegate
-(void)getRtspForwardFin:(id)responseContent
{
    NSDictionary *dict = responseContent;
    int status = [[dict objectForKey:@"status"] intValue];
    NSString *channelId = [dict objectForKey:@"channelId"];
    NSString *liveId = [NSString stringWithFormat:@"%@%@",channelId,m_chatRoomID];
    __weak typeof(self) weakSelf = self;
    if (status == 1)
    {
        NSDictionary *infoDic = @{@"id":liveId,
                                  @"creator":UserId,
                                  @"name":_rtspNameText.text,
                                  @"rtsp":_rtspInfoUrl.text,
                                  @"type":[NSString stringWithFormat:@"%d",createType]
                                  };
        NSString *infoStr = [infoDic ilg_jsonString];
        if ([AppConfig AEventCenterEnable] )
        {
            [[[InterfaceUrls alloc] init] demoSaveTolist:createType ID:liveId data:[infoStr ilg_URLEncode]];
        }
        else
        {
            
            [[XHClient sharedClient].roomManager saveToList:UserId type:createType chatroomID:m_chatRoomID info:[infoStr ilg_URLEncode] completion:^(NSError *error) {
                if(error == nil)
                {
                    
                }
            }];
        }
        NSLog(@"拉流成功,请到视频会议或者互动直播中观看");
        [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"拉流成功,请到视频会议或者互动直播中观看"] position:ILGToastPositionCenter];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"创建直播失败"] position:ILGToastPositionCenter];
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
