//
//  UIColor+Category.m
//  WangHuo
//
//  Created by zhangtongle on 2017/5/22.
//  Copyright © 2017年 All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)
+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue {
    return  [UIColor colorWithR:red g:green b:blue alpha:1];
}

+ (UIColor *)colorWithR:(CGFloat)red g:(CGFloat)green b:(CGFloat)blue alpha:(CGFloat)alpha {
    UIColor *color = [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
    
    return color;
}

+ (UIColor *)ilg_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (UIColor *)ilg_colorWithHexString:(NSString *)hexString {
    return [self ilg_colorWithHexString:hexString alpha:1.0f];
}

+ (UIColor *)ilg_randomColor {
    int r = arc4random()%255;
    int g = arc4random()%255;
    int b = arc4random()%255;
    return [UIColor colorWithR:r g:g b:b];
}

+ (NSString *)ilg_randomColorHex {
    int hexInt = arc4random()%999999;
    return [NSString stringWithFormat:@"%d", hexInt];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    return [self ilg_colorWithHexString:hexString alpha:1.0f];
}
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [self ilg_colorWithHexString:hexString alpha:alpha];
}
@end
