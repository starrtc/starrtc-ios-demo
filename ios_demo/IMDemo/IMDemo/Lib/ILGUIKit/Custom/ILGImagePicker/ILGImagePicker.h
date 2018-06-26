//
//  ILGImagePicker.h
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2018/1/30.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILGImagePicker;
@protocol ILGImagePickerDelegate <NSObject>

/**
 成功获取图片等信息

 @param imagePicker self
 @param image 编辑后的image
 */
- (void)imagePicker:(ILGImagePicker *)imagePicker didFinishedWithEditedImage:(UIImage *)image;
@optional
- (void)imagePicker:(ILGImagePicker *)imagePicker didSelectSourceType:(UIImagePickerControllerSourceType)sourceType;
- (void)imagePickerDidCancel:(ILGImagePicker *)imagePicker;
@end


@interface ILGImagePicker : NSObject
@property (nonatomic, assign) UIImagePickerControllerSourceType sourceType;
@property (nonatomic, assign) CGFloat scaleRatio; //指定裁剪比例，默认为1.0

+ (instancetype)sharedInstance;

- (void)selectImageInViewController:(UIViewController *)viewController delegate:(id<ILGImagePickerDelegate>)delegate;
@end

// ------ 使用问题 ------
/*
 1.系统相机或者相册显示英文: 在项目的info.plist里面添加Localized resources can be mixed，Boolean类型，并设置为YES（表示是否允许应用程序获取框架库内语言）即可解决这个问题
 2.
 */

// ------ 待完成任务 ------
/*
 1.指定比例裁剪功能需要优化
 2.读取系统相册图片和视频功能
 */
