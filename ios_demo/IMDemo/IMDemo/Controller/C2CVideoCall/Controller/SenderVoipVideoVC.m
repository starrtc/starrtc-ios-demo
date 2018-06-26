//
//  SenderVoipVideoVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "SenderVoipVideoVC.h"

#import "IMUserInfo.h"

@interface SenderVoipVideoVC ()

{
    
    
    NSString* _fromUserID;  //呼叫方ID
    NSString* _toUserID;    //被呼叫方ID
    NSInteger _contectType;   //连接类型
}

@property (weak, nonatomic) IBOutlet UIButton *senHangupButton;

@property (weak, nonatomic) IBOutlet UIView *videoPreview1;
@property (weak, nonatomic) IBOutlet UIView *videoPreview2;

@end

@implementation SenderVoipVideoVC


+ (instancetype)shareInstance
{
    static SenderVoipVideoVC * staticSenderVoipVideoVC = nil;
    static dispatch_once_t sendOnceToken;
    dispatch_once(&sendOnceToken, ^{
        staticSenderVoipVideoVC = [[SenderVoipVideoVC alloc] initWithToUserID:@""];
    });
    return staticSenderVoipVideoVC;
}

- (instancetype)initWithToUserID:(NSString*)toUserID
{
    self = [super initWithNibName:@"SenderVoipVideoVC" bundle:[NSBundle mainBundle]];
    if (self) {
        _fromUserID = [IMUserInfo shareInstance].userID;
        _toUserID = toUserID;
        
        _contectType = -1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 设置显示view
   
    // 初始化voip
}

#pragma mark 点击事件

//父类方法
- (void)leftButtonClicked:(UIButton *)button
{
   
    [[IMHelp shareManager] clearHelp];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)hangupButtonClicked:(UIButton *)sender {
    
   
    [[IMHelp shareManager] clearHelp];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//开始连接
- (void)sendVoipToUserId:(NSString*) toUserId
{
    if (_contectType != -1) {
        
    } else {
        _toUserID = toUserId;
        _contectType = 1;
    }
}

//关闭视频通话
- (void)closeVoip
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)adjustVideoPreviewSize:(CGSize)size
{
    
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
