//
//  SuperRoomMenuView.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRoomMenuView.h"
@interface SuperRoomMenuView ()<UITextFieldDelegate>
{

}

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *speechView;
@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UIButton *micButton;

@end
@implementation SuperRoomMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.inputTextField.delegate = self;
}


// 停止说话
- (IBAction)speechTouchInside:(UIButton *)sender {

    NSLog(@"speechTouchInside");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuViewStopSpeech:)]) {
        [self.delegate SuperRoomMenuViewStopSpeech:self];
    }
}


// 按住说话
- (IBAction)speechTouchDown:(UIButton *)sender {
    NSLog(@"speechTouchDown");
    if (self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuViewStartSpeech:)]) {
        [self.delegate SuperRoomMenuViewStartSpeech:self];
    }
    
}

- (IBAction)sendButtonClicked:(UIButton *)sender {
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuView:sendText:)]) {
        [self.delegate SuperRoomMenuView:self sendText:self.inputTextField.text];
    }
    [self.inputTextField resignFirstResponder];
    self.inputTextField.text = @"";
}
- (IBAction)switchButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textInputView.hidden = !sender.selected;
    self.speechView.hidden = sender.selected;
}



#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuView:sendText:)]) {
        [self.delegate SuperRoomMenuView:self sendText:self.inputTextField.text];
    }
    [textField resignFirstResponder];
    return YES;
}
@end
