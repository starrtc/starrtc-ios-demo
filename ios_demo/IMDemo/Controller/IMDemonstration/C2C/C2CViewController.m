	//
//  ViewController.m
//  IMDemo
//
//  Created by  Admin on 2017/12/18.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "C2CViewController.h"

#import "ChatRoomViewController.h"

#import "IFCreateSessionView.h"

@interface C2CViewController () <IFCreateSessionViewDelegate>
@end

@implementation C2CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createUI {
    self.title = @"创建新会话";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    __weak typeof(self) weakSelf = self;
    IFCreateSessionView *sessionView = [[IFCreateSessionView alloc] init];
    [self.view addSubview:sessionView];
    [sessionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(weakSelf.areaHeight + 15);
        make.leading.equalTo(weakSelf.view).offset(15);
        make.trailing.equalTo(weakSelf.view).offset(-15);
        make.bottom.equalTo(weakSelf.view).offset(-15);
    }];

    sessionView.alertTitle = @"请在下方输入对方用户名";
    sessionView.textFieldPlaceholder = @"对方名称";
    sessionView.funcBtnTitle = @"发起会话";
    sessionView.isHasControl = NO;
    sessionView.delegate = self;
}

#pragma mark - Event

#pragma mark - Delegate
- (void)sessionViewCreateBtnDidClicked:(NSString *)name {
    if (name.length == 0) {
        [self.view ilg_makeToast:@"请输入对方ID" position:ILGToastPositionCenter];
        return;
    }
    
    if (![[IMUserInfo shareInstance].c2cSessionList containsObject:name]) {
        [[IMUserInfo shareInstance].c2cSessionList insertObject:name atIndex:0];
    }
    
    ChatRoomViewController *vc = [[ChatRoomViewController alloc] init];
    vc.fromType = IFChatroomVCTypeFromC2C;
    vc.targetID = name;
    
    NSMutableArray *mutArr = self.navigationController.viewControllers.mutableCopy;
    [mutArr removeLastObject];
    [mutArr addObject:vc];
    [self.navigationController setViewControllers:mutArr animated:YES];
}

@end
