//
//  SpeechChatMenuView.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechChatMenuView.h"
@interface SpeechChatMenuView ()<UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UIButton *switchButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *speechView;
@property (weak, nonatomic) IBOutlet UIView *textInputView;

@end
@implementation SpeechChatMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.inputTextField.delegate = self;
}

- (IBAction)speechTouchInside:(UIButton *)sender {
    NSLog(@"speechTouchInside");
    if (self.delegate && [self.delegate respondsToSelector:@selector(speechChatMenuViewStopSpeech:)]) {
        [self.delegate speechChatMenuViewStopSpeech:self];
    }
}
- (IBAction)speechTouchDown:(UIButton *)sender {
    NSLog(@"speechTouchDown");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(speechChatMenuViewStartSpeech:)]) {
        [self.delegate speechChatMenuViewStartSpeech:self];
    }
}

- (IBAction)sendButtonClicked:(UIButton *)sender {
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(speechChatMenuView:sendText:)]) {
        [self.delegate speechChatMenuView:self sendText:self.inputTextField.text];
    }
    [self.inputTextField resignFirstResponder];
    self.inputTextField.text = @"";
}
- (IBAction)switchButtonClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.textInputView.hidden = !sender.selected;
    self.speechView.hidden = sender.selected;
}

-(void)hiddenAudioButton
{
   dispatch_async(dispatch_get_main_queue(), ^{
    self.textInputView.hidden = NO;
    self.speechView.hidden = YES;
    self.switchButton.hidden = YES;
    });
}

-(void)showAudioButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
    self.textInputView.hidden = YES;
    self.speechView.hidden = NO;
    self.switchButton.hidden = NO;
    });
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(speechChatMenuView:sendText:)]) {
        [self.delegate speechChatMenuView:self sendText:self.inputTextField.text];
    }
    [textField resignFirstResponder];
    return YES;
}
@end
