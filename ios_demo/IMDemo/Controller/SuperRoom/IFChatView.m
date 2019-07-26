//
//  IFChatView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFChatView.h"

@interface IFChatView ()
@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) UIButton *button;
@end

@implementation IFChatView

- (instancetype)initWithDelegate:(id<UITableViewDelegate, UITableViewDataSource, IFChatViewDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        [self createUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_micButton setMulColor:@[(id)[UIColor colorWithHexString:@"FF6000"].CGColor, (id)[UIColor colorWithHexString:@"FFA414"].CGColor] startPoint:@[@0.0, @0.75]];
    [_button setMulColor:@[(id)[UIColor colorWithHexString:@"FF6000"].CGColor, (id)[UIColor colorWithHexString:@"FFA414"].CGColor] startPoint:@[@0.0, @0.75]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UI

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = _delegate;
    tableView.dataSource = _delegate;
    tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    tableView.separatorInset = UIEdgeInsetsMake(0, 14, 0, 18);
//    tableView.separatorColor = [UIColor darkGrayColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableFooterView = [UIView new];
    tableView.layer.masksToBounds = YES;
    tableView.layer.cornerRadius = 8;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView = tableView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"请输入内容...";
    textField.backgroundColor = [UIColor colorWithHexString:@"F2F2F2"];
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 20;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    _textField = textField;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 5)];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 20;
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;
    _button = button;
    
    UIButton *micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [micBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    micBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    micBtn.layer.masksToBounds = YES;
    micBtn.layer.cornerRadius = 20;
    [micBtn setTitle:@"上麦" forState:UIControlStateNormal];
    [micBtn setTitle:@"下麦" forState:UIControlStateSelected];
//    [micBtn addTarget:self action:@selector(micBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    micBtn.hidden = YES;
    _micButton = micBtn;
    
    [self addSubview:tableView];
    [self addSubview:textField];
    [self addSubview:button];
    [self addSubview:micBtn];
    
    __weak typeof(self) weakSelf = self;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf).offset(-15);
        make.bottom.equalTo(weakSelf).offset(-5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(75);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(15);
        make.bottom.equalTo(button);
        make.height.equalTo(button);
        make.trailing.equalTo(button.mas_leading).offset(-15);
    }];
    
    [micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button.mas_top).offset(-5);
        make.trailing.equalTo(button).offset(0);
        make.width.mas_equalTo(button);
        make.height.mas_equalTo(button);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(0);
        make.leading.equalTo(weakSelf).offset(0);
        make.trailing.equalTo(weakSelf).offset(0);
        make.bottom.equalTo(button.mas_top).offset(-5);
    }];
}


#pragma mark - Event

- (void)buttonClicked:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(chatViewDidSendText:)]) {
        [_delegate chatViewDidSendText:self.textField.text];
    }
    
    self.textField.text = nil;
    self.button.enabled = NO;
}

//- (void)micBtnClicked:(UIButton *)button {
//    button.selected = !button.selected;
//    
//}

- (void)textFieldTextDidChanged:(NSNotification *)notif {
    if (self.textField.text.length == 0) {
        self.button.enabled = NO;
    } else {
        self.button.enabled = YES;
    }
}

#pragma mark - other


@end
