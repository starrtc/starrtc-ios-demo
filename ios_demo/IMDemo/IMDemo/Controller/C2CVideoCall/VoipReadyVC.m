//
//  VoipReadyVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipReadyVC.h"
#import "SenderVoipVideoVC.h"
@interface VoipReadyVC ()

{
    NSString* _fromUserID;  //呼叫方ID
    NSString* _toUserID;    //被呼叫方ID
}
@property (weak, nonatomic) IBOutlet UILabel *fromUserLabel;
@property (weak, nonatomic) IBOutlet UITextField *toUserTextField;

@end

@implementation VoipReadyVC

- (instancetype)initWithFromUserID:(NSString*)fromUserID
{
    self = [super initWithNibName:@"VoipReadyVC" bundle:[NSBundle mainBundle]];
    if (self) {
        _fromUserID = fromUserID;
        _toUserID = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"一对一视频通话";
    
    if (_fromUserID) {
        self.fromUserLabel.text = [NSString stringWithFormat:@"呼叫方ID:%@",_fromUserID];
    }
    // Do any additional setup after loading the view from its nib.
}

//校验用户ID
- (BOOL)isValidData{
    if ([_fromUserID isKindOfClass:[NSString class]] == NO || _fromUserID.length == 0) {
        [UIWindow ilg_makeToast:@"无效的发送方ID"];
        return NO;
    }
    
    if ([self.toUserTextField.text isKindOfClass:[NSString class]] == NO || self.toUserTextField.text.length == 0) {
        [UIWindow ilg_makeToast:@"无效的发送方ID"];
        return NO;
    }
    _toUserID = self.toUserTextField.text;
    return YES;
}

#pragma mark 点击事件
- (IBAction)startCallButtonClicked:(UIButton *)sender {
    
    if(UserOnline){
        
        if ([self isValidData]) {
            SenderVoipVideoVC *vc = [[SenderVoipVideoVC alloc] initWithToUserID:_toUserID];
            [self.navigationController pushViewController:vc animated:YES];
            [IMHelp shareManager].voipVideoVC = vc;
        }
        
    } else {
        [UIWindow ilg_makeToast:@"用户已掉线，请重新登录"];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.toUserTextField resignFirstResponder];
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
