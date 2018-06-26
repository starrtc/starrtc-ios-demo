//
//  XHVideoConfig.h
//  XHSDK
//
//  Created by zhangtongle-Pro on 2018/4/17.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHConstants.h"

@interface XHVideoConfig : NSObject
@property (nonatomic, assign) XHCropTypeEnum resolution; //分辨率
@property (nonatomic, assign) BOOL openGLEnable; //YES表示使用openGL渲染
@property (nonatomic, assign) BOOL hwEncodeEnable;  //YES表示使用硬编

+ (instancetype)defaultConfig;

@end
