//
//  IFListViewCell.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/20.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFListViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *topL;
@property (nonatomic, strong) UILabel *leftBottomL;
@property (nonatomic, strong) UILabel *bottomL;
@property (nonatomic, strong) UILabel *rightL;

@end
