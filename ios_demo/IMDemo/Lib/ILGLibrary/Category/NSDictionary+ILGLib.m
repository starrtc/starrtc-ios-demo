//
//  NSDictionary+ILGLib.m
//  IMDemo
//
//  Created by HappyWork on 2019/4/25.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "NSDictionary+ILGLib.h"

@implementation NSDictionary (ILGLib)
- (NSString *)ilg_jsonString {
    NSString *json = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(!error) {
        json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"JSON parse error: %@", error);
    }
    
    return json;
}
@end
