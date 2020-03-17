//
//  SystemSettingVC.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/21.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SystemSettingVC.h"
#import "IFNetworkingInterfaceHandle.h"
@interface SystemSettingVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UITextField *uploadTextField;
@property (weak, nonatomic) IBOutlet UITextField *downloadTextField;
@property (weak, nonatomic) IBOutlet UITextField *voipTextField;
@property (weak, nonatomic) IBOutlet UITextField *uploadProxyTextField;



@property (weak, nonatomic) IBOutlet UITextField *aecIMGroupListTexfield;
@property (weak, nonatomic) IBOutlet UITextField *aecIMGroupInfoTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherListDeleteTextField;

@property (weak, nonatomic) IBOutlet UITextField *otherListSaveTextField;
@property (weak, nonatomic) IBOutlet UITextField *otherListQueryTextField;


//@property (weak, nonatomic) IBOutlet UILabel *messageTitleL;
//@property (weak, nonatomic) IBOutlet UILabel *chatroomTitleL;
//@property (weak, nonatomic) IBOutlet UILabel *uploadTitleL;
//@property (weak, nonatomic) IBOutlet UILabel *downloadTitleL;
//@property (weak, nonatomic) IBOutlet UILabel *voipTitleL;
//
//@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;
//
//@property (weak, nonatomic) IBOutlet UIView *yewuView;
//@property (weak, nonatomic) IBOutlet UIView *appidView;
//@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (assign, nonatomic) IFServiceType serviceTypeForTmp;
@end

@implementation SystemSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统设置";
    [self addDelegate];
    
    self.serviceTypeForTmp = IFServiceTypePrivate;

    //[self adjustUI:self.serviceTypeForTmp];
    [self initTextField];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditTextField:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)addDelegate{
    //self.yewuTextField.delegate = self;
    self.userIdTextField.delegate = self;
    //self.appIdTextField.delegate = self;
    //self.loginTextField.delegate = self;
    self.messageTextField.delegate = self;
    self.chatTextField.delegate = self;
    self.uploadTextField.delegate = self;
    self.downloadTextField.delegate = self;
    self.voipTextField.delegate = self;
    self.uploadProxyTextField.delegate = self;
    
    self.aecIMGroupListTexfield.delegate = self;
    self.aecIMGroupInfoTextField.delegate = self;
    self.otherListDeleteTextField.delegate = self;
    self.otherListSaveTextField.delegate = self;
    self.otherListQueryTextField.delegate = self;
}

- (void)initTextField
{
    AppConfig *config = [AppConfig appConfigForLocal:self.serviceTypeForTmp];
    
    //self.yewuTextField.text = config.host;
    self.userIdTextField.text = config.userId;
    //self.appIdTextField.text = config.appId;
    //self.loginTextField.text = config.loginHost;
    self.messageTextField.text = config.messageHost;
    self.chatTextField.text = config.chatHost;
    self.uploadTextField.text = config.uploadHost;
    self.downloadTextField.text = config.downloadHost;
    self.voipTextField.text = config.voipHost;
    self.uploadProxyTextField.text = config.uploadProxyHost;
    
    self.aecIMGroupListTexfield.text = config.getIMGroupListHost;
    self.aecIMGroupInfoTextField.text = config.getIMGroupInfoHost;
    self.otherListQueryTextField.text = config.otherListQueryHost;
    self.otherListSaveTextField.text = config.otherListSaveHost;
    self.otherListDeleteTextField.text = config.otherListDeleteHost;
    
    
}

- (void)endEditTextField:(UIGestureRecognizer*)ges{
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)saveButtonClicked:(UIButton *)sender {
//    if (self.serviceTypeForTmp != [AppConfig SDKServiceType]) {
//        [AppConfig switchSDKServiceType];
//    }
    
    NSMutableDictionary *appParameters = [NSMutableDictionary dictionaryWithCapacity:1];
//    [appParameters setObject:self.yewuTextField.text forKey:@"host"];
//    [appParameters setObject:self.loginTextField.text forKey:@"loginHost"];
    [appParameters setObject:self.messageTextField.text forKey:@"messageHost"];
    [appParameters setObject:self.chatTextField.text forKey:@"chatHost"];
    [appParameters setObject:self.uploadTextField.text forKey:@"uploadHost"];
    [appParameters setObject:self.downloadTextField.text forKey:@"downloadHost"];
    [appParameters setObject:self.voipTextField.text forKey:@"voipHost"];
//    [appParameters setObject:self.appIdTextField.text forKey:@"appId"];
    [appParameters setObject:self.userIdTextField.text forKey:@"userId"];
    [appParameters setObject:self.uploadProxyTextField.text forKey:@"uploadProxyHost"];
    
    [appParameters setObject:self.aecIMGroupListTexfield.text forKey:@"getIMGroupListHost"];
    [appParameters setObject:self.aecIMGroupInfoTextField.text forKey:@"getIMGroupInfoHost"];
    [appParameters setObject:self.otherListDeleteTextField.text forKey:@"otherListDeleteHost"];
    [appParameters setObject:self.otherListSaveTextField.text forKey:@"otherListSaveHost"];
    [appParameters setObject:self.otherListQueryTextField.text forKey:@"otherListQueryHost"];
    
    if (self.serviceTypeForTmp == IFServiceTypePublic) {
        [AppConfig saveSystemSettingsForPublic:appParameters];
    } else {
        [AppConfig saveSystemSettingsForPrivate:appParameters];
    }
    
    [UIView showProgressWithText:@"App即将自动终止，请重新启动APP"];
    [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timeRecordDidEnd:) userInfo:nil repeats:NO];
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark - event

//- (IBAction)switchService:(id)sender {
//    __weak typeof(self) weakSelf = self;
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *privateAction = [UIAlertAction actionWithTitle:@"私有部署" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf handleServiceSwitch:IFServiceTypePrivate];
//    }];
//    UIAlertAction *publicAction = [UIAlertAction actionWithTitle:@"公有云" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf handleServiceSwitch:IFServiceTypePublic];
//    }];
//    [alertController addAction:privateAction];
//    [alertController addAction:publicAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}

- (void)timeRecordDidEnd:(NSTimer *)timer {
    exit(0);
}


#pragma mark - other
- (void)handleServiceSwitch:(IFServiceType)serviceType
{
    self.serviceTypeForTmp = serviceType;
    
    //[self adjustUI:serviceType];

    [self initTextField];
}

//- (void)adjustUI:(IFServiceType)serviceType
//{
//    // 隐藏公有私有切换
//    [self.serviceBtn setHidden:YES];
//
//    if (serviceType == IFServiceTypePublic) {
//        [self.serviceBtn setTitle:@"公有云 >" forState:UIControlStateNormal];
//
//        self.appidView.hidden = NO;
//        self.yewuView.hidden = NO;
//        self.loginView.hidden = NO;
//
//        self.messageTitleL.text = @"消息调度";
//        self.chatroomTitleL.text = @"聊天室调度";
//        self.uploadTitleL.text = @"LiveSrc调度";
//        self.downloadTitleL.text = @"LiveVdn调度";
//        self.voipTitleL.text = @"VOIP调度";
//    } else {
//        [self.serviceBtn setTitle:@"私有部署 >" forState:UIControlStateNormal];
//
//        self.appidView.hidden = YES;
//        self.yewuView.hidden = YES;
//        self.loginView.hidden = YES;
//
//        self.messageTitleL.text = @"消息服务";
//        self.chatroomTitleL.text = @"聊天室服务";
//        self.uploadTitleL.text = @"LiveSrc服务";
//        self.downloadTitleL.text = @"LiveVdn服务";
//        self.voipTitleL.text = @"VOIP服务";
//    }
//}

@end
