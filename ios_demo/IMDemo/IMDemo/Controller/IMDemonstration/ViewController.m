//
//  ViewController.m
//  IMDemo
//
//  Created by  Admin on 2017/12/26.
//  Copyright © 2017年  Admin. All rights reserved.
//

#import "ViewController.h"

#import "IFC2CSessionListVC.h"
#import "ChatRoomListViewController.h"
#import "MessageGroupListViewController.h"

#import "IMMsgManager.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView *msgAlertIV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"IM";
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatMessageDidReceive:) name:IMChatMsgReceiveNotif object:nil];
    
    int unReadNum = [[IMMsgManager sharedInstance] unReadNumForSessionList];
    if (unReadNum) {
        self.msgAlertIV.hidden = NO;
    } else {
        self.msgAlertIV.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IMChatMsgReceiveNotif object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI

- (void)addLineToButton:(UIButton *)lineButton {
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = [UIColor redColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:lineButton.bounds cornerRadius:5];
    
    //设置路径
    border.path = path.CGPath;
    
    border.frame = lineButton.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    
    lineButton.layer.cornerRadius = 5.f;
    lineButton.layer.masksToBounds = YES;
    
    [lineButton.layer addSublayer:border];
}

- (void)createUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"一对一" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 8;
    [button addTarget:self action:@selector(C2CButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chatroomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatroomBtn setTitle:@"聊天室" forState:UIControlStateNormal];
    [chatroomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    chatroomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    chatroomBtn.layer.masksToBounds = YES;
    chatroomBtn.layer.cornerRadius = 8;
    [chatroomBtn addTarget:self action:@selector(chatroomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [groupBtn setTitle:@"群组" forState:UIControlStateNormal];
    [groupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    groupBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    groupBtn.layer.masksToBounds = YES;
    groupBtn.layer.cornerRadius = 8;
    [groupBtn addTarget:self action:@selector(groupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *msgAlertIV = [[UIImageView alloc] init];
    msgAlertIV.image = [UIImage imageNamed:@"new_msg_alert"];
    msgAlertIV.hidden = YES;
    self.msgAlertIV = msgAlertIV;
    
    [self.view addSubview:button];
    [self.view addSubview:chatroomBtn];
    [self.view addSubview:groupBtn];
    [self.view addSubview:msgAlertIV];
    
    [button setImage:[UIImage imageNamed:@"im_mainPage_c2c"] forState:UIControlStateNormal];
    [chatroomBtn setImage:[UIImage imageNamed:@"im_mainPage_chatroom"] forState:UIControlStateNormal];
    [groupBtn setImage:[UIImage imageNamed:@"im_mainPage_group"] forState:UIControlStateNormal];
    
    CGSize imageSize = [UIImage imageNamed:@"im_mainPage_c2c"].size;
    
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(weakSelf.areaHeight + 15);
        make.centerX.equalTo(weakSelf.view);
        make.leading.equalTo(weakSelf.view).offset(15);
        make.trailing.equalTo(weakSelf.view).offset(-15);
        make.height.mas_equalTo(self.view.width*(imageSize.height/imageSize.width));
    }];
    
    [chatroomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(button);
        make.leading.equalTo(button);
        make.trailing.equalTo(button);
    }];
    
    [groupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(chatroomBtn.mas_bottom).offset(15);
        make.centerX.equalTo(weakSelf.view);
        make.height.equalTo(button);
        make.leading.equalTo(button);
        make.trailing.equalTo(button);
    }];
    
    [msgAlertIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button);
        make.trailing.equalTo(button);
    }];
    
    [self.view layoutIfNeeded];
//    [self addLineToButton:button];

}


#pragma mark - Event

- (void)C2CButtonClicked:(UIButton *)button {
    IFC2CSessionListVC *vc = [[IFC2CSessionListVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatroomButtonClicked:(UIButton *)button {
    ChatRoomListViewController *vc = [[ChatRoomListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)groupButtonClicked:(UIButton *)button {
    [UIView ilg_makeToast:@"Coming soon..."];
    return;
    
    MessageGroupListViewController *vc = [[MessageGroupListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatMessageDidReceive:(NSNotification *)notif {
    NSDictionary *dic = notif.object;
    NSString *uid = dic[@"uid"];
    
    if (![[IMMsgManager sharedInstance].sessionIDForChating isEqualToString:uid]) {
        self.msgAlertIV.hidden = NO;
    }
}

@end
