//
//  QGSandboxViewerVC.h
//  QGSandboxViewer
//
//  Created by Hanxiaojie on 2018/6/20.
//  Copyright © 2018年 徐其岗. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QGSandboxViewerVC : UIViewController

- (instancetype)initWithHomeDirectory;

- (instancetype)initWithDirectory:(NSString*)directory;

@end
