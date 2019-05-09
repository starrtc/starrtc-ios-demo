//
//  IFBaseTableVC.h
//  IMDemo
//
//  Created by HappyWork on 2019/4/23.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFBaseTableVC : UITableViewController

- (void)hiddenLeftButton;  //隐藏左按钮
- (void)leftButtonClicked:(UIButton *)button;

- (void)hiddenRightButton;
//设置右按钮
- (void)setRightButtonText:(NSString * )text;
- (void)setRightButtonImage:(NSString * )image;
- (void)rightButtonClicked:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
