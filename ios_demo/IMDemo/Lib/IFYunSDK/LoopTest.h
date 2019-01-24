//
//  LoopTest.h
//  monitor_001
//
//  Created by  Admin on 2018/5/9.
//  Copyright © 2018年 ndp_001_Tommy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LoopTest : NSObject

/**
 * 设置画面
 *
 */
-(void) setupView:(UIView *)self_big_view
  self_small_view:(UIView *)self_small_view
  target_big_view:(UIView *)target_big_view
target_small_view:(UIView *)target_small_view;


/**
 * 开始LoopTest
 *
 */
-(void) startLoopTest;

/**
 * 停止LoopTest
 *
 */
-(void) stopLoopTest;

@end
