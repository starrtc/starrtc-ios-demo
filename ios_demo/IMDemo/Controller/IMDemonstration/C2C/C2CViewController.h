//
//  ViewController.h
//  IMDemo
//
//  Created by  Admin on 2017/12/18.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "IFBaseVC.h"

@interface C2CViewController : IFBaseVC
@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *targetID;
@property (weak, nonatomic) IBOutlet UITextField *sendMsg;

@end

