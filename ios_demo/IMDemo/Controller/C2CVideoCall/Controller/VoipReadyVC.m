//
//  VoipReadyVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipReadyVC.h"
#import "SenderVoipVideoVC.h"
#import "VoipVideoVC.h"
#import "VoipHistoryManage.h"

@interface VoipReadyVC ()<UITextFieldDelegate>

{
    NSString* _toUserID;    //被呼叫方ID
}
@property (weak, nonatomic) IBOutlet UITextField *toUserTextField;

@end

@implementation VoipReadyVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建新会话";
}

//校验用户ID
- (BOOL)isValidData{
    
    if ([self.toUserTextField.text isKindOfClass:[NSString class]] == NO || self.toUserTextField.text.length == 0) {
        [UIWindow ilg_makeToast:@"无效的用户名ID"];
        return NO;
    }
    _toUserID = self.toUserTextField.text;
    return YES;
}

#pragma mark 点击事件
- (IBAction)startCallButtonClicked:(UIButton *)sender {
    if(UserOnline){
        
        if ([self isValidData]) {
            //保存历史记录
            [[VoipHistoryManage manage] addVoip:self.toUserTextField.text];
            
            [self showAlertChooseAudioOrVideo];
            
            
            
            
        }
        
    } else {
        [UIWindow ilg_makeToast:@"用户已掉线，请重新登录"];
    }
    
}


-(void)showAlertChooseAudioOrVideo
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSArray *titles = @[@"视频通话", @"音频通话", @"取消"];
    for (int index = 0; index < titles.count; index++)
    {
        UIAlertActionStyle style = UIAlertActionStyleDefault;
        if (index == titles.count - 1)
        {
            style = UIAlertActionStyleCancel;
        }
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[index] style:style handler:^(UIAlertAction * _Nonnull action)
                                 {
                                     if (index == 0 )
                                     {
                                         //设置对方UserId
                                         [[VoipVideoVC shareInstance] setupTargetId:self.toUserTextField.text viopStatus:VoipVCStatus_Calling showType:VoipShowType_Video];
                                     }
                                     else
                                     {
                                         //设置对方UserId
                                         [[VoipVideoVC shareInstance] setupTargetId:self.toUserTextField.text viopStatus:VoipVCStatus_Calling showType:VoipShowType_Audio];
                                     }
                                     [self.navigationController pushViewController:[VoipVideoVC shareInstance] animated:YES];
                                 }];
        [alertController addAction:action];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.toUserTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.toUserTextField resignFirstResponder];
    if(UserOnline){
        
        if ([self isValidData]) {
            //保存历史记录
            [[VoipHistoryManage manage] addVoip:self.toUserTextField.text];
            //设置对方UserId
            [self showAlertChooseAudioOrVideo];
            [self.navigationController pushViewController:[VoipVideoVC shareInstance] animated:YES];
            
        }
        
    } else {
        [UIWindow ilg_makeToast:@"用户已掉线，请重新登录"];
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
