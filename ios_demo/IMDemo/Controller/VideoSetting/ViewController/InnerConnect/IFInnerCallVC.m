//
//  IFInnerCallVC.m
//  IMDemo
//
//  Created by HappyWork on 2019/2/20.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "IFInnerCallVC.h"

@interface IFInnerCallVC () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;

@end

@implementation IFInnerCallVC

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createIU];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


#pragma mark - UI
- (void)createIU {
    self.ipTextField.delegate = self;
    self.ipTextField.enablesReturnKeyAutomatically = YES;
    self.ipTextField.returnKeyType = UIReturnKeyContinue;
}


#pragma mark - event

- (IBAction)backBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.ipTextField.text.length == 0) {
        [UIView ilg_makeToast:@"清输入其它端IP地址"];
        return NO;
    }
    
    [self.ipTextField resignFirstResponder];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IFInnerStartCallNotif" object:@{@"ipStr":self.ipTextField.text}];

    return YES;
}


@end
