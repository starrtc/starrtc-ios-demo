// IFAutoPurgingDataCache.m
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

#if TARGET_OS_IOS || TARGET_OS_TV 

#import "IFAutoPurgingDataCache.h"
#import <malloc/malloc.h>
#import "MD5Util.h"

@interface IFCachedData : NSObject

@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign) UInt64 totalBytes;
@property (nonatomic, strong) NSDate *lastAccessDate;
@property (nonatomic, assign) UInt64 currentMemoryUsage;
@property (nonatomic, strong) NSDate *saveDate;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation IFCachedData

-(instancetype)initWithData:(id)data identifier:(NSString *)identifier {
    if (self = [self init]) {
        self.data = data;
        self.identifier = identifier;
        CGFloat bytesPerPixel = 4.0;
        CGFloat bytesPerSize = malloc_size((__bridge const void *)(data));
        self.totalBytes = (UInt64)bytesPerPixel * (UInt64)bytesPerSize;
        self.lastAccessDate = [NSDate date];
        self.duration = NSIntegerMax;
    }
    return self;
}

- (void)setData:(id)data {
    self.saveDate = [NSDate date];
    _data = data;
}

- (id)accessdData {
    self.lastAccessDate = [NSDate date];
    return self.data;
}

- (void)setDuration:(NSTimeInterval)duration {
    _duration = duration;
}
- (NSString *)description {
    NSString *descriptionString = [NSString stringWithFormat:@"Idenfitier: %@  lastAccessDate: %@ ", self.identifier, self.lastAccessDate];
    return descriptionString;
}

@end

@interface IFAutoPurgingDataCache ()
@property (nonatomic, strong) NSMutableDictionary <NSString* , IFCachedData*> *cachedDatas;
@property (nonatomic, assign) UInt64 currentMemoryUsage;
@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@end

@implementation IFAutoPurgingDataCache

+ (instancetype)shareManager {
    static IFAutoPurgingDataCache *autoPurgingDataCache = nil;
    static dispatch_once_t oncetime;
    dispatch_once(&oncetime, ^{
        autoPurgingDataCache = [[IFAutoPurgingDataCache alloc] init];
    });
    return autoPurgingDataCache;
}

- (instancetype)init {
    return [self initWithMemoryCapacity:100 * 1024 * 1024 preferredMemoryCapacity:60 * 1024 * 1024];
}

- (instancetype)initWithMemoryCapacity:(UInt64)memoryCapacity preferredMemoryCapacity:(UInt64)preferredMemoryCapacity {
    if (self = [super init]) {
        self.memoryCapacity = memoryCapacity;
        self.preferredMemoryUsageAfterPurge = preferredMemoryCapacity;
        self.cachedDatas = [[NSMutableDictionary alloc] init];

        NSString *queueName = [NSString stringWithFormat:@"com.alamofire.autopurgingdatacache-%@", [[NSUUID UUID] UUIDString]];
        self.synchronizationQueue = dispatch_queue_create([queueName cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(removeAllDatas)
         name:UIApplicationDidReceiveMemoryWarningNotification
         object:nil];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UInt64)memoryUsage {
    __block UInt64 result = 0;
    dispatch_sync(self.synchronizationQueue, ^{
        result = self.currentMemoryUsage;
    });
    return result;
}

- (void)addData:(id)data withIdentifier:(NSString *)identifier duration:(NSTimeInterval)duration {
//    identifier = [MD5Util MD5UppercaseString:identifier];
    dispatch_barrier_async(self.synchronizationQueue, ^{
        IFCachedData *cacheData = [[IFCachedData alloc] initWithData:data identifier:identifier];
        cacheData.duration = duration;
        IFCachedData *previousCachedData = self.cachedDatas[identifier];
        if (previousCachedData != nil) {
            self.currentMemoryUsage -= previousCachedData.totalBytes;
        }
        
        self.cachedDatas[identifier] = cacheData;
        self.currentMemoryUsage += cacheData.totalBytes;
    });
    
    dispatch_barrier_async(self.synchronizationQueue, ^{
        if (self.currentMemoryUsage > self.memoryCapacity) {
            UInt64 bytesToPurge = self.currentMemoryUsage - self.preferredMemoryUsageAfterPurge;
            NSMutableArray <IFCachedData*> *sortedDatas = [NSMutableArray arrayWithArray:self.cachedDatas.allValues];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastAccessDate"
                                                                           ascending:YES];
            [sortedDatas sortUsingDescriptors:@[sortDescriptor]];
            
            UInt64 bytesPurged = 0;
            
            for (IFCachedData *cachedData in sortedDatas) {
                [self.cachedDatas removeObjectForKey:cachedData.identifier];
                bytesPurged += cachedData.totalBytes;
                if (bytesPurged >= bytesToPurge) {
                    break ;
                }
            }
            self.currentMemoryUsage -= bytesPurged;
        }
    });
}

- (void)addData:(id)data withIdentifier:(NSString *)identifier {
    [self addData:data withIdentifier:identifier duration:NSIntegerMax];
}

- (BOOL)removeDataWithIdentifier:(NSString *)identifier {
    __block BOOL removed = NO;
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        IFCachedData *cachedData = self.cachedDatas[identifier];
        if (cachedData != nil) {
            [self.cachedDatas removeObjectForKey:identifier];
            self.currentMemoryUsage -= cachedData.totalBytes;
            removed = YES;
        }
    });
    return removed;
}

- (BOOL)removeAllDatas {
    __block BOOL removed = NO;
    dispatch_barrier_sync(self.synchronizationQueue, ^{
        if (self.cachedDatas.count > 0) {
            [self.cachedDatas removeAllObjects];
            self.currentMemoryUsage = 0;
            removed = YES;
        }
    });
    return removed;
}

- (nullable id )dataWithIdentifier:(NSString *)identifier {
    __block id data = nil;
//    identifier = [MD5Util MD5UppercaseString:identifier];
    dispatch_sync(self.synchronizationQueue, ^{
        IFCachedData *cachedData = self.cachedDatas[identifier];
        if (cachedData){
            NSDate *nowData = [NSDate date];
            NSLog(@"%lf %lf %lf ",cachedData.saveDate.timeIntervalSince1970,cachedData.duration,nowData.timeIntervalSince1970);
            if (nowData.timeIntervalSince1970 - cachedData.saveDate.timeIntervalSince1970 <= cachedData.duration) {
                data = [cachedData accessdData];
            } else {
                [self.cachedDatas removeObjectForKey:identifier];
                self.currentMemoryUsage -= cachedData.totalBytes;
            }
        } else {
            data = nil;
        }
    });
    return data;
}

- (void)addData:(id)data forRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    [self addData:data withIdentifier:[self dataCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (BOOL)removeDataforRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    return [self removeDataWithIdentifier:[self dataCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (nullable id)dataforRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)identifier {
    return [self dataWithIdentifier:[self dataCacheKeyFromURLRequest:request withAdditionalIdentifier:identifier]];
}

- (NSString *)dataCacheKeyFromURLRequest:(NSURLRequest *)request withAdditionalIdentifier:(NSString *)additionalIdentifier {
    NSString *key = request.URL.absoluteString;
    if (additionalIdentifier != nil) {
        key = [key stringByAppendingString:additionalIdentifier];
    }
    return key;
}

@end

#endif
