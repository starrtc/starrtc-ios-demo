//
//  IFFrameAndBitSetView.m
//  IMDemo
//
//  Created by HappyWork on 2019/4/26.
//  Copyright © 2019  Admin. All rights reserved.
//

#import "IFFrameAndBitSetView.h"

@interface IFFrameAndBitSetView ()
@property (assign, nonatomic) IFFrameAndBitSetViewType type;
@end

@implementation IFFrameAndBitSetView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

+ (instancetype)viewFromXIBWithType:(IFFrameAndBitSetViewType)type {
    IFFrameAndBitSetView *view = [self viewFromXIB];
    view.type = type;
    return view;
}
+ (instancetype)viewFromXIB {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
}


#pragma mark - event

- (IBAction)frameSliderChanged:(UISlider *)sender {
    self.frameL.text = [NSString stringWithFormat:@"帧率:%.0f", sender.value];
}

- (IBAction)bitSliderChanged:(UISlider *)sender {
    self.bitL.text = [NSString stringWithFormat:@"码率:%.0f", sender.value];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)sureBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(frameAndBitDidChanged:frame:bit:)]) {
        [self.delegate frameAndBitDidChanged:self.type frame:self.frameSlider.value bit:self.bitSlider.value];
    }
    
    [self removeFromSuperview];
}

@end
