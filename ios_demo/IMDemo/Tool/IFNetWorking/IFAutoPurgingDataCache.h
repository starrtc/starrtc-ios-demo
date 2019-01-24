// IFAutoPurgingDataCache.h
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <TargetConditionals.h>
#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The `IFDataCache` protocol defines a set of APIs for adding, removing and fetching Datas from a cache synchronously.
 */
@protocol IFDataCache <NSObject>

/**
 Adds the data to the cache with the given identifier.

 @param data The data to cache.
 @param identifier The unique identifier for the data in the cache.
 */
- (void)addData:(id)data withIdentifier:(NSString *)identifier;

/**
 Removes the data from the cache matching the given identifier.

 @param identifier The unique identifier for the data in the cache.

 @return A BOOL indicating whether or not the data was removed from the cache.
 */
- (BOOL)removeDataWithIdentifier:(NSString *)identifier;

/**
 Removes all Datas from the cache.

 @return A BOOL indicating whether or not all Datas were removed from the cache.
 */
- (BOOL)removeAllDatas;

/**
 Returns the data in the cache associated with the given identifier.

 @param identifier The unique identifier for the data in the cache.

 @return An data for the matching identifier, or nil.
 */
- (nullable id)dataWithIdentifier:(NSString *)identifier;
@end


/**
 The `dataRequestCache` protocol extends the `dataCache` protocol by adding methods for adding, removing and fetching Datas from a cache given an `NSURLRequest` and additional identifier.
 */
@protocol IFDataRequestCache <IFDataCache>

- (void)addData:(id)data withIdentifier:(NSString *)identifier duration:(NSTimeInterval)duration;

/**
 Adds the data to the cache using an identifier created from the request and additional identifier.

 @param data The data to cache.
 @param request The unique URL request identifing the data asset.
 @param identifier The additional identifier to apply to the URL request to identify the data.
 */
- (void)addData:(id)data forRequest:(NSURLRequest *)request withAdditionalIdentifier:(nullable NSString *)identifier;

/**
 Removes the data from the cache using an identifier created from the request and additional identifier.

 @param request The unique URL request identifing the data asset.
 @param identifier The additional identifier to apply to the URL request to identify the data.
 
 @return A BOOL indicating whether or not all Datas were removed from the cache.
 */
- (BOOL)removeDataforRequest:(NSURLRequest *)request withAdditionalIdentifier:(nullable NSString *)identifier;

/**
 Returns the data from the cache associated with an identifier created from the request and additional identifier.

 @param request The unique URL request identifing the data asset.
 @param identifier The additional identifier to apply to the URL request to identify the data.

 @return An data for the matching request and identifier, or nil.
 */
- (nullable id)dataforRequest:(NSURLRequest *)request withAdditionalIdentifier:(nullable NSString *)identifier;

@end

/**
 The `AutoPurgingDataCache` in an in-memory data cache used to store Datas up to a given memory capacity. When the memory capacity is reached, the data cache is sorted by last access date, then the oldest data is continuously purged until the preferred memory usage after purge is met. Each time an data is accessed through the cache, the internal access date of the data is updated.
 */
@interface IFAutoPurgingDataCache : NSObject <IFDataRequestCache>

/**
 The total memory capacity of the cache in bytes.
 */
@property (nonatomic, assign) UInt64 memoryCapacity;

/**
 The preferred memory usage after purge in bytes. During a purge, Datas will be purged until the memory capacity drops below this limit.
 */
@property (nonatomic, assign) UInt64 preferredMemoryUsageAfterPurge;

/**
 The current total memory usage in bytes of all Datas stored within the cache.
 */
@property (nonatomic, assign, readonly) UInt64 memoryUsage;

/**
 Initialies the `AutoPurgingDataCache` instance with default values for memory capacity and preferred memory usage after purge limit. `memoryCapcity` defaults to `100 MB`. `preferredMemoryUsageAfterPurge` defaults to `60 MB`.

 @return The new `AutoPurgingDataCache` instance.
 */
- (instancetype)init;

/**
 Initialies the `AutoPurgingDataCache` instance with the given memory capacity and preferred memory usage
 after purge limit.

 @param memoryCapacity The total memory capacity of the cache in bytes.
 @param preferredMemoryCapacity The preferred memory usage after purge in bytes.

 @return The new `AutoPurgingDataCache` instance.
 */
- (instancetype)initWithMemoryCapacity:(UInt64)memoryCapacity preferredMemoryCapacity:(UInt64)preferredMemoryCapacity;

+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END

#endif

