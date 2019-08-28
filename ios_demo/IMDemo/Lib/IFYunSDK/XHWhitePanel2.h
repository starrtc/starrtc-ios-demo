//
//  XHWhitePanel2.h
//  starLibrary
//
//  Created by  Admin on 2018/9/28.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHWhitePanel2 : UIView

-(id)initWithView:(UIView *)superView;

/**
 *  开始
 */
-(void)publish;

/**
 *  暂停
 */
-(void)pause;

/**
 *  清屏
 */
-(void)clean;

/**
 *  撤销
 */
- (void)undo;

/**
 *  恢复
 */
- (void)redo;

/**
 *  设置绘制数据
 */
-(void)setPaintData:(NSInteger)upId
               data:(NSString*)data;

/**
 *  打开激光笔
 */
-(void) laserPenOn;

/**
 *  关闭激光笔
 */
-(void) laserPenOff;

/**
 *  设置画笔颜色
 */

-(void)setSelectColor:(UIColor *)color;

@end
