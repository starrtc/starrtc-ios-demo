//
//  NSDate+ILGLib.h
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2017/9/6.
//  Copyright © 2017年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ILGLib)

/**
 获取十位长度时间戳

 @return 时间戳
 */
+ (NSString *)ilg_timeStamp;

/**
 获取本地时区，如北京时区+8

 @return 本地时区
 */
+ (NSString *)ilg_timeZone;

/**
 获取本地date

 @return 本地date
 */
+ (NSDate *)ilg_dateForLocal;

/**
 获取本地date的字符串

 @param dateFormat 可以指定时间格式(可选，默认使用yyyy-MM-dd HH:mm:ss)
 @return 本地date的字符串
 */
+ (NSString *)ilg_dateStringForLocal:(NSString *)dateFormat;

/**
 将指定格式的时间字符串"2017-10-23 17:18:30"转化成NSDate对象

 @param dateString 时间字符串
 @param dateFormat 时间字符串对应的格式
 @return date
 */
+ (NSDate *)ilg_dateFromString:(NSString *)dateString format:(NSString *)dateFormat;

/**
 计算两个date的时差，单位秒

 @param firstDate date1
 @param secondDate date2
 @return 时差
 */
+ (double)ilg_timeIntervalBetween:(NSDate *)firstDate date:(NSDate *)secondDate;

+ (NSString *)ilg_timeFromTimeStamp:(NSString *)timeStamp format:(NSString *)dateFormat;

@end


/*
 1.可以使用NSDate的方法timeIntervalSinceDate:计算两个NSDate对象的时间差/单位秒
*/
