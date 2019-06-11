//
//  CallingVoipView.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/19.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "CallingVoipView.h"

@interface CallingVoipView ()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitingInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation CallingVoipView

- (void)setupUserNickname:(NSString*)nickname isAudio:(BOOL)isAudio{
    self.nickNameLabel.text = nickname;
    self.headerImageView.image = [UIImage imageWithUserId:nickname];
    if(isAudio)
    {
        _waitingInfoLabel.text = @"正在等待对方接受语音通话...";
    }
    else
    {
        _waitingInfoLabel.text = @"正在等待对方接受视频通话...";
    }
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    
    if(_delegate && [_delegate respondsToSelector:@selector(callingVoipViewDidCancel:)]){
        [_delegate callingVoipViewDidCancel:self];
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
@end
