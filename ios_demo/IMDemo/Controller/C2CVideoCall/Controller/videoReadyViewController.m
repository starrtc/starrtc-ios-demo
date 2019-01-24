//
//  videoReadyView.m
//  sdk_UI_work
//
//  Created by  Admin on 2017/9/21.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "videoReadyViewController.h"
#import "voipControllerView.h"

static  NSString *m_user_ID_text;

@implementation videoReadyViewController
{


}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (m_user_ID_text == nil)
    {
        m_user_ID_text =  _m_user_ID;
    }
    _my_user_ID.text = [NSString stringWithFormat:@"%@%@", @"我的ID:", m_user_ID_text ];;
    
    //读取存入的数组 打印
    
   NSString *targetID = [[NSUserDefaults standardUserDefaults] objectForKey:@"targetID"];
    
    NSLog(@"%@",targetID);
    _target_user_ID.text = targetID;
    
}



/**
 * 响应 send_calling_button
 */
- (IBAction)send_calling_button:(id)sender {
    
    
    NSString *targetID = _target_user_ID.text;
    
    //存入数组并同步
    
    [[NSUserDefaults standardUserDefaults] setObject:targetID forKey:@"targetID"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    // 根据指定线的ID跳转到目标Vc
    [self performSegueWithIdentifier:@"sendValue" sender:self];
    
    
    //voipControllerView *m_voipControllerView = [[voipControllerView alloc] initWithName:VoIP_Type_Calling];

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // segue.identifier：获取连线的ID
    if ([segue.identifier isEqualToString:@"sendValue"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        voipControllerView *receive = segue.destinationViewController;
        receive.m_voipType = VoIP_Type_Calling;
        receive.m_userID = m_user_ID_text;
        receive.m_targetID = _target_user_ID.text;
    }
}

@end
