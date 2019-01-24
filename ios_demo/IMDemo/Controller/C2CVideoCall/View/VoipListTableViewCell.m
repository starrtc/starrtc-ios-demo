//
//  VoipListTableViewCell.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/18.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VoipListTableViewCell.h"

@interface VoipListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;


@end

@implementation VoipListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void) setupCellData:(NSDictionary*)data{
    self.nickNameLabel.text = [data objectForKey:@"userId"];
    self.headerImageView.image = [UIImage imageWithUserId:[data objectForKey:@"userId"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
