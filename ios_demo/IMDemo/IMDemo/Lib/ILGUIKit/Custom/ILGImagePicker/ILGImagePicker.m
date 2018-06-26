//
//  ILGImagePicker.m
//  ILGDemo
//
//  Created by zhangtongle-Pro on 2018/1/30.
//  Copyright © 2018年 Happy. All rights reserved.
//

#import "ILGImagePicker.h"
#import "ILGImageCropViewController.h"

@interface ILGImagePicker () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) id<ILGImagePickerDelegate> delegate;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation ILGImagePicker
static ILGImagePicker *imagePicker = nil;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sourceType = -1;
        _scaleRatio = 0.0;
    }
    return self;
}

+ (instancetype)sharedInstance {
    if (!imagePicker) {
        imagePicker = [[ILGImagePicker alloc] init];
    }
    return imagePicker;
}

- (void)selectImageInViewController:(UIViewController *)viewController delegate:(id<ILGImagePickerDelegate>)delegate
{
    _delegate = delegate;
    
    if (self.scaleRatio) {
        self.imagePickerController.allowsEditing = NO;
    } else {
        self.imagePickerController.allowsEditing = YES;
    }
    
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera ||
        self.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [self fetchImageFromSystem:self.sourceType viewController:viewController];
    } else {
        [self selectSourceType:viewController];
    }
}


#pragma mark - delegate
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    __weak typeof(self) weakself = self;

    if (self.scaleRatio) {
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp){
            // Adjust picture Angle
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        ILGImageCropViewController *imageCropperController = [[ILGImageCropViewController alloc] initWithImage:image cropFrame:CGRectMake(0, (screenHeight-screenWidth*self.scaleRatio)/2, screenWidth, screenWidth*self.scaleRatio) limitScaleRatio:5];
        imageCropperController.submitBlock = ^(UIViewController *viewController, UIImage *image) {
            [viewController dismissViewControllerAnimated:YES completion:nil];
            if ([weakself.delegate respondsToSelector:@selector(imagePicker:didFinishedWithEditedImage:)]) {
                [weakself.delegate imagePicker:weakself didFinishedWithEditedImage:image];
            }
            [weakself clearData];
        };
        imageCropperController.cancelBlock = ^(UIViewController *viewController) {
            UIImagePickerController *picker = (UIImagePickerController *)viewController.navigationController;
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
                [viewController.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else{
                [viewController.navigationController popViewControllerAnimated:YES];
            }
            
            if ([weakself.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
                [weakself.delegate imagePickerDidCancel:weakself];
            }
            [weakself clearData];
        };
        [picker pushViewController:imageCropperController animated:YES];
        
    } else {
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];

        [picker dismissViewControllerAnimated:YES completion:^{
            if ([_delegate respondsToSelector:@selector(imagePicker:didFinishedWithEditedImage:)]) {
                [_delegate imagePicker:self didFinishedWithEditedImage:image];
            }
            [weakself clearData];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    __weak typeof(self) weakself = self;

    [picker dismissViewControllerAnimated:YES completion:^{
        if ([_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [_delegate imagePickerDidCancel:self];
        }
        [weakself clearData];
    }];
}

#pragma mark - setter

- (void)setscaleRatio:(CGFloat)scaleRatio {
    if (scaleRatio > 0 && scaleRatio < 1.5) {
        _scaleRatio = scaleRatio;
    }
}

#pragma mark - getter

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

#pragma mark - other
- (void)selectSourceType:(UIViewController *)viewController
{
    viewController ? nil:(viewController = [UIApplication sharedApplication].keyWindow.rootViewController);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if ([_delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [_delegate imagePickerDidCancel:self];
        }
    }];
    [alertController addAction:cancelAction];
    
    UIAlertAction *phoneAlbumAction = [UIAlertAction actionWithTitle:@"系统相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchImageFromSystem:UIImagePickerControllerSourceTypePhotoLibrary viewController:viewController];
    }];
    [alertController addAction:phoneAlbumAction];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self fetchImageFromSystem:UIImagePickerControllerSourceTypeCamera viewController:viewController];
        
    }];
    [alertController addAction:cameraAction];
    
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (void)fetchImageFromSystem:(UIImagePickerControllerSourceType)sourceType viewController:(UIViewController *)viewController {
    viewController ? nil:(viewController = [UIApplication sharedApplication].keyWindow.rootViewController);

    self.imagePickerController.sourceType = (UIImagePickerControllerSourceType)sourceType;
    
    [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)clearData {
    _scaleRatio = 0.0;
    _sourceType = -1;
    _delegate = nil;
    _imagePickerController = nil;
}

@end
