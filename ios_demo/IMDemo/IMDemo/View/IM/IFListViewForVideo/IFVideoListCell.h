//
//  IFVideoListCell.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/25.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFVideoListCell : UICollectionViewCell
@property(nonatomic, strong, readonly) UIImageView *coverIV;
@property(nonatomic, strong, readonly) UIImageView *iconIV;
@property(nonatomic, strong, readonly) UILabel *signLabel;
@property(nonatomic, strong, readonly) UILabel *nickLabel;
@end
