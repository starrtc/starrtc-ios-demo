//
//  VideoSetParameters.h
//  IMDemo
//
//  Created by Hanxiaojie on 2018/4/3.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoSetParameters : XHVideoConfig

@property (nonatomic, assign) BOOL logEnable;

+ (instancetype)locaParameters;
+ (NSString*)resolutionTextWithType:(XHCropTypeEnum) resolution;

- (NSDictionary*)objectToDictionary;
- (void)saveParametersToLocal;
- (NSString*)currentResolutionText;


@end
