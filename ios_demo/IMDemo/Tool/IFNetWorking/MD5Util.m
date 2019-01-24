//
//  MD5Util.m
//  凤凰新媒体
//
//  Created by Xuqigang on 2017/5/16.
//
//

#import "MD5Util.h"
#import <CommonCrypto/CommonDigest.h>
@implementation MD5Util
//md5 32位小写
+ (NSString *) MD5String:(NSString *) string
{
    const char *cStr = [string UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

//md5 32位大写
+ (NSString *) MD5UppercaseString:(NSString *) string {
    return [[self MD5String:string] uppercaseString];
}

@end
