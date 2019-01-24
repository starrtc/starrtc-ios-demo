//
//  IFGroupMemberCell.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/24.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFGroupMemberCell.h"

@interface IFGroupMemberCell ()
@property (nonatomic, strong) UIImageView *iconIV;
@property (nonatomic, strong) UILabel *label;
@end

@implementation IFGroupMemberCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _label.text = nil;
}

#pragma mark - UI

- (void)createUI {
    UIImageView *iconIV = [[UIImageView alloc] init];
    _iconIV = iconIV;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithHexString:@"888888"];
    label.font = [UIFont systemFontOfSize:13];
    _label = label;
    
    [self.contentView addSubview:iconIV];
    [self.contentView addSubview:label];
    
    __weak typeof(self) weakSelf = self;
    [iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.leading.equalTo(weakSelf.contentView);
        make.trailing.equalTo(weakSelf.contentView);
        make.width.equalTo(iconIV.mas_height).multipliedBy(1);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconIV.mas_bottom).offset(7);
        make.leading.equalTo(weakSelf.contentView);
        make.trailing.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
    }];
}

@end
