//
//  SpeechChatListCell.m
//  IMDemo
//
//  Created by 韩肖杰 on 2019/1/14.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "SuperRomListCell.h"
@interface SuperRoomListCell()

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@end
@implementation SuperRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setupCellData:(SuperRoomModel* _Nullable)data{
    if (data) {
        self.headerImageView.image = [UIImage imageWithUserId:data.Creator];
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@",data.Name];
    } else {
        self.nicknameLabel.text = @"";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
