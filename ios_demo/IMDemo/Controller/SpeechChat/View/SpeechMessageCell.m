//
//  SpeechMessageCell.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/16.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechMessageCell.h"
@interface SpeechMessageCell()
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation SpeechMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(SpeechMessageModel* _Nullable)data{
    if (data && [data isKindOfClass:[SpeechMessageModel class]]) {
        self.nicknameLabel.text = data.nickname;
        self.contentLabel.text = data.content;
        self.contentView.hidden = NO;
    } else {
        self.contentView.hidden = YES;
        self.nicknameLabel.text = @"";
        self.contentLabel.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
