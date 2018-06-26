//
//  QGSendboxViewerModel.h
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGSendboxViewerModel : NSObject


@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileCreationDate;
@property (nonatomic, copy) NSString *fileModificationDate;
@property (nonatomic, strong) NSNumber *fileSize;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *filePath;

- (instancetype)initWithFileName:(NSString*)fileName filePath:(NSString*)filePath;

@end
