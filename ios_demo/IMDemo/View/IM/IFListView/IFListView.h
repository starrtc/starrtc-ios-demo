//
//  IFListView.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/3/30.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFListView : UIView

@property (nonatomic, strong) UILabel *useL;
@property (nonatomic, strong) UILabel *creatorNameL;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithDelegate:(id)delegate frame:(CGRect)frame;
@end
