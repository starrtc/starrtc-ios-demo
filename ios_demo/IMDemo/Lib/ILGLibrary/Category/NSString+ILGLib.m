//
//  NSString+ILGLib.m
//  IMDemo
//
//  Created by HappyWork on 2019/4/25.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "NSString+ILGLib.h"

@implementation NSString (ILGLib)
- (NSDictionary *)ilg_dictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    
    return dic;
}

- (NSString *)ilg_URLEncode {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!*'();:,.@&=+$/?%#[]_-{}|\""]];
    } else {
        return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}
- (NSString *)ilg_URLDecode {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        result = [result stringByRemovingPercentEncoding];
    } else {
        result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return result;
}
@end
