//
//  UIView+ILGKit.h
//  WangHuo
//
//  Created by zhangtongle on 2017/6/16.
//  Copyright © 2017年 All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, ILGToastPosition) {
    ILGToastPositionTop = 0,
    ILGToastPositionCenter = 1,
    ILGToastPositionBottom = 2
};

@interface UIView (ILGKit)
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat tailing;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat k;

+ (void)showProgressWithText:(NSString*)text;
+ (void)hiddenProgress;
+ (void)ilg_makeToast:(NSString *)message;
- (void)ilg_makeToast:(NSString *)message position:(ILGToastPosition)position;
- (void)showTopAlertWithText:(NSString *)text;
- (UIWindow *)showTopAlertWithText:(NSString *)text autoHide:(BOOL)isAuthHide;
+ (UIViewController*)ilg_getCurrentVC;

- (void)setMulColor:(NSArray <UIColor *>*)colors startPoint:(NSArray <NSNumber *>*)points;

@end
