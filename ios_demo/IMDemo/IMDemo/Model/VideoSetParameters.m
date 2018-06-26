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
        parameters.hwEncodeEnable = NO;
    }
    return parameters;
}

+ (NSString*)resolutionTextWithType:(XHCropTypeEnum) resolution{

    NSString * text = @"";
    switch (resolution) {
        case IOS_STAR_VIDEO_CROP_CONFIG_BIG_NOCROP_SMALL_NONE:
            text = @"大图:特殊定制 小图:无";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_SMALL_NONE:
            text = @"大图:368*640 小图:无";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_480BW_480BH_SMALL_NONE:
            text = @"大图:480*480 小图:无";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_SMALL_NONE:
            text = @"大图:720*1280 小图:无";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_80SW_160SH:
            text = @"大图:368*640 小图:80*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_112SW_160SH:
            text = @"大图:368*640 小图:112*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_160SW_160SH:
            text = @"大图:368*640 小图:160*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_176SW_320SH:
            text = @"大图:368*640 小图:176*320";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_240SW_320SH:
            text = @"大图:368*640 小图:240*320";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_368BW_640BH_320SW_320SH:
            text = @"大图:368*640 小图:320*320";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_80SW_160SH:
            text = @"大图:720*1280 小图:80*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_112SW_160SH:
            text = @"大图:720*1280 小图:112*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_160SW_160SH:
            text = @"大图:720*1280 小图:160*160";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_176SW_320SH:
            text = @"大图:720*1280 小图:176*320";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_240SW_320SH:
            text = @"大图:720*1280 小图:240*320";
            break;
        case IOS_STAR_VIDEO_CROP_CONFIG_720BW_1280BH_320SW_320SH:
            text = @"大图:720*1280 小图:320*320";
            break;
        default:
            text = @"未知分辨率";
            break;
    }
    
    return text;
}

- (NSString*)currentResolutionText {
    return [VideoSetParameters resolutionTextWithType:self.resolution];
}
- (NSDictionary*)objectToDictionary
{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithCapacity:5];
    [dic setObject:[NSNumber numberWithInteger:self.resolution] forKey:@"resolution"];
    [dic setObject:[NSNumber numberWithBool:self.openGLEnable] forKey:@"openGLEnable"];
    [dic setObject:[NSNumber numberWithBool:self.hwEncodeEnable] forKey:@"hwEncodeEnable"];
    return dic;
}

- (void)saveParametersToLocal
{
    NSDictionary *parameters = [self objectToDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:parameters forKey:@"VideoSetParameters"];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
