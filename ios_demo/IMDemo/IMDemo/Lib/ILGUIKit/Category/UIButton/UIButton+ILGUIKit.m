//
//  UIButton+ILGUIKit.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/20.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "UIButton+ILGUIKit.h"

@implementation UIButton (ILGUIKit)
- (void)setMulColor:(NSArray <UIColor *>*)colors startPoint:(NSArray <NSNumber *>*)points {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;  // 设置显示的frame
    gradientLayer.colors = colors;  // 设置渐变颜色
    gradientLayer.locations = points;    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
@end
