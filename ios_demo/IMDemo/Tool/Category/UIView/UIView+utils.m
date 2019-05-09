//
//  UIView+utils.m
//  水晶日记
//
//  Created by Hanxiaojie on 2018/6/17.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "UIView+utils.h"

@implementation UIView (utils)
+ (UINib*)nib{
    UINib * nibCell = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    return nibCell;
}

+ (instancetype)instanceFromNib{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil];
    return [nibView lastObject];
}
@end
