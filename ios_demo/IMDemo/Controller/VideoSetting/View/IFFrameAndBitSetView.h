//
//  IFFrameAndBitSetView.h
//  IMDemo
//
//  Created by HappyWork on 2019/4/26.
//  Copyright © 2019  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, IFFrameAndBitSetViewType) {
    IFFrameAndBitSetViewTypeBig, //大图
    IFFrameAndBitSetViewTypeSmall //小图
};

@protocol IFFrameAndBitSetViewDelegate <NSObject>

- (void)frameAndBitDidChanged:(IFFrameAndBitSetViewType)type frame:(int)frame bit:(int)bit;

@end

@interface IFFrameAndBitSetView : UIView
@property (weak, nonatomic) id<IFFrameAndBitSetViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *frameL;
@property (weak, nonatomic) IBOutlet UILabel *bitL;
@property (weak, nonatomic) IBOutlet UISlider *frameSlider;
@property (weak, nonatomic) IBOutlet UISlider *bitSlider;

+ (instancetype)viewFromXIBWithType:(IFFrameAndBitSetViewType)type;

@end

NS_ASSUME_NONNULL_END
