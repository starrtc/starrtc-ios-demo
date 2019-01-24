//
//  IFVideoListCell.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFVideoListCell.h"

@interface IFVideoListCell ()
@property(nonatomic, strong) UIImageView *coverIV;
@property(nonatomic, strong) UIImageView *iconIV;
@property(nonatomic, strong) UILabel *signLabel;
@property(nonatomic, strong) UILabel *nickLabel;
@end

@implementation IFVideoListCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

#pragma mark - UI

- (void)createUI {
    UIImageView *coverIV = [[UIImageView alloc] init];
    coverIV.layer.masksToBounds = YES;
    coverIV.layer.cornerRadius = 6;
    _coverIV = coverIV;
    
    UIImageView *iconIV = [[UIImageView alloc] init];
    _iconIV = iconIV;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"FFFFFf"];
    label.font = [UIFont systemFontOfSize:16];
    _signLabel = label;
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor colorWithHexString:@"FFFFFf"];
    label2.font = [UIFont systemFontOfSize:12];
    _nickLabel = label2;
    
    [self.contentView addSubview:coverIV];
    [self.contentView addSubview:label];
    [self.contentView addSubview:iconIV];
    [self.contentView addSubview:label2];
    
    
    __weak typeof(self) weakSelf = self;
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.contentView).offset(9);
        make.bottom.equalTo(weakSelf.contentView).offset(-9);
        make.width.mas_equalTo(24).multipliedBy(weakSelf.contentView.width/178.0);
        make.height.equalTo(iconIV.mas_width);
    }];
    
    [coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.leading.equalTo(weakSelf.contentView);
        make.trailing.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
    
    [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconIV);
        make.bottom.equalTo(iconIV.mas_top).offset(-10);
        make.trailing.lessThanOrEqualTo(weakSelf.contentView).offset(-10);
    }];
    
    [_nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_iconIV.mas_trailing).offset(8);
        make.centerY.equalTo(iconIV);
        make.trailing.greaterThanOrEqualTo(weakSelf.contentView).offset(-10);
    }];
}
@end
