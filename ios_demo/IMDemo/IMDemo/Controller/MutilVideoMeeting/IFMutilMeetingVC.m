//
//  IFMutilMeetingVC.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFMutilMeetingVC.h"

@interface IFMutilMeetingVC () <XHMeetingManagerDelegate>
@property (nonatomic, strong) NSMutableArray *videoViewArr;
@property (nonatomic, strong) UIView *videoContentView;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) NSMutableDictionary *videoViewDic;
@end

@implementation IFMutilMeetingVC {
    int showViewNum;
    IFMutilMeetingVCType _vcType;
}

- (instancetype)initWithType:(IFMutilMeetingVCType)type {
    self = [super init];
    if (self) {
        _vcType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.videoViewArr = [NSMutableArray array];
    self.videoViewDic = [NSMutableDictionary dictionary];

    [self createUI];
    __weak typeof(self) weakSelf = self;

    [[XHClient sharedClient].meetingManager addDelegate:self];
    
    if (_vcType == IFMutilMeetingVCTypeJoin) {
        
    }
    [[XHClient sharedClient].meetingManager joinMeeting:self.meetingId completion:^(NSError *error) {
        if (error) {
            [UIView ilg_makeToast:[NSString stringWithFormat:@"加入会议失败：%@", error.localizedDescription]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        } else {
            [weakSelf.view ilg_makeToast:[NSString stringWithFormat:@"加入会议成功"] position:ILGToastPositionCenter];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self setNavigationBarColor:[UIColor clearColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self setNavigationBarColor:[UIColor colorWithHexString:@"ff6c00"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}


#pragma mark - UI

- (void)createUI {
    self.title = [NSString stringWithFormat:@"会议名称：%@", self.meetingName];

    UIView *videoContentView = [[UIView alloc] init];
    [self.view insertSubview:videoContentView atIndex:0];
    _videoContentView = videoContentView;
    
    __weak typeof(self) weakSelf = self;
    // 多人会议布局
    [videoContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(ios 11, *)) {
//            make.top.equalTo(weakSelf.view.mas_safeAreaLayoutGuideTop);
//            make.bottom.equalTo(weakSelf.view.mas_safeAreaLayoutGuideBottom);
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        } else {
            make.top.equalTo(weakSelf.view);
            make.bottom.equalTo(weakSelf.view);
        }
        make.leading.equalTo(weakSelf.view);
        make.trailing.equalTo(weakSelf.view);
    }];
}

- (void)relayoutVideoViewsForMeeting {
    if (self.videoViewArr.count == 0) {
        [self.view ilg_makeToast:@"已经没有视频流窗口" position:ILGToastPositionCenter];
        return;
    } else if (self.videoViewArr.count > 7) {
        [self.view ilg_makeToast:@"已经达到上限七个视频流窗口" position:ILGToastPositionCenter];
        return;
    }
    
    UIView *superView = self.videoContentView;
    
    NSInteger viewCount = self.videoViewArr.count;
    CGFloat smallWidth = superView.width/3;
    CGFloat smallHeight = smallWidth/3*4;
    CGFloat bigHeight = superView.height - smallHeight*((viewCount - 1 + 2)/3);
    [self.videoViewArr[0] setFrame:CGRectMake(0, 0, superView.width, bigHeight)];
    [[XHClient sharedClient].meetingManager changeToBigPreview:self.videoViewArr[0]];
    
    for (NSInteger index = 1; index < viewCount; index++) {
        CGFloat x = (index - 1)%3 * smallWidth;
        CGFloat y = bigHeight + (index - 1)/3 * smallHeight;
        
        [self.videoViewArr[index] setFrame:CGRectMake(x, y, smallWidth, smallHeight)];
    }
    
    NSArray *colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor orangeColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor yellowColor]];
    for (int index = 0; index < self.videoViewArr.count; index++) {
        UIView *view = self.videoViewArr[index];
//        view.backgroundColor = colors[index];
    }
}


#pragma mark - Delegate
#pragma mark XHMeetingManagerDelegate
- (UIView *)onJoined:(NSString *)uid meeting:(NSString *)meetingID {
    if (self.videoViewArr.count >= 7) {
        [self.view ilg_makeToast:@"数目已达上限" position:ILGToastPositionCenter];
        return nil;
    }
    
    UIView *videoView = self.videoViewDic[uid];
    if (videoView) {
        [self.videoContentView insertSubview:videoView atIndex:0];
        [self.videoViewArr addObject:videoView];
        
    } else {
        videoView = [[UIView alloc] init];
//        videoView.clipsToBounds = YES;
        videoView.layer.masksToBounds = YES;
        videoView.layer.cornerRadius = 12;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesClicked:)];
        [videoView addGestureRecognizer:tapGes];
        
        [self.videoContentView insertSubview:videoView atIndex:0];
        [self.videoViewArr addObject:videoView];
        [self.videoViewDic setObject:videoView forKey:uid];
    }

    [self relayoutVideoViewsForMeeting];
    
    return videoView;
}

- (void)onLeft:(NSString *)uid meeting:(NSString *)meetingID {
    if (self.videoViewArr.count == 0) {
        [self.view ilg_makeToast:@"数目已为零" position:ILGToastPositionCenter];
        return;
    }
    
    UIView *view = self.videoViewDic[uid];
    [view removeFromSuperview];
    [self.videoViewArr removeObject:view];
//    [self.videoViewDic removeObjectForKey:uid];

    if (self.videoViewArr.count != 0) {
        [self relayoutVideoViewsForMeeting];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - Event

- (void)leftButtonClicked:(UIButton *)button {
    [[XHClient sharedClient].meetingManager leaveMeeting:self.meetingId completion:^(NSError *error) {
        
    }];
    [super leftButtonClicked:button];
}

- (void)tapGesClicked:(UIGestureRecognizer *)ges {
    UIView *targetView = ges.view;
    
    UIView *bigView = self.videoViewArr[0];
    if (targetView == bigView || self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    CGRect bigFrame = bigView.frame;
    
    [UIView animateWithDuration:0.25 animations:^{
        bigView.frame = targetView.frame;
        targetView.frame = bigFrame;
    } completion:^(BOOL finished) {
        [[XHClient sharedClient].meetingManager changeToBigPreview:targetView];
        [[XHClient sharedClient].meetingManager changeToSmall:bigView];
        NSInteger targetIndex = [self.videoViewArr indexOfObject:targetView];
        [self.videoViewArr exchangeObjectAtIndex:0 withObjectAtIndex:targetIndex];
        _isAnimating = NO;
    }];
}


#pragma mark - Other

@end
