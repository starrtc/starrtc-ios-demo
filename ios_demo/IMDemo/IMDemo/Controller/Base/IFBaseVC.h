//
//  IFBaseVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/3/29.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XHClient.h"

@interface IFBaseVC : UIViewController
@property (nonatomic, assign) CGFloat areaHeight;

- (void)setNavigationBarColor:(UIColor *)color;


- (void)hiddenLeftButton;  //隐藏左按钮
- (void)leftButtonClicked:(UIButton *)button;

- (void)hiddenRightButton;
//设置右按钮
- (void)setRightButtonText:(NSString * )text;
- (void)setRightButtonImage:(NSString * )image;
- (void)rightButtonClicked:(UIButton *)button;


@end
