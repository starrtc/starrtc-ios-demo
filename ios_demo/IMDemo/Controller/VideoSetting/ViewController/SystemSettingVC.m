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
@property (weak, nonatomic) IBOutlet UITextField *yewuTextField;
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *appIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UITextField *uploadTextField;
@property (weak, nonatomic) IBOutlet UITextField *downloadTextField;
@property (weak, nonatomic) IBOutlet UITextField *voipTextField;

@property (weak, nonatomic) IBOutlet UILabel *messageTitleL;
@property (weak, nonatomic) IBOutlet UILabel *chatroomTitleL;
@property (weak, nonatomic) IBOutlet UILabel *uploadTitleL;
@property (weak, nonatomic) IBOutlet UILabel *downloadTitleL;
@property (weak, nonatomic) IBOutlet UILabel *voipTitleL;

@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

@property (weak, nonatomic) IBOutlet UIView *yewuView;
@property (weak, nonatomic) IBOutlet UIView *appidView;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (assign, nonatomic) IFServiceType serviceTypeForTmp;
@end

@implementation SystemSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"系统设置";
    [self addDelegate];
    [self initTextField];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditTextField:)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
    
    self.serviceTypeForTmp = [AppConfig SDKServiceType];
    if ([AppConfig SDKServiceType] == IFServiceTypePublic) {
        [self.serviceBtn setTitle:@"公有云" forState:UIControlStateNormal];
    } else {
        [self.serviceBtn setTitle:@"私有部署" forState:UIControlStateNormal];
    }
}
- (void)addDelegate{
    self.yewuTextField.delegate = self;
    self.userIdTextField.delegate = self;
    self.appIdTextField.delegate = self;
    self.loginTextField.delegate = self;
    self.messageTextField.delegate = self;
    self.chatTextField.delegate = self;
    self.uploadTextField.delegate = self;
    self.downloadTextField.delegate = self;
    self.voipTextField.delegate = self;
}

- (void)initTextField
{
    self.yewuTextField.text = [AppConfig shareConfig].host;
    self.userIdTextField.text = [AppConfig shareConfig].userId;
    self.appIdTextField.text = [AppConfig shareConfig].appId;
    self.loginTextField.text = [AppConfig shareConfig].loginHost;
    self.messageTextField.text = [AppConfig shareConfig].messageHost;
    self.chatTextField.text = [AppConfig shareConfig].chatHost;
    self.uploadTextField.text = [AppConfig shareConfig].uploadHost;
    self.downloadTextField.text = [AppConfig shareConfig].downloadHost;
    self.voipTextField.text = [AppConfig shareConfig].voipHost;
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
    if (self.serviceTypeForTmp != [AppConfig SDKServiceType]) {
        [AppConfig switchSDKServiceType];
    }
    
    NSMutableDictionary *appParameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [appParameters setObject:self.yewuTextField.text forKey:@"host"];
    [appParameters setObject:self.loginTextField.text forKey:@"loginHost"];
    [appParameters setObject:self.messageTextField.text forKey:@"messageHost"];
    [appParameters setObject:self.chatTextField.text forKey:@"chatHost"];
    [appParameters setObject:self.uploadTextField.text forKey:@"uploadHost"];
    [appParameters setObject:self.downloadTextField.text forKey:@"downloadHost"];
    [appParameters setObject:self.voipTextField.text forKey:@"voipHost"];
    [appParameters setObject:self.appIdTextField.text forKey:@"appId"];
    [appParameters setObject:self.userIdTextField.text forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:appParameters forKey:@"AppConfigParameters"];
    [UIWindow ilg_makeToast:@"保存成功，重新启动APP后生效"];
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

- (IBAction)switchService:(id)sender {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *privateAction = [UIAlertAction actionWithTitle:@"私有部署" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleServiceSwitch:IFServiceTypePrivate];
    }];
    UIAlertAction *publicAction = [UIAlertAction actionWithTitle:@"公有云" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleServiceSwitch:IFServiceTypePublic];
    }];
    [alertController addAction:privateAction];
    [alertController addAction:publicAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - other
// To do ... : 处理UI以及数据
- (void)handleServiceSwitch:(IFServiceType)serviceType
{
    self.serviceTypeForTmp = serviceType;
    
    if (serviceType == IFServiceTypePublic) {
        [self.serviceBtn setTitle:@"公有云" forState:UIControlStateNormal];

        self.appidView.hidden = NO;
        self.yewuView.hidden = NO;
        self.loginView.hidden = NO;
        
        self.messageTitleL.text = @"消息调度";
        self.chatroomTitleL.text = @"聊天室调度";
        self.uploadTitleL.text = @"LiveSrc调度";
        self.downloadTitleL.text = @"LiveVdn调度";
        self.voipTitleL.text = @"VOIP调度";
    } else {
        [self.serviceBtn setTitle:@"私有部署" forState:UIControlStateNormal];
        
        self.appidView.hidden = YES;
        self.yewuView.hidden = YES;
        self.loginView.hidden = YES;
        
        self.messageTitleL.text = @"消息服务";
        self.chatroomTitleL.text = @"聊天室服务";
        self.uploadTitleL.text = @"LiveSrc服务";
        self.downloadTitleL.text = @"LiveVdn服务";
        self.voipTitleL.text = @"VOIP服务";
    }
}

@end
