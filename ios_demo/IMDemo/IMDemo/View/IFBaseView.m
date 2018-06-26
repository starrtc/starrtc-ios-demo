//
//  IFBaseView.m
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/2.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseView.h"

@implementation IFBaseView
+ (instancetype)instanceFromNIB
{
    NSArray *nibViews =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    id view = [nibViews firstObject];
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
