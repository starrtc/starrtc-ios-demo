//
//  XHWhitePanel.h
//  starLibrary
//
//  Created by  Admin on 2018/7/27.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHWhitePanel : NSObject

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
@end
