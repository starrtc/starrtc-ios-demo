//
//  VideoSetParameters.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "VideoSetParameters.h"

@implementation VideoSetParameters

+ (instancetype)locaParameters{
    VideoSetParameters *parameters = [self defaultConfig];
    //本Demo将视频参数存储在了NSUserDefaults中，用户可视情况选择不同的本地化方案
    NSDictionary * parametersDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"VideoSetParameters"];
    
    if (parametersDic) {
        [parameters setValuesForKeysWithDictionary:parametersDic];
        //记得注释掉
    }
    return parameters;
}

+ (NSString*)resolutionTextWithType:(XHCropTypeEnum) resolution{

    NSString * text = @"";
    switch (resolution) {
        case IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_SMALL_NONE:             //0
            text = @"大图：176*320 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_176BW_320BH_88SW_160SH:             //1
            text = @"大图：176*320 小图：88*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_SMALL_NONE:             //2
            text = @"大图：240*320 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_240BW_320BH_120SW_160SH:            //3
            text = @"大图：240*320 小图：120*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE:               //4
            text = @"大图：480*480 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_120SW_120SH:               //5
            text = @"大图：480*480 小图：120*120 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_240SW_240SH:              //6
            text = @"大图：480*480 小图：240*240 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_SMALL_NONE:               //7
            text = @"大图：360*640 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_90SW_160SH:               //8
            text = @"大图：360*640 小图：90*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_360BW_640BH_180SW_320SH:              //9
            text = @"大图：360*640 小图：180*320 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_SMALL_NONE:               //10
            text = @"大图：480*640 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_120SW_160SH:              //11
            text = @"大图：480*640 小图：120*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_640BH_240SW_320SH:              //12
            text = @"大图：480*640 小图：240*320 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_SMALL_NONE:               //13
            text = @"大图：640*640 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_160SW_160SH:              //14
            text = @"大图：640*640 小图：160*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_640BW_640BH_320SW_320SH:              //15
            text = @"大图：640*640 小图320*320 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE:              //16
            text = @"大图：720*1280 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_90SW_160SH:              //17
            text = @"大图：720*1280 小图：90*160 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_180SW_320SH:             //18
            text = @"大图：720*1280 小图：180*320 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_360SW_640SH:             //19
            text = @"大图：720*1280 小图：360*640 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_SMALL_NONE:             //20
            text = @"大图：1080*1920 小图：无 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_135SW_240SH:            //21
            text = @"大图：1080*1920 小图：135*240 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_270SW_480SH:            //22
            text = @"大图：1080*1920 小图：270*480 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_1080BW_1920BH_540SW_960SH:            //23
            text = @"大图： 1080*1920 小图：540*960 >";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE:               //24
            text = @"大图：特殊定制 小图：无 >";
            break;
        default:
            text = @"未知分辨率 >";
            break;
    }
    
    return text;
}

- (NSString*)currentResolutionText {
    return [VideoSetParameters resolutionTextWithType:self.resolution];
}
- (NSDictionary*)objectToDictionary
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:self.resolution] forKey:@"resolution"];
    [dic setObject:[NSNumber numberWithBool:self.openGLEnable] forKey:@"openGLEnable"];
    [dic setObject:[NSNumber numberWithBool:self.hwEncodeEnable] forKey:@"hwEncodeEnable"];
    [dic setObject:@(self.videoEnable) forKey:@"videoEnable"];
    [dic setObject:@(self.audioEnable) forKey:@"audioEnable"];
    [dic setObject:@(self.dynamicBitrateAndFPSEnable) forKey:@"dynamicBitrateAndFPSEnable"];
    [dic setObject:@(self.voipP2PEnable) forKey:@"voipP2PEnable"];
    [dic setObject:@(self.bigVideoBitrate) forKey:@"bigVideoBitrate"];
    [dic setObject:@(self.bigVideoFPS) forKey:@"bigVideoFPS"];
    [dic setObject:@(self.smallVideoBitrate) forKey:@"smallVideoBitrate"];
    [dic setObject:@(self.smallVideoFPS) forKey:@"smallVideoFPS"];
    
    [dic setObject:@(self.videoCodecType) forKey:@"videoCodecType"];
    [dic setObject:@(self.audioCodecType) forKey:@"audioCodecType"];
    
    [dic setObject:[NSNumber numberWithBool:self.logEnable] forKey:@"logEnable"];
    
    return dic;
}

- (void)saveParametersToLocal
{
    NSDictionary *parameters = [self objectToDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"VideoSetParameters"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
