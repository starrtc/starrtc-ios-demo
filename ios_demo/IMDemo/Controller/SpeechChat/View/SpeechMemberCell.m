//
//  SpeechMemberCell.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/15.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SpeechMemberCell.h"
@interface SpeechMemberCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

@end
@implementation SpeechMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(SpeechMemberModel*)data{
    if (data) {
        self.headerImageView.image = [UIImage imageWithUserId:data.uid];
        self.nicknameLabel.text = data.uid;
    } else {
        self.headerImageView.image = [UIImage imageNamed:@"icon_add_more"];
        self.nicknameLabel.text = @"";
    }
}
@end
