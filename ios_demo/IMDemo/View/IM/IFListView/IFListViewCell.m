//
//  IFListViewCell.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/20.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFListViewCell.h"

@implementation IFListViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UI

- (void)createUI {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.layer.masksToBounds = YES;
    bgImageView.layer.cornerRadius = 30;
    [self addSubview:bgImageView];
    _bgImageView = bgImageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 28;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:button];
    _iconBtn = button;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"000000"];
    label.font = [UIFont systemFontOfSize:18];
    [self addSubview:label];
    _topL = label;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor colorWithHexString:@"BDBDBD"];
    label2.font = [UIFont systemFontOfSize:20];
    label2.layer.masksToBounds = YES;
    label2.layer.cornerRadius = 4;
    [self addSubview:label2];
    _bottomL = label2;
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.textColor = [UIColor colorWithHexString:@"BDBDBD"];
    label3.font = [UIFont systemFontOfSize:16];
    [self addSubview:label3];
    _leftBottomL = label3;
    
    UILabel *label4 = [[UILabel alloc] init];
    label4.textColor = [UIColor colorWithHexString:@"BDBDBD"];
    label4.font = [UIFont systemFontOfSize:16];
    label4.text = @"直播中";
    label4.hidden = YES;
    [self addSubview:label4];
    _rightL = label4;
    
    __weak typeof(self) weakSelf = self;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(16);
        make.centerY.equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(weakSelf).offset(16);
//        make.centerY.equalTo(weakSelf);
        make.center.equalTo(bgImageView);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(button.mas_trailing).offset(18);
        make.top.equalTo(bgImageView).offset(0);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf).offset(-10);
        make.bottom.equalTo(bgImageView.mas_bottom).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(label);
        make.bottom.equalTo(bgImageView.mas_bottom).offset(0);
        make.trailing.lessThanOrEqualTo(label2.mas_leading).offset(5);
    }];
    
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgImageView).offset(0);
        make.trailing.equalTo(weakSelf).offset(-10);
    }];
}


#pragma mark - Event

- (void)buttonClick:(UIButton *)button {
    
}

@end
