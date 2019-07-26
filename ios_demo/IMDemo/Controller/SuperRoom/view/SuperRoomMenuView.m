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
@property (weak, nonatomic) IBOutlet UIView *speechView;
@property (weak, nonatomic) IBOutlet UIView *textInputView;
@property (weak, nonatomic) IBOutlet UIButton *micButton;

@end
@implementation SuperRoomMenuView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.inputTextField.delegate = self;
    _mPrivateMsgTargetId = nil;
}


// 停止说话
- (IBAction)speechTouchInside:(UIButton *)sender {

    NSLog(@"stop mic");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuViewStopSpeech:)]) {
        [self.delegate SuperRoomMenuViewStopSpeech:self];
    }
}


// 按住说话
- (IBAction)speechTouchDown:(UIButton *)sender {
    NSLog(@"star mic");
    if (self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuViewStartSpeech:)]) {
        [self.delegate SuperRoomMenuViewStartSpeech:self];
    }
    
}

- (IBAction)sendButtonClicked:(UIButton *)sender {
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuView:sendText:toId:)]) {
        [self.delegate SuperRoomMenuView:self sendText:self.inputTextField.text toId:_mPrivateMsgTargetId];
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
    if ([self.inputTextField.text length] > 0 && self.delegate && [self.delegate respondsToSelector:@selector(SuperRoomMenuView:sendText:toId:)]) {
        [self.delegate SuperRoomMenuView:self sendText:self.inputTextField.text toId:_mPrivateMsgTargetId];
    }
    [textField resignFirstResponder];
    return YES;
}
@end
