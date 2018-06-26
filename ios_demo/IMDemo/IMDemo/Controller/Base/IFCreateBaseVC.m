//
//  IFCreateBaseVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFCreateBaseVC.h"

@interface IFCreateBaseVC ()

@end

@implementation IFCreateBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBaseUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createBaseUI {
    __weak typeof(self) weakSelf = self;
    IFCreateSessionView *sessionView = [[IFCreateSessionView alloc] init];
    [self.view addSubview:sessionView];
    [sessionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(weakSelf.areaHeight + 15);
        make.leading.equalTo(weakSelf.view).offset(15);
        make.trailing.equalTo(weakSelf.view).offset(-15);
        make.bottom.equalTo(weakSelf.view).offset(-15);
    }];
    
    sessionView.delegate = self;
    _sessionView = sessionView;
    
    
//    UITextField *textField = [[UITextField alloc] init];
//    textField.placeholder = @"输入群组名称";
//    textField.backgroundColor = [UIColor whiteColor];
//    textField.layer.masksToBounds = YES;
//    textField.layer.cornerRadius = 8;
//    self.textField = textField;
//
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:16];
//    button.backgroundColor = [UIColor greenColor];
//    button.layer.masksToBounds = YES;
//    button.layer.cornerRadius = 8;
//    [button setTitle:@"创建" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(createButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.button = button;
//
//    [self.view addSubview:textField];
//    [self.view addSubview:button];
//
//    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).offset(weakSelf.areaHeight + 10);
//        make.leading.equalTo(weakSelf.view).offset(20);
//        make.trailing.equalTo(weakSelf.view).offset(-20);
//        make.height.mas_equalTo(40);
//    }];
//
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(textField);
//        make.width.equalTo(textField);
//        make.height.equalTo(textField);
//        make.top.equalTo(textField.mas_bottom).offset(16);
//    }];
}

#pragma mark - Event
- (void)createButtonClicked:(UIButton *)button {
    
}

@end
