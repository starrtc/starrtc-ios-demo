//
//  UIView+ILGKit.m
//  WangHuo
//
//  Created by zhangtongle on 2017/6/16.
//  Copyright © 2017年 All rights reserved.
//

#import "UIView+ILGKit.h"

@interface UIView ()
@property (nonatomic, strong) UIWindow *tempWindow;
@end
@implementation UIView (ILGKit)
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (void)setK:(CGFloat)k {
    
}
- (CGFloat)k{
    return 0;
    
}
- (CGFloat)width {
    return self.size.width;
}
- (void)setWidth:(CGFloat)width {
    [self setSize:CGSizeMake(width, self.height)];
}

- (CGFloat)height {
    return self.size.height;
}
- (void)setHeight:(CGFloat)height {
    [self setSize:CGSizeMake(self.width, height)];
}

- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)tailing {
    return self.x + self.width;
}
- (void)setTailing:(CGFloat)tailing {
    self.x = tailing - self.width;
}

- (CGFloat)bottom {
    return self.y + self.height;
}
- (void)setBottom:(CGFloat)bottom {
    self.y = bottom - self.height;
}

+ (UIView *)ilg_loadNibNamed:(NSString *)name {
    return nil;
}


+ (void)showProgressWithText:(NSString*)text {
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.detailsLabel.text = text;
}

+ (void)hiddenProgress {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

- (void)showProgressWithText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.detailsLabel.text = text;
}
- (void)hideProgress {
    [MBProgressHUD hideHUDForView:self animated:YES];
}

+ (void)ilg_makeToast:(NSString *)message {
    [[UIApplication sharedApplication].keyWindow ilg_makeToast:message position:ILGToastPositionCenter];
}
- (void)ilg_makeToast:(NSString *)message position:(ILGToastPosition)position {
    const NSString *positionStr = CSToastPositionCenter;
    if (position == ILGToastPositionTop) {
        positionStr = CSToastPositionTop;
    } else if (position == ILGToastPositionBottom) {
        positionStr = CSToastPositionBottom;
    }
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    
    [self makeToast:message duration:2 position:positionStr style:toastStyle];
}

+ (UIViewController*)ilg_getCurrentVC {
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self ilg_getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)ilg_getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self ilg_getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self ilg_getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}


- (UIWindow *)showTopAlertWithText:(NSString *)text autoHide:(BOOL)isAuthHide {
    UIWindow *tempWindow = [[UIWindow alloc]init];
    tempWindow.frame = CGRectMake(0, -50, self.width, 50);
    tempWindow.windowLevel = UIWindowLevelStatusBar + 1;
    tempWindow.backgroundColor = [UIColor colorWithHexString:@"FF9210"];
    tempWindow.hidden = NO;
    
    UIButton *topView = [UIButton buttonWithType:UIButtonTypeCustom];
    topView.backgroundColor = [UIColor clearColor];
    [topView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    topView.titleLabel.font = [UIFont systemFontOfSize:15];
    [topView setTitle:text forState:UIControlStateNormal];
    //    [topView addTarget:self action:@selector(hideTopAlert) forControlEvents:UIControlEventTouchUpInside];
    topView.frame = tempWindow.bounds;
    
    [tempWindow addSubview:topView];
    
    [UIView animateWithDuration:0.26 animations:^{
        CGRect frame = tempWindow.frame;
        frame.origin.y = 0;
        
        tempWindow.frame = frame;
    }];
    
    if (isAuthHide) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.26 animations:^{
                CGRect frame = tempWindow.frame;
                frame.origin.y = - tempWindow.frame.size.height;
                tempWindow.frame = frame;
            }completion:^(BOOL finished) {
                [tempWindow removeFromSuperview];
            }];
        });
    }
    
    return tempWindow;
}
- (void)showTopAlertWithText:(NSString *)text {
    [self showTopAlertWithText:text autoHide:YES];
}

- (void)setMulColor:(NSArray <UIColor *>*)colors startPoint:(NSArray <NSNumber *>*)points {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;  // 设置显示的frame
    gradientLayer.colors = colors;  // 设置渐变颜色
    gradientLayer.locations = points;    // 颜色的起点位置，递增，并且数量跟颜色数量相等
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

//- (void)hideTopAlert {
//    [UIView animateWithDuration:0.26 animations:^{
//        CGRect frame = self.tempWindow.frame;
//        frame.origin.y = - self.tempWindow.frame.size.height;
//        self.tempWindow.frame = frame;
//    }completion:^(BOOL finished) {
//        [self.tempWindow removeFromSuperview];
//    }];
//}
@end
