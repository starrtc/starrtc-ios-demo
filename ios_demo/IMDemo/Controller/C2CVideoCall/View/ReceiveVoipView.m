//
//  ReceiveVoipView.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "ReceiveVoipView.h"

@interface ReceiveVoipView()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingInfoLabel;
@end

@implementation ReceiveVoipView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setupUserNickname:(NSString*)nickname isAudio:(BOOL)isAudio{
    self.nickNameLabel.text = nickname;
    self.headerImageView.image = [UIImage imageWithUserId:nickname];
    if(isAudio)
    {
        _waitingInfoLabel.text = @"邀请您进行语音通话";
    }
    else
    {
        _waitingInfoLabel.text = @"邀请您进行视频通话";
    }
}
- (IBAction)agreeButtonClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(receiveVoipViewDidAgree:)]){
        [_delegate receiveVoipViewDidAgree:self];
    }
}
- (IBAction)refuseButtonClicked:(UIButton *)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(receiveVoipViewDidRefuse:)]){
        [_delegate receiveVoipViewDidRefuse:self];
    }
}

@end
