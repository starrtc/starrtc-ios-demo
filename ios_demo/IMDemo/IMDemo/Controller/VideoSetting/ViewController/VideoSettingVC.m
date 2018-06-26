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
#import "QGSandboxViewerVC.h"

@interface VideoSettingVC ()

{
    VideoSetParameters * _videoSetParameters;
}
@property (weak, nonatomic) IBOutlet UISwitch *hwEncodeSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *openGLSwitch;
@property (nonatomic, strong) UIAlertController * corpAlertController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *corpSetButton;

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
    [self setupVideoDefaultParameters];
    if ([UIDevice currentDevice].systemVersion.doubleValue < 11.0) {
        self.top.constant = 64;
    }
}

- (void)setupVideoDefaultParameters{
    _videoSetParameters = [VideoSetParameters locaParameters];
    [self.hwEncodeSwitch setOn:_videoSetParameters.hwEncodeEnable];
    [self.openGLSwitch setOn:_videoSetParameters.openGLEnable];
    [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
}

- (UIAlertController*)corpAlertController{
    if (!_corpAlertController) {
        _corpAlertController = [UIAlertController alertControllerWithTitle:@"设置分辨率" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        
        UIAlertAction *alertAction0 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction3 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction4 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_80SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_80SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction5 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_112SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_112SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction6 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_160SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_160SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction7 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_176SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_176SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction8 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_240SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_240SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction9 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_320SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_320SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction10 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_80SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_80SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction11 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_112SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_112SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction12 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_160SW_160SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_160SW_160SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction13 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_176SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_176SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction14 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH;
            [self.corpSetButton setTitle:[_videoSetParameters.currentResolutionText stringByAppendingString:@"＞"] forState:UIControlStateNormal];
        }];
        UIAlertAction *alertAction15 = [UIAlertAction actionWithTitle:[VideoSetParameters resolutionTextWithType:IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_320SW_320SH] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            _videoSetParameters.resolution = IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_320SW_320SH;
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
    }
    return _corpAlertController;
}

- (IBAction)crop:(UIButton *)sender {
    
    [self presentViewController:self.corpAlertController animated:YES completion:nil];
    
}
- (IBAction)openGL:(UISwitch *)sender {
    _videoSetParameters.openGLEnable = sender.isOn;
    
}
- (IBAction)hardEncode:(UISwitch *)sender {
    
    _videoSetParameters.hwEncodeEnable = sender.isOn;
}
- (IBAction)testSpeed:(UIButton *)sender {
    VideoTestSpeedVC * vc = [[VideoTestSpeedVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)aboutUSButtonClicked:(UIButton *)sender {
    AboutUsVC * vc = [AboutUsVC new];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (IBAction)encodeFormat:(UIButton *)sender {
//    [UIWindow ilg_makeToast:@"开发中...."];
    
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

/**
 三次点击发送日志
 
 @param sender 手势
 */
-(void)handleLogTap:(UIGestureRecognizer *)sender{
    QGSandboxViewerVC *vc = [[QGSandboxViewerVC alloc] initWithHomeDirectory];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareLogsAtDirectory:(NSString*)path delegate:(UIViewController*)delegate {
    //分享的url
    NSURL *urlToShare = [NSURL fileURLWithPath:path];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[urlToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [delegate presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}

///pcm转WAV
- (NSString*)pcm2WAV
{
    NSString *pcmPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xbMedia"];
    
    NSString *wavPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/xbMedia.wav"];
    char *pcmPath_c = [pcmPath UTF8String];
    char *wavPath_c = [wavPath UTF8String];
    convertPcm2Wav(pcmPath_c, wavPath_c, 1, 16000);
    return wavPath;
    
    //进入沙盒找到xbMedia.wav即可
}



// pcm 转wav

//wav头的结构如下所示：

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
    char        fccType[4];
    
} HEADER;

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
    int16_t      wFormatTag;
    
    int16_t      wChannels;
    
    int32_t      dwSamplesPerSec;
    
    int32_t      dwAvgBytesPerSec;
    
    int16_t      wBlockAlign;
    
    int16_t      uiBitsPerSample;
    
}FMT;

typedef  struct  {
    
    char        fccID[4];
    
    int32_t      dwSize;
    
}DATA;

/*
 int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate)
 请问这个方法怎么用?参数都是什么意思啊
 
 赞  回复
 code书童： @不吃鸡爪 pcm文件路径，wav文件路径，channels为通道数，手机设备一般是单身道，传1即可，sample_rate为pcm文件的采样率，有44100，16000，8000，具体传什么看你录音时候设置的采样率。
 */

int convertPcm2Wav(char *src_file, char *dst_file, int channels, int sample_rate)

{
    int bits = 16;
    
    //以下是为了建立.wav头而准备的变量
    
    HEADER  pcmHEADER;
    
    FMT  pcmFMT;
    
    DATA  pcmDATA;
    
    unsigned  short  m_pcmData;
    
    FILE  *fp,*fpCpy;
    
    if((fp=fopen(src_file,  "rb"))  ==  NULL) //读取文件
        
    {
        
        printf("open pcm file %s error\n", src_file);
        
        return -1;
        
    }
    
    if((fpCpy=fopen(dst_file,  "wb+"))  ==  NULL) //为转换建立一个新文件
        
    {
        
        printf("create wav file error\n");
        
        return -1;
        
    }
    
    //以下是创建wav头的HEADER;但.dwsize未定，因为不知道Data的长度。
    
    strncpy(pcmHEADER.fccID,"RIFF",4);
    
    strncpy(pcmHEADER.fccType,"WAVE",4);
    
    fseek(fpCpy,sizeof(HEADER),1); //跳过HEADER的长度，以便下面继续写入wav文件的数据;
    
    //以上是创建wav头的HEADER;
    
    if(ferror(fpCpy))
        
    {
        
        printf("error\n");
        
    }
    
    //以下是创建wav头的FMT;
    
    pcmFMT.dwSamplesPerSec=sample_rate;
    
    pcmFMT.dwAvgBytesPerSec=pcmFMT.dwSamplesPerSec*sizeof(m_pcmData);
    
    pcmFMT.uiBitsPerSample=bits;
    
    strncpy(pcmFMT.fccID,"fmt  ", 4);
    
    pcmFMT.dwSize=16;
    
    pcmFMT.wBlockAlign=2;
    
    pcmFMT.wChannels=channels;
    
    pcmFMT.wFormatTag=1;
    
    //以上是创建wav头的FMT;
    
    fwrite(&pcmFMT,sizeof(FMT),1,fpCpy); //将FMT写入.wav文件;
    
    //以下是创建wav头的DATA;  但由于DATA.dwsize未知所以不能写入.wav文件
    
    strncpy(pcmDATA.fccID,"data", 4);
    
    pcmDATA.dwSize=0; //给pcmDATA.dwsize  0以便于下面给它赋值
    
    fseek(fpCpy,sizeof(DATA),1); //跳过DATA的长度，以便以后再写入wav头的DATA;
    
    fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
    
    while(!feof(fp)) //在.pcm文件结束前将他的数据转化并赋给.wav;
        
    {
        
        pcmDATA.dwSize+=2; //计算数据的长度；每读入一个数据，长度就加一；
        
        fwrite(&m_pcmData,sizeof(int16_t),1,fpCpy); //将数据写入.wav文件;
        
        fread(&m_pcmData,sizeof(int16_t),1,fp); //从.pcm中读入数据
        
    }
    
    fclose(fp); //关闭文件
    
    pcmHEADER.dwSize = 0;  //根据pcmDATA.dwsize得出pcmHEADER.dwsize的值
    
    rewind(fpCpy); //将fpCpy变为.wav的头，以便于写入HEADER和DATA;
    
    fwrite(&pcmHEADER,sizeof(HEADER),1,fpCpy); //写入HEADER
    
    fseek(fpCpy,sizeof(FMT),1); //跳过FMT,因为FMT已经写入
    
    fwrite(&pcmDATA,sizeof(DATA),1,fpCpy);  //写入DATA;
    
    fclose(fpCpy);  //关闭文件
    
    return 0;
    
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
