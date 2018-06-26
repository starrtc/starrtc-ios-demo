//
//  IFListView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFListView.h"

@interface IFListView ()
@property (nonatomic, weak) id<UITableViewDelegate, UITableViewDataSource> delegate;

@end

@implementation IFListView

- (instancetype)initWithDelegate:(id)delegate frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;

        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_button setMulColor:@[(id)[UIColor colorWithHexString:@"FF6000"].CGColor, (id)[UIColor colorWithHexString:@"FFA414"].CGColor] startPoint:@[@0.0, @0.75]];
}

#pragma mark - UI

- (void)createUI {
    //初始化tableview
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, 380, 200)];
    [tableView setDelegate:_delegate];
    [tableView setDataSource:_delegate];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorInset = UIEdgeInsetsMake(0, 14, 0, 18);
    tableView.separatorColor = [UIColor lightGrayColor];
    tableView.tableFooterView = [UIView new];
    _tableView = tableView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    button.backgroundColor = [UIColor redColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 25;
    _button = button;

    [self addSubview:tableView];
    [self addSubview:button];
    
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.leading.equalTo(weakSelf).offset(20);
        make.trailing.equalTo(weakSelf).offset(-20);
        make.height.mas_offset(50);
        make.bottom.equalTo(weakSelf).offset(-20);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.leading.equalTo(weakSelf).offset(0);
        make.trailing.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(button.mas_top).offset(-20);
    }];
}


#pragma mark - Event


#pragma mark - Other


@end
