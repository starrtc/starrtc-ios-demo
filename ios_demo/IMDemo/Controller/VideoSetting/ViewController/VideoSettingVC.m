//
//  VideoSettingVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/18.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VideoSettingVC.h"
#import "VideoSetParameters.h"
#import "VideoTestSpeedVC.h"
#import "AboutUsVC.h"
#import "CircleTestVC.h"
#import "QGSandboxViewerVC.h"
#import "SystemSettingVC.h"

#import "IFInnerHomeVC.h"

typedef NS_ENUM(NSUInteger, IFVideoSettingType) {
    IFVideoSettingTypeServerConfig = 1001,
    IFVideoSettingTypeLoopTest = 1002,
    IFVideoSettingTypeThirdStreamTest = 1003,
    IFVideoSettingTypeInnerTest = 1004, //内网直连测试
    IFVideoSettingTypeResolutionSet = 1007, //分辨率设置
    IFVideoSettingTypeBigPictureSet = 1008, //大图帧率码率设置
    IFVideoSettingTypeSmallPictureSet = 1009, //小图帧率码率设置
    IFVideoSettingTypeVideoEncodeSet = 1010, //视频编码设置
    IFVideoSettingTypeAudioEncodeSet = 1011, //音频编码设置
    IFVideoSettingTypeUploadLog = 1020, //上传日志
    IFVideoSettingTypeAbout = 1021, //关于
    
};

@interface VideoSettingVC ()
{
    VideoSetParameters * _videoSetParameters;
}

@property (nonatomic, strong) UIAlertController *corpAlertController;

@property (weak, nonatomic) IBOutlet UISwitch *hwEncodeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openGLSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *corpSetButton;

@property (weak, nonatomic) IBOutlet UISwitch *audioEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *videoEnableSwitch;
@property (weak, nonatomic) IBOutlet UILabel *resolutionL;
@property (weak, nonatomic) IBOutlet UILabel *bigPictureFrameAndBitL;
@property (weak, nonatomic) IBOutlet UILabel *smallPictureFrameAndBitL;
@property (weak, nonatomic) IBOutlet UILabel *videoEncodeFormL;
@property (weak, nonatomic) IBOutlet UILabel *audioEncodeFormL;
@property (weak, nonatomic) IBOutlet UISwitch *autoAdjustFrameAndBitSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *hardEncodeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openGLEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openSLEnableSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *voipP2PModelSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *audioHandleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *lowLevelAECHandleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *logEnableSwitch;


@end

@implementation VideoSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    UITapGestureRecognizer *logTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleLogTap:)];
    logTapGesture.numberOfTapsRequired =3;
    logTapGesture.numberOfTouchesRequired =1;
    [self.view addGestureRecognizer:logTapGesture];
    // Do any additional setup after loading the view from its nib.
    if ([UIDevice currentDevice].systemVersion.doubleValue < 11.0) {
        self.top.constant = 64;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setupVideoDefaultParameters];
}

- (void)leftButtonClicked:(UIButton *)button{
    [super leftButtonClicked:button];
    [_videoSetParameters saveParametersToLocal];
    [[XHClient sharedClient] setVideoConfig:_videoSetParameters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UI
- (UIAlertController *)corpAlertController {
    if (!_corpAlertController) {
        _corpAlertController = [UIAlertController alertControllerWithTitle:@"设置分辨率" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_88SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_88SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_120SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_120SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_120SW_120SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_120SW_120SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction6 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_240SW_240SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_240SW_240SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction7 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction8 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_90SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_90SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction9 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_180SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_180SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction10 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction11 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_120SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_120SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction12 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_240SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_240SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction13 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction14 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_160SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_160SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction15 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_320SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_320SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction16 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction17 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_90SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_90SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction18 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_180SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_180SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction19 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_360SW_640SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_360SW_640SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction20 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction21 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_135SW_240SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_135SW_240SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction22 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_270SW_480SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_270SW_480SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction23 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_540SW_960SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_540SW_960SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction24 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        
        [_corpAlertController addAction:alertAction];
        [_corpAlertController addAction:alertAction0];
        [_corpAlertController addAction:alertAction1];
        [_corpAlertController addAction:alertAction2];
        [_corpAlertController addAction:alertAction3];
        [_corpAlertController addAction:alertAction4];
        [_corpAlertController addAction:alertAction5];
        [_corpAlertController addAction:alertAction6];
        [_corpAlertController addAction:alertAction7];
        [_corpAlertController addAction:alertAction8];
        [_corpAlertController addAction:alertAction9];
        [_corpAlertController addAction:alertAction10];
        [_corpAlertController addAction:alertAction11];
        [_corpAlertController addAction:alertAction12];
        [_corpAlertController addAction:alertAction13];
        [_corpAlertController addAction:alertAction14];
        [_corpAlertController addAction:alertAction15];
        [_corpAlertController addAction:alertAction16];
        [_corpAlertController addAction:alertAction17];
        [_corpAlertController addAction:alertAction18];
        [_corpAlertController addAction:alertAction19];
        [_corpAlertController addAction:alertAction20];
        [_corpAlertController addAction:alertAction21];
        [_corpAlertController addAction:alertAction22];
        [_corpAlertController addAction:alertAction23];
        [_corpAlertController addAction:alertAction24];
    }
    return _corpAlertController;
}


#pragma mark - deledate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 0;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (cell.tag) {
        case IFVideoSettingTypeServerConfig:
            [self handleEventForServerSet];
            break;
        case IFVideoSettingTypeLoopTest:
            [self handleEventForLoopTest];
            break;
        case IFVideoSettingTypeThirdStreamTest:
            [self handleEventForThirdStreamTest];
            break;
        case IFVideoSettingTypeInnerTest:
            [self handleEventForInnerTest];
            break;
        case IFVideoSettingTypeResolutionSet:
            [self handleEventForResolutionSet];
            break;
        case IFVideoSettingTypeBigPictureSet:
            [self handleEventForBiPictureSet];
            break;
        case IFVideoSettingTypeSmallPictureSet:
            [self handleEventForSmallPictureSet];
            break;
        case IFVideoSettingTypeVideoEncodeSet:
            [self handleEventForVideoEncodeSet];
            break;
        case IFVideoSettingTypeAudioEncodeSet:
            [self handleEventForAudioEncodeSet];
            break;
        case IFVideoSettingTypeUploadLog:
            [self handleEventForUploadLog];
            break;
        case IFVideoSettingTypeAbout:
            [self handleEventForAbout];
            break;
        default:
            break;
    }
}


#pragma mark - event

- (IBAction)serverSetBtnClicked:(id)sender {
    [self handleEventForServerSet];
}
- (void)handleEventForServerSet
{
    SystemSettingVC *system = [[SystemSettingVC alloc] initWithNibName:@"SystemSettingVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:system animated:YES];
}

- (void)handleEventForLoopTest
{
    CircleTestVC *vc = [[CircleTestVC alloc] initWithNibName:@"CircleTestVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleEventForThirdStreamTest
{
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (void)handleEventForInnerTest
{
    IFInnerHomeVC *vc = [[IFInnerHomeVC alloc] initWithNibName:NSStringFromClass([IFInnerHomeVC class]) bundle:[NSBundle mainBundle]];
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)handleEventForResolutionSet
{
    [self presentViewController:self.corpAlertController animated:YES completion:nil];
}

- (void)handleEventForBiPictureSet
{
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (void)handleEventForSmallPictureSet
{
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (void)handleEventForVideoEncodeSet
{
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (void)handleEventForAudioEncodeSet
{
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (void)handleEventForUploadLog
{
    QGSandboxViewerVC *vc = [[QGSandboxViewerVC alloc] initWithHomeDirectory];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleEventForAbout
{
    AboutUsVC *vc = [AboutUsVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)audioEnable:(UISwitch *)sender {
    [AppConfig shareConfig].audioEnabled = !sender.isOn;
}

- (IBAction)videoEnabled:(UISwitch *)sender {
    [AppConfig shareConfig].videoEnabled = !sender.isOn;
}

- (IBAction)autoAdjustFrameAndBit:(UISwitch *)sender {
    _videoSetParameters.dynamicBitrateAndFPSEnable = sender.on;
}

- (IBAction)hardEncode:(UISwitch *)sender {
    _videoSetParameters.hwEncodeEnable = sender.isOn;
}

- (IBAction)openGL:(UISwitch *)sender {
    _videoSetParameters.openGLEnable = sender.isOn;
}

- (IBAction)switchForOpenSL:(UISwitch *)sender {
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (IBAction)switchForVoipP2P:(UISwitch *)sender {
    _videoSetParameters.voipP2PEnable = sender.on;
}

- (IBAction)switchForAudioHandle:(UISwitch *)sender {
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (IBAction)switchForLowAECHandle:(UISwitch *)sender {
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}

- (IBAction)switchForLogWindow:(UISwitch *)sender {
    [self.view ilg_makeToast:@"暂未实现" position:ILGToastPositionBottom];
}


#pragma mark - other

- (void)setupVideoDefaultParameters {
    _videoSetParameters = [VideoSetParameters locaParameters];
    
    [self.audioEnableSwitch setOn:!_videoSetParameters.audioEnable];
    [self.videoEnableSwitch setOn:!_videoSetParameters.videoEnable];
    
    self.resolutionL.text = _videoSetParameters.currentResolutionText;
    self.bigPictureFrameAndBitL.text = @"";
    self.smallPictureFrameAndBitL.text = @"";
    self.videoEncodeFormL.text = @"";
    self.audioEncodeFormL.text = @"";
    
    [self.autoAdjustFrameAndBitSwitch setOn:_videoSetParameters.dynamicBitrateAndFPSEnable];
    [self.hardEncodeSwitch setOn:_videoSetParameters.hwEncodeEnable];
    [self.openGLSwitch setOn:_videoSetParameters.openGLEnable animated:NO];
    [self.openSLEnableSwitch setOn:NO animated:NO];
    [self.voipP2PModelSwitch setOn:_videoSetParameters.voipP2PEnable];
    [self.audioHandleSwitch setOn:NO];
    [self.lowLevelAECHandleSwitch setOn:NO];
    
    [self.logEnableSwitch setOn:YES];
}

@end
