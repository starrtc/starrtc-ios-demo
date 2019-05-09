
#import <Foundation/Foundation.h>

@protocol XHChatManagerDelegate <NSObject>

- (void)chatMessageDidReceived:(NSString *)message fromID:(NSString *)uid;

@end


@interface XHChatManager : NSObject

- (void)addDelegate:(id<XHChatManagerDelegate>)delegate;

- (void)sendMessage:(NSString *)message toID:(NSString *)toID completion:(void(^)(NSError *error))completion;
- (void)sendOnLineMessage:(NSString *)message toID:(NSString *)toID completion:(void(^)(NSError *error))completion;
@end
