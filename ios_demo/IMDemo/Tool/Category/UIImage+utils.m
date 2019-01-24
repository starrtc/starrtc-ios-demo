//
//  NSString+utils.m
//  IMDemo
//
//  Created by Hanxiaojie on 2018/6/8.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "UIImage+utils.h"

@implementation UIImage (utils)
+ (UIImage*)imageWithUserId:(id)userId{
    NSInteger index = [userId integerValue];
    return [UIImage imageNamed:[NSString stringWithFormat:@"head_icon_%ld",index % 70 + 1]];
}
@end
