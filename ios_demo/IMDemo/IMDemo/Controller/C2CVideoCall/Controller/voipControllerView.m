//
//  voipView.m
//  sdk_UI_work
//
//  Created by  Admin on 2017/9/21.
//  Copyright © 2017年 ndp_001_Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "voipControllerView.h"


@implementation voipControllerView
{
    
    

}



////自定义初始化方法，必须以init开头
//- (id)initWithName:(int)voipType
//{
//    //调用父类的初始化方法
//    self = [super init];
//
//    
//    
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"InfoNotification" object:nil];
    

    BOOL isCaller = false;
   // 主叫 隐藏挂断按钮
    if( _m_voipType == VoIP_Type_Calling)
    {
        isCaller = true;
    }
    else // 被叫
    {
        isCaller = false;
    }
    
   
    
    

}

// 2.实现收到通知触发的方法

- (void)InfoNotificationAction:(NSNotification *)notification{
    NSLog(@"voip controller view---接收到通知---");
    NSLog(@"%@",notification.userInfo);
    
    NSString *recvEvent = [notification.userInfo objectForKey:@"voipEvent"];
    
    if([recvEvent isEqualToString:@"onHangup"])
    {
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"end \n");
        
            }];
    }
    

    
}



-(void)showCallingView
{
    _pickup_button.hidden = YES;
    _hanoff_button.hidden = NO;
    _called_hangoff_button.hidden = YES;
}

-(void)showRingView
{
    _pickup_button.hidden = NO;
    _hanoff_button.hidden = YES;
    _called_hangoff_button.hidden = NO;
}
- (IBAction)pickup_button_clicked:(id)sender {
    
   
    _pickup_button.hidden = YES;
    _hanoff_button.hidden = NO;
    _called_hangoff_button.hidden = YES;
    
    
}

/**
 * 响应 拒接按钮
 */
- (IBAction)calling_hanoff_button_clicked:(id)sender {
    
}

- (IBAction)hangoff_button_clicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"hangoff_button_clicked end \n");
    }];
  
}


/**
 * 收到挂断电话 代理函数
 */
-(void)onHangup;
{

    
    
//    [self dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"end \n");
    
//    }];
}



@end
