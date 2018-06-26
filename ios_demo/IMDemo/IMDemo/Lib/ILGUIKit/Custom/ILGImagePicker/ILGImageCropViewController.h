//
//  ILGImageCropViewController.h
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2018/1/30.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILGImageCropViewController : UIViewController
@property (nonatomic, copy) void(^submitBlock)(UIViewController *viewController , UIImage *image);
@property (nonatomic, copy) void(^cancelBlock)(UIViewController *viewController);

- (id)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;
@end
