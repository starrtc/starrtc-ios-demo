//
//  MD5Util.h
//  凤凰新媒体
//
//  Created by Xuqigang on 2017/5/16.
//
//

#import <Foundation/Foundation.h>

@interface MD5Util : NSObject


//md5 32位小写
+ (NSString *) MD5String:(NSString *) string;

//md5 32位大写
+ (NSString *) MD5UppercaseString:(NSString *) string;
@end
