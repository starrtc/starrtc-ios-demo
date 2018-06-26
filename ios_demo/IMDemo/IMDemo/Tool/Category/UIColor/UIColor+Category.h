//
//  UIColor+Category.h
//  WangHuo
//
//  Created by zhangtongle on 2017/5/22.
//  Copyright © 2017年  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)
+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue;
+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)ilg_colorWithHexString:(NSString *)hexString;
+ (UIColor *)ilg_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)ilg_randomColor;
+ (NSString *)ilg_randomColorHex;

#pragma mark - 废弃方法
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
