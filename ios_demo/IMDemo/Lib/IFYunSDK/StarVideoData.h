//
//  StarVideoData.m
//  starLibrary
//
//  Created by  Admin on 2019/6/3.
//  Copyright © 2019年  Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StarVideoData : NSObject

@property (atomic) NSInteger width ;
@property (atomic) NSInteger height;
@property (atomic) NSData *videoData;//NV12格式
@property (atomic) NSInteger dataLength;
@property (atomic) NSInteger index;

@end
