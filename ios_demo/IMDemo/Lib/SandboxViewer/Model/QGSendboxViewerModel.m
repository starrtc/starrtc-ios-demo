//
//  QGSendboxViewerModel.m
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import "QGSendboxViewerModel.h"

@implementation QGSendboxViewerModel

- (instancetype)initWithFileName:(NSString*)fileName filePath:(NSString*)filePath{
    if (self = [super init]) {
        self.fileName = fileName;
        self.filePath = filePath;
        NSDictionary *atts = [[NSFileManager defaultManager] attributesOfItemAtPath:[filePath stringByAppendingFormat:@"/%@",fileName] error:nil];
        [self setModelWithDictionary:atts];
    }
    return self;
}

- (void)setModelWithDictionary:(NSDictionary*)dic{
    self.fileCreationDate = [NSString stringWithFormat:@"%@",dic[@"NSFileCreationDate"]];
    self.fileModificationDate = [NSString stringWithFormat:@"%@",dic[@"NSFileModificationDate"]];
    self.fileSize = dic[@"NSFileSize"];
    self.fileType = [NSString stringWithFormat:@"%@",dic[@"NSFileType"]];
//    NSFileTypeRegular /NSFileTypeDirectory
}

@end
