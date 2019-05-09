//
//  NSString+ILGLib.h
//  IMDemo
//
//  Created by HappyWork on 2019/4/25.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ILGLib)
- (NSDictionary *)ilg_dictionary;

- (NSString *)ilg_URLEncode;
- (NSString *)ilg_URLDecode;
@end

NS_ASSUME_NONNULL_END
