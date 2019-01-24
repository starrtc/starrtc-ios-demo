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

- (void)initTextField{
    self.yewuTextField.text = [AppConfig shareConfig].host;
    self.userIdTextField.text = [AppConfig shareConfig].userId;
    self.appIdTextField.text = [AppConfig shareConfig].appId;
    self.loginTextField.text = [AppConfig shareConfig].loginHost;
    self.messageTextField.text = [AppConfig shareConfig].messageHost;
    self.chatTextField.text = [AppConfig shareConfig].chatHost;
    self.uploadTextField.text = [AppConfig shareConfig].uploadHost;
    self.downloadTextField.text = [AppConfig shareConfig].downloadHost;
    self.voipTextField.text = [AppConfig shareConfig].voipHost;
//    if (parameters) {
//        self.appIdTextField.text = [parameters objectForKey:@"agentID"];
//        self.loginTextField.text = [parameters objectForKey:@"starLoginURL"];
//        self.messageTextField.text = [parameters objectForKey:@"imScheduleURL"];
//        self.chatTextField.text = [parameters objectForKey:@"chatRoomScheduleURL"];
//        self.uploadTextField.text = [parameters objectForKey:@"liveSrcScheduleURL"];
//        self.downloadTextField.text = [parameters objectForKey:@"liveVdnScheduleURL"];
//        self.voipTextField.text = [parameters objectForKey:@"voipServerURL"];
//    } else {
//        self.appIdTextField.text = [XHClient sharedClient].config.agentID;
//        self.loginTextField.text = [XHClient sharedClient].config.starLoginURL;
//        self.messageTextField.text = [XHClient sharedClient].config.imScheduleURL;
//        self.chatTextField.text = [XHClient sharedClient].config.chatRoomScheduleURL;
//        self.uploadTextField.text = [XHClient sharedClient].config.liveSrcScheduleURL;
//        self.downloadTextField.text = [XHClient sharedClient].config.liveVdnScheduleURL;
//        self.voipTextField.text = [XHClient sharedClient].config.voipServerURL;
//    }
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
    
    NSMutableDictionary *appParameters = [NSMutableDictionary dictionaryWithCapacity:1];
    [appParameters setObject:self.appIdTextField.text forKey:@"host"];
    [appParameters setObject:self.loginTextField.text forKey:@"loginHost"];
    [appParameters setObject:self.messageTextField.text forKey:@"messageHost"];
    [appParameters setObject:self.chatTextField.text forKey:@"chatHost"];
    [appParameters setObject:self.uploadTextField.text forKey:@"uploadHost"];
    [appParameters setObject:self.downloadTextField.text forKey:@"downloadHost"];
    [appParameters setObject:self.voipTextField.text forKey:@"voipHost"];
    [appParameters setObject:self.yewuTextField.text forKey:@"host"];
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
@end
