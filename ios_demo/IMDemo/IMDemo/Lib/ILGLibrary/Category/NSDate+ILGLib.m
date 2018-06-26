//
//  NSDate+ILGLib.m
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2017/9/6.
//  Copyright © 2017年 Happy. All rights reserved.
//

#import "NSDate+ILGLib.h"

@implementation NSDate (ILGLib)

+ (NSString *)ilg_timeStamp {
    NSString *timeStamp = [NSString stringWithFormat:@"%ld", (long)([[self ilg_dateForLocal] timeIntervalSince1970])];
    return timeStamp;
}

+ (NSString *)ilg_timeZone {
    /*
     timeZone.abbreviation GMT+8 or GMT-8
     */
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    return [timeZone.abbreviation substringFromIndex:3];
}

+ (NSDate *)ilg_dateForLocal {
    NSString *localDateString = [self ilg_dateStringForLocal:nil];
    
    return [self ilg_dateFromString:localDateString format:nil];
}

+ (NSString *)ilg_dateStringForLocal:(NSString *)dateFormat {
    NSDate *GTMDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    ;
    dateFormat?[dateFormatter setDateFormat:dateFormat]:[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:GTMDate];
}

+ (NSDate *)ilg_dateFromString:(NSString *)dateString format:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    
    dateFormat?[dateFormatter setDateFormat:dateFormat]:[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

+ (double)ilg_timeIntervalBetween:(NSDate *)firstDate date:(NSDate *)secondDate
{
    double timeInterval = [firstDate timeIntervalSinceDate:secondDate];
    return timeInterval;
}

+ (NSString *)ilg_timeFromTimeStamp:(NSString *)timeStamp format:(NSString *)dateFormatStr {
    if (timeStamp.length != 10) {
        return nil;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:dateFormatStr];
    return [dateFormatter stringFromDate:date];    
}

@end
