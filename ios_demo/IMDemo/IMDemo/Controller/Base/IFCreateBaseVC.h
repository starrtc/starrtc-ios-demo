//
//  IFCreateBaseVC.h
//  IMDemo
//
//  Created by zhangtongle-Pro on 2018/4/9.
//  Copyright © 2018年  Admin. All rights reserved.
//

#import "IFBaseVC.h"

#import "IFCreateSessionView.h"

@interface IFCreateBaseVC : IFBaseVC <IFCreateSessionViewDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) IFCreateSessionView *sessionView;

- (void)createButtonClicked:(UIButton *)button;
@end
