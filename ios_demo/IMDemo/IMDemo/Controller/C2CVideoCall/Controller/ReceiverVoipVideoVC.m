//
//  ReceiverVoipVideoVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "ReceiverVoipVideoVC.h"

@interface ReceiverVoipVideoVC ()

{
    
    
    NSString* _fromUserID;  //呼叫方ID
    NSString* _toUserID;    //被呼叫方ID
    NSInteger _contectType;   //连接类型
}
@property (weak, nonatomic) IBOutlet UIButton *pickupButton;
@property (weak, nonatomic) IBOutlet UIButton *hangupButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (weak, nonatomic) IBOutlet UIView *videoPreview1;
@property (weak, nonatomic) IBOutlet UIView *videoPreview2;

@end

@implementation ReceiverVoipVideoVC


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
    self = [super initWithNibName:@"ReceiverVoipVideoVC" bundle:[NSBundle mainBundle]];
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
   
    [self closeVoip];
}

- (IBAction)pickupButtonClicked:(UIButton *)sender {
    
   
    self.pickupButton.hidden = YES;
    self.hangupButton.hidden = NO;
    self.refuseButton.hidden = YES;
}

- (IBAction)hangupButtonClicked:(UIButton *)sender {
    
   
    [self closeVoip];
}
- (IBAction)refuseButtonClicked:(UIButton *)sender {
    
   
    [self closeVoip];
}

//关闭视频通话
- (void)closeVoip
{
    [[IMHelp shareManager] clearHelp];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)adjustVideoPreviewSize:(CGSize)size
{
    
}
@end
