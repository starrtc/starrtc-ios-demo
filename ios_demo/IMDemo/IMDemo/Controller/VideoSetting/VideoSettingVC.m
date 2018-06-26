//
//  VideoSettingVC.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VideoSettingVC.h"
#import "VideoSetParameters.h"
@interface VideoSettingVC ()

{
    VideoSetParameters * videoSetParameters;
    StarManagerModel *m_starManagerModel;
}
@property (weak, nonatomic) IBOutlet UIButton *openNLButton;
@property (weak, nonatomic) IBOutlet UIButton *fpsButton;
@property (weak, nonatomic) IBOutlet UIButton *openGLButton;
@property (weak, nonatomic) IBOutlet UIButton *hwEncodeButton;
@property (nonatomic, strong) UIAlertController *pixSheetVC;

@end

@implementation VideoSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    m_starManagerModel = [StarManagerModel shareInstance];
    videoSetParameters = [[VideoSetParameters alloc] initWithLocaParameters];
    [self setUIDefaultParameters];
    

}

- (void)setUIDefaultParameters {
    self.openGLButton.selected = videoSetParameters.openGLEnable;
    self.hwEncodeButton.selected = videoSetParameters.hwDecodeEnable;
    self.openNLButton.selected = videoSetParameters.openNLEnable;
}

- (void)setVideoParameters
{
    [m_starManagerModel setCropTypenum:videoSetParameters.resolution];
    [m_starManagerModel setOpenGLESEnable:videoSetParameters.openGLEnable];
    [m_starManagerModel setHardEncode:videoSetParameters.hwDecodeEnable];
}

- (UIAlertController*)pixSheetVC {
    if (!_pixSheetVC) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择分辨率" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:@"大图:368*640|小图:无" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE;
        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"大图:720*1280|小图:无" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE;
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"大图:368*640|小图:240*320" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_240SW_320SH;
        }];
        UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:@"大图:720*1280|小图:240*320" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH;
        }];
        
        UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:@"大图:368*640|小图:320*320" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_320SW_320SH;
        }];
        UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:@"大图:720*1280|小图:320*320" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE;
        }];
        
        UIAlertAction *alertAction6 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH;
        }];
        
        [alert addAction:alertAction0];
        [alert addAction:alertAction1];
        [alert addAction:alertAction2];
        [alert addAction:alertAction3];
        [alert addAction:alertAction4];
        [alert addAction:alertAction5];
        [alert addAction:alertAction6];
        _pixSheetVC = alert;
    }
    return _pixSheetVC;
}
- (IBAction)openGLButtonClicked:(UIButton *)sender {
    
    sender.selected = !videoSetParameters.openGLEnable;
    videoSetParameters.openGLEnable = sender.selected;
    
}
- (IBAction)openNLButtonClicked:(UIButton *)sender {
    
    sender.selected = !videoSetParameters.openNLEnable;
    videoSetParameters.openNLEnable = sender.selected;
    
}
- (IBAction)fpsButtonClicked:(UIButton *)sender {
    
    
    
}
- (IBAction)pixButtonClicked:(UIButton *)sender {
    
    
    [self presentViewController:self.pixSheetVC animated:YES completion:nil];
    
}
- (IBAction)testSpeedButtonClicked:(UIButton *)sender {
    
    [m_starManagerModel voipEchoTest];
    
}
- (IBAction)enterButtonClicked:(UIButton *)sender {
    
    [self setVideoParameters];
    [videoSetParameters saveParametersToLocal];
    [self.navigationController popViewControllerAnimated:YES];
}

//编码格式
- (IBAction)encodeButtonClicked:(UIButton *)sender {
    
    
    
}
//编码类型  硬编、软编
- (IBAction)encodeTypeButtonClicked:(UIButton *)sender {
    
    sender.selected = !videoSetParameters.hwDecodeEnable;
    videoSetParameters.hwDecodeEnable = sender.selected;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
